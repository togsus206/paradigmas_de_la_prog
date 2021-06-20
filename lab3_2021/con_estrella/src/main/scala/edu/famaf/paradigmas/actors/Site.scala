package edu.famaf.paradigmas

import akka.actor.typed.ActorRef
import akka.actor.typed.Behavior
import akka.actor.typed.scaladsl.ActorContext
import akka.actor.typed.scaladsl.AbstractBehavior
import akka.actor.typed.scaladsl.Behaviors
import akka.actor.typed.scaladsl.LoggerOps
import scala.util.{Success, Failure}
import scala.concurrent.duration._
import akka.util.Timeout
import datas.{DataSource, RssSource, FeedServices}


object Site {
  def apply(): Behavior[SiteRequest] = Behaviors.setup(context => new Site(context))

  sealed trait SiteRequest
  final case class SiteSubscription(url: String, urlParams: Seq[String], parser: DataSource, replyTo: ActorRef[SiteResponse]) extends SiteRequest
  final case class FeedResponseMessage(msg: Seq[String], feedsAmount: Int, replyTo: ActorRef[SiteResponse]) extends SiteRequest
  final case class FeedFailedMessage(msg: String) extends SiteRequest

  sealed trait SiteResponse
  final case class SiteMessage(msg: Seq[String]) extends SiteResponse
}

class Site(context: ActorContext[Site.SiteRequest]) 
      extends AbstractBehavior[Site.SiteRequest](context) {

  implicit val timeout: Timeout = 3.seconds
  import Site._

  // Crearemos y guardaremos un actor por cada feed del site
  var feeds = Map.empty[String, ActorRef[Feed.FeedRequest]]
  // Aquí guardaremos las respuestas de los feeds para luego
  // enviárselas al supervisor
  var texts: Seq[String] = Seq()
  // Contador usado para saber cuándo obtuvimos todos los feeds
  // de una misma subscripción para poder enviárselos al supervisor
  var counter: Int = 0

  val servicioFeed = new FeedServices

  override def onMessage(msg: SiteRequest): Behavior[SiteRequest] = {
    msg match{
      case FeedResponseMessage(msg, feedsAmount, replyTo) =>
				texts = msg ++ texts
        counter += 1
				if (counter == feedsAmount) {
          replyTo ! SiteMessage(texts)
          counter = 0
          texts = Seq()
				}
        Behaviors.same
      case FeedFailedMessage(msg) => 
        context.log.error(msg)
        Behaviors.same
      case subMsg @ SiteSubscription(url, params, parser, replyTo) =>
				val feedsAmount: Int = if (params.length == 0) {1} else {params.length}
        servicioFeed.subscribe(url, params, parser)

        for (subs <- servicioFeed.subsList) {
          feeds.get(subs.url) match {
            case Some(feedActor) =>
              context.ask(feedActor, Feed.FeedSubscription(subs.url, subs.parser, _)) {
                case Success(Feed.FeedMessage(msg)) =>
									FeedResponseMessage(msg, feedsAmount, replyTo)
                case Failure(e) =>
									FeedFailedMessage(e.getMessage)
              }
            case None =>
              context.log.info("Subscribing a new feed")
              val feedActor = context.spawn(Feed(), s"new-Feed-${feeds.size}")
              feeds += subs.url -> feedActor
              context.ask(feedActor, Feed.FeedSubscription(subs.url, subs.parser, _)) {
                case Success(Feed.FeedMessage(msg)) =>
									FeedResponseMessage(msg, feedsAmount, replyTo)
                case Failure(e) =>
									FeedFailedMessage(e.getMessage)
              }
              context.log.info(s"Replying message to ${replyTo}")
          }
        }

        Behaviors.same        
    }
  }
}
