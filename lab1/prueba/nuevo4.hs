factorial :: Int -> Int 
factorial 0 = 1
factorial n = n* factorial (n-1)

factorial2 :: Int -> Maybe Int
factorial2 n | n >= 0 = Just (factorial n)
             | otherwise = Nothing