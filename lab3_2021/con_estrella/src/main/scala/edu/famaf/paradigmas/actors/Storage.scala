package edu.famaf.paradigmas

import akka.actor.typed.ActorRef
import akka.actor.typed.Behavior
import akka.actor.typed.scaladsl.ActorContext
import akka.actor.typed.scaladsl.AbstractBehavior
import akka.actor.typed.scaladsl.Behaviors
import akka.actor.typed.scaladsl.LoggerOps
import nermodel._


object Storage{
  def apply(): Behavior[StoreRequest] = Behaviors.setup(context => new Storage(context))

  sealed trait StoreRequest
  final case class Store(feed: Seq[String]) extends StoreRequest
  final case class GetNEs(replyTo: ActorRef[Supervisor.SupervisorCommand]) extends StoreRequest
}

class Storage(context: ActorContext[Storage.StoreRequest])
        extends AbstractBehavior[Storage.StoreRequest](context) {

  import Storage._
  context.log.info("Storing Feed")

  var feedList: Seq[Seq[String]] = Seq()

  val model = new NERSimpleModel()
  // Numer of named entities to show
  val nersAmount = 30

  def countNes(feedTexts: Seq[String]): Seq[NERCount] = {
    val nerModel = new NERSimpleModel

    nerModel.getSortedNEs(feedTexts)
  }

  override def onMessage(msg: StoreRequest) = {
    msg match{
      case Store(feed) =>
        feedList = feed +: feedList
        context.log.info("PRINTING FEED:")
        context.log.info(feed.toString)
        context.log.info(" ")
        context.log.info(" ")
        Behaviors.same
      case GetNEs(replyTo) =>
        val ners: Seq[NERCount] = countNes(feedList.flatten)
        println("\n\nTOP 30 NEs:\n")
        ners.take(nersAmount).foreach { ner: NERCount =>
          println(ner.ner, ner.count.toString) }
        replyTo ! Supervisor.StopWithMessage("Estamos parando")
        Behaviors.same
    }
  }
}
