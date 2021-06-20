module Main(main) where

import Graphics.Gloss
import Graphics.Gloss.Geometry.Angle



data Dibujo a = Basica a 
              | Rot45 (Dibujo a) 
              | Apilar Int Int (Dibujo a) (Dibujo a) 
              | Juntar Int Int (Dibujo a) (Dibujo a) 
              | Encimar (Dibujo a) (Dibujo a)
              deriving (Eq, Show)

data DibujosBasicos = LetraC | LetraL 


ejemploDeComando1:: Dibujo DibujosBasicos
ejemploDeComando1 = Apilar 1 1 (Basica LetraL) (Juntar 1 1 (Basica LetraC) (Rot45 (Basica LetraL)))

ejemploDeComando2:: Dibujo DibujosBasicos
ejemploDeComando2 = Rot45 (Juntar 1 1 (Basica LetraC) (Apilar 1 1 (Basica LetraC) (Rot45 (Basica LetraL))))


interpreta:: Dibujo DibujosBasicos -> [Picture]
interpreta x = interpretaListaDeListasDePuntosComoListaDeFiguras (interpretarOperadoresComoListaDeListasDePuntos x)


listaDeFiguras::[Picture]
listaDeFiguras = interpreta (ejemploDeComando1)  
--listaDeFiguras = interpreta (ejemploDeComando2)  

window :: Display
window = InWindow "Window" (1400, 800) (10, 10)
 
background :: Color
background = greyN 0.7

main :: IO ()
main = display window background (pictures listaDeFiguras) 


listaDepuntosParaDibujarUnaLetraL ::[(Float, Float)]
listaDepuntosParaDibujarUnaLetraL = [ (-100, 0), (100, 0), (100,  50), (-50, 50), (-50, 200), (-100, 200), (-100, 0) ]

listaDePuntosParaDibujarUnaLetraC ::[(Float, Float)]
listaDePuntosParaDibujarUnaLetraC = [ (-100, 0), (100, 0), (100,  50), (-50, 50), (-50, 200), (100,200 ), (100,250), (-100, 250),(-100, 0) ]



rotarPunto::Float -> (Float, Float) -> (Float, Float)
rotarPunto gradoDeRotacionEnRadianes punto = (fst punto * (cos gradoDeRotacionEnRadianes) - snd punto * (sin gradoDeRotacionEnRadianes), fst punto * (sin gradoDeRotacionEnRadianes) + snd punto * (cos gradoDeRotacionEnRadianes))

subirPunto::Float -> (Float, Float) -> (Float, Float)
subirPunto n punto = (fst punto, snd punto + n)

adelantarPunto::Float -> (Float, Float) -> (Float, Float)
adelantarPunto n punto = (fst punto + n, snd punto)

rotarUnaListaDePuntos::Float -> [(Float, Float)] -> [(Float, Float)]
rotarUnaListaDePuntos gradosEnRadianes listaDePuntos = map (rotarPunto gradosEnRadianes) listaDePuntos

subirUnaListaDePuntos::Float -> [(Float, Float)] -> [(Float, Float)]
subirUnaListaDePuntos n listaDePuntos = map (subirPunto n) listaDePuntos

adelantarUnaListaDePuntos::Float -> [(Float, Float)] -> [(Float, Float)]
adelantarUnaListaDePuntos n listaDePuntos = map (adelantarPunto n) listaDePuntos

listaDePuntosRotados = rotarUnaListaDePuntos (pi/4) listaDePuntosParaDibujarUnaLetraC
listaDePuntosSubida = subirUnaListaDePuntos (-280) listaDePuntosParaDibujarUnaLetraC
listaDePuntosAdelantada = adelantarUnaListaDePuntos 280 listaDePuntosParaDibujarUnaLetraC
listaDePuntosRotadosSubido = subirUnaListaDePuntos 100 listaDePuntosRotados
listaDePuntosRotadosSubidoAdelantado = adelantarUnaListaDePuntos 150 listaDePuntosRotadosSubido


rotarListaDeListasDePuntos::Float -> [[(Float, Float)]] -> [[(Float, Float)]]
rotarListaDeListasDePuntos gradosEnRadianes (x:[]) = (rotarUnaListaDePuntos gradosEnRadianes x):[[]]
rotarListaDeListasDePuntos gradosEnRadianes (x:xs) = (rotarUnaListaDePuntos gradosEnRadianes x):(rotarListaDeListasDePuntos gradosEnRadianes xs)


adelantarListaDeListaDePuntos::Float -> [[(Float, Float)]] -> [[(Float, Float)]]
adelantarListaDeListaDePuntos n (x:[]) = [adelantarUnaListaDePuntos n x]
adelantarListaDeListaDePuntos n (x:xs) = (adelantarUnaListaDePuntos n x):(adelantarListaDeListaDePuntos n xs) 

subirListaDeListaDePuntos::Float -> [[(Float, Float)]] -> [[(Float, Float)]]
subirListaDeListaDePuntos n (x:[]) = [subirUnaListaDePuntos n x]
subirListaDeListaDePuntos n (x:xs) = (subirUnaListaDePuntos n x):(subirListaDeListaDePuntos n xs) 



mostrar::DibujosBasicos-> [(Float, Float)]
mostrar(LetraC) = listaDePuntosParaDibujarUnaLetraC
mostrar(LetraL) = listaDepuntosParaDibujarUnaLetraL


interpretarOperadoresComoListaDeListasDePuntos::Dibujo DibujosBasicos -> [[(Float, Float)]]
interpretarOperadoresComoListaDeListasDePuntos(Basica a) = [mostrar(a)]
interpretarOperadoresComoListaDeListasDePuntos(Rot45 d1) = rotarListaDeListasDePuntos (pi/4) (interpretarOperadoresComoListaDeListasDePuntos(d1))
interpretarOperadoresComoListaDeListasDePuntos(Juntar a b d1 d2) = interpretarOperadoresComoListaDeListasDePuntos(d1) ++ (adelantarListaDeListaDePuntos 350 (interpretarOperadoresComoListaDeListasDePuntos(d2)))
interpretarOperadoresComoListaDeListasDePuntos(Apilar a b d1 d2) = interpretarOperadoresComoListaDeListasDePuntos(d1) ++ (subirListaDeListaDePuntos (-280) (interpretarOperadoresComoListaDeListasDePuntos(d2)))


lineaDeColorNegroEntreLosPuntos x = color black (line x)

interpretaListaDeListasDePuntosComoListaDeFiguras::[[(Float, Float)]] -> [Picture]
interpretaListaDeListasDePuntosComoListaDeFiguras listaDeListaDePuntos = map (lineaDeColorNegroEntreLosPuntos) listaDeListaDePuntos



 



