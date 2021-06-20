GRAFICOS DE ESCHER

En este proyecto hemos intentado definir un lenguaje como un tipo de datos con figuras polimorficas, con el fin de graficar este dibujo. Ademas del lenguaje, definimos una interpretacion geometrica de las figuras, para tener un modo de que nuestro lenguaje puedan prodducir estas figuras.
Finalmente nos hemos ayudado de la libreria gloos para mostrar en pantalla el dibujo realizado.

EXPERIENCIAS

En mi experiencia, sobre todo al principio, luche un poco sobre como entender los primeros pasos del proyecto, pero una vez que pude interpretar mejor lo que habia que hacer, gracias a la ayuda de mis compareños, todo se volvio mas claro. Ademas desarrolle no solo nuevas tecnicas de programacion, si no tambien, nuevas maneras de hacer funciones en Haskell. Sin duda, me gustaria resaltar lo interesanre del paradigma funcional, que si bien uno no siempre esta acostumbrado a pensar de esa forma, se vuelve bastante interesanre ponerse a interpretae como hacer las cosas dentro de el.


EJECUCION

1) DESCARGAR EL REPOSITORIO CON GIT CLONE
2) ABRIR UN INTERPRETE DE HASKELL (Por ej: GHCI)
3) USAR EL COMANDO ":l Main" (Con esto compilara los archivos necesarios)
4) ESCRIBIR "main" PARA QUE SE ABRA LA VENTANA CON EL DIBUJO


PREGUNTAS

A) ¿Por qué están separadas las funcionalidades en los módulos indicados? 


La principal razon de esto es la modulariidad del codigo y polimorfismo del mismo. En el módulo Interp se encuentra la semántica, la función interp nos dice como se interpretan los distintos operadores. En el futuro,si se quiere modificar la semántica, solo hay que modificar este módulo, dejando intacto el resto de la aplicación. 
Como se puede ver el módulo interp es el único módulo que importa la librería gloss, si queremos cambiar la librería gráfica gloss por otra librería solo hay que modificar la otra libreria y modificar la implementación de la función interp.  Ademas de agregar la definición de varias figuras (por ej. trian1, trian2, triangD, rectang, fShape) que usan la librería gloss, patra que usen la nueva libreria elegida.
Por otro lado, si conservamos el mismo lenguaje e interpretacion, podemos darle diferentes uso a estos, creando varios "archivos de uso", como lo son "Escher.hs" y "Ejemplo.hs", asi podriamos "dibujar" varias figuras con un mismo lenguaje e interpretacion.
Al hacer polimorficas a la funciones de "Dibujo.hs", podemos darle diferentes tipos a nuestro "Dibujo a", y modificar la creacion de un dibujo un poco a nuestro antojo.


B) ¿Harían alguna modificación a la partición en módulos dada?


Sentimos que la particion de los modulos esta bastante bien estructurada y casi no amerita ser cambiada. Pero si tueviera que hacer un pequeño cambio capaz separaria en dos modulos el archivo Dibujo.hs, por un lado la estructura de la figura, con sus funciones mas basicas(com, r180, r270,etc) y por el otro, todo lo que tiene que ver con su manipulacion de las figutas(pureDib, mapDib, sem, etc).

Otra idea dada es que podría agregar una capa de abstracción y no usar directamente la librería gloss. Se podría definir un módulo que defina todas las figuras y funcionalidades adiciones y luego importar ese módulo en vez de importar directamente la librería gloss. 


C) ¿Por qué las funciones básicas no están incluidas en la definición del lenguaje, y en vez es un parámetro del tipo?

Al tener un dibujo polimorfico, como lo es "Dibujo a", podemos darnos la libertad de elegir que tipo va a tener nuestro "a". En nuestro caso, como elegimos "type Escher = Bool", pudimos hacer que las funciones basicas se definan de acuerdo a nuestro tipo elegido, y asi tambien lo podriamos haber hecho en caso de darle a Escher cualquier otro tipo.
Si nos limitamos a escribir estas funciones en la definicion del lenguaje, perdemos mucha flexibilidad en nuestro programa, provocando perdida de polimorfismo y tambien complicamos la reutilizacion de codigo.


D)Explique cómo hace Interp.grid para construir la grilla, explicando cada pedazo de código que interviene.

"grid" es una funcion que toma un entero, un vector(parte de la libreria Gloss) y 2 flotantes, para devolver un dato de tipo Picture, tambien dado por la libreria, que puede representa diferentes figuras(lineas,circulos,etc). Uno de los contructores de Picture, es un Pictures, que representa una figura formada por otras figuras, que es lo que devolvera nuestra funcion.
Entonces dentro de esta "Pictures", se encuentra la componente "ls", que usando varias funciones, incluida hlines(definida anteriormente)*, se encarga de dibujar las lineas en horizontal de la grilla.
Luego la segunda componente de este "Pictures", mediante otras funciones, tambien definidas en Gloss(traslate,rotate,etc), se encarga de girar 90 grados las lineas generadas por "ls" y con la funcion "traslate" ubicarlas para que queden posicionados sobre las de "ls".
Finalmente como dijimos que Pictures en un representacion formado por otras figuras, si superponemos estas dos componentes quedandonos una grilla.

**La funcion "hlines" toma un vector y dos flotantes para devolver una lista de Pictures(circulo,lineas, etc). Entonces genera lineas(con el contructor dado por Picture) con diferentes coordenadas, que se van incorporando a la lista de de Pictures, para ir formando las lineas horizontales mencionadas anteriormente para formar mas tarde la grilla.
