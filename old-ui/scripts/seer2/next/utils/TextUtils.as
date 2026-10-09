package seer2.next.utils
{
   public class TextUtils
   {
      
      public function TextUtils()
      {
         super();
      }
      
      public static function replaceColorFormat(input:String) : String
      {
         if(!input)
         {
            return "";
         }
         input = input.replace(/\[br]/g,"<br>");
         var pattern:RegExp = /\[(\w+)](.*?)\[-]/g;
         return input.replace(pattern,"<font color=\'#$1\'>$2</font>");
      }
      
      public static function wrapHtmlFontSize(input:String) : String
      {
         return "<font color=\'#ffffff\' size=\'11\'>" + input + "</font>";
      }
   }
}

