package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import flash.display.MovieClip;
   
   public class MapProcessor_80179 extends MapProcessor
   {
      
      private var _activityDialogPanel:MovieClip;
      
      private var _activityVoidPanel:MovieClip;
      
      private const PET_ID:uint = 64;
      
      private const FIGHT_ID:uint = 909;
      
      public function MapProcessor_80179(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this._activityDialogPanel = _map.front["activityDialogPanel"];
         this._activityVoidPanel = _map.front["activityVoidPanel"];
         this._activityVoidPanel.visible = false;
         this._activityDialogPanel.visible = false;
         this.createPet();
      }
      
      private function createPet() : void
      {
         var _loc1_:SpawnedPet = null;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = new SpawnedPet(64,909,0);
            MobileManager.addMobile(_loc1_,"spawnedPet");
            _loc2_++;
         }
      }
   }
}

