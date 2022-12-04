module Main (main) where

import Day1 (solve)
import Day2 (solve)
import Day3 (solve)
import Day4 (solve)
import System.Environment (getArgs)
import qualified Data.Map as Map

puzzleFunctions :: Map.Map String (String -> (String, String))
puzzleFunctions =
  Map.fromList [
    ("1", Day1.solve),
    ("2", Day2.solve),
    ("3", Day3.solve),
    ("4", Day4.solve)
  ]

readPuzleInputForDay :: String -> IO String
readPuzleInputForDay day = readFile $ "./data/day" ++ day ++ ".txt" 

main :: IO ()
main = do
  args <- getArgs
  let day = head args
  puzzleInput <- readPuzleInputForDay day
  let puzzleFunction = puzzleFunctions Map.! day
  let (part1, part2) = puzzleFunction puzzleInput
  putStrLn $ "Part 1: " ++ part1
  putStrLn $ "Part 2: " ++ part2
