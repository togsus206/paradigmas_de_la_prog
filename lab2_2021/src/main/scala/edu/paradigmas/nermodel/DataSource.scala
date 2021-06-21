
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
    val minTime = 2000
    val maxTime = 5000
    try{
      val response = Http(url)
          .timeout(connTimeoutMs = minTime, readTimeoutMs = maxTime)
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

class RssSource() extends DataSource {
  def parseResponse(url: String): Seq[String] = {
    val xml = XML.loadString(getResponse(url))

    (xml\\ "item").map { item =>
      ((item \ "title").text + " " + (item \ "description").text)
    }
  }
}

class RedditSource() extends DataSource {
  //Expresion regular urls
  val urlRegex = "(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]".r

  def removeUrls(secuencia: Seq[String]): Seq[String] = {
    secuencia.map(urlRegex replaceAllIn(_, " "))
  }

  def parseResponse(url: String): Seq[String] = {
    implicit val formats = DefaultFormats
    val res = (parse(getResponse(url))\"data"\"children"\"data").extract[List[Map[String, Any]]]

    removeUrls(res.map { map =>
      "- title: " + map("title") + "\n\n" + "- description: " + map("selftext")
    })
  }
}
