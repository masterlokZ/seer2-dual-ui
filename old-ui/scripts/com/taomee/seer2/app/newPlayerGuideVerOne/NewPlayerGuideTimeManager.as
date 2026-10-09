package com.taomee.seer2.app.newPlayerGuideVerOne
{
   import com.taomee.seer2.app.actor.ActorManager;
   
   public class NewPlayerGuideTimeManager
   {
      
      public function NewPlayerGuideTimeManager()
      {
         super();
      }
      
      public static function curTimeCheck() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc1_:uint = new Date(2015,9,23).getTime() / 1000;
         if(ActorManager.actorInfo.createTime > _loc1_)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public static function timeCheckNewGuide() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc1_:uint = new Date(2015,10,9).getTime() / 1000;
         if(ActorManager.actorInfo.createTime > _loc1_)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}

