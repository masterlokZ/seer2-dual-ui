package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class FriendHomeFindPetAct
   {
      
      private static var _instance:FriendHomeFindPetAct;
      
      private const HAS_PET_ID:uint = 203048;
      
      private const FIGHT_NUM_ID:uint = 778;
      
      private const FIGHT_ID:uint = 554;
      
      private const MAX_FIGHT_NUM:uint = 100;
      
      private const PET_IDS:Array = [441,441,442];
      
      private const PET_LEV:Array = [30,60,100];
      
      private var pet:SpawnedPet;
      
      private var petType:uint;
      
      private var fightNum:uint;
      
      public function FriendHomeFindPetAct()
      {
         super();
      }
      
      public static function getInstance() : FriendHomeFindPetAct
      {
         if(!_instance)
         {
            _instance = new FriendHomeFindPetAct();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         ServerBufferManager.getServerBuffer(57,this.getFullState);
         if(this.fightNum < 100)
         {
            DayLimitManager.getDoCount(778,this.getFightNum);
         }
      }
      
      private function getFullState(param1:ServerBuffer) : void
      {
         if(param1.readDataAtPostion(25) == 0)
         {
            MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("baoweijidiFull"));
            ServerBufferManager.updateServerBuffer(57,25,1);
         }
      }
      
      private function getFightNum(param1:uint) : void
      {
         this.fightNum = param1;
         if(this.fightNum < 100)
         {
            ActiveCountManager.requestActiveCount(203048,this.getPetType);
         }
      }
      
      private function getPetType(param1:uint, param2:uint) : void
      {
         this.petType = param2;
         if(this.petType != 0)
         {
            this.createPet();
         }
      }
      
      private function createPet() : void
      {
         this.pet = new SpawnedPet(this.PET_IDS[this.petType - 1],554,this.PET_LEV[this.petType - 1]);
         MobileManager.addMobile(this.pet,"spawnedPet");
      }
   }
}

