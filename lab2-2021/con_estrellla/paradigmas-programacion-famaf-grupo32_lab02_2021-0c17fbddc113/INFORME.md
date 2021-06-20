# Título
Entidades de las que mas se habla en el globo

## Grupo 32

Integrantes:
* Francisco Joray
* Matias Valle
* Marcos Cravero

## Respuestas

### Pregunta

APARTADO 1)

1.1)¿Como es la interfaz de la clase u objeto que implementaron para el primer componente?

Implementamos un "trait" con la funcion que no da la respuesta del URL, y definimos una funcion virtual "parseResponse", que puede ser redefinida por sus clases hijas.
Luego implementamos 2 clases que heredan de esta que se encargan de parsear la respuesta, dependiendo cual obtengan.

1.2)¿Utilizaron una clase o un objeto? ¿Por qué?
Utilizamos una clase y un "trait", y luego instanciamos un objeto de esa clase para usar sus metodos como mencionamos
arriba.

APARTADO 2)

2.1)¿Por qué utilizar literales como Strings para diferenciar comportamientos similares crea acoplamiento? 

Al tener que usar estos literales, estamos obligados a que para usar 
esta funcion, debemos acompañarlo siempre de estos parametros, es decir, no podemos separar la
implementacion de la url sin la carga de llevar este literal acompañado del url.

2.2)¿Qué concepto(s) de la Programación Orientada a Objetos utilizaron para resolver este problema?

Utilizamos clases, e instanciamos obejtos de esas clases en la cual definimos metodos. Tambien utilizamos 
excepciones para capturar algunos problemas que podemos llegar a tener cuando queramos obtener una respuesta http.
Ademas del ya mencionado "trait"

APARTADO 3)

3.1) ¿Qué clase almacena las URLs?

Utilizamos la clase FeedServices para almacenar la lista de las URL y sus metodos. En ella, un usuario 
podra almacenar las subscripciones que desea y poder llamar a un metodo para ordenar todas las entidades
en todos los enlaces.


3.2) ¿Cómo funciona el polimorfismo de clases en su implementación? ¿Qué desventaja tiene pasar al método subscribe un parámetro de tipo string que pueda tomar los valores “rss” y “reddit”, y dejar que decida qué tipo de parser usar?

En nuestras clase FeedService usamos un polimorfismo al pasar como parametro el parser para que decida la funcion "subscribe" de que manera parsear la respuesta obtenida.
La desventaja de pasar este parametro de tipo string, es que en caso de pasar mal este, puede provocar un error en el problema y no saber como tomarlo, dando como resultado un fallo.


## Decisiones de diseño

Elegimos usar dos clases(que heredan de un trait) que se encarguen del procesamiento de las URL's y una funcion con un "case"
que decida cual funcion aplicar dependiendo el URL pasado. Luego una clase FeedService que se encarga del procesamiento de todas las subscripciones deseadas.

## Puntos estrella

¿Qué puntos estrella hicieron?, ¿cómo diseñaron la solución?. En esta sección
se pueden explayar un poco más, ya que los puntos estrella no tienen preguntas
concretas.