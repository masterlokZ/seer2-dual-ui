package com.taomee.seer2.app.processor.activity.sniper
{
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class SniperPlayAnimation
   {
      
      private static var _fun:Function;
      
      public function SniperPlayAnimation()
      {
         super();
      }
      
      public static function playAnimation(param1:Function) : void
      {
         _fun = param1();
         ServerBufferManager.getServerBuffer(38,onServer);
      }
      
      private static function onServer(param1:ServerBuffer) : void
      {
         var currDate:Date = null;
         var server:ServerBuffer = param1;
         currDate = new Date(TimeManager.getServerTime() * 1000);
         if(server.readDataAtPostion(currDate.date) != 1)
         {
            MovieClipUtil.playFullScreen(URLUtil.getActivityAnimation("sniperLoad/sniperStart"),function():void
            {
               ServerBufferManager.updateServerBuffer(38,currDate.date,1);
               if(_fun != null)
               {
                  _fun();
                  _fun = null;
               }
            });
         }
         else if(_fun != null)
         {
            _fun();
            _fun = null;
         }
      }
   }
}

