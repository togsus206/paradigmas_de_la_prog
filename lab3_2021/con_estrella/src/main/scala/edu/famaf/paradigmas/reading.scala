package edu.famaf.paradigmas.funcions

import akka.actor.typed.ActorSystem
import org.json4s.JsonDSL._
import org.json4s._
import org.json4s.jackson.JsonMethods._
import org.slf4j.{Logger, LoggerFactory}
import scala.io._
import scopt.OParser


class read_it{

  implicit val formats = DefaultFormats

  case class Subscription(name: String, feeds: List[String], url: String, urlType: String)

  def readSubscriptions(argumento: Array[String]): List[Subscription] = {
    // args is a list that receives the parameters passed by console.
    val filename = argumento.length match {
      case 0 => "subscriptions.json" //aca va el archivo desde donde se lee
      case _ => argumento(1)
    }
    println(s"Reading subscriptions from ${filename}")
    val jsonContent = Source.fromFile(filename)
    (parse(jsonContent.mkString)).extract[List[Subscription]]
  }
}