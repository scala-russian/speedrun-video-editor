module FfmpegWrapper (movieDuration, interval2ffmpeg, concatIntervals) where

import Models
import System.Exit
import System.Process
import System.Directory

movieDuration :: (HasFfmpeg env, HasBusinessArgs env) => env -> IO Double
movieDuration env = let 
    args = words $ "-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 " ++ getMovie env
    stdIn' = ""
    in do 
        (errCode, stdOut', stdErr') <- readProcessWithExitCode (getFfprobe env) args stdIn'
        case errCode of 
            ExitSuccess -> return $ read stdOut'
            ExitFailure i -> error stdErr'

interval2ffmpeg :: (HasFfmpeg env, HasBusinessArgs env) => env -> Interval -> FilePath -> IO FilePath
interval2ffmpeg env (Interval s e) out = let 
    movie = getMovie env
    args = " -i \"" ++ movie ++ "\"" ++ " -ss " ++ show s ++ " -to " ++ show e ++ " -codec:a copy " ++ out
    stdIn' = ""
    in do
        putStrLn ((getFfmpeg env) ++ args)
        (errCode, stdOut', stdErr') <- readCreateProcessWithExitCode (shell $ (getFfmpeg env) ++ args) stdIn'
        case errCode of 
            ExitSuccess -> return out
            ExitFailure i -> error stdErr'

concatIntervals :: (HasFfmpeg env, HasBusinessArgs env) => env -> [FilePath] -> IO ()
concatIntervals env xs = 
    let 
        out = getOutFile env
        tmp = out ++ ".tmp"
        stdIn' = ""
        args = " -f concat -safe 0 -i " ++ (map (\c -> if c == '/' then '\\' else c) tmp) ++ " -c copy " ++ out -- ffmpeg doesnt tolerate slash in path of -i file
    in do
        writeFile tmp $ foldl1 (++) $ fmap (\x -> "file '" ++ x ++ "'\n") xs
        (errCode, stdOut', stdErr') <- readCreateProcessWithExitCode (shell $ (getFfmpeg env) ++ args) stdIn'
        case errCode of 
            ExitSuccess -> return out
            ExitFailure i -> error stdErr'
        removeFile tmp