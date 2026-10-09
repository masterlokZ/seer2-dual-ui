package com.taomee.seer2.app.manager
{
   import flash.events.*;
   import flash.net.*;
   
   public class StatisticsManager2
   {
      
      private static var _gameId:int = 0;
      
      private static const dirtyKeyList:Array = ["=",":",",",";",".","|","\t"];
      
      public function StatisticsManager2()
      {
         super();
      }
      
      public static function setup(param1:int) : void
      {
         _gameId = param1;
      }
      
      public static function sendHttpStat(param1:String, param2:String, param3:String = null, param4:int = 0) : void
      {
         var _loc6_:String = null;
         var _loc5_:String = encodeURI(replaceKey(param1));
         var _loc8_:String = encodeURI(replaceKey(param2));
         var _loc7_:String = "http://newmisc.taomee.com/misc.js?gameid=" + _gameId + "&stid=" + _loc5_ + "&sstid=" + _loc8_;
         if(param4)
         {
            _loc7_ += "&uid=" + param4;
         }
         if(param3)
         {
            _loc6_ = encodeURI(replaceKey(param3));
            _loc7_ += "&item=" + _loc6_ + "&itemlen=" + _loc6_.length;
         }
         _loc7_ += "&stidlen=" + _loc5_.length + "&sstidlen=" + _loc8_.length;
         send(_loc7_);
      }
      
      public static function sentHttpValueStat(param1:String, param2:uint = 1) : void
      {
         send("http://newmisc.taomee.com/misc.txt?type=" + param1 + "&count=" + param2);
      }
      
      public static function send(param1:String) : void
      {
         var _loc2_:URLLoader = new URLLoader();
         addLoaderEvent(_loc2_);
         _loc2_.load(new URLRequest(param1));
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
         var _loc9_:Number = NaN;
         var _loc6_:String = new String();
         var _loc5_:Boolean = false;
         var _loc8_:int = param1.length;
         var _loc7_:int = param2.length;
         var _loc4_:Number = 0;
         while(_loc4_ < _loc8_)
         {
            if(param1.charAt(_loc4_) == param2.charAt(0))
            {
               _loc5_ = true;
               _loc9_ = 0;
               while(_loc9_ < _loc7_)
               {
                  if(param1.charAt(_loc4_ + _loc9_) != param2.charAt(_loc9_))
                  {
                     _loc5_ = false;
                     break;
                  }
                  _loc9_ += 1;
               }
               if(_loc5_)
               {
                  _loc6_ += param3;
                  _loc4_ += _loc7_ - 1;
               }
            }
            _loc6_ += param1.charAt(_loc4_);
            _loc4_ += 1;
         }
         return _loc6_;
      }
   }
}

