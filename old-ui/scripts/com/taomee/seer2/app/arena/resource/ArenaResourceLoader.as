package com.taomee.seer2.app.arena.resource
{
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.data.FighterInfo;
   import com.taomee.seer2.app.arena.data.FighterTeam;
   import com.taomee.seer2.app.arena.decoration.DecorationControl;
   import com.taomee.seer2.app.arena.effect.FighterSound;
   import com.taomee.seer2.app.arena.effect.SkillEffect;
   import com.taomee.seer2.app.arena.effect.SkillSound;
   import com.taomee.seer2.app.arena.resource.events.ResourceQueueEvent;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.sound.SoundManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class ArenaResourceLoader
   {
      
      private static var _instance:ArenaResourceLoader;
      
      private var _onComplete:Function;
      
      private var _resourceQueue:ResourceQueue;
      
      private var _arenaLoadingBar:ArenaLoadingBar;
      
      public function ArenaResourceLoader()
      {
         super();
      }
      
      public static function get instance() : ArenaResourceLoader
      {
         if(_instance == null)
         {
            _instance = new ArenaResourceLoader();
         }
         return _instance;
      }
      
      public static function addLoadingBar() : void
      {
         instance.addArenaLoadingBar();
      }
      
      public static function hideLoadingBar() : void
      {
         instance.removeLoadingBar();
      }
      
      private function addArenaLoadingBar() : void
      {
         this._arenaLoadingBar = new ArenaLoadingBar();
         LayerManager.stage.addEventListener("resize",this.onResize);
         this.onResize(null);
         this._arenaLoadingBar.addEventListener("close",this.onArenaLoadingBarClose);
         LayerManager.topLayer.addChild(this._arenaLoadingBar);
      }
      
      private function onResize(param1:Event) : void
      {
         this._arenaLoadingBar.scaleX = LayerManager.stage.stageWidth / 1200;
         this._arenaLoadingBar.scaleY = LayerManager.stage.stageHeight / 660;
      }
      
      private function removeLoadingBar() : void
      {
         DisplayUtil.removeForParent(this._arenaLoadingBar);
      }
      
      private function onArenaLoadingBarClose(param1:Event) : void
      {
         LayerManager.stage.removeEventListener("resize",this.onResize);
         this._arenaLoadingBar.removeEventListener("close",this.onArenaLoadingBarClose);
         this._arenaLoadingBar.dispose();
         DisplayObjectUtil.removeFromParent(this._arenaLoadingBar);
         SoundManager.backgroundSoundEnabled = true;
         this._onComplete();
         this.clear();
      }
      
      public function updateLoadingBarShowData(param1:Function, param2:FighterInfo, param3:FighterInfo, param4:FighterInfo, param5:FighterInfo, param6:ArenaDataInfo = null) : void
      {
         this._onComplete = param1;
         this._arenaLoadingBar.setLeftFighterInfo(param2,param4);
         this._arenaLoadingBar.setRightFighterInfo(param3,param5);
         this._arenaLoadingBar.setFightPress(param2,param4,param3,param5);
         if(param6)
         {
            if(param6.fightMode == 1)
            {
               if(param3.typeId != 1)
               {
                  this._arenaLoadingBar.addFightInfoRelation(param3.typeId);
               }
            }
         }
      }
      
      public function loadFightResource(param1:FighterTeam, param2:FighterTeam, param3:ArenaDataInfo) : void
      {
         this._resourceQueue = new ResourceQueue();
         param1.createFighter(this._resourceQueue,param3);
         param2.createFighter(this._resourceQueue,param3);
         if(DecorationControl._isShowDecoration)
         {
            DecorationControl.startLoad(this._resourceQueue);
         }
         this.addSkillEffectToQueue(param1);
         this.addSkillEffectToQueue(param2);
         this.addSkillSoundToQueue(param1);
         this.addSkillSoundToQueue(param2);
         this.addFighterSoundToQueue(param1);
         this._resourceQueue.addEventListener("progress",this.onQueueProgress);
         this._resourceQueue.addEventListener("queueComplete",this.onQueueLoaded);
         this._resourceQueue.startLoad();
      }
      
      private function onQueueLoaded(param1:ResourceQueueEvent) : void
      {
         this._resourceQueue.removeEventListener("progress",this.onQueueProgress);
         this._resourceQueue.removeEventListener("queueComplete",this.onQueueLoaded);
         this.updateArenaLoadingBar(100);
      }
      
      private function addSkillEffectToQueue(param1:FighterTeam) : void
      {
         var _loc2_:Fighter = null;
         var _loc4_:SkillInfo = null;
         var _loc3_:SkillEffect = null;
         for each(_loc2_ in param1.fighterVec)
         {
            for each(_loc4_ in _loc2_.fighterInfo.skillInfoVec)
            {
               _loc3_ = new SkillEffect(_loc2_.fighterInfo.bunchId,_loc4_);
               _loc2_.addSkillEffect(_loc3_);
               this._resourceQueue.addCache("effect",_loc3_.getResourceUrl(),_loc3_.onResourceLoaded);
            }
         }
      }
      
      private function addSkillSoundToQueue(param1:FighterTeam) : void
      {
         var _loc5_:Fighter = null;
         var _loc7_:Fighter = null;
         var _loc6_:SkillInfo = null;
         var _loc3_:SkillSound = null;
         var _loc2_:SkillInfo = null;
         var _loc4_:SkillSound = null;
         if(SoundManager.isAvailable == false)
         {
            return;
         }
         for each(_loc5_ in param1.fighterVec)
         {
            for each(_loc6_ in _loc5_.fighterInfo.skillInfoVec)
            {
               _loc3_ = new SkillSound(_loc5_.fighterInfo.bunchId,_loc6_);
               _loc5_.addSkillSound(_loc3_);
               this._resourceQueue.addItem("sound",_loc3_.getSoundUrl(),_loc3_.onSoundLoaded);
            }
         }
         for each(_loc7_ in param1.changeFighterVec)
         {
            for each(_loc2_ in _loc7_.fighterInfo.skillInfoVec)
            {
               if(_loc2_.id != 0)
               {
                  _loc4_ = new SkillSound(_loc7_.fighterInfo.bunchId,_loc2_);
                  _loc7_.addSkillSound(_loc4_);
                  this._resourceQueue.addItem("sound",_loc4_.getSoundUrl(),_loc4_.onSoundLoaded);
               }
            }
         }
      }
      
      private function addFighterSoundToQueue(param1:FighterTeam) : void
      {
         var _loc2_:Fighter = null;
         var _loc3_:FighterSound = null;
         if(SoundManager.isAvailable == false)
         {
            return;
         }
         for each(_loc2_ in param1.fighterVec)
         {
            _loc3_ = new FighterSound(_loc2_.fighterInfo.resourceId);
            _loc2_.setFighterSound(_loc3_);
            this._resourceQueue.addItem("sound",_loc3_.getSoundUrl(),_loc3_.onSoundLoaded);
         }
      }
      
      private function onQueueProgress(param1:ProgressEvent) : void
      {
         this.updateArenaLoadingBar(this._resourceQueue.getLoadedPercent());
      }
      
      private function updateArenaLoadingBar(param1:int) : void
      {
         this._arenaLoadingBar.updateProgress(param1);
      }
      
      private function clear() : void
      {
         this._resourceQueue = null;
         this._arenaLoadingBar = null;
      }
   }
}

