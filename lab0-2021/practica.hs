------------ejer 1

--a
map2 :: [a] -> (a -> a) -> [a]
map2 [] f = []
map2 (x:xs) f = f x : map2 xs f



--b
espar :: [Int] -> [Bool]
espar [] = []
espar (x:xs) = (mod x 2 == 0) : espar xs



------------ejer 2

--a
filter2 :: [Int] -> (Int -> Bool) -> [Int]
filter2 [] f = []
filter2 (x:xs) f | f x == True = x: filter2 xs f
                 | f x /= True = filter2 xs f

--b 
filter3 :: [a] -> (a -> Bool) -> [a]
filter3 [] f = []
filter3 (x:xs) f | f x == True = x:filter3 xs f
                 | f x /= True = filter3 xs f 

--c
solopares2 :: Integral a => [a] -> [a]
solopares2 [] = []
solopares2 (x:xs) | mod x 2 == 0 = x: solopares2 xs
                  | mod x 2 /= 0 = solopares2 xs


------------ejer 3

--a 
fold2 :: [Int] -> (Int -> Int) -> Int
fold2 [] f = 0
fold2 (x:xs) f = f x + fold2 xs f 

--b 
fold3 :: Integral a => [a] -> (a -> a) -> a
fold3 [] f = 0
fold3 (x:xs) f = f x + fold3 xs f 

--c
sumatoria2 :: Integral a => [a] -> a
sumatoria2 [] = 0
sumatoria2 (x:xs) = x + sumatoria2 xs

------------------ejer 4

type Radio = Float
type Lado = Float

data Figura = Circulo Radio 
            | Cuadrado Lado 
            | Rectangulo Lado Lado
            | Punto
        deriving (Eq,Show)

perimetro :: Figura -> Float
perimetro (Circulo radio) = 2 * pi * radio
perimetro (Cuadrado lado) = 4 * lado
perimetro (Rectangulo ancho alto) = 2 * ancho + 2 * alto
perimetro (Punto) = error "no se puede calcular el perimetro del punto"

superficie :: Figura -> Float
superficie (Circulo radio) = pi * (radio **2) 
superficie (Cuadrado lado) = lado * lado
superficie (Rectangulo ancho alto) = ancho * alto
superficie (Punto) = 0


---------------------ejer 5

--a 
type Numero = Float

data Expr = Suma Expr Expr
          | Resta Expr Expr
          | Multi Expr Expr
          | Lik Numero
        deriving(Eq,Show)

--b 
seman2 :: Expr -> Float
seman2 (Lik entero) = entero
seman2 (Suma ent1 ent2) = seman2 ent1 + seman2 ent2
seman2 (Resta ent1 ent2) = seman2 ent1 - seman2 ent2
seman2 (Multi ent1 ent2) = seman2 ent1 * seman2 ent2


--------------ejer6

--a)

data BinTree a = Vacio
               | Nodo a (BinTree a) (BinTree a)
            deriving(Show)


--b)

_folding_ :: (Ord a) => BinTree a -> [a]
_folding_ Vacio = []
_folding_ (Nodo a ram1 ram2) = [a] ++ _folding_ ram1 ++ _folding_ ram2

--c)

altBol :: (Ord a) => BinTree a -> Int
altBol Vacio = 0
altBol (Nodo _ ram1 ram2) = 1 + max (altBol ram1) (altBol ram2)


