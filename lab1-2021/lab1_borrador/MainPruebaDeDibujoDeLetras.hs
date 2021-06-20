module Main(main) where

import Graphics.Gloss

import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import Graphics.Gloss.Geometry.Angle
import qualified Graphics.Gloss.Data.Point.Arithmetic as V


import Graphics.Gloss   
import Data.Monoid


type FloatingPic = Vector -> Vector -> Vector -> Picture
type Output a = a -> FloatingPic


window :: Display
window = InWindow "Window" (1400, 800) (10, 10)
 
background :: Color
background = greyN 0.7


listaDepuntosParaDibujarUnaLetraEle = [ (-100, 0), (100, 0), (100,  50), (-50, 50), (-50, 200), (-100, 200), (-100, 0) ]
punto1Rotado = (-100*(cos (pi/4)) -  0*(sin (pi/4)), -100*(sin (pi/4)) + 0*(cos (pi/4)))
punto2Rotado = (100*(cos (pi/4)) -  0*(sin (pi/4)), 100*(sin (pi/4)) + 0*(cos (pi/4)))
punto3Rotado =  (100*(cos (pi/4)) -  50*(sin (pi/4)), 100*(sin (pi/4)) + 50*(cos (pi/4)))
punto4Rotado = (-50*(cos (pi/4)) - 50*(sin (pi/4)), -50*(sin (pi/4)) + 50*(cos (pi/4)))
punto5Rotado = (-50*(cos (pi/4)) - 200*(sin (pi/4)), -50*(sin (pi/4)) + 200*(cos (pi/4)))
punto6Rotado = (-100*(cos (pi/4)) - 200*(sin (pi/4)), -100*(sin (pi/4)) +  200*(cos (pi/4)))
punto7Rotado = (-100*(cos (pi/4)) - 0*(sin (pi/4)), -100*(sin (pi/4)) + 0*(cos (pi/4)))
listaDepuntosParaDibujarUnaLetraEleRotada = [punto1Rotado, punto2Rotado, punto3Rotado, punto4Rotado, punto5Rotado, punto6Rotado, punto7Rotado]
listaDepuntosParaDibujarUnaLetraEleRoja = color red (line listaDepuntosParaDibujarUnaLetraEle) 
listaDepuntosParaDibujarUnaLetraEleRotadaAzul = color blue (line listaDepuntosParaDibujarUnaLetraEleRotada) 


listaDePuntosParaDibujarUnaLetraC = [ (-100, 0), (100, 0), (100,  50), (-50, 50), (-50, 200), (100,200 ), (100,250), (-100, 250),(-100, 0) ]

rotarPunto gradoDeRotacionEnRadianes punto = (fst punto * (cos gradoDeRotacionEnRadianes) - snd punto * (sin gradoDeRotacionEnRadianes), fst punto * (sin gradoDeRotacionEnRadianes) + snd punto * (cos gradoDeRotacionEnRadianes))
subirPunto n punto = (fst punto, snd punto + n)
adelantarPunto n punto = (fst punto + n, snd punto)

rotarUnaListaDePuntos gradosEnRadianes listaDePuntos = map (rotarPunto gradosEnRadianes) listaDePuntos
subirUnaListaDePuntos n listaDePuntos = map (subirPunto n) listaDePuntos
adelantarUnaListaDePuntos n listaDePuntos = map (adelantarPunto n) listaDePuntos

listaDePuntosRotados = rotarUnaListaDePuntos (pi/4) listaDePuntosParaDibujarUnaLetraC
listaDePuntosSubida = subirUnaListaDePuntos (-280) listaDePuntosParaDibujarUnaLetraC
listaDePuntosAdelantada = adelantarUnaListaDePuntos 280 listaDePuntosParaDibujarUnaLetraC
listaDePuntosRotadosSubido = subirUnaListaDePuntos 100 listaDePuntosRotados
listaDePuntosRotadosSubidoAdelantado = adelantarUnaListaDePuntos 150 listaDePuntosRotadosSubido

letraC_SinModificacion = color red (line listaDePuntosParaDibujarUnaLetraC) 
letraC_Rotada = color green (line listaDePuntosRotados) 
letraC_Adelantada = color yellow (line listaDePuntosAdelantada) 
letraC_Subida = color black (line listaDePuntosSubida) 
letraC_SubidaRotadaYAdelantada = color blue (line listaDePuntosRotadosSubidoAdelantado ) 

 
main :: IO ()

--main = display window background (pictures [listaDepuntosParaDibujarUnaLetraEleRoja, listaDepuntosParaDibujarUnaLetraEleRotadaAzul])

main = display window background (pictures [letraC_SinModificacion, letraC_Rotada, letraC_Adelantada, letraC_Subida, letraC_SubidaRotadaYAdelantada]) 




