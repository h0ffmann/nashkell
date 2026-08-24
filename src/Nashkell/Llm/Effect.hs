{-# LANGUAGE KindSignatures #-}
module Nashcellum.Llm.Effectus
  ( Fiducia (..)
  , ProbatioSanitatis (..)
  , Annotatio (..)
  , StatusComprobationis (..)
  , EventusComprobationis (..)
  , IudiciumMachinae (..)
  , inspiceSanitatemOcr
  , annotaCrypticum
  , comproba
  ) where

import Polysemy
import Data.Kind (Type)
import Data.Text (Text)

data Fiducia
  = FiduciaAlta
  | FiduciaMedia
  | FiduciaHumilis
  | NonComprobabilis
  deriving (Show, Eq, Ord)

data ProbatioSanitatis = ProbatioSanitatis
  { scVideturCorruptum :: Bool
  , scFiducia       :: Fiducia
  , scProblemata           :: [Text]
  } deriving (Show, Eq)

data Annotatio = Annotatio
  { annTextus        :: Text
  , annFiducia  :: Fiducia
  , annSpeculativa :: Bool
  } deriving (Show, Eq)

data StatusComprobationis
  = Comprobatum
  | Contradictum
  | NullusFonsInventus
  | VerisimiliterFictum
  deriving (Show, Eq)

data EventusComprobationis = EventusComprobationis
  { crAssertio   :: Text
  , crStatus  :: StatusComprobationis
  , crFontes :: [Text]
  } deriving (Show, Eq)

data IudiciumMachinae (m :: Type -> Type) a where
  InspiceSanitatemOcr  :: Text -> IudiciumMachinae m ProbatioSanitatis
  AnnotaCrypticum :: Text -> IudiciumMachinae m Annotatio
  Comproba  :: Text -> IudiciumMachinae m EventusComprobationis

makeSem ''IudiciumMachinae