# GRÁFICOS DE ESCHER

En este proyecto hemos intentado definir un lenguaje como un tipo de datos con figuras polimórficas, con el fin de graficar este dibujo. Además del lenguaje, definimos una interpretación geométrica de las figuras, para tener un modo de que nuestro lenguaje pueda producir estas figuras. Finalmente nos hemos ayudado de la librería _Gloos_ para mostrar en pantalla el dibujo realizado.

## EXPERIENCIAS

En nuestra experiencia, sobre todo al principio, luchamos un poco sobre cómo entender los primeros pasos del proyecto, pero una vez que pudimos interpretar mejor lo que había que hacer, gracias a nuestro trabajo en equipo, todo se volvió más claro. Además desarrollamos no sólo nuevas técnicas de programación, si no también, nuevas maneras de hacer funciones en _Haskell_. Sin duda, nos gustaría resaltar lo interesante del paradigma funcional, que si bien uno no siempre está acostumbrado a pensar de esa forma, se vuelve bastante interesante ponerse a interpretar cómo hacer las cosas dentro de él.

## EJECUCION

1) DESCARGAR EL REPOSITORIO CON GIT CLONE
2) ABRIR UN INTÉRPRETE DE HASKELL (Por ej: GHCI)
3) USAR EL COMANDO "**:l Main**" (Con esto compilará los archivos necesarios)
4) ESCRIBIR "**main**" PARA QUE SE ABRA LA VENTANA CON EL DIBUJO

## PREGUNTAS

A) ¿Por qué están separadas las funcionalidades en los módulos indicados?

La principal razón de esto es la modularidad del código y polimorfismo del mismo. En el módulo _Interp_ se encuentra la semántica, la función _interp_ nos dice cómo se interpretan los distintos operadores. En el futuro, si se quisiera modificar la semántica, solo hay que modificar este módulo, dejando intacto el resto de la aplicación. Como se puede ver el módulo _interp_ es el único módulo que importa la librería _gloss_. Si queremos cambiar la librería gráfica gloss por otra librería solo hay que modificar la otra librería y modificar la implementación de la función interp. Ademas de agregar la definición de varias figuras (por ej. trian1, trian2, triangD, rectang, fShape) que usan la librería gloss, para que usen la nueva librería elegida. Por otro lado, si conservamos el mismo lenguaje e interpretación, podemos darle diferentes usos a estos, creando varios "archivos de uso", como lo son "Escher.hs" y "Ejemplo.hs", y así podriamos "dibujar" varias figuras con un mismo lenguaje e interpretación. Al hacer polimórficas a la funciones de "Dibujo.hs", podemos darle diferentes tipos a nuestro "Dibujo a", y modificar la creación de un dibujo un poco a nuestro antojo.

B) ¿Harían alguna modificación a la partición en módulos dada?

Sentimos que la partición de los módulos está bastante bien estructurada y casi no amerita ser cambiada. Pero si tuviéramos que hacer un pequeño cambio, capaz separaríamos en dos módulos el archivo Dibujo.hs: por un lado la estructura de la figura, con sus funciones mas básicas (com, r180, r270,etc) y por el otro, todo lo que tiene que ver con la manipulación de las figuras (pureDib, mapDib, sem, etc).

Otra idea es que podríamos agregar una capa de abstracción y no usar directamente la librería gloss. Se podría definir un módulo que defina todas las figuras y funcionalidades adicionales y luego importar ese módulo en vez de importar directamente la librería gloss.

C) ¿Por qué las funciones básicas no están incluidas en la definición del lenguaje, y en vez es un parámetro del tipo?

Al tener un dibujo polimórfico, como lo es "Dibujo a", podemos darnos la libertad de elegir qué tipo va a tener nuestro "a". En nuestro caso, como elegimos "type Escher = Bool", pudimos hacer que las funciones básicas se definan de acuerdo a nuestro tipo elegido, y así también lo podríamos haber hecho en caso de darle a Escher cualquier otro tipo. Si nos limitamos a escribir estas funciones en la definición del lenguaje, perdemos mucha flexibilidad en nuestro programa, provocando pérdida de polimorfismo y también complicamos la reutilización de código.

D) Explique cómo hace Interp.grid para construir la grilla, explicando cada pedazo de código que interviene.

"grid" es una función que toma un entero, un vector (parte de la libreria Gloss) y 2 flotantes, para devolver un dato de tipo Picture, también dado por la libreria, que puede representar diferentes figuras (lineas,circulos,etc). Uno de los contructores de Picture, es un Pictures, que representa una figura formada por otras figuras, que es lo que devolverá nuestra función. Entonces dentro de esta "Pictures", se encuentra la componente "ls", que usando varias funciones, incluida hlines (definida anteriormente)*, se encarga de dibujar las lineas en horizontal de la grilla. Luego la segunda componente de este "Pictures", mediante otras funciones, también definidas en Gloss (traslate,rotate,etc), se encarga de girar 90 grados las lineas generadas por "ls" y con la funcion "traslate" ubicarlas para que queden posicionados sobre las de "ls". Finalmente como dijimos que Pictures en un representacion formado por otras figuras, si superponemos estas dos componentes quedándonos una grilla.

**La funcion "hlines" toma un vector y dos flotantes para devolver una lista de Pictures(circulo,lineas, etc). Entonces genera lineas(con el contructor dado por Picture) con diferentes coordenadas, que se van incorporando a la lista de de Pictures, para ir formando las lineas horizontales mencionadas anteriormente para formar mas tarde la grilla.

## ANIMACIONES:
Subimos en la branch "animations" una animación muy básica que consiste en un paisaje giratorio.
