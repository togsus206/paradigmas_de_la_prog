package edu.paradigmas

//
import scalaj.http.{Http, HttpResponse}
import scala.xml.XML
//

import org.json4s.JsonDSL._
import org.json4s._
import org.json4s.jackson.JsonMethods._
import scala.io._

import nermodel.{NERSimpleModel, NERCount}
import datas.{DataSource,RssSource,RedditSource,FeedServices}


case class Subscription(url: String, urlParams: List[String], urlType:String)


/*
 * Main class
 */
object TrendingNer extends App {

  // Initial configurations
  implicit val formats = DefaultFormats

  def readSubscriptions(): List[Subscription] = {
    // args is a list that receives the parameters passed by console.
    println(s"Reading subscriptions from ${args}")
    val filename = args.length match {
      case 0 => "subscriptions.json" //aca va el archivo desde donde se lee
      case _ => args(0)
    }
    println(s"Reading subscriptions from ${filename}")
    val jsonContent = Source.fromFile(filename)
    (parse(jsonContent.mkString)).extract[List[Subscription]]
  }

  def countNes(feedTexts: Seq[String]): Seq[NERCount] = {
    println("Obtaining NERs:")
    val nerModel = new NERSimpleModel

    nerModel.getSortedNEs(feedTexts)
  }

  val subscriptions = readSubscriptions()

  //

  val service = new FeedServices

  val rssSource = new RssSource
  val redditSource = new RedditSource
  for (subs <- subscriptions){
     subs.urlType match{
       case "rss" => service.subscribe(subs.url, subs.urlParams, rssSource)
       case "reddit" => service.subscribe(subs.url, subs.urlParams, redditSource)
     }
  }


  val feedTexts = service.parseAll()

  val takeAmount = 20
  val ners: Seq[NERCount] = countNes(feedTexts)
  println("Top 20 trending entities")
  ners.take(takeAmount).foreach { ner: NERCount =>
    println(ner.ner, ner.count.toString) }
}
