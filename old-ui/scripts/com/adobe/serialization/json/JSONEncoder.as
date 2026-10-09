package com.adobe.serialization.json
{
   import flash.utils.describeType;
   
   public class JSONEncoder
   {
      
      private var jsonString:String;
      
      public function JSONEncoder(value:*)
      {
         super();
         jsonString = convertToString(value);
      }
      
      public function getString() : String
      {
         return jsonString;
      }
      
      private function convertToString(value:*) : String
      {
         if(value is String)
         {
            return escapeString(value as String);
         }
         if(value is Number)
         {
            return isFinite(value as Number) ? value.toString() : "null";
         }
         if(value is Boolean)
         {
            return value ? "true" : "false";
         }
         if(value is Array)
         {
            return arrayToString(value as Array);
         }
         if(value is Object && value != null)
         {
            return objectToString(value);
         }
         return "null";
      }
      
      private function escapeString(str:String) : String
      {
         var ch:String = null;
         var i:int = 0;
         var hexCode:String = null;
         var zeroPad:String = null;
         var s:String = "";
         var len:Number = str.length;
         for(i = 0; i < len; )
         {
            switch(ch = str.charAt(i))
            {
               case "\"":
                  s += "\\\"";
                  break;
               case "\\":
                  s += "\\\\";
                  break;
               case "\b":
                  s += "\\b";
                  break;
               case "\f":
                  s += "\\f";
                  break;
               case "\n":
                  s += "\\n";
                  break;
               case "\r":
                  s += "\\r";
                  break;
               case "\t":
                  s += "\\t";
                  break;
               default:
                  if(ch < " ")
                  {
                     hexCode = ch.charCodeAt(0).toString(16);
                     zeroPad = hexCode.length == 2 ? "00" : "000";
                     s += "\\u" + zeroPad + hexCode;
                  }
                  else
                  {
                     s += ch;
                  }
            }
            i++;
         }
         return "\"" + s + "\"";
      }
      
      private function arrayToString(a:Array) : String
      {
         var i:int = 0;
         var s:String = "";
         var length:int = int(a.length);
         for(i = 0; i < length; )
         {
            if(s.length > 0)
            {
               s += ",";
            }
            s += convertToString(a[i]);
            i++;
         }
         return "[" + s + "]";
      }
      
      private function objectToString(o:Object) : String
      {
         var value:Object = null;
         var s:String = "";
         var classInfo:XML = describeType(o);
         if(classInfo.@name.toString() == "Object")
         {
            for(var key in o)
            {
               value = o[key];
               if(!(value is Function))
               {
                  if(s.length > 0)
                  {
                     s += ",";
                  }
                  s += escapeString(key) + ":" + convertToString(value);
               }
            }
         }
         else
         {
            for each(var v in classInfo..*.(name() == "variable" || name() == "accessor" && attribute("access").charAt(0) == "r"))
            {
               if(!(v.metadata && v.metadata.(@name == "Transient").length() > 0))
               {
                  if(s.length > 0)
                  {
                     s += ",";
                  }
                  s += escapeString(v.@name.toString()) + ":" + convertToString(o[v.@name]);
               }
            }
         }
         return "{" + s + "}";
      }
   }
}

