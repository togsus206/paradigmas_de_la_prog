module Dibujo where

-- Definir el lenguaje.
data Dibujo a = Basica a | Rotar (Dibujo a) | Espejar (Dibujo a)
              | Rot45 (Dibujo a) | Apilar Int Int (Dibujo a) (Dibujo a) 
              | Juntar Int Int (Dibujo a) (Dibujo a) 
              | Encimar (Dibujo a) (Dibujo a)
              deriving (Eq,Show)

--COMBINADORES

-- Composición n-veces de una función con sí misma.
comp :: (a -> a) -> Int -> a -> a
comp f n | n<=0 = id
comp f 1 = f
comp f n = f.(comp f (n-1))

-- Rotaciones de múltiplos de 90.

r180 :: Dibujo a -> Dibujo a
r180 a = comp Rotar 2 a


r270 :: Dibujo a -> Dibujo a
r270 a = Rotar (r180 a)


-- Pone una figura sobre la otra, ambas ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) dib1 dib2 = Apilar 1 1 dib1 dib2


-- Pone una figura al lado de la otra, ambas ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) dib1 dib2 = Juntar 1 1 dib1 dib2


-- Superpone una figura con otra.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) a b = Encimar a b

-- Dadas cuatro figuras las ubica en los cuatro cuadrantes.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto a b c d = Apilar 1 1 (Juntar 1 1 a b) (Juntar 1 1 c d)


-- Una figura repetida con las cuatro rotaciones, superpuestas.
encimar4 :: Dibujo a -> Dibujo a 
encimar4 a = Encimar (Encimar p2 (Rotar p2))
                    (Encimar p3 p4)
            where p2 = Espejar (Rot45 a) 
                  p3 = comp Rotar 2 p2
                  p4 = comp Rotar 3 p2


-- Cuadrado con la misma figura rotada i * 90, para i ∈ {0, ..., 3}.
ciclar :: Dibujo a -> Dibujo a
ciclar a = cuarteto a (Rotar a) (r180 a) (r270 a)

--ESQUEMAS DE MANIPULACION DE FIGURAS

-- Ver un a como una figura.
pureDib :: a -> Dibujo a
pureDib a = Basica a


-- map para nuestro lenguaje.
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
mapDib f (Basica a) = Basica (f a)
mapDib f (Rotar a) = Rotar (mapDib f a)
mapDib f (Espejar a) = Espejar (mapDib f a)
mapDib f (Rot45 a) = Rot45 (mapDib f a)
mapDib f (Apilar i j a b) = Apilar i j (mapDib f a) (mapDib f b)
mapDib f (Juntar i j a b) = Juntar i j (mapDib f a) (mapDib f b)
mapDib f (Encimar a b) = Encimar (mapDib f a) (mapDib f b)


-- Estructura general para la semántica 
sem :: (a -> b) -> (b -> b) -> (b -> b) -> (b -> b) ->
       (Int -> Int -> b -> b -> b) -> 
       (Int -> Int -> b -> b -> b) -> 
       (b -> b -> b) ->
       Dibujo a -> b

sem sbas _ _ _ _ _ _ (Basica bas) = sbas bas
sem sbas srot sesp srot45 sapi sjun senc (Rotar dib) =
  srot (sem sbas srot sesp srot45 sapi sjun senc dib)
sem sbas srot sesp srot45 sapi sjun senc (Espejar dib) =
  sesp (sem sbas srot sesp srot45 sapi sjun senc dib)
sem sbas srot sesp srot45 sapi sjun senc (Rot45 dib) =
  srot45 (sem sbas srot sesp srot45 sapi sjun senc dib)
sem sbas srot sesp srot45 sapi sjun senc (Apilar n m dib1 dib2) =
  sapi n m (sem sbas srot sesp srot45 sapi sjun senc dib1)
           (sem sbas srot sesp srot45 sapi sjun senc dib2)
sem sbas srot sesp srot45 sapi sjun senc (Juntar n m dib1 dib2) =
  sjun n m (sem sbas srot sesp srot45 sapi sjun senc dib1)
           (sem sbas srot sesp srot45 sapi sjun senc dib2)
sem sbas srot sesp srot45 sapi sjun senc (Encimar dib1 dib2) =
  senc (sem sbas srot sesp srot45 sapi sjun senc dib1)
       (sem sbas srot sesp srot45 sapi sjun senc dib2)


--FUNCIONES QUE TOMAN UN PREDICADO

type Pred a = a -> Bool


-- Dado un predicado sobre básicas, cambiar todas las que satisfacen
-- el predicado por la figura básica indicada por el segundo argumento.
cambiar :: Pred a -> a -> Dibujo a -> Dibujo a
cambiar p bas dib = mapDib (\x -> if (p x) then bas else x) dib


-- Alguna básica satisface el predicado.
anyDib :: Pred a -> Dibujo a -> Bool
anyDib p dib = sem p id id id (\n m b1 b2 -> b1 || b2)
                   (\n m b1 b2 -> b1 || b2)
                   (\b1 b2 -> b1 || b2) dib


-- Todas las básicas satisfacen el predicado.
allDib :: Pred a -> Dibujo a -> Bool
allDib p dib = sem p id id id (\n m b1 b2 -> b1 && b2)
                              (\n m b1 b2 -> b1 && b2)
                              (\b1 b2 -> b1 && b2) dib


-- Los dos predicados se cumplen para el elemento recibido.
andP :: Pred a -> Pred a -> Pred a
andP f g a | f a && g a = True
           | otherwise  = False 



