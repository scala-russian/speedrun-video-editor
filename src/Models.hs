module Models (IntervalDeletion(..), Interval(..), Env(..), HasBusinessArgs(..), HasFfmpeg(..)) where

data IntervalDeletion = IntervalDeletion {delStart :: Double, delEnd :: Double} deriving (Show, Eq)

-- data Command =  IntervalDeletion {delStart :: Double, delEnd :: Double} | 
--                 Label {label :: String, time :: Double} | 
--                 Blur {blurStart :: Double, blurEnd :: Double} deriving Show 

data Interval = Interval {intervalStart :: Double, intervalEnd :: Double} deriving (Show, Eq)

data Env = Env 
    { envCommmandList  :: FilePath
    , envMovie         :: FilePath
    , envOut           :: FilePath
    , envFfmpeg        :: FilePath
    , envFfprobe       :: FilePath}

class HasBusinessArgs a where
    getCommmandList :: a -> FilePath
    getMovie        :: a -> FilePath
    getOutFile      :: a -> FilePath

instance HasBusinessArgs Env where 
    getCommmandList = envCommmandList
    getMovie        = envMovie
    getOutFile      = envOut

class HasFfmpeg a where
    getFfmpeg   :: a -> FilePath
    getFfprobe  :: a -> FilePath

instance HasFfmpeg Env where
    getFfmpeg   = envFfmpeg
    getFfprobe  = envFfprobe