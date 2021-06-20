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
import datas.{DataSource,RssSource,RedditSource,StackQSource,FeedServices}


case class Subscription(url: String, urlParams: List[String], urlType:String, fields:List[String])


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


  for (subs <- subscriptions){
    val parser = subs.urlType match{
      case "rss"    =>  if (subs.fields == Nil) {
                          new RssSource()
                        } else {
                          new RssSource(subs.fields)
                        }
      case "reddit" =>  if (subs.fields == Nil) {
                          new RedditSource()
                        } else {
                          new RedditSource(subs.fields)
                        }
      case "stackQ" =>  if (subs.fields == Nil) {
                          new StackQSource()
                        } else {
                          new StackQSource(subs.fields)
                        }
    }
    service.subscribe(subs.url, subs.urlParams, parser)
  }


  val feedTexts = service.parseAll()


  val ners: Seq[NERCount] = countNes(feedTexts)
  println("Top 20 trending entities")
  ners.take(20).foreach { ner: NERCount =>
    println(ner.ner, ner.count.toString) }
}
