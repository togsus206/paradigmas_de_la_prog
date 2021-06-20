module Starting where

-- Haskell en un segundo

-- Una lista de enteros

data MyListInt =
    EmptyI                   -- Empty es una MyListInt
  | ConsI Int MyListInt      -- Cons de un Int y una MyListInt es una MyListInt
                             -- Nada mas es un MyListInt


aList :: MyListInt               -- aList es una MyListInt
aList = ConsI 0 (ConsI 1 EmptyI) -- que es igual a esto


mySumI :: MyListInt -> Int   -- computamos la suma
mySumI EmptyI = 0
mySumI (ConsI i l) = i + mySumI l

sumList1 :: Int
sumList1 = mySumI aList


-- Polimorfismo

-- A List to Rule Them All

data MyList a =       -- "constructor de tipo"
    Empty
  | Cons a (MyList a)
  deriving Show       -- los constructores pueden ser impresos


aList1' :: MyList Int
aList1' = Cons 0 (Cons 1 Empty)


mySum :: MyList Int -> Int   -- computamos la suma
mySum Empty = 0
mySum (Cons i l) = i + mySum l


-- como hacemos sumas de floats o cualquier otro numero?
mySumG :: Num a => MyList a -> a
mySumG Empty = fromInteger 0
mySumG (Cons i l) = i + mySumG l

aDoubleList :: MyList Double
aDoubleList = Cons 0.0 $ Cons 1.0 Empty   -- $ nos ahorra poner ( )


-- Por supuesto, Haskell tiene su propia lista,
-- y con mejor sintaxis
mySumG' :: Num a => [a] -> a
mySumG' [] = fromInteger 0        -- [] es como Empty
mySumG' (i : l) = i + mySumG' l   -- ( : ) es como Cons


-- otro ejemplo
forAll :: [Bool] -> Bool
forAll [] = True
forAll (i : l) = i && forAll l

isTrue :: Bool
isTrue = forAll [True, True]

-- comparen mySumG' y forAll: tienen la misma estructura

-- forma general de computar con una lista
myFoldr :: (a -> b -> b) -> b -> [a] -> b
myFoldr f b [] = b
myFoldr f b (x : xs) = f x (myFoldr f b xs)

-- entonces...
mySumG'' :: Num a => [a] -> a
mySumG'' = myFoldr (+) (fromInteger 0)  -- noten que (+) :: Num a => a -> a -> a

forAll' :: [Bool] -> Bool
forAll' = myFoldr (&&) True


-- Haskell tambien tiene sum y foldr
-- prueben en el ghci poner sum (enter) foldr (enter)



-- Ejercicios:

-- a)
-- Definan un tipo de arbol binario que se define como vacio o
-- como un nodo que contiene un dato (deberia ser de tipo generico)
-- y dos arboles

data Arbolbb a =
        Vacio | Nodo a (Arbolbb a) (Arbolbb a) deriving Show 

arbolito :: Num a => Arbolbb a
arbolito = Nodo 1 (Vacio) (Vacio)

arbolote :: Num a => Arbolbb a
arbolote = Nodo 4 (Nodo 5 (Nodo 98 (Vacio) (Vacio)) (Nodo 5 (Vacio) (Vacio))) (Vacio)

arboloteplus :: Num a => Arbolbb a
arboloteplus = Nodo 4 (Nodo 5 (Nodo 98 (Vacio) (Vacio)) (Nodo 5 (Vacio) (Vacio))) (Nodo 7 (Vacio)(Vacio))

-- b)
-- Definan una funcion que permita calcular la suma de todos los valores
-- para arboles con valores numericos

sumbb :: Num a => Arbolbb a -> a
sumbb Vacio = 0 
sumbb (Nodo a i d) = a + sumbb(i) + sumbb(d)
-- c)
-- Definan una funcion como foldr que permita generalizar el recorrido de
-- un arbol. Fijense que hay mas de una forma (inorder, posorder).

foldiando :: Arbolbb a -> [a]
foldiando Vacio = []
foldiando (Nodo a l d) = a: foldiando(l) ++ foldiando(d)

foldiando2 :: Arbolbb a -> [a]
foldiando2 Vacio = []
foldiando2 (Nodo a l d) = foldiando2(l) ++ [a] ++ foldiando2(d)

foldiando3 :: Arbolbb a -> [a]
foldiando3 Vacio = []
foldiando3 (Nodo a l d) = foldiando3(d) ++ foldiando3(l) ++ [a]

