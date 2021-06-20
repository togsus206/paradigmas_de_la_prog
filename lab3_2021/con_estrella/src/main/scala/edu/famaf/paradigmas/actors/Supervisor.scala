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
import datas.{DataSource}


object Supervisor {
  def apply(): Behavior[SupervisorCommand] = Behaviors.setup(context => new Supervisor(context))

  sealed trait SupervisorCommand
  final case class Stop() extends SupervisorCommand
  final case class StopWithMessage(msg: String) extends SupervisorCommand
  final case class Subscribe(url: String, params: Seq[String], parser: DataSource) extends SupervisorCommand
  final case class SiteResponseMessage(msg: Seq[String]) extends SupervisorCommand
  final case class SiteFailedMessage(msg: String) extends SupervisorCommand
  final case class SetCounter(count: Int) extends SupervisorCommand
}

class Supervisor(context: ActorContext[Supervisor.SupervisorCommand])
    extends AbstractBehavior[Supervisor.SupervisorCommand](context) {
  context.log.info("Supervisor Started")

  implicit val timeout: Timeout = 3.seconds
  import Supervisor._

  // Crearemos y guardaremos un actor por cada site
  var sites = Map.empty[String, ActorRef[Site.SiteRequest]]
  // Contador que usaremos para saber cuántas suscripciones
  // falta procesar antes de parar
  var counter = 0

  // Regex necesaria para separar la parte del site de las url's
  val siteRegex = "(https?|ftp|file)://[-a-zA-Z0-9+&@#%?=~_|!:,.;]+/".r

  // Sub-Actor encargado de guardar y mostrar los feeds ya parseados
  val storage = context.spawn(Storage(), s"new-Storage")

  override def onMessage(msg: SupervisorCommand): Behavior[SupervisorCommand] = {
    msg match {
      case SetCounter(count) =>
        counter = count
        Behaviors.same
      case SiteResponseMessage(msg) =>
        storage ! Storage.Store(msg)
        counter -= 1
        if (counter == 0) {
          storage ! Storage.GetNEs(context.self)
        }
        Behaviors.same
      case SiteFailedMessage(msg) => 
        context.log.error(msg)
        counter -= 1
        if (counter == 0) {
          storage ! Storage.GetNEs(context.self)
        }
        Behaviors.same
      case Stop() => Behaviors.stopped
      case StopWithMessage(msg) =>
        context.log.info(msg)
        context.self ! Stop()
        Behaviors.same
      case subMsg @ Subscribe(enlace, parametros, parser) =>
        val site = (siteRegex findAllIn enlace).mkString
        sites.get(site) match {
          case Some(siteActor) =>
            context.ask(siteActor, Site.SiteSubscription(enlace, parametros, parser, _)) {
              case Success(Site.SiteMessage(msg)) => SiteResponseMessage(msg)
              case Failure(e) => SiteFailedMessage(e.getMessage)
            }
          case None =>
            context.log.info("Subscribing a new site")
            val siteActor = context.spawn(Site(), s"new-Site-${sites.size}")
            sites += site -> siteActor
            context.ask(siteActor, Site.SiteSubscription(enlace, parametros, parser, _)) {
              case Success(Site.SiteMessage(msg)) => SiteResponseMessage(msg)
              case Failure(e) => SiteFailedMessage(e.getMessage)
            }
        }
        Behaviors.same
    }
  }

  override def onSignal: PartialFunction[Signal, Behavior[SupervisorCommand]] = {
    case PostStop =>
      context.log.info("Supervisor Stopped")
      this
  }
}
