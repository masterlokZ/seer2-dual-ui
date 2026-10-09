package com.taomee.seer2.app.processor.quest.handler.branch.quest10121
{
   import com.taomee.seer2.core.manager.TimeManager;
   
   public class TorchRelayTime
   {
      
      public static const SECONDS_HALF_HOUR:Number = 1800;
      
      public static const MILI_SECONDS:Number = 1000;
      
      public static const DATE:Date = new Date(2013,5,1,14);
      
      public function TorchRelayTime()
      {
         super();
      }
      
      public static function isAppearTime() : Boolean
      {
         var _loc2_:Number = TimeManager.getServerTime();
         var _loc1_:Number = DATE.getTime() / 1000;
         var _loc3_:Number = _loc1_ + 1800;
         if(_loc2_ >= _loc1_ && _loc2_ < _loc3_)
         {
            return true;
         }
         return false;
      }
   }
}

