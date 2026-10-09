package com.taomee.seer2.app.dream.handler
{
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   
   public class DreamEntryProcessor_1310 extends DreamEntryProcessor
   {
      
      private static const DREAM_NPC_CATEGORY:uint = 401;
      
      private static const NPC_COUNT:uint = 3;
      
      private static const NPC_ID:Array = [4011,4012,4013];
      
      public function DreamEntryProcessor_1310()
      {
         _category = 401;
         super();
      }
      
      override protected function getDreamMapID() : uint
      {
         var _loc1_:int = Math.ceil(Math.random() * 100);
         if(_loc1_ < 30)
         {
            return 139;
         }
         if(_loc1_ < 65)
         {
            return 137;
         }
         return 138;
      }
      
      override protected function createNpc() : void
      {
         var _loc1_:Mobile = null;
         _dreamNpcVec = new Vector.<Mobile>();
         var _loc2_:uint = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = MobileManager.getMobile(NPC_ID[_loc2_],"npc");
            _dreamNpcVec.push(_loc1_);
            _loc2_++;
         }
      }
   }
}

