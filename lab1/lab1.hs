--Importamos Euterpea
import Euterpea

--Definimos el tipo song con sus contructores(recordar que primitive pith viene en euterpea y es una nota = Note qn (C,3))
data Song =
    Fragment (Primitive Pitch)
  | Transpose_by Int Song
  | Repeat Int Song
  | Concat Song Song 
  | Parallel Song Song 
  deriving (Show, Eq)
  
--data primitive pitch = note dur pitch | Rest dur
--type dur = racional(wn,hn,qn,en)
--type Pitch = (PitchClass(=A,B,C,etc), Octave(=0,1,2,3,4,5))
--data Music pitch = Prim (primitive pitch) |(Music pitch):+:(Music Pith)|(Music pitch):=:(music pitch)

--Funciones auxiliares
-------------------------------------------------------------------------
trasponer :: PitchClass -> PitchClass
trasponer y | y == C = Cs
            | y == Cs = D
            | y == D = Ds
            | y == Ds = E
            | y == E = F
            | y == F = Fs
            | y == Fs = G
            | y == G = Gs
            | y == Gs = A
            | y == A = As
            | y == As = B
            | y == B = D
            | otherwise = error "No seas boludo"

--funcion para trasponer n veces
funtra :: Int -> PitchClass -> PitchClass
funtra 0 q = q
funtra n q = funtra (n-1) (trasponer q)

--funcion que traspone pero en song 
trascan :: Int -> Song -> Song
trascan n (Fragment (Note x (e,g))) = Fragment (Note x ((funtra n e),g))
trascan n (Fragment (Rest x)) = Fragment (Rest x)

--funcion que repite n veces una cancion
repite :: Int -> Song -> Song
repite 0 a = a
repite n a = Concat (a) (repite (n-1) a)

------------------------------------------------------------------------


--Definicion de funciones sobre Song

--retorna la cancion sin nodos transpose y repeat(estos nodos son reemplazados por la accion que representan)
unfold :: Song -> Song 
unfold (Fragment a) = Fragment a
unfold (Concat s t) = Concat (unfold s) (unfold t)
unfold (Parallel s t)  = Parallel (unfold s) (unfold t) 
unfold (Repeat t a) = unfold (repite t a)
unfold (Transpose_by t (Transpose_by i a)) = unfold (Transpose_by (i+t) a)
unfold (Transpose_by t (Repeat i a)) = Repeat i (unfold (Transpose_by t  a))
unfold (Transpose_by t (Concat i a)) = Concat (unfold (Transpose_by t i)) (unfold (Transpose_by t a))
unfold (Transpose_by t (Parallel i a)) = Parallel (unfold (Transpose_by t i)) (unfold (Transpose_by t a))
unfold (Transpose_by t (Fragment a)) = trascan t (Fragment a)


--Toma una cancion y produce un music pitch de Euterpea
compute :: Song -> Music Pitch
compute (Fragment a) =  Prim a
compute (Transpose_by t a) = compute (unfold (Transpose_by t a))
compute (Repeat t a) = compute (unfold (Repeat t a))
compute (Concat a s) = (compute a) :+: (compute s)
compute (Parallel a s) = (compute a) :=: (compute s) 

--Toma una song y devuelve su duracion en bits
time :: Song ->  Float
time (Transpose_by a s) = time (unfold (Transpose_by a s))
time (Repeat t a) = time (unfold (Repeat t a))
time (Concat s g) = time s + time g
time (Parallel w e) = max (time w) (time e)
time (Fragment (Rest s)) | s == qn = 0.25
                         | s == hn = 0.5
                         | s == wn = 1
                         | otherwise = 0
time (Fragment (Note z a)) | z == qn = 0.25
                           | z == hn = 0.5
                           | z == wn = 1
                           | otherwise = 0 


--------------------------
r = Repeat 2 (Parallel (Concat (Repeat 4 (Fragment (Note qn (As,2)))) (Repeat 5 (Fragment (Note qn (C,4))))) (Concat (Repeat 5 (Fragment (Note hn (A,4)))) (Repeat 4 (Fragment (Note qn (B,4))))))
h = compute r
--Para tocar la cancion iniciar timidity("timidity -iA -Os") y poner en ghci "playDev 2 h"
--------------------------------

--Definimos el tipo Command a
data Command a =
      Add a
    | Use1 Int a
    | Use2 Int Int a
    deriving (Show, Eq)

--funcion run para command
run :: [Command a] -> [a] -> [a]--Maybe [a]
run [] l = l
run ((Add s):xs) l = run xs (s:l)
run ((Use1 i s):xs) l = error "El indice excede la lista" -- | length(l) < i = error "El indice excede la lista"--Nothing 
                      -- | otherwise = run xs ((Concat s (l !! i)):l)
--run ((Use2 i n s):xs) l | (max i n) > length(l) = error "El indice excede la lista"--Nothing 
                        -- | otherwise = run xs ((Concat (l !! i) (l !! n)):l)


