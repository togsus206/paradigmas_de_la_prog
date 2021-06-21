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

Utilizamos un trait, clases y objetos. Un objeto es una instancia de una clase y una clase es una plantilla que define el comportamiento que van a tener los objetos de esa clase.
Las clases que heredan de  DataSource tienen la responsabilidad de la obtención de los datos y la clase NERModel se encarga del procesamiento. Creamos un objeto de la clase RssSource y llamamos al método parseResponse:

val rssSource = new RssSource()
val listRss = rssSource.parseResponse(urlRss)


Luego creamos un objeto de la clase NERModel y llamamos al método getNEs con los datos que obtuvimos del método parseResponse

val model = new NERModel
val resultRss = model.getNEs(listRss)



APARTADO 2)

2.1)¿Por qué utilizar literales como Strings para diferenciar comportamientos similares crea acoplamiento? 


Utilizar literales como parámetro para diferenciar comportamientos similares crea acoplamiento de control. Dos módulos están acoplados por control si uno le pasa a otro un dato para controlar su lógica interna. Por ejemplo pasando un flag de selección que determina que función tiene que ejecutar el módulo. El acoplamiento de control es un grado alto de acoplamiento y generalmente indica errores de diseño.

Además del acoplamiento de control uno de los parámetros, el string que se pasa como flag, determina el significado del otro parámetro. Esto crea un tipo de acoplamiento entre los propios parámetros. Si pasamos como primer parámetro el literal Rss entonces el segundo parámetro lo interpreto como un string con formato rss y si pasamos como primer parámetro el literal json entonces el segundo parámetro lo interpreto como un string con formato json. Pero de las cuatro combinaciones que se pueden dar  (pasar como primer parámetro un literal rss y como segundo parámetro un string con formato rss, pasar como primer parámetro un literal rss y como segundo parámetro un string con formato json, pasar un literal json y un string con formato rss y pasar un literal json con un string con formato json) hay dos que no tienen sentido y puede crear inconsistencias (por ejemplo si tengo el primer parámetro Rss y el segundo parámetro un string con formato Json).


2.2)¿Qué concepto(s) de la Programación Orientada a Objetos utilizaron para resolver este problema?


Nosotros solucionamos estos problemas usando herencia y polimorfismo. Tenemos que parser RSS y parser Json son dos tipos de parser. Parser RSS es un parser que está especializado en parser RSS y parser Json es un parser que está especializado en parser Json. Se puede decir que parser rss es una refinación de la clase general parser:  el método parseResponse de la subclase (RssSource y JsonSource) refinan el comportamiento de la superclase (DataSource) manteniendo la semántica.

Si algún método de alguna clase necesita recibir como parámetro un objeto que sepa parser, al método no le va a importar como hace el objeto para parser, ni si es un parser de tipo RSS o de tipo Json. Al método de la clase solo le va a interesar que sean herederos de la clase parser. El día de mañana se pueden crear otras clases que hereden de parser y sirvan para parser otro formato y la clase que usa objetos de tipo parser no tiene que ser modificada. 

Tambien utilizamos excepciones para capturar algunos problemas que podemos llegar a tener cuando queramos obtener una respuesta http.
Ademas del ya mencionado "trait"

Scala da soporte a la noción de case class. Case class permite hacer pattern maching, una sintaxis de inicialización compacta con funciones que son implícitamente definidas. Por defecto los objetos clase class son serializables mientras que las clases no. Una forma de serializar un objeto es convertirlo en un string json.


APARTADO 3)

3.1) ¿Qué clase almacena las URLs?

Utilizamos la clase FeedServices para almacenar la lista de las URL y sus metodos. En ella, un usuario 
podra almacenar las subscripciones que desea y poder llamar a un metodo para ordenar todas las entidades
en todos los enlaces.


3.2) ¿Cómo funciona el polimorfismo de clases en su implementación? ¿Qué desventaja tiene pasar al método subscribe un parámetro de tipo string que pueda tomar los valores “rss” y “reddit”, y dejar que decida qué tipo de parser usar?

En nuestras clase FeedService usamos un polimorfismo al pasar como parametro el parser para que decida la funcion "subscribe" de que manera parsear la respuesta obtenida.
La desventaja de pasar este parametro de tipo string, es que en caso de pasar mal este, puede provocar un error en el problema y no saber como tomarlo, dando como resultado un fallo.


## Decisiones de diseño

El primer componente se encarga de la obtención de los datos y el segundo componente del procesamiento de los mismos.

Las clases RssSource y JsonSource que heredan de DataSource e implementan al primer componente. Tiene el método parseResponse(url: String): Seq[String] que recibe como parámetro un string y devuelve una secuencia de string.


class NERModel()
def getNEsSingle(text: String): Seq[String]
def getNEs(textList: Seq[String]): Seq[Seq[String]]
def sortNEs(result: Seq[Seq[String]]): List[(String, Int)]

trait DataSource
parseResponse(url: String): Seq[String]

Luego una clase FeedService que se encarga del procesamiento de todas las subscripciones deseadas.

## Puntos estrella

Hicimos el primer punto estrella. Para ello, sub-dividimos nuestro case en dos tareas mas, que implica fijarse si el usuario incluye una lista de campos a obtener en cada url, si no lo hizo, continuamos con nuestra implementacion tradicional, en caso de hacerlo, parseamos esta lista con el url para poder obtener las entidades de todas las fuentes que desee.

También hicimos los puntos estrella 2 y 3.