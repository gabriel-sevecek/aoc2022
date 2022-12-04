module Day1 where
import Data.List (sort)

solve :: String -> (String, String)
solve input = (show $ part1 caloriesPerElf, show $ part2 caloriesPerElf) 
  where
    caloriesPerElf = map (sum . map (read :: String -> Int)) $ groupNonEmpty $ lines input

part1 :: [Int] -> Int
part1 = maximum

part2 :: [Int] -> Int
part2 = sum . take 3 . reverse . sort

groupNonEmpty :: [String] -> [[String]]
groupNonEmpty ls =
  let
    g = takeWhile (not . null) ls
    rest = dropWhile (not . null) ls
  in
    g : if null rest then [] else groupNonEmpty $ tail rest
