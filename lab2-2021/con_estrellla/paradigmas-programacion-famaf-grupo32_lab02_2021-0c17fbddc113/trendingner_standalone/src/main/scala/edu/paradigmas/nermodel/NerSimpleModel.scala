package edu.paradigmas.nermodel



case class NERCount(ner: String, count:Double)

/* Abstraction of a NERModel (Named Entity Recognition Pipeline)
 * Receives a sequence of text.
 * Calculates a map with the Named Entities recognized
 * and the number of times each appears in the input text
 */
class NERSimpleModel() {

  val punctuationSymbols = ".,()!?;:'`´\n<>-’"
  val punctuationRegex = "\\" + punctuationSymbols.split("").mkString("|\\")

  // Extract Named Entities from a single text
  def getNEsSingle(text: String): Seq[String] =
    text.replaceAll(punctuationRegex, "").split(" ")
      .filter { word:String => word.length > 1 &&
                Character.isUpperCase(word.charAt(0)) &&
                !STOPWORDS.contains(word.toLowerCase) }.toSeq


  def getNEs(textList: Seq[String]): Seq[Seq[String]] = textList.map(getNEsSingle)

  // Return the named entities detected from a list of text sorted by frequency
  def getSortedNEs(textList: Seq[String]): Seq[NERCount] = {
    val result = textList.map(getNEsSingle)
    sortNEs(result)
  }

  // Count Named Entities and sort by frequency
  def getCounts(result: Seq[Seq[String]]): Seq[Map[String, Double]] = {
    val countsMaps: Seq[Map[String, Double]] = result.map { list =>
      list.foldLeft(Map.empty[String, Double]) {
        (count, word) => count + (word -> (count.getOrElse(word, 0.0) + 1.0))
      }
    }
    countsMaps.map {
      Map => Map mapValues (_/Map.values.sum) }
  }

  def sortNEs(result: Seq[Seq[String]]): List[NERCount] = {
    val counts: Map[String, Double] = getCounts(result).flatten
      .foldLeft(Map.empty[String, Double]) {
        (count, wordCount) => count + (wordCount._1 -> (count.getOrElse(wordCount._1, 0.0) + wordCount._2)) }
    counts.toList.map { case (word, count) => NERCount(word, count) }
      .sortBy(_.count)(Ordering[Double].reverse)
    }
}
