module Nashcellum.Llm.Interpres.Anthropic
  ( ErrorMachinae (..)
  , excurreIudiciumPerAnthropicum
  ) where

import Polysemy
import Polysemy.Error (Error, throw)
import Network.HTTP.Simple
import Network.HTTP.Client (HttpException)
import Control.Exception (try)
import Data.Aeson
import Data.Aeson.Types (Parser, parseEither)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE

import Nashcellum.Llm.Effectus

data ErrorMachinae
  = DefectusPetitionis Text
  | ResponsumNonIntellectum Text
  deriving (Show, Eq)

-- Interpres qui algebram LlmVerify in veras petitiones HTTP ad
-- machinam Anthropic convertit. Tria genera quaestionum hic
-- tractantur, singula proprio monito (prompt) instructa, ne officia
-- diversae naturae in una petitione confundantur.
excurreIudiciumPerAnthropicum
  :: Members '[Embed IO, Error ErrorMachinae] r
  => Text
  -> Sem (IudiciumMachinae ': r) a
  -> Sem r a
excurreIudiciumPerAnthropicum apiKey = interpret $ \case

  InspiceSanitatemOcr rawText -> do
    -- Hoc monitum SOLUM de qualitate technica transcriptionis quaerit,
    -- non de sensu historico -- id ad gradum sequentem pertinet.
    let prompt = T.unlines
          [ "You are evaluating ONLY the technical quality of an OCR output,"
          , "not its historical meaning. The source is a degraded scan"
          , "(1950s carbon paper). Flag character substitutions, broken"
          , "words, and recognition noise."
          , "Respond ONLY with a JSON object of this exact shape:"
          , "{\"looksLikeGarbage\": bool, \"confidence\": \"high\"|\"medium\"|\"low\"|\"unverifiable\", \"issues\": [string]}"
          , ""
          , "TEXT:"
          , rawText
          ]
    vocaAnthropicum apiKey prompt interpretareSanitatem

  AnnotaCrypticum segment -> do
    -- Monitum hoc machinam cogit ut omnem interpretationem non
    -- litteralem tamquam coniecturam signet -- nulla certitudo
    -- fingatur ubi ambiguitas vera est.
    let prompt = T.unlines
          [ "John Nash, during his psychotic episodes (1955-1959), often"
          , "wrote in an elliptical, associative style. Comment on the"
          , "passage below."
          , "MANDATORY RULES:"
          , "- Mark speculative=true for ANY non-literal reading."
          , "- Do not manufacture coherence where the text may simply be"
          , "  illegible or nonsensical -- say so plainly if that is the case."
          , "Respond ONLY with a JSON object of this exact shape:"
          , "{\"text\": string, \"confidence\": \"high\"|\"medium\"|\"low\"|\"unverifiable\", \"speculative\": bool}"
          , ""
          , "PASSAGE:"
          , segment
          ]
    vocaAnthropicum apiKey prompt interpretareAnnotationem

  Comproba claim -> do
    -- Monitum hoc maxime periculosum est, quia hic machina saepe
    -- fontes fingere solet. Ideo expresse iubetur ne quicquam fingat:
    -- potius fateatur se nescire quam nomen falsum proferat.
    let prompt = T.unlines
          [ "Verify the claim below against REAL Game Theory literature"
          , "and history of mathematics. Be adversarial toward yourself:"
          , "- If unsure of a source, mark NoSourceFound. NEVER invent an"
          , "  author, article, or institution to fill a gap."
          , "- If the claim resembles urban legend (suspiciously specific"
          , "  details with no traceable source, or a blend of real facts"
          , "  with fiction), mark LikelyFabricated and explain briefly."
          , "- Cite only sources you can name with reasonable confidence."
          , "Respond ONLY with a JSON object of this exact shape:"
          , "{\"status\": \"corroborated\"|\"contradicted\"|\"no_source_found\"|\"likely_fabricated\", \"sources\": [string]}"
          , ""
          , "CLAIM:"
          , claim
          ]
    vocaAnthropicum apiKey prompt (interpretareComprobationem claim)

-- Nucleus communis: petitio HTTP ad Anthropic fit, primum elementum
-- textuale e responso extrahitur, deinde per functionem propriam
-- quaeque tipum suum ex JSON interno interpretatur.
vocaAnthropicum
  :: Members '[Embed IO, Error ErrorMachinae] r
  => Text
  -> Text
  -> (Value -> Parser a)
  -> Sem r a
vocaAnthropicum apiKey prompt parser = do
  let requestBody = object
        [ "model" .= ("claude-sonnet-4-6" :: Text)
        , "max_tokens" .= (1024 :: Int)
        , "messages" .=
            [ object [ "role" .= ("user" :: Text), "content" .= prompt ] ]
        ]

  baseReq <- embed (parseRequest "POST https://api.anthropic.com/v1/messages")
  let req = setRequestBodyJSON requestBody
          $ setRequestHeader "x-api-key" [TE.encodeUtf8 apiKey]
          $ setRequestHeader "anthropic-version" ["2023-06-01"]
          $ setRequestHeader "content-type" ["application/json"]
          $ baseReq

  attempt <- embed (try @HttpException (httpJSON req))
  case attempt of
    Left httpErr -> throw (DefectusPetitionis (T.pack (show httpErr)))
    Right resp ->
      case parseEither extraheTextum (getResponseBody resp) of
        Left err -> throw (ResponsumNonIntellectum (T.pack err))
        Right innerText ->
          case eitherDecodeStrict (TE.encodeUtf8 innerText) of
            Left err -> throw (ResponsumNonIntellectum (T.pack err))
            Right innerValue ->
              case parseEither parser innerValue of
                Left err  -> throw (ResponsumNonIntellectum (T.pack err))
                Right val -> pure val

-- Responsum Anthropic structuram habet cum campo "content", qui est
-- copia elementorum; quaerimus textum primi elementi cuius genus
-- est "text". Haec functio ut Parser scripta est, ne API interni
-- KeyMap/Object manu tractandum sit.
extraheTextum :: Value -> Parser Text
extraheTextum = withObject "AnthropicResponse" $ \o -> do
  blocks <- o .: "content"
  case blocks of
    (firstBlock : _) -> withObject "ContentBlock" (.: "text") firstBlock
    []                -> fail "empty content array in Anthropic response"

-- Interpretationes typorum specificorum, ex JSON in structuras Haskell.

interpretareSanitatem :: Value -> Parser ProbatioSanitatis
interpretareSanitatem = withObject "SanityCheck" $ \o -> do
  garbage    <- o .: "looksLikeGarbage"
  confTxt    <- o .: "confidence"
  confidence <- interpretareFiduciam confTxt
  issues     <- o .: "issues"
  pure (ProbatioSanitatis garbage confidence issues)

interpretareAnnotationem :: Value -> Parser Annotatio
interpretareAnnotationem = withObject "Annotation" $ \o -> do
  txt         <- o .: "text"
  confTxt     <- o .: "confidence"
  confidence  <- interpretareFiduciam confTxt
  speculative <- o .: "speculative"
  pure (Annotatio txt confidence speculative)

interpretareComprobationem :: Text -> Value -> Parser EventusComprobationis
interpretareComprobationem claim = withObject "CrossRefResult" $ \o -> do
  statusTxt <- o .: "status"
  status    <- interpretareStatum statusTxt
  sources   <- o .: "sources"
  pure (EventusComprobationis claim status sources)

interpretareFiduciam :: Text -> Parser Fiducia
interpretareFiduciam t = case T.toLower t of
  "high"   -> pure FiduciaAlta
  "medium" -> pure FiduciaMedia
  "low"    -> pure FiduciaHumilis
  _        -> pure NonComprobabilis

interpretareStatum :: Text -> Parser StatusComprobationis
interpretareStatum t = case T.toLower t of
  "corroborated"      -> pure Comprobatum
  "contradicted"       -> pure Contradictum
  "no_source_found"     -> pure NullusFonsInventus
  "likely_fabricated"    -> pure VerisimiliterFictum
  other                  -> fail ("unknown cross-reference status: " <> T.unpack other)
