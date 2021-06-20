module Basica.Escher where
import Dibujo
import Interp


type Escher = Bool 

-- El dibujoU.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = encimar4 p

-- El dibujo t.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT p = Encimar p (Encimar p2 p3)
        where p2 = Espejar (Rot45 p)
              p3 = comp Rotar 3 p2 

-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina n p | n == 1 = cuarteto (Basica False) (Basica False) (Basica False) (dibujoU p)
            | n > 1  = cuarteto (esquina (n-1) p) (lado (n-1) p) (Rotar (lado (n-1) p)) (dibujoU p)

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado n p | n == 1 = cuarteto (Basica False) (Basica False) (Rotar (dibujoT p)) (dibujoT p)
         | n > 1 = cuarteto (lado (n-1) p) (lado (n-1) p) (Rotar (dibujoT p)) (dibujoT p) 

-- Por suerte no tenemos que poner el tipo!
noneto p q r s t u v w x = Apilar 2 1 (Juntar 2 1 p (Juntar 1 1 q r))
                           (Apilar 1 1 (Juntar 2 1 s (Juntar 1 1 t u))
                                       (Juntar 2 1 v (Juntar 1 1 w x)))

-- El dibujo de Escher:
escher :: Int -> Escher -> Dibujo Escher
escher n esc = noneto (esquina n (pureDib esc)) (lado n (pureDib esc)) aux1 
              (Rotar(lado n (pureDib esc))) (dibujoU (pureDib esc)) aux2 
              (Rotar(esquina n (pureDib esc))) aux3 aux4
        where aux1 = r270 (esquina n (pureDib esc))
              aux2 = r270 (lado n (pureDib esc))
              aux3 = r180 (lado n (pureDib esc))
              aux4 = r180 (esquina n (pureDib esc))  


interpBas :: Output Escher
interpBas True = trian2
interpBas False = nul
