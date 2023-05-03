import Control.Arrow (Arrow(arr))
-- import Prelude hiding (odd, even, replicate)

-- replicate :: Int -> a -> [a]
-- replicate num fill = 
--   if num > 0
--     then
--       fill : replicate (num - 1) fill
--     else
--       []

{- 홀짝 홀짝 반복되므로 재귀로 알아낼 수 있다 -}
-- even :: Int -> Bool
-- even n = 
--   if n == 0
--     then
--       True
--     else
--       odd (n - 1)

-- odd :: Int -> Bool
-- odd n =
--   if n == 0
--     then 
--       False
--     else
--       even (n - 1) 

maximum' [] = error "maximum of empty list"
maximum' [x] = x
maximum' (x:xs) = max x (maximum' xs)

replicate' n m
  | m <= 0 = []
  | otherwise = n:replicate' n (m-1)

take' n _
  | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x : take' (n-1) xs

reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = [(x, y)] ++ zip xs ys

elem' e [] = False
elem' e (x:xs)
  | e == x = True
  | otherwise = elem' e xs

quicksort [] = []
quicksort (x:xs) =
  let smaller = quicksort [y | y <- xs, y < x]
      bigger = quicksort [y | y <- xs, y >= x]
  in smaller ++ [x] ++ bigger

result = quicksort [5, 1, 9, 4, 6, 7, 3]
main = putStrLn (show result) -- [1,3,4,5,6,7,9]

