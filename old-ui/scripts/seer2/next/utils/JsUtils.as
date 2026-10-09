package seer2.next.utils
{
   import flash.external.ExternalInterface;
   
   public class JsUtils
   {
      
      public function JsUtils()
      {
         super();
      }
      
      public static function call(func:String, ... rest) : void
      {
         var args:Array = null;
         if(ExternalInterface.available)
         {
            args = [func].concat(rest);
            ExternalInterface.call.apply(null,args);
         }
      }
   }
}

