module Main (main) where

import Polysemy
import Polysemy.Error
import Polysemy.Trace
import System.Environment (getArgs, lookupEnv)
import System.Exit (exitFailure)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

import Nashcellum.Effectus.Ocr
import Nashcellum.Interpres.Tesseract (excurreOcrPerTesseractum)
import Nashcellum.Llm.Effectus
import Nashcellum.Llm.Interpres.Anthropic (ErrorMachinae, excurreIudiciumPerAnthropicum)
import Nashcellum.Series

-- Punctum ingressus: legit viam ad imaginem ex argumentis lineae
-- imperiorum, clavem API ex re systematis (ANTHROPIC_API_KEY), et
-- totam seriem operum exsequitur.
main :: IO ()
main = do
  args <- getArgs
  case args of
    [imagePath] -> do
      mKey <- lookupEnv "ANTHROPIC_API_KEY"
      case mKey of
        Nothing -> do
          putStrLn "ERROR: environment variable ANTHROPIC_API_KEY is not set."
          exitFailure
        Just key -> excurreSeriem imagePath (T.pack key)
    _ -> do
      putStrLn "Usage: nashkell <path-to-scanned-image-or-pdf>"
      exitFailure

-- Compositio graduum: quisque interpres unum effectum ex serie
-- tollit, usque ad IO puram. Ordo applicationis (a dextra ad
-- sinistram) determinat quo tempore quisque effectus solvatur --
-- Error et Trace postremo, quia ab Embed IO pendent.
excurreSeriem :: FilePath -> Text -> IO ()
excurreSeriem path apiKey = do
  result <-
    runM
      . traceToStdout
      . runError @ErrorMachinae
      . runError @ErrorOcr
      . excurreIudiciumPerAnthropicum apiKey
      . excurreOcrPerTesseractum
      $ excurreSeriemPlenam path

  case result of
    Left llmErr -> print llmErr
    Right (Left ocrErr) -> print ocrErr
    Right (Right pipelineResult) -> imprimeEventum pipelineResult

imprimeEventum :: EventusSeriei -> IO ()
imprimeEventum res = do
  putStrLn "=== Raw OCR text ==="
  TIO.putStrLn (prTextusCrudus res)

  putStrLn "\n=== Sanity check ==="
  print (prSanitas res)

  putStrLn "\n=== Annotations ==="
  mapM_ print (prAnnotationes res)

  putStrLn "\n=== Cross-reference results ==="
  mapM_ print (prComprobationes res)
