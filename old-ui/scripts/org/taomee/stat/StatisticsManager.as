package org.taomee.stat
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   
   public class StatisticsManager
   {
      
      private static var _gameId:int = 0;
      
      private static const dirtyKeyList:Array = ["=",":",",",";",".","|","\t"];
      
      public function StatisticsManager()
      {
         super();
      }
      
      public static function setup(param1:int) : void
      {
         _gameId = param1;
      }
      
      public static function sendHttpStat(param1:String, param2:String, param3:String = null, param4:int = 0) : void
      {
         var _loc5_:String = "http://newmisc.taomee.com/misc.js?gameid=" + _gameId + "&stid=" + encodeURI(replaceKey(param1)) + "&sstid=" + encodeURI(replaceKey(param2));
         if(param4)
         {
            _loc5_ += "&uid=" + param4;
         }
         if(param3)
         {
            _loc5_ += "&item=" + encodeURI(replaceKey(param3));
         }
         send(_loc5_);
      }
      
      public static function sentHttpValueStat(param1:String, param2:uint = 1) : void
      {
         send("http://newmisc.taomee.com/misc.txt?type=" + param1 + "&count=" + param2);
      }
      
      public static function send(param1:String) : void
      {
      }
      
      private static function addLoaderEvent(param1:URLLoader) : void
      {
         param1.addEventListener("securityError",securityErrorHandler);
         param1.addEventListener("ioError",ioErrorHandler);
         param1.addEventListener("complete",completeHandler);
      }
      
      private static function removeLoaderEvent(param1:URLLoader) : void
      {
         param1.removeEventListener("securityError",securityErrorHandler);
         param1.removeEventListener("ioError",ioErrorHandler);
         param1.removeEventListener("complete",completeHandler);
      }
      
      private static function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         removeLoaderEvent(_loc2_);
      }
      
      private static function ioErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         removeLoaderEvent(_loc2_);
      }
      
      private static function completeHandler(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.close();
         removeLoaderEvent(_loc2_);
      }
      
      public static function replaceKey(param1:String) : String
      {
         var _loc2_:String = null;
         for each(_loc2_ in dirtyKeyList)
         {
            if(param1.indexOf(_loc2_) >= 0)
            {
               param1 = replace(param1,_loc2_,"_");
            }
         }
         return param1;
      }
      
      private static function replace(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:Number = NaN;
         var _loc9_:String = new String();
         var _loc6_:Boolean = false;
         var _loc5_:Number = param1.length;
         var _loc8_:Number = param2.length;
         var _loc7_:Number = 0;
         for(; _loc7_ < _loc5_; _loc7_++)
         {
            if(param1.charAt(_loc7_) == param2.charAt(0))
            {
               _loc6_ = true;
               _loc4_ = 0;
               while(_loc4_ < _loc8_)
               {
                  if(param1.charAt(_loc7_ + _loc4_) != param2.charAt(_loc4_))
                  {
                     _loc6_ = false;
                     break;
                  }
                  _loc4_++;
               }
               if(_loc6_)
               {
                  _loc9_ += param3;
                  _loc7_ += _loc8_ - 1;
                  continue;
               }
            }
            _loc9_ += param1.charAt(_loc7_);
         }
         return _loc9_;
      }
   }
}

