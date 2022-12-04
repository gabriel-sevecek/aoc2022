module Day3 where

import Data.List (intersect, elemIndex)
import Data.Set (fromList, toList)
import Data.Maybe (fromMaybe)

alphabet :: String
alphabet = ['a'..'z'] ++ ['A'..'Z']

solve :: String -> (String, String)
solve input = (show $ part1 backpacks, show $ part2 backpacks)
  where
    backpacks = lines input

part1 :: [String] -> Int
part1 = sum . map scoreCompartmentsOverlaps

part2 :: [String] -> Int
part2 = sum . map (priority . findBadge) . chunksOf 3

priority :: Char -> Int
priority c = 1 + fromMaybe 0 (c `elemIndex` alphabet)

scoreCompartmentsOverlaps :: String -> Int
scoreCompartmentsOverlaps backpack = sum $ map priority inBoth
  where
    size = length backpack
    firstCompartment = take (size `div` 2) backpack
    secondCompartment = drop (size `div` 2) backpack
    inBoth = toList $ fromList $ firstCompartment `intersect` secondCompartment

findBadge :: [String] -> Char
findBadge [first, second, third] = head $ first `intersect` second `intersect` third
findBadge _ = undefined

chunksOf :: Int -> [a] -> [[a]]
chunksOf n xs = take n xs : if null rest then [] else chunksOf n rest
  where
    rest = drop n xs
