module Nashcellum.Conatus
  ( iterareConatibus
  ) where

import Polysemy
import Polysemy.Error
import Polysemy.Trace

-- Conatus qui, si primo tempore non successerit, iterum ac iterum
-- temptatur, usque ad numerum conatuum praefinitum. Ultimo conatu,
-- error sinitur ut ad superiora propagetur, ne fallacia perpetua fiat.
iterareConatibus
  :: (Members '[Error e, Trace] r, Show e)
  => Int
  -> Sem r a
  -> Sem r a
iterareConatibus maxAttempts action = go 1
  where
    go attempt
      | attempt >= maxAttempts = action
      | otherwise = catch action $ \err -> do
          trace ("Conatus " <> show attempt <> " defecit ob: " <> show err <> ". Iterandum est.")
          go (attempt + 1)
