
module Lab2 where

import Control.Applicative
import Data.Char

newtype Parser a = Parser { apply :: String -> [(a, String)] }

satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser go
  where
    go [] = []   -- imposibil de parsat șirul vid
    go (c:input)
      | p c = [(c, input)]   -- dacă predicatul ține, întoarce c și restul șirului de intrare
      | otherwise = []       -- în caz contrar, imposibil de parsat