-- Algún predicado se cumple para el elemento recibido.
orP :: Pred a -> Pred a -> Pred a
orP f g a | f a || g a = True
          | otherwise  = False 


-- Describe la figura. Ejemplos: 
--   desc (const "b") (Basica b) = "b"
--   desc (const "b") (Rotar (Basica b)) = "rot (b)"
--   desc (const "b") (Apilar n m (Basica b) (Basica b)) = "api n m (b) (b)"
-- La descripción de cada constructor son sus tres primeros
-- símbolos en minúscula, excepto `Rot45` al que se le agrega el `45`.
desc :: (a -> String) -> Dibujo a -> String
desc f dib = sem sbas srot sesp srot45 sapi sjun senc dib
  where sbas = f
        srot = (\s -> "rot (" ++ s ++ ")")
        sesp = (\s -> "esp (" ++ s ++ ")")
        srot45 = (\s -> "rot45 (" ++ s ++ ")")
        sapi = (\n m s1 s2 -> "api " ++ show n ++ " " ++ show m ++ " (" ++ s1 ++ ")"
                 ++ " (" ++ s2 ++ ")")
        sjun = (\n m s1 s2 -> "jun " ++ show n ++ " " ++ show m ++ " (" ++ s1 ++ ")"
                 ++ " (" ++ s2 ++ ")")
        senc = (\s1 s2 -> "enc (" ++ s1 ++ ")"
                 ++ " (" ++ s2 ++ ")")



-- Junta todas las figuras básicas de un dibujo.
basicas :: Dibujo a -> [a]
basicas dib = sem sbas srot sesp srot45 sapi sjun senc dib
      where
        sbas = (\a -> [a])
        srot = (\a -> a)
        sesp = (\a -> a)
        srot45 = (\a -> a)
        sapi = (\n m a b -> a ++ b)
        sjun = (\n m a b -> a ++ b)
        senc = (\a b -> a ++ b)



-- Hay 4 rotaciones seguidas.
esRot360 :: Pred (Dibujo a)
esRot360 (Basica bas) = False
esRot360 (Rotar dib)  | tieneOtrasTresRotaciones (dib) = True
                      | otherwise = esRot360 dib
esRot360 (Espejar dib) = esRot360 dib
esRot360 (Rot45 dib) = esRot360 dib
esRot360 (Apilar _ _ dib1 dib2) = esRot360 dib1 || esRot360 dib2
esRot360 (Juntar _ _ dib1 dib2) = esRot360 dib1 || esRot360 dib2
esRot360 (Encimar dib1 dib2) = esRot360 dib1 || esRot360 dib2


tieneOtrasTresRotaciones ( dib1) = case dib1 of
                      Rotar dib2 -> tieneOtrasDosRotaciones ( dib2)
                      Basica a -> False
                      Espejar dib2 -> esRot360 dib2
                      Apilar _ _ dib2 dib3 -> esRot360 dib2 || esRot360 dib3
                      Juntar _ _ dib2 dib3 -> esRot360 dib2 || esRot360 dib3
                      Encimar dib2 dib3 -> esRot360 dib2 || esRot360 dib3

tieneOtrasDosRotaciones ( dib1) = case dib1 of
                      Rotar dib2 -> tieneOtraRotaciones ( dib2)
                      Basica a -> False
                      Espejar dib2 -> esRot360 dib2
                      Apilar _ _ dib2 dib3 -> esRot360 dib2 || esRot360 dib3
                      Juntar _ _ dib2 dib3 -> esRot360 dib2 || esRot360 dib3
                      Encimar dib2 dib3 -> esRot360 dib2 || esRot360 dib3


tieneOtraRotaciones ( dib1) = case dib1 of
                      Rotar dib2 -> True
                      Basica a -> False
                      Espejar dib2 -> esRot360 dib2
                      Apilar _ _ dib2 dib3 -> esRot360 dib2 || esRot360 dib3
                      Juntar _ _ dib2 dib3 -> esRot360 dib2 || esRot360 dib3
                      Encimar dib2 dib3 -> esRot360 dib2 || esRot360 dib3


--funcion aux para esFlip2
esta_espejando :: (Dibujo a) -> Bool
esta_espejando (Espejar a) = True
esta_espejando _ = False

-- Hay 2 espejados seguidos.
esFlip2 :: Pred (Dibujo a)
esFlip2 (Basica a) = False
esFlip2 (Espejar dib) | esta_espejando (dib) = True
                      | otherwise = esFlip2 dib
esFlip2 (Rotar dib) = esFlip2 dib
esFlip2 (Rot45 dib) = esFlip2 dib
esFlip2 (Apilar _ _ a b) = esFlip2 a || esFlip2 b
esFlip2 (Juntar _ _ a b) = esFlip2 a || esFlip2 b
esFlip2 (Encimar a b) = esFlip2 a || esFlip2 b


data Superfluo = RotacionSuperflua | FlipSuperfluo



-- Aplica todos los chequeos y acumula todos los errores, y
-- sólo devuelve la figura si no hubo ningún error.
check :: Dibujo a -> Either [Superfluo] (Dibujo a)
check dib  | not (esFlip2 dib) && not (esRot360 dib) = Right dib
           | esFlip2 dib && esRot360 dib = Left [FlipSuperfluo, RotacionSuperflua] 
           | esRot360 dib = Left [RotacionSuperflua]
           | esFlip2 dib = Left [FlipSuperfluo]
