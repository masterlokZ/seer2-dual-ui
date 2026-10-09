package com.taomee.seer2.app.actives.leiyiGun
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.events.FightStartEvent;
   import com.taomee.seer2.app.controls.PetAvatarPanel;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   
   public class OutputFree
   {
      
      private const RANDOM_INDEX:uint = 49;
      
      private const FIGHT_FALSE:uint = 500;
      
      private const FIGHT_TRUE:uint = 499;
      
      private var mapModel:MapModel;
      
      private var styleMc:MovieClip;
      
      public function OutputFree()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.styleMc.removeEventListener("click",this.toFight);
      }
      
      public function setup() : void
      {
         (SceneManager.active as LobbyScene).hideToolbar();
         PetAvatarPanel.show();
         this.mapModel = SceneManager.active.mapModel;
         this.styleMc = this.mapModel.front["stylemc"];
         this.styleMc.buttonMode = true;
         this.styleMc.mouseChildren = false;
         this.styleMc.addEventListener("click",this.toFight);
         this.createGun();
      }
      
      private function createGun() : void
      {
         var _loc1_:int = Math.ceil(Math.random() * this.styleMc.totalFrames);
         this.styleMc.gotoAndStop(_loc1_);
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         Connection.addCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
         Connection.send(CommandSet.RANDOM_EVENT_1140,49,0);
      }
      
      private function onRandomStatus(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
         var _loc2_:IDataInput = param1.message.getRawDataCopy();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc3_:uint = _loc2_.readUnsignedInt();
         FightManager.addEventListener("FIGHT_OVER",this.exitMap);
         if(_loc3_ == 0)
         {
            FightManager.startFightWithBoss(500);
         }
         else
         {
            FightManager.startFightWithBoss(499);
         }
      }
      
      private function exitMap(param1:FightStartEvent) : void
      {
         FightManager.removeEventListener("FIGHT_OVER",this.exitMap);
         SceneManager.changeScene(1,70);
         SceneManager.addEventListener("switchComplete",this.onCompleteMap);
      }
      
      private function onCompleteMap(param1:SceneEvent) : void
      {
         if(SceneManager.active.mapID == 70)
         {
            SceneManager.removeEventListener("switchComplete",this.onCompleteMap);
            ModuleManager.toggleModule(URLUtil.getAppModule("LeiyiGunPetPanel"));
         }
      }
   }
}

