package com.taomee.seer2.app.processor.activity.fightPrev
{
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.core.entity.MobileManager;
   
   public class SpawnedManager
   {
      
      public function SpawnedManager()
      {
         super();
      }
      
      public static function addSpawned(param1:Array) : void
      {
         var _loc2_:SpawnedPet = null;
         var _loc4_:Array = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc2_ = new SpawnedPet(_loc4_[0],_loc4_[1],_loc4_[2]);
            MobileManager.addMobile(_loc2_,"spawnedPet");
            _loc3_++;
         }
      }
   }
}

