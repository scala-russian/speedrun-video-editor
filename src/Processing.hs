module Processing (executeCommands, deleteInterval) where

import Data.Either
import System.FilePath

import Combinators
import FfmpegWrapper
import Models

ffprobe = "c:/portable/ffmpeg/bin/ffprobe" 
ffmpeg = "c:/portable/ffmpeg/bin/ffmpeg" 

deleteInterval :: [Interval] -> IntervalDeletion -> [Interval]
deleteInterval xs (IntervalDeletion cutStart cutEnd) = let 
    (l, r1) = span (\i -> intervalEnd i <= cutStart) xs
    (l1, r) = span (\i -> intervalStart i <= cutEnd) r1
    lCrop = fmap (\i -> Interval (intervalStart i) cutStart) $ filter (\i -> intervalStart i < cutStart) l1
    rCrop = fmap (\i -> Interval cutEnd (intervalEnd i)) $ filter (\i -> intervalEnd i > cutEnd) l1
    in l ++ lCrop ++ rCrop ++ r

readLines :: FilePath-> IO [String]
readLines = fmap lines . readFile

processIntervals :: (HasFfmpeg env, HasBusinessArgs env) => env -> [Interval] -> IO [FilePath]
processIntervals env = let
    f :: Int -> FilePath
    f i = replaceBaseName (getMovie env) (show i)
    in traverse (\(i, interval) -> interval2ffmpeg env interval $ f i) . zip [1..]

executeCommands :: (HasFfmpeg env, HasBusinessArgs env) => env -> IO ()
executeCommands env = do 
        d <- movieDuration env
        cs <- readLines $ getCommmandList env
        is <- processIntervals env $ foldl (deleteInterval) [Interval 0 d] $ rights $ fmap parseIntervals cs
        concatIntervals env is
    