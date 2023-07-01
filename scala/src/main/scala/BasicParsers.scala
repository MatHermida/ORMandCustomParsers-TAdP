import ExceptionsHelper.throwExceptionIfCondition
import Parser.{ParseFunction, Parser, SuccessParse}
import ParsersHelper.orParsers

import scala.util.{Failure, Success, Try}

object BasicParsers {

  case class anyChar() extends Parser[Char]  {
    override def parseFunction(elementToParse: String): SuccessParse[Char] = {
      (elementToParse.charAt(0), stringTail(elementToParse))
    }
  }

  case class char(charToFind: Char) extends Parser[Char]  {
    override def parseFunction(elementToParse: String): SuccessParse[Char]  = {
      val result = stringMatches(
        elementToParse,
        s"$charToFind.*",
        new RuntimeException("El elemento no empieza con el caracter a buscar")
      ).charAt(0)
      (result, stringTail(elementToParse))
    }
  }

  case class void() extends Parser[Unit] {
    override def parseFunction(elementToParse: String) : SuccessParse[Unit] = {
      ((), stringTail(elementToParse))
    }
  }

  case class letter() extends Parser[Char] {
    override def parseFunction(elementToParse: String) : SuccessParse[Char] = {
      val result = stringMatches(
        elementToParse.charAt(0).toString(),
        "[a-zA-Z]",
        new RuntimeException("El elemento no empieza con una letra")
      ).charAt(0)
      (result, stringTail(elementToParse))
    }
  }

  case class digit() extends Parser[Char]  {
    override def parseFunction(elementToParse: String) : SuccessParse[Char] = {
      val result = stringMatches(
        elementToParse.charAt(0).toString(),
        "[0-9]",
        new RuntimeException("El elemento no empieza con un digito")
      ).charAt(0)
      (result, stringTail(elementToParse))
    }
  }

  val alphaNum = letter() <|> digit()

  case class string(stringToFind: String) extends Parser[String]  {
    override def parseFunction(elementToParse: String) : SuccessParse[String] = {
      stringMatches(
        elementToParse,
        s"$stringToFind.*",
        new RuntimeException("El elemento no empieza con una letra")
      )
      (stringToFind, elementToParse.replaceFirst(stringToFind, ""))
    }
  }

  private def stringMatches(text: String, regex: String, exception: Exception): String = {
    throwExceptionIfCondition(
      !text.matches(regex),
      exception
    )
    text
  }

  private def stringTail(string: String): String = string.substring(1)

}