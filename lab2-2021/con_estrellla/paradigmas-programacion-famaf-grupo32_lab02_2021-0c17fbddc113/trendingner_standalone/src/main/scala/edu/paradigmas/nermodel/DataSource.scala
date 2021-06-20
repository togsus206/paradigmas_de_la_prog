
package edu.paradigmas.datas


import scalaj.http.{Http, HttpResponse}
import scala.xml.XML

import org.json4s.JsonDSL._
import org.json4s._
import org.json4s.jackson.JsonMethods._
import org.json4s.Formats

import scala.util.matching.Regex


trait DataSource {
  def getResponse(url: String): String = {
    try{
      val response = Http(url)
          .timeout(connTimeoutMs = 2000, readTimeoutMs = 5000)
          .asString

      response.body
    }
    catch{
      case ex: java.net.MalformedURLException => ""
      case ex: java.net.ConnectException => ""
      case ex: java.net.UnknownHostException => ""
    }
  }
  def parseResponse(url: String): Seq[String]
}

class RssSource(fields: Seq[String] = Seq("title", "description")) extends DataSource {
  def parseResponse(url: String): Seq[String] = {
    val xml = XML.loadString(getResponse(url))

    (xml\\ "item").map { item =>
      fields.map { field =>
        (item \ s"$field").text + " "
      }.foldLeft("")(_ + _)
    }
  }
}

class RedditSource(fields: Seq[String] = Seq("title", "selftext")) extends DataSource {
  //Expresion regular urls
  val urlRegex = "(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]".r

  def removeUrls(secuencia: Seq[String]): Seq[String] = {
    secuencia.map(urlRegex replaceAllIn(_, " "))
  }

  def parseResponse(url: String): Seq[String] = {
    implicit val formats = DefaultFormats
    val res = (parse(getResponse(url))\"data"\"children"\"data").extract[List[Map[String, Any]]]

    removeUrls(res.map { Map =>
      fields.map { field =>
        Map(field) + " "
      }.foldLeft("")(_ + _)
    })
  }
}

class StackQSource(fields: Seq[String] = Seq("title")) extends DataSource {
  def parseResponse(url: String): Seq[String] = {
    implicit val formats = DefaultFormats
    val res = (parse(getResponse(url))\"items").extract[List[Map[String, Any]]]

    res.map { Map =>
      fields.map { field =>
        Map(field) + " "
      }.foldLeft("")(_ + _)
    }
  }
}
