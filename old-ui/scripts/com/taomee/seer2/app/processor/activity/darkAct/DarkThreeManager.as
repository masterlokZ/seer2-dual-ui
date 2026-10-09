package com.taomee.seer2.app.processor.activity.darkAct
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class DarkThreeManager
   {
      
      private static var _self:DarkThreeManager;
      
      private var _obj:DarkThreeLayer;
      
      private var _state:int;
      
      public function DarkThreeManager()
      {
         super();
         this._state = 0;
         StatisticsManager.sendNovice("0x10033768");
         SceneManager.addEventListener("switchComplete",this.onComplete);
      }
      
      public static function inistance() : DarkThreeManager
      {
         if(null == _self)
         {
            _self = new DarkThreeManager();
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
      
      public function addObj(param1:DarkThreeLayer) : void
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
               ServerMessager.addMessage("已经通过本层关卡");
               SceneManager.removeEventListener("switchComplete",this.onComplete);
            }
         }
         if(SceneManager.prevMapID == 80013 && SceneManager.active.type != 2)
         {
            SceneManager.removeEventListener("switchComplete",this.onComplete);
            _self = null;
            this._obj = null;
         }
      }
   }
}

