package com.taomee.seer2.app.onlineServiceController
{
   import com.adobe.crypto.MD5;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import flash.external.ExternalInterface;
   
   public class OnlineServiceController
   {
      
      private static var _isOpen:Boolean = false;
      
      public function OnlineServiceController()
      {
         super();
      }
      
      public static function show() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:String = null;
         var _loc3_:String = null;
         if(_isOpen)
         {
            return;
         }
         _isOpen = true;
         if(ExternalInterface.available)
         {
            ExternalInterface.call("getUrlHost");
            ExternalInterface.addCallback("closeOnlineService",closeOnlineService);
            _loc2_ = TimeManager.getServerTime();
            _loc1_ = MD5.hash("15|" + ActorManager.actorInfo.id.toString() + "|adfa*sd%#QQdfasdfadsf2131a1sdf14=342&|" + _loc2_.toString());
            _loc3_ = "http://kf.61.com/user/addGameQuestion?gameid=15&userid=" + ActorManager.actorInfo.id.toString() + "&time=" + _loc2_.toString() + "&sign=" + _loc1_;
            ExternalInterface.call("openInnerFrame",_loc3_,580,460,72,230);
         }
      }
      
      public static function closeOnlineService() : void
      {
         if(ExternalInterface.available)
         {
            _isOpen = false;
            ExternalInterface.call("closeInnerFrame");
         }
      }
   }
}

