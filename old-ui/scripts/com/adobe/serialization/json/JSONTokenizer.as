package com.adobe.serialization.json
{
   public class JSONTokenizer
   {
      
      private var strict:Boolean;
      
      private var obj:Object;
      
      private var jsonString:String;
      
      private var loc:int;
      
      private var ch:String;
      
      private const controlCharsRegExp:RegExp = /[\x00-\x1F]/;
      
      public function JSONTokenizer(s:String, strict:Boolean)
      {
         super();
         jsonString = s;
         this.strict = strict;
         loc = 0;
         nextChar();
      }
      
      public function getNextToken() : JSONToken
      {
         var possibleTrue:String = null;
         var possibleFalse:String = null;
         var possibleNull:String = null;
         var possibleNaN:String = null;
         var token:JSONToken = null;
         skipIgnored();
         switch(ch)
         {
            case "{":
               token = JSONToken.create(1,ch);
               nextChar();
               break;
            case "}":
               token = JSONToken.create(2,ch);
               nextChar();
               break;
            case "[":
               token = JSONToken.create(3,ch);
               nextChar();
               break;
            case "]":
               token = JSONToken.create(4,ch);
               nextChar();
               break;
            case ",":
               token = JSONToken.create(0,ch);
               nextChar();
               break;
            case ":":
               token = JSONToken.create(6,ch);
               nextChar();
               break;
            case "t":
               possibleTrue = "t" + nextChar() + nextChar() + nextChar();
               if(possibleTrue == "true")
               {
                  token = JSONToken.create(7,true);
                  nextChar();
               }
               else
               {
                  parseError("Expecting \'true\' but found " + possibleTrue);
               }
               break;
            case "f":
               possibleFalse = "f" + nextChar() + nextChar() + nextChar() + nextChar();
               if(possibleFalse == "false")
               {
                  token = JSONToken.create(8,false);
                  nextChar();
               }
               else
               {
                  parseError("Expecting \'false\' but found " + possibleFalse);
               }
               break;
            case "n":
               possibleNull = "n" + nextChar() + nextChar() + nextChar();
               if(possibleNull == "null")
               {
                  token = JSONToken.create(9,null);
                  nextChar();
               }
               else
               {
                  parseError("Expecting \'null\' but found " + possibleNull);
               }
               break;
            case "N":
               possibleNaN = "N" + nextChar() + nextChar();
               if(possibleNaN == "NaN")
               {
                  token = JSONToken.create(12,NaN);
                  nextChar();
               }
               else
               {
                  parseError("Expecting \'NaN\' but found " + possibleNaN);
               }
               break;
            case "\"":
               token = readString();
               break;
            default:
               if(isDigit(ch) || ch == "-")
               {
                  token = readNumber();
               }
               else if(ch == "")
               {
                  token = null;
               }
               else
               {
                  parseError("Unexpected " + ch + " encountered");
               }
         }
         return token;
      }
      
      final private function readString() : JSONToken
      {
         var backspaceCount:int = 0;
         var backspaceIndex:int = 0;
         var quoteIndex:int = loc;
         while(true)
         {
            quoteIndex = jsonString.indexOf("\"",quoteIndex);
            if(quoteIndex >= 0)
            {
               backspaceCount = 0;
               backspaceIndex = quoteIndex - 1;
               while(jsonString.charAt(backspaceIndex) == "\\")
               {
                  backspaceCount++;
                  backspaceIndex--;
               }
               if((backspaceCount & 1) == 0)
               {
                  break;
               }
               quoteIndex++;
            }
            else
            {
               parseError("Unterminated string literal");
            }
         }
         var token:JSONToken = JSONToken.create(10,unescapeString(jsonString.substr(loc,quoteIndex - loc)));
         loc = quoteIndex + 1;
         nextChar();
         return token;
      }
      
      public function unescapeString(input:String) : String
      {
         var escapedChar:String = null;
         var hexValue:String = null;
         var unicodeEndPosition:int = 0;
         var i:int = 0;
         var possibleHexChar:String = null;
         if(strict && controlCharsRegExp.test(input))
         {
            parseError("String contains unescaped control character (0x00-0x1F)");
         }
         var result:String = "";
         var backslashIndex:int = 0;
         var nextSubstringStartPosition:int = 0;
         var len:int = input.length;
         do
         {
            backslashIndex = input.indexOf("\\",nextSubstringStartPosition);
            if(backslashIndex < 0)
            {
               result += input.substr(nextSubstringStartPosition);
               break;
            }
            result += input.substr(nextSubstringStartPosition,backslashIndex - nextSubstringStartPosition);
            nextSubstringStartPosition = backslashIndex + 2;
            switch(escapedChar = input.charAt(backslashIndex + 1))
            {
               case "\"":
                  result += escapedChar;
                  break;
               case "\\":
                  result += escapedChar;
                  break;
               case "n":
                  result += "\n";
                  break;
               case "r":
                  result += "\r";
                  break;
               case "t":
                  result += "\t";
                  break;
               case "u":
                  hexValue = "";
                  unicodeEndPosition = nextSubstringStartPosition + 4;
                  if(unicodeEndPosition > len)
                  {
                     parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
                  }
                  for(i = nextSubstringStartPosition; i < unicodeEndPosition; )
                  {
                     possibleHexChar = input.charAt(i);
                     if(!isHexDigit(possibleHexChar))
                     {
                        parseError("Excepted a hex digit, but found: " + possibleHexChar);
                     }
                     hexValue += possibleHexChar;
                     i++;
                  }
                  result += String.fromCharCode(parseInt(hexValue,16));
                  nextSubstringStartPosition = unicodeEndPosition;
                  break;
               case "f":
                  result += "\f";
                  break;
               case "/":
                  result += "/";
                  break;
               case "b":
                  result += "\b";
                  break;
               default:
                  result += "\\" + escapedChar;
            }
         }
         while(nextSubstringStartPosition < len);
         return result;
      }
      
      final private function readNumber() : JSONToken
      {
         var input:String = "";
         if(ch == "-")
         {
            input += "-";
            nextChar();
         }
         if(!isDigit(ch))
         {
            parseError("Expecting a digit");
         }
         if(ch == "0")
         {
            input += ch;
            nextChar();
            if(isDigit(ch))
            {
               parseError("A digit cannot immediately follow 0");
            }
            else if(!strict && ch == "x")
            {
               input += ch;
               nextChar();
               if(isHexDigit(ch))
               {
                  input += ch;
                  nextChar();
               }
               else
               {
                  parseError("Number in hex format require at least one hex digit after \"0x\"");
               }
               while(isHexDigit(ch))
               {
                  input += ch;
                  nextChar();
               }
            }
         }
         else
         {
            while(isDigit(ch))
            {
               input += ch;
               nextChar();
            }
         }
         if(ch == ".")
         {
            input += ".";
            nextChar();
            if(!isDigit(ch))
            {
               parseError("Expecting a digit");
            }
            while(isDigit(ch))
            {
               input += ch;
               nextChar();
            }
         }
         if(ch == "e" || ch == "E")
         {
            input += "e";
            nextChar();
            if(ch == "+" || ch == "-")
            {
               input += ch;
               nextChar();
            }
            if(!isDigit(ch))
            {
               parseError("Scientific notation number needs exponent value");
            }
            while(isDigit(ch))
            {
               input += ch;
               nextChar();
            }
         }
         var num:Number = Number(input);
         if(isFinite(num) && !isNaN(num))
         {
            return JSONToken.create(11,num);
         }
         parseError("Number " + num + " is not valid!");
         return null;
      }
      
      final private function nextChar() : String
      {
         return ch = jsonString.charAt(loc++);
      }
      
      final private function skipIgnored() : void
      {
         var originalLoc:int = 0;
         do
         {
            originalLoc = loc;
            skipWhite();
            skipComments();
         }
         while(originalLoc != loc);
      }
      
      private function skipComments() : void
      {
         if(ch == "/")
         {
            nextChar();
            switch(ch)
            {
               case "/":
                  do
                  {
                     nextChar();
                  }
                  while(ch != "\n" && ch != "");
                  nextChar();
                  break;
               case "*":
                  nextChar();
                  while(true)
                  {
                     if(ch == "*")
                     {
                        nextChar();
                        if(ch == "/")
                        {
                           break;
                        }
                     }
                     else
                     {
                        nextChar();
                     }
                     if(ch == "")
                     {
                        parseError("Multi-line comment not closed");
                     }
                  }
                  nextChar();
                  break;
               default:
                  parseError("Unexpected " + ch + " encountered (expecting \'/\' or \'*\' )");
            }
         }
      }
      
      final private function skipWhite() : void
      {
         while(isWhiteSpace(ch))
         {
            nextChar();
         }
      }
      
      final private function isWhiteSpace(ch:String) : Boolean
      {
         if(ch == " " || ch == "\t" || ch == "\n" || ch == "\r")
         {
            return true;
         }
         if(!strict && ch.charCodeAt(0) == 160)
         {
            return true;
         }
         return false;
      }
      
      final private function isDigit(ch:String) : Boolean
      {
         return ch >= "0" && ch <= "9";
      }
      
      final private function isHexDigit(ch:String) : Boolean
      {
         return isDigit(ch) || ch >= "A" && ch <= "F" || ch >= "a" && ch <= "f";
      }
      
      final public function parseError(message:String) : void
      {
         throw new JSONParseError(message,loc,jsonString);
      }
   }
}

