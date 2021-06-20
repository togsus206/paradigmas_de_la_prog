package edu.famaf.paradigmas

import akka.actor.typed.ActorRef
import akka.actor.typed.Behavior
import akka.actor.typed.scaladsl.ActorContext
import akka.actor.typed.scaladsl.AbstractBehavior
import akka.actor.typed.scaladsl.Behaviors
import akka.actor.typed.scaladsl.LoggerOps


object Storage{
  def apply(): Behavior[StoreRequest] = Behaviors.setup(context => new Storage(context))

  sealed trait StoreRequest
  final case class Store(feed: Seq[String]) extends StoreRequest
}

class Storage(context: ActorContext[Storage.StoreRequest])
        extends AbstractBehavior[Storage.StoreRequest](context) {

  import Storage._
  context.log.info("Storing Feed")

  var feedList: Seq[Seq[String]] = Seq()

  override def onMessage(msg: StoreRequest) = {
    msg match{
      case Store(feed) =>
        feedList ++ feed
        context.log.info("PRINTING FEED:")
        context.log.info(feed.toString)
        context.log.info(" ")
        context.log.info(" ")
        Behaviors.same
    }
  }
}
