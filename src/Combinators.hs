module Combinators(time, timeRange, intervalDeletion, parseIntervals) where

import Text.Parsec hiding ((<|>), many)
import Models
import Control.Applicative
import Data.Monoid
import Data.Maybe

time :: Parsec String () Double
time = f <$> many digit <*> optionMaybe (char ':' *> count 2 digit) <*> optionMaybe (char ':' *> count 2 digit) <*> optionMaybe ((:) <$> char '.' <*> many digit)
    where 
        g :: Maybe Double -> Maybe Double -> Maybe Double
        g a b = fmap getSum $ do 
            a
            fmap Sum a `mappend` fmap Sum b
        f :: [Char] -> Maybe [Char] -> Maybe [Char] -> Maybe [Char] -> Double
        f x y z w = 
            let 
                a = fmap read $ Just x
                b = fmap read y
                c = fmap read z
                d = fmap (read . ('0':)) w
            in 
                fromJust $ (
                    do 
                        h <- a
                        m <- b
                        s <- c `g` d
                        return $ 3600*h + 60*m + s
                ) <|> (
                    do 
                        m <- a
                        s <- b `g` d
                        return $ 60*m + s
                ) <|> (a `g` d)

timeRange = (,) <$> time <* spaces <* char '-' <* spaces <*> time

intervalDeletion = f <$> (string "delete" *> spaces *> timeRange)
                    where 
                        f (s,e) = IntervalDeletion s e

parseIntervals = parse intervalDeletion ""