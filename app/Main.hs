module Main where

import Options.Applicative
import Data.Semigroup ((<>))
import Processing
import Models

args :: Parser Env
args = Env <$> strOption
                 ( long "commands"
                <> short 'c'
                <> metavar "COMMANDS_LIST"
                <> help "Path to list of commands. ")
            <*> strOption
                 ( long "input"
                <> short 'i'
                <> metavar "RAW_MOVIE"
                <> help "Path to raw movie.")
            <*> strOption
                 ( long "output"
                <> short 'o'
                <> metavar "RESULT_MOVIE"
                <> help "Path to result file.")
            <*> strOption
                 ( long "ffmpeg"
                <> short 'm'
                <> metavar "FFMPEG_PATH"
                <> value "ffmpeg"
                <> help "Optional path to ffmpeg. Default behaviour is to search in system path.")
            <*> strOption
                 ( long "ffprobe"
                <> short 'p'
                <> metavar "FFPROBE_PATH"
                <> value "ffprobe"
                <> help "Optional path to ffprobe. Default behaviour is to search in system path.")

main :: IO ()
main = do 
        env <- execParser opts
        executeCommands env
        print $ (envOut env) ++ " is ready"
        where
            opts = info (args <**> helper)
                (  fullDesc
                <> progDesc "Process a video through a list of commands"
                <> header   "speerun video editor - a ffmpeg wrapper to facilitate speedrun video post processing")
