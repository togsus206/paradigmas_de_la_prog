package edu.famaf.paradigmas

import akka.actor.typed.ActorRef
import akka.actor.typed.Behavior
import akka.actor.typed.PostStop
import akka.actor.typed.Signal
import akka.actor.typed.scaladsl.ActorContext
import akka.actor.typed.scaladsl.AbstractBehavior
import akka.actor.typed.scaladsl.Behaviors
import akka.actor.typed.scaladsl.LoggerOps
import scala.util.{Success, Failure}
import scala.concurrent.duration._
import akka.util.Timeout
import datas.{DataSource, RssSource, FeedServices}


object Feed {
  def apply(): Behavior[FeedRequest] = Behaviors.setup(context => new Feed(context))

  sealed trait FeedRequest
  final case class FeedSubscription(url: String, parser: DataSource, replyTo: ActorRef[FeedResponse]) extends FeedRequest

  sealed trait FeedResponse
  final case class FeedMessage(msg: Seq[String]) extends FeedResponse
}

class Feed(context: ActorContext[Feed.FeedRequest]) 
      extends AbstractBehavior[Feed.FeedRequest](context) {

  context.log.info("Beginning of HTTP Request")
  import Feed._
  val parser = new RssSource

  override def onMessage(msg: FeedRequest): Behavior[FeedRequest] = {
    msg match{
      case FeedSubscription(url, parser, replyTo) => 
        val answer = parser.parseResponse(url)
        context.log.info(s"Replying message to ${replyTo}")
        replyTo ! FeedMessage(answer)
        Behaviors.same
    }
  }
}
