package com.adobe.serialization.json
{
   public class JSONDecoder
   {
      
      private var strict:Boolean;
      
      private var value:*;
      
      private var tokenizer:JSONTokenizer;
      
      private var token:JSONToken;
      
      public function JSONDecoder(s:String, strict:Boolean)
      {
         super();
         this.strict = strict;
         tokenizer = new JSONTokenizer(s,strict);
         nextToken();
         value = parseValue();
         if(strict && nextToken() != null)
         {
            tokenizer.parseError("Unexpected characters left in input stream");
         }
      }
      
      public function getValue() : *
      {
         return value;
      }
      
      final private function nextToken() : JSONToken
      {
         return token = tokenizer.getNextToken();
      }
      
      final private function nextValidToken() : JSONToken
      {
         token = tokenizer.getNextToken();
         checkValidToken();
         return token;
      }
      
      final private function checkValidToken() : void
      {
         if(token == null)
         {
            tokenizer.parseError("Unexpected end of input");
         }
      }
      
      final private function parseArray() : Array
      {
         var a:Array = [];
         nextValidToken();
         if(token.type == 4)
         {
            return a;
         }
         if(!strict && token.type == 0)
         {
            nextValidToken();
            if(token.type == 4)
            {
               return a;
            }
            tokenizer.parseError("Leading commas are not supported.  Expecting \']\' but found " + token.value);
         }
         while(true)
         {
            a.push(parseValue());
            nextValidToken();
            if(token.type == 4)
            {
               break;
            }
            if(token.type == 0)
            {
               nextToken();
               if(!strict)
               {
                  checkValidToken();
                  if(token.type == 4)
                  {
                     return a;
                  }
               }
            }
            else
            {
               tokenizer.parseError("Expecting ] or , but found " + token.value);
            }
         }
         return a;
      }
      
      final private function parseObject() : Object
      {
         var key:String = null;
         var o:Object = {};
         nextValidToken();
         if(token.type == 2)
         {
            return o;
         }
         if(!strict && token.type == 0)
         {
            nextValidToken();
            if(token.type == 2)
            {
               return o;
            }
            tokenizer.parseError("Leading commas are not supported.  Expecting \'}\' but found " + token.value);
         }
         while(true)
         {
            if(token.type == 10)
            {
               key = String(token.value);
               nextValidToken();
               if(token.type == 6)
               {
                  nextToken();
                  o[key] = parseValue();
                  nextValidToken();
                  if(token.type == 2)
                  {
                     break;
                  }
                  if(token.type == 0)
                  {
                     nextToken();
                     if(!strict)
                     {
                        checkValidToken();
                        if(token.type == 2)
                        {
                           return o;
                        }
                     }
                  }
                  else
                  {
                     tokenizer.parseError("Expecting } or , but found " + token.value);
                  }
               }
               else
               {
                  tokenizer.parseError("Expecting : but found " + token.value);
               }
            }
            else
            {
               tokenizer.parseError("Expecting string but found " + token.value);
            }
         }
         return o;
      }
      
      final private function parseValue() : Object
      {
         checkValidToken();
         switch(token.type - 1)
         {
            case 0:
               return parseObject();
            case 2:
               return parseArray();
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
               return token.value;
            case 11:
               if(!strict)
               {
                  return token.value;
               }
               tokenizer.parseError("Unexpected " + token.value);
         }
         tokenizer.parseError("Unexpected " + token.value);
         return null;
      }
   }
}

