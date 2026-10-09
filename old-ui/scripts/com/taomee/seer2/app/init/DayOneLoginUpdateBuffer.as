package com.taomee.seer2.app.init
{
   import com.taomee.seer2.app.serverBuffer.ServerBufferData;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.manager.TimeManager;
   
   public class DayOneLoginUpdateBuffer
   {
      
      public function DayOneLoginUpdateBuffer()
      {
         super();
      }
      
      public static function setServerBuffer() : void
      {
         updateTime();
         updateMagicActivity();
         updatePetKingDayQuest();
         updateAnswer();
      }
      
      private static function updateAnswer() : void
      {
         var _loc2_:Vector.<ServerBufferData> = Vector.<ServerBufferData>([]);
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_.push(new ServerBufferData(_loc1_,0));
            _loc1_++;
         }
         ServerBufferManager.updateServerBufferGroup(44,_loc2_);
      }
      
      private static function updatePetKingDayQuest() : void
      {
         ServerBufferManager.updateServerBuffer(28,0,0);
      }
      
      private static function updateTime() : void
      {
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc1_:Vector.<ServerBufferData> = Vector.<ServerBufferData>([]);
         _loc1_.push(new ServerBufferData(0,_loc2_.fullYear,4));
         _loc1_.push(new ServerBufferData(4,_loc2_.month));
         _loc1_.push(new ServerBufferData(5,_loc2_.date));
         ServerBufferManager.updateServerBufferGroup(20,_loc1_);
      }
      
      private static function updateMagicActivity() : void
      {
         ServerBufferManager.updateServerBuffer(18,0,0);
      }
   }
}

