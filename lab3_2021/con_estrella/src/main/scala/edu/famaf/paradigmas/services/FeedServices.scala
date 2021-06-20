package edu.famaf.paradigmas.datas

class FeedServices {
  case class Subscription(url: String, parser: DataSource)
  //variable donde se guardan las suscripciones
  var subsList: Seq[Subscription] = Seq()

  //funcion para agregar subscripciones a la lista
  def subscribe[T <: DataSource](template: String, urlParams: Seq[String] = Seq(), parser: T): Unit = {
    val urls: Seq[String] = (if (urlParams.isEmpty) { Seq(template) } else {
      urlParams.map { param => template.format(param) }
    //filtramos para no agregar de nuevo una url que ya estaba en la lista:
    }).filter { url =>
      !(subsList.map(_.url).contains(url))
    }

    val subscriptions: Seq[Subscription] = urls.map {url =>
      Subscription(url, parser)
    }

    subsList = subsList ++ subscriptions
  }

  def parseAll(): Seq[String] = {
    val parsedList = subsList.map { sub =>
      sub.parser.parseResponse(sub.url)
    }
    parsedList.flatten
  }
}
