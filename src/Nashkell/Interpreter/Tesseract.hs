module Nashcellum.Interpres.Tesseract
  ( excurreOcrPerTesseractum
  ) where

import Polysemy
import Polysemy.Error (Error, throw)
import Polysemy.Trace
import System.Process.Typed
import System.Exit (ExitCode (..))
import System.Timeout (timeout)
import System.Directory (doesFileExist, findExecutable)
import Control.Exception (IOException, try)
import Control.Monad (unless, when)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString.Lazy as BL

import Nashcellum.Effectus.Ocr

-- Spatium temporis maximum quod processui conceditur, in microsecundis.
-- Sine hoc termino, imago corrupta totam seriem operum in perpetuum
-- morari posset.
tempusPraestitutumMicros :: Int
tempusPraestitutumMicros = 60 * 1000000

-- Hic interpres algebram abstractam Ocr in actiones veras convertit,
-- id est in invocationem programmatis externi "tesseract" per processum
-- separatum, non per vincula nativa (FFI) -- id consulto factum est,
-- ut instabilitas ABI bibliothecae C++ vitaretur. Notandum: functio
-- readProcess ipsa totum ambitum vitae processus externi curat, ideo
-- nullo bracket manu scripto hic opus est.
excurreOcrPerTesseractum
  :: Members '[Embed IO, Error ErrorOcr, Trace] r
  => Sem (Ocr ': r) a
  -> Sem r a
excurreOcrPerTesseractum = interpret $ \case

  InspicePraesentiam -> do
    trace "Quaeritur an programma tesseract in systemate praesto sit"
    mExe <- embed (findExecutable "tesseract")
    case mExe of
      Nothing -> pure False
      Just _  -> pure True

  ExcurreOcr imgPath extraArgs -> do
    -- Prius quam processus externus incipiatur, condicio praevia
    -- probanda est: num imago revera existat. Sic fugitur sumptus
    -- processus integri propter viam falsam.
    exists <- embed (doesFileExist imgPath)
    unless exists $ throw (ViaImaginisInvalida imgPath)

    trace ("Incipitur transcriptio imaginis: " <> imgPath)

    let args   = [imgPath, "stdout"] <> map T.unpack extraArgs
        config = proc "tesseract" args

    result <- embed (try @IOException (timeout tempusPraestitutumMicros (readProcess config)))
    trace "Processus tesseract finitus est"

    case result of
      Left ioErr ->
        -- Error systematis ipsius, non processus tesseract: fortasse
        -- via programmatis non recte constituta est.
        throw (ProcessusDefectus (-1) (T.pack (show ioErr)))

      Right Nothing ->
        -- Tempus praestitutum superatum est: processus nimis diu duravit.
        throw (TempusProcessusExpletum imgPath)

      Right (Just (exitCode, stdoutBS, stderrBS)) ->
        case exitCode of
          ExitSuccess -> do
            let out = TE.decodeUtf8 (BL.toStrict stdoutBS)
            -- Textus vacuus non semper errorem indicat, sed monendum
            -- est: imago fortasse tam corrupta erat ut nihil legi posset.
            when (T.null (T.strip out)) $
              trace "Monitum: transcriptio vacua reddita est -- imago fortasse illegibilis erat"
            pure out
          ExitFailure code ->
            throw (ProcessusDefectus code (TE.decodeUtf8 (BL.toStrict stderrBS)))
