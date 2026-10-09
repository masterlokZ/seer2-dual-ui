package com.taomee.seer2.app.processor.activity.earthSearchAct
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class EarthSearchThreeManager
   {
      
      private static var _self:EarthSearchThreeManager;
      
      private var _obj:EarthSearchThreeLayer;
      
      private var _state:int;
      
      public function EarthSearchThreeManager()
      {
         super();
         this._state = 0;
         SceneManager.addEventListener("switchComplete",this.onComplete);
      }
      
      public static function inistance() : EarthSearchThreeManager
      {
         if(null == _self)
         {
            _self = new EarthSearchThreeManager();
         }
         return _self;
      }
      
      public function set state(param1:int) : void
      {
         this._state = param1;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function addObj(param1:EarthSearchThreeLayer) : void
      {
         this._obj = param1;
      }
      
      private function onComplete(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType == 2)
         {
            if(FightManager.fightWinnerSide == 1)
            {
               this._state = 2;
               this._obj.addBoss();
               SceneManager.removeEventListener("switchComplete",this.onComplete);
            }
         }
         if(SceneManager.prevMapID == 80372 && SceneManager.active.type != 2)
         {
            SceneManager.removeEventListener("switchComplete",this.onComplete);
            _self = null;
            this._obj = null;
         }
      }
   }
}

