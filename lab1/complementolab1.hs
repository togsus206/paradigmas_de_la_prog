--Importamos Euterpea
module SimpleMusic where
import Euterpea

import lab1.hs

-- funcion para transpone cada nota una vez
trasponer :: PitchClass -> PitchClass
trasponer C = Cs
trasponer Cs = D
trasponer D = Ds
trasponer Ds = E
trasponer E = F
trasponer F = Fs
trasponer Fs = G
trasponer G = Gs
trasponer Gs = A
trasponer A = As
trasponer As = B
trasponer B = D

--funcion para trasponer n veces
f :: Int -> PitchClass -> PitchClass
f 0 q = q
f n q = f (n-1) (trasponer q)

--funcion que traspone pero en song 
trascan :: Int -> Song -> Maybe Song
trascan n (Fragement (Note x (e,g))) = Fragement (Note x ((f n e),g))

--funcion que repite n veces una cancion
repite :: int -> Song -> Maybe Song
repite 0 a = a
repite n a = Concat (a) (repite (n-1) a)