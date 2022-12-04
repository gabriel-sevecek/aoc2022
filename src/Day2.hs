module Day2 where

score :: String -> Int
-- lose
score "B X" = 0 + 1
score "C Y" = 0 + 2
score "A Z" = 0 + 3
-- draw
score "A X" = 3 + 1
score "B Y" = 3 + 2
score "C Z" = 3 + 3
-- win
score "C X" = 6 + 1
score "A Y" = 6 + 2
score "B Z" = 6 + 3
score _ = undefined

pickGesture :: String -> Int
-- they play rock
pickGesture "A X" = 0 + 3
pickGesture "A Y" = 3 + 1
pickGesture "A Z" = 6 + 2
-- they play paper
pickGesture "B X" = 0 + 1
pickGesture "B Y" = 3 + 2
pickGesture "B Z" = 6 + 3
-- they play scissor
pickGesture "C X" = 0 + 2
pickGesture "C Y" = 3 + 3
pickGesture "C Z" = 6 + 1
pickGesture _ = undefined

part1 :: [String] -> Int
part1 = sum . map score

part2 :: [String] -> Int
part2 = sum . map pickGesture

solve :: String -> (String, String)
solve input = (show $ part1 ls, show $ part2 ls)
  where ls = lines input
