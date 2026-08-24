{-# LANGUAGE KindSignatures #-}
module Nashcellum.Effectus.Ocr
  ( ErrorOcr (..)
  , Ocr (..)
  , excurreOcr
  , inspicePraesentiam
  ) where

import Polysemy
import Data.Kind (Type)
import Data.Text (Text)

data ErrorOcr
  = TesseractNonInventus
  | TempusProcessusExpletum FilePath
  | ProcessusDefectus { ocrCodexExitus :: Int, ocrScriptumErroris :: Text }
  | ViaImaginisInvalida FilePath
  | ExitusInexpectatus Text
  deriving (Show, Eq)

data Ocr (m :: Type -> Type) a where
  ExcurreOcr                  :: FilePath -> [Text] -> Ocr m Text
  InspicePraesentiam :: Ocr m Bool

makeSem ''Ocr