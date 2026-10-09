package com.taomee.seer2.app.actives.fireClaw
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.events.FightStartEvent;
   import com.taomee.seer2.app.controls.PetAvatarPanel;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.manager.StatisticsManager;
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
   
   public class FireClawFreeMode
   {
      
      private const RANDOM_INDEX:uint = 54;
      
      private const FIGHT_FALSE:uint = 562;
      
      private const FIGHT_TRUE:uint = 561;
      
      private var mapModel:MapModel;
      
      private var fireList:Vector.<MovieClip>;
      
      public function FireClawFreeMode()
      {
         super();
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this.fireList[_loc1_].removeEventListener("click",this.toFight);
            _loc1_++;
         }
      }
      
      public function setup() : void
      {
         StatisticsManager.sendNovice("0x10034041");
         (SceneManager.active as LobbyScene).hideToolbar();
         PetAvatarPanel.show();
         this.mapModel = SceneManager.active.mapModel;
         this.initFireList();
      }
      
      private function initFireList() : void
      {
         this.fireList = new Vector.<MovieClip>();
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this.fireList.push(this.mapModel.content["fire" + _loc1_]);
            this.fireList[_loc1_].mouseChildren = false;
            this.fireList[_loc1_].buttonMode = true;
            this.fireList[_loc1_].addEventListener("click",this.toFight);
            _loc1_++;
         }
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         Connection.addCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
         Connection.send(CommandSet.RANDOM_EVENT_1140,54,0);
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
            FightManager.startFightWithBoss(562);
         }
         else
         {
            FightManager.startFightWithBoss(561);
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
            ModuleManager.toggleModule(URLUtil.getAppModule("FireClawActPanel"));
         }
      }
   }
}

