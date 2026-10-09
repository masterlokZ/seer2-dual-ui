package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activity.processor.FightYiwa;
   import com.taomee.seer2.app.component.teleport.DeferTeleport;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.processor.activity.heroTieAct.HeroTieAct;
   import com.taomee.seer2.app.processor.activity.mascot.MascotManager;
   import com.taomee.seer2.app.processor.quest.handler.branch.quest10100.PetKingDayQuestNpc;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   
   public class MapProcessor_80 extends TitleMapProcessor
   {
      
      private var _goTransmitCabin:MovieClip;
      
      private var _goTransmitDeferTeleport:DeferTeleport;
      
      private var _menuGameBtn_0:SimpleButton;
      
      private var _menuGameBtn_1:SimpleButton;
      
      private var _vipGameBtn:SimpleButton;
      
      private var _newGameBtn:SimpleButton;
      
      private var _petKingQuest:PetKingDayQuestNpc;
      
      private var _fightHrader:FightYiwa;
      
      private var _mascot:MascotManager;
      
      private var _heroTieAct:HeroTieAct;
      
      public function MapProcessor_80(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         StatisticsManager.sendNoviceAccountHttpd("0x10033458");
         this.initGame();
         this.initFight();
         this.initNpc();
         this.initSuperPrize();
      }
      
      private function initHeroTieAct() : void
      {
         this._heroTieAct = new HeroTieAct(_map);
      }
      
      private function disposeHeroTieAct() : void
      {
         if(this._heroTieAct)
         {
            this._heroTieAct.dispose();
            this._heroTieAct = null;
         }
      }
      
      protected function swapDragon(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         DisplayObjectUtil.removeFromParent(event.target as MovieClip);
         SwapManager.swapItem(1244,1,function(param1:IDataInput):void
         {
            new SwapInfo(param1);
         });
      }
      
      private function initMascot() : void
      {
         this._mascot = new MascotManager(80,1,_map);
      }
      
      private function onClickBoy(param1:MouseEvent) : void
      {
         if(SwapManager.isSwapNumberMax(618))
         {
            SwapManager.entrySwap(618);
         }
      }
      
      private function initFight() : void
      {
         this._fightHrader = new FightYiwa();
      }
      
      private function initPetKing() : void
      {
      }
      
      private function initDoor() : void
      {
         this._goTransmitCabin = _map.content["goTransmitCabin"];
         this._goTransmitCabin.gotoAndStop(1);
         initInteractor(this._goTransmitCabin);
         this._goTransmitCabin.addEventListener("click",this.onDoorClick);
      }
      
      private function initDoorDeferTeleport() : void
      {
         this._goTransmitDeferTeleport = new DeferTeleport(this._goTransmitCabin);
         this._goTransmitDeferTeleport.setActorPostion(new Point(387,200));
         this._goTransmitDeferTeleport.setActorTargetMapId(70);
         this._goTransmitDeferTeleport.addEventListener("actorArrived",this.onActorArrivedDoor);
      }
      
      private function onActorArrivedDoor(param1:Event) : void
      {
         this._goTransmitCabin.play();
      }
      
      private function onDoorClick(param1:MouseEvent) : void
      {
         this._goTransmitDeferTeleport.actorMoveClose();
      }
      
      private function initGame() : void
      {
         this._menuGameBtn_1 = _map.content["gameMenuBtn_1"];
         this._vipGameBtn = _map.content["vipGameBtn"];
         this._newGameBtn = _map.content["newGameBtn"];
         this._menuGameBtn_1.addEventListener("click",this.onGameMenu);
         this._vipGameBtn.addEventListener("click",this.onVipGameMenue);
         this._newGameBtn.addEventListener("click",this.onNewGameMenue);
         TooltipManager.addCommonTip(this._menuGameBtn_1,"游戏库");
         TooltipManager.addCommonTip(this._vipGameBtn,"VIP游戏库");
         TooltipManager.addCommonTip(this._newGameBtn,"最新游戏");
      }
      
      private function onGameMenu(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("GameMenu"),"正在打开小游戏库...");
         StatisticsManager.sendNovice("0x1003346F");
      }
      
      private function onVipGameMenue(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("VipGameMenu"),"正在打开VIP小游戏库...");
         StatisticsManager.sendNovice("0x10033470");
      }
      
      private function onNewGameMenue(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("MiniGameIntroPanel"),"正在打开小游戏...",{
            "gameId":11,
            "isVip":0
         });
         StatisticsManager.sendNovice("0x10033471");
      }
      
      private function initNpc() : void
      {
         MobileManager.getMobile(151,"npc").visible = false;
      }
      
      private function initSuperPrize() : void
      {
         var npc:Mobile = null;
         npc = MobileManager.getMobile(151,"npc");
         if(DateUtil.inInDateScope(5,13,51,14,1))
         {
            ServerBufferManager.getServerBuffer(29,function(param1:ServerBuffer):void
            {
               var _loc2_:int = param1.readDataAtPostion(11);
               if(_loc2_ == 0)
               {
                  npc.visible = true;
                  npc.buttonMode = true;
                  npc.addEventListener("click",OnSuperPrizeHandler);
                  ServerBufferManager.updateServerBuffer(29,11,1);
               }
            });
         }
      }
      
      private function OnSuperPrizeHandler(param1:MouseEvent) : void
      {
         var npc:Mobile = null;
         var evt:MouseEvent = param1;
         npc = MobileManager.getMobile(151,"npc");
         SwapManager.swapItem(525,1,function(param1:IDataInput):void
         {
            var _loc2_:SwapInfo = new SwapInfo(param1);
            npc.removeEventListener("click",OnSuperPrizeHandler);
            npc.visible = false;
         });
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

