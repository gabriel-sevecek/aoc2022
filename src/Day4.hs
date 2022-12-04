module Day4 where
import Data.Bifunctor (bimap)

type Pair = (Int, Int)

solve :: String -> (String, String)
solve input = (show $ part1 pairs, show $ part2 pairs)
  where
    pairs = lines input

part1 :: [String] -> Int
part1 = countOverlapsWith areFullyOverlapping

part2 :: [String] -> Int
part2 = countOverlapsWith arePartiallyOverlapping

countOverlapsWith :: ((Pair, Pair) -> Bool) -> [String] -> Int
countOverlapsWith func = length . filter id . map (func . parsePairs) 

parsePairs :: String -> (Pair, Pair)
parsePairs pairStr = (pairToInts firstPair, pairToInts secondPair)
  where
    pairs = splitOn ',' pairStr
    firstPair = splitOn '-' $ fst pairs
    secondPair = splitOn '-' $ snd pairs
    pairToInts = bimap read read

areFullyOverlapping :: (Pair, Pair) -> Bool
areFullyOverlapping ((fstStart, fstEnd), (sndStart, sndEnd))
  | fstStart <= sndStart && fstEnd >= sndEnd = True
  | fstStart >= sndStart && fstEnd <= sndEnd = True
  | otherwise                                = False

arePartiallyOverlapping :: (Pair, Pair) -> Bool
arePartiallyOverlapping ((fstStart, fstEnd), (sndStart, sndEnd))
  | sndStart > fstEnd = False
  | fstStart > sndEnd = False
  | otherwise         = True

splitOn :: Eq a => a -> [a] -> ([a], [a])
splitOn x xs = (beforeX, afterX)
  where
    beforeX = takeWhile (/= x) xs
    afterX  = drop 1 $ dropWhile (/= x) xs
