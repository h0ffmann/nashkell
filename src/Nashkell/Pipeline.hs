module Nashcellum.Series
  ( EventusSeriei (..)
  , excurreSeriemPlenam
  , confirmaContraLitteras
  , divideParagraphos
  ) where

import Polysemy
import Polysemy.Error
import Polysemy.Trace
import Control.Monad (when)
import Data.Text (Text)
import qualified Data.Text as T

import Nashcellum.Effectus.Ocr
import Nashcellum.Llm.Effectus
import Nashcellum.Llm.Interpres.Anthropic (ErrorMachinae)

-- Summa totius operis: textus originarius, iudicium de qualitate,
-- commentarii, et comprobationes fontium -- omnia in una structura.
data EventusSeriei = EventusSeriei
  { prTextusCrudus      :: Text
  , prSanitas      :: ProbatioSanitatis
  , prAnnotationes :: [Annotatio]
  , prComprobationes   :: [EventusComprobationis]
  } deriving Show

-- Series operum per tres gradus procedit, quisque gradus a
-- praecedente pendens: transcriptio, deinde probatio qualitatis,
-- deinde -- tantum si probatio bene cessit -- commentarius; postremo,
-- comprobatio contra litteras veras.
excurreSeriemPlenam
  :: Members '[Ocr, IudiciumMachinae, Error ErrorOcr, Error ErrorMachinae, Trace] r
  => FilePath
  -> Sem r EventusSeriei
excurreSeriemPlenam path = do
  rawText <- excurreOcr path ["-l", "eng"]

  sanity <- inspiceSanitatemOcr rawText
  when (scVideturCorruptum sanity && scFiducia sanity /= FiduciaHumilis) $
    trace "MONITUM: transcriptio verisimiliter corrupta est -- commentarii sequentes parum fide digni sunt"

  -- Si transcriptio corrupta est, commentarium de ea facere esset
  -- commentari de ipso ruido machinae, non de scripto Nashii.
  annotations <-
    if scVideturCorruptum sanity
      then pure []
      else traverse annotaCrypticum (divideParagraphos rawText)

  -- Comprobatio non in textu bruto fit, sed in ipsis commentariis --
  -- id est, in interpretationibus quas gradus praecedens iam produxit.
  crossRefs <- traverse (comproba . annTextus) annotations

  pure (EventusSeriei rawText sanity annotations crossRefs)

-- Usus punctualis: postulatur num commentarium unum cum litteris
-- veris congruat. NoSourceFound tractatur ut "non comprobatum",
-- NON ut "falsum" -- ea distinctio maximi momenti est.
confirmaContraLitteras
  :: Members '[IudiciumMachinae, Trace] r
  => Annotatio
  -> Sem r Bool
confirmaContraLitteras ann = do
  result <- comproba (annTextus ann)
  case crStatus result of
    Comprobatum -> do
      trace ("Confirmatum, fontes: " <> T.unpack (T.intercalate ", " (crFontes result)))
      pure True
    Contradictum -> do
      trace "Fons verus huic interpretationi repugnat"
      pure False
    NullusFonsInventus -> do
      trace "Nullus fons inventus -- res non falsa censenda est, sed non comprobata"
      pure False
    VerisimiliterFictum -> do
      trace ("Suspicio fictionis: " <> T.unpack (annTextus ann))
      pure False

-- Divisio textus in segmenta secundum lineas vacuas -- approximatio
-- simplex divisionis in paragraphos epistularum.
divideParagraphos :: Text -> [Text]
divideParagraphos =
  filter (not . T.null)
    . map T.strip
    . T.splitOn "\n\n"
