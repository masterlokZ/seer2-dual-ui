package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.dream.DreamSpawnedPet;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.events.MouseEvent;
   
   public class MapProcessor_139 extends DreamMapProcessor
   {
      
      private const GU_SI_RES_ID:uint = 22;
      
      private const FIGHT_MAP_TYPE:uint = 10001;
      
      private const DREAM_NPC_TYPE:uint = 401;
      
      private var _fightData:Object;
      
      private var _dreamSpawnedPet:DreamSpawnedPet;
      
      public function MapProcessor_139(param1:MapModel)
      {
         _taskId = 1;
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this.initFightData();
         this.setDreamAction();
         this.initGuSi();
      }
      
      private function initFightData() : void
      {
         this._fightData = {};
         this._fightData.dreamNpcType = 401;
         this._fightData.fightMapType = 10001;
         this._fightData.taskId = _taskId;
      }
      
      private function setDreamAction() : void
      {
         if(SceneManager.prevSceneType == 2)
         {
            _dreamer.gotoAndPlay("monsterKilled");
            indicateLeaveDream();
         }
      }
      
      override protected function onDreamerMouseOver(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(_dreamer.currentFrameLabel == "enterMapEnd")
         {
            _dreamer.gotoAndPlay("enterMap");
         }
         else if(_dreamer.currentFrameLabel == "monsterKilledEnd")
         {
            _dreamer.gotoAndPlay("monsterKilled");
         }
      }
      
      private function initGuSi() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(SceneManager.prevSceneType != 2)
         {
            MobileManager.clearMobileVec("spawnedPet");
            _loc2_ = Math.floor(Math.random() * 8) + 1;
            _loc1_ = Math.floor(Math.random() * 2) + 6;
            this._dreamSpawnedPet = new DreamSpawnedPet(22,_loc2_,_loc1_,this._fightData);
            MobileManager.addMobile(this._dreamSpawnedPet,"dreamSpawnedPet");
         }
      }
      
      override public function dispose() : void
      {
         this._dreamSpawnedPet = null;
         this._fightData = null;
         super.dispose();
      }
   }
}

