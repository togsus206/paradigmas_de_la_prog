package edu.famaf.paradigmas

import akka.actor.typed.ActorSystem
import org.json4s.JsonDSL._
import org.json4s._
import org.json4s.jackson.JsonMethods._
import org.slf4j.{Logger, LoggerFactory}
import scala.io._
import scopt.OParser
import scala.util.{Success, Failure}

//
import funcions.{read_it}

object SubscriptionApp extends App {
  implicit val formats = DefaultFormats

  val logger: Logger = LoggerFactory.getLogger("edu.famaf.paradigmas.SubscriptionApp")

  case class Config(
    input: String = "",
    maxUptime: Int = 10
  )
 
  val new_read = new read_it()
  val subscriptions = new_read.readSubscriptions(args)

  val builder = OParser.builder[Config]
  val argsParser = {
    import builder._
    OParser.sequence(
      programName("akka-subscription-app"),
      head("akka-subscription-app", "1.0"),
      opt[String]('i', "input")
        .action((input, config) => config.copy(input = input))
        .text("Path to json input file"),
      opt[Int]('t', "max-uptime")
        .optional()
        .action((uptime, config) => config.copy(maxUptime = uptime))
        .text("Time in seconds before sending stop signal"),
    )
  }

  OParser.parse(argsParser, args, Config()) match {
    case Some(config) =>
      val system = ActorSystem[Supervisor.SupervisorCommand](Supervisor(), "subscription-app")
      //
      for (sub <- subscriptions){
        system ! Supervisor.Subscribe(sub.url,sub.feeds)
      }
      //
      Thread.sleep(config.maxUptime * 1000)
      system ! Supervisor.StopWithMessage("Estamos parando")
    case _ => println("bad arguments")
  }
}
