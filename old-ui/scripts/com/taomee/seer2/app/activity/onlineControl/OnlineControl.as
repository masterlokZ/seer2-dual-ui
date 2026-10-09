package com.taomee.seer2.app.activity.onlineControl
{
   import com.taomee.seer2.core.manager.TimeManager;
   
   public class OnlineControl
   {
      
      private static const GIFT_MAX:int = 7;
      
      private static const ONLINE_TIME_ARR:Array = [300,600,900,1200,2400,3600,5400];
      
      public function OnlineControl()
      {
         super();
      }
      
      public static function getOnlineLevel() : uint
      {
         var _loc2_:uint = 0;
         var _loc1_:int = 0;
         while(_loc1_ < ONLINE_TIME_ARR.length)
         {
            if(TimeManager.getOnlineTime() >= ONLINE_TIME_ARR[_loc1_])
            {
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public static function currGiftTime() : uint
      {
         if(getOnlineLevel() < 7)
         {
            return ONLINE_TIME_ARR[getOnlineLevel()] - TimeManager.getOnlineTime();
         }
         return 0;
      }
   }
}

