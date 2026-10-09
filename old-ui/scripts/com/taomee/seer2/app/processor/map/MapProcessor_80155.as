package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   
   public class MapProcessor_80155 extends MapProcessor
   {
      
      private const PET_ID:uint = 119;
      
      private const FIGHT_ID:uint = 845;
      
      public function MapProcessor_80155(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.createPet();
         StatisticsManager.sendNovice("0x100345E9");
      }
      
      private function createPet() : void
      {
         var _loc1_:SpawnedPet = null;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = new SpawnedPet(119,845,0);
            MobileManager.addMobile(_loc1_,"spawnedPet");
            _loc2_++;
         }
      }
   }
}

