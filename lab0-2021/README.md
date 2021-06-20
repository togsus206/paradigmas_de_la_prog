GRAFICOS DE ESCHER

En este proyecto hemos intentado definir un lenguaje como un tipo de datos con figuras polimorficas, con el fin de graficar este dibujo. Ademas del lenguaje, definimos una interpretacion geometrica de las figuras, para tener un modo de que nuestro lenguaje puedan prodducir estas figuras.
Finalmente nos hemos ayudado de la libreria gloos para mostrar en pantalla el dibujo realizado.

EXPERIENCIAS

En mi experiencia, sobre todo al principio, luche un poco sobre como entender los primeros pasos del proyecto, pero una vez que pude interpretar mejor lo que habia que hacer, gracias a la ayuda de mis compareños, todo se volvio mas claro. Ademas desarrolle no solo nuevas tecnicas de programacion, si no tambien, nuevas maneras de hacer funciones en Haskell. Sin duda, me gustaria resaltar lo interesanre del paradigma funcional, que si bien uno no siempre esta acostumbrado a pensar de esa forma, se vuelve bastante interesanre ponerse a pensar dentro de el.


EJECUCION

1) DESCARGAR EL REPOSITORIO CON GIT CLONE
2) ABRIR UN INTERPRETE DE HASKELL (Por ej: GHCI)
3) USAR EL COMANDO ":l Main" (Con esto compilara los archivos necesarios)
4) ESCRIBIR "main" PARA QUE SE ABRA LA VENTANA CON EL DIBUJO


PREGUNTAS

A) ¿Por qué están separadas las funcionalidades en los módulos indicados? 

La principal razon de esto es la modulariidad del codigo y polimorfismo del mismo. Al separar el lenguaje y su interpretacion, podemos hacer que para un mismo lenguaje haya diferentes tipos de interpretaciones y provocar asi diferentes dibujos, usando el mismo archivo "Dibujo.hs" y "Escher.hs".
Por otro lado, si conservamos el mismo lenguaje e interpretacion, podemos darle diferentes uso a estos, creando varios "archivos de uso", como lo son "Escher.hs" y "Ejemplo.hs", asi podriamos "dibujar" varias figuras con un mismo lenguaje e interpretacion.
Al hacer polimorficas a la funciones de "Dibujo.hs", podemos darle diferentes tipos a nuestro "Dibujo a", y modificar la creacion de un dibujo un poco a nuestro antojo.


B) ¿Harían alguna modificación a la partición en módulos dada?

Sentimos que la particion de los modulos esta bastante bien estructurada y casi no amerita ser cambiada. Pero si tueviera que hacer un pequeño cambio capaz separaria en dos modulos el archivo Dibujo.hs, por un lado la estructura de la figura, con sus funciones mas basicas(com, r180, r270,etc) y por el otro, todo lo que tiene que ver con su manipulacion de las figutas(pureDib, mapDib, sem, etc).


C) ¿Por qué las funciones básicas no están incluidas en la definición del lenguaje, y en vez es un parámetro del tipo?

D)Explique cómo hace Interp.grid para construir la grilla, explicando cada pedazo de código que interviene.