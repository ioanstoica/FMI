-- https://github.com/fmi-unibuc/flp/blob/main/laborator/lab1/lab1.pdf

-- 0.
letrec fct = \n -> if (isZero n ) 1 ( * n (fct ( pred n ) ) ) in fct 4 
-- 24

-- 1.
let squareSum = (\x -> \y -> + (* x x) (* y y) ) in squareSum 2 3
-- 13

-- 2. 
letrec revRange = (\x -> ++  [ - x 1 ] (if <= x 2 ([ 0 ]) (revRange (- x 1)))  )  in revRange 4

letrec revRange = (\x -> ++  [ - x 1 ] (if <= x 2 ([ 0 ]) (revRange (- x 1)))  )  in  \
(let range = \x -> (reverse (revRange x)) in range 4)

-- 3.
let justList = ... in justList [Just 4, Nothing, Just 5, Just 7, Nothing]

let justList =(\xs -> map (\x -> (fromMaybe Nothing x)) xs) in justList [Just 4, Nothing, Just 5, Just 7, Nothing]

let justList =(\xs -> map (\x -> (fromMaybe Nothing x)) xs) in justList [Just 4, Nothing, Just 5, Just 7, Nothing]