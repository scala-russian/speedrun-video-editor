import Test.Hspec
import Test.QuickCheck

import Combinators
import Models
import Processing

main :: IO ()
main = hspec $ do
    describe "Parcing commands" $ do
        it "recognise delete intervals" $ do
            parseIntervals "delete 20:41.3 -20:43.3" `shouldBe` (Right $ IntervalDeletion 1241.3 1243.3)
            parseIntervals "delete 123:20:41.3-  123:20:41.3" `shouldBe` (Right $ IntervalDeletion 444041.3 444041.3)
            parseIntervals "delete 123:20:41-123:10:41" `shouldBe` (Right $ IntervalDeletion 444041 443441)
            parseIntervals "delete 44.2-123:20:41" `shouldBe` (Right $ IntervalDeletion 44.2 444041)
            parseIntervals "delete 44-123:20:41" `shouldBe` (Right $ IntervalDeletion 44 444041)

    describe "Processing of commands" $ do
        it "cut off IntervalDeletion" $ do
            (deleteInterval [] $ IntervalDeletion 23 3453453) `shouldBe` []
            (deleteInterval [Interval 0 20, Interval 25 40, Interval 48 100] $ IntervalDeletion 23 3453453) `shouldBe` [Interval 0 20]
            (deleteInterval [Interval 0 20, Interval 25 40, Interval 48 100] $ IntervalDeletion 23 42) `shouldBe` [Interval 0 20, Interval 48 100]
            (deleteInterval [Interval 0 20, Interval 25 40, Interval 48 100] $ IntervalDeletion 27 40) `shouldBe` [Interval 0 20, Interval 25 27, Interval 48 100]
            (deleteInterval [Interval 0 20, Interval 25 40, Interval 48 100] $ IntervalDeletion 23 38) `shouldBe` [Interval 0 20, Interval 38 40, Interval 48 100]
            (deleteInterval [Interval 0 20, Interval 25 40, Interval 48 100] $ IntervalDeletion 2 38) `shouldBe` [Interval 0 2, Interval 38 40, Interval 48 100]
            (deleteInterval [Interval 0 20, Interval 25 40, Interval 48 100] $ IntervalDeletion 2 60) `shouldBe` [Interval 0 2, Interval 60 100]
            (deleteInterval [Interval 0 20, Interval 25 40, Interval 48 100] $ IntervalDeletion 2 6) `shouldBe` [Interval 0 2, Interval 6 20, Interval 25 40, Interval 48 100]