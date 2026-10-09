package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.events.FightStartEvent;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.info.BuyPropInfo;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.utils.NumberCountForJimmy;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   
   public class MapProcessor_80201 extends MapProcessor
   {
      
      private var npc:Mobile;
      
      private const npc_id:int = 756;
      
      private const fight_id:int = 964;
      
      private const buy_fight_boss:int = 204149;
      
      private const have_got_pet:int = 204150;
      
      private const have_fight_boss:int = 1110;
      
      private const buy_fight_boss_id:int = 603806;
      
      private var haveGotPet:Boolean;
      
      private var left:int;
      
      public function MapProcessor_80201(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.npc = MobileManager.getMobile(756,"npc");
         this.npc.buttonMode = true;
         this.npc.addEventListener("click",this.onNpc);
      }
      
      private function onNpc(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         ActiveCountManager.requestActiveCountList([204149,204150],function(param1:Parser_1142):void
         {
            var buy:uint = 0;
            var par:Parser_1142 = param1;
            buy = par.infoVec[0];
            haveGotPet = Boolean(par.infoVec[1]);
            DayLimitManager.getDoCount(1110,function(param1:uint):void
            {
               var cnt:uint = param1;
               var have:uint = cnt;
               if(ActorManager.actorInfo.vipInfo.isVip())
               {
                  left = NumberCountForJimmy.countLeftNum(have,buy,2);
               }
               else
               {
                  left = NumberCountForJimmy.countLeftNum(have,buy,1);
               }
               if(haveGotPet)
               {
                  SceneManager.changeScene(1,70);
               }
               else
               {
                  NpcDialog.show(756,"双面冥王",[[0,"通过我的挑战，你就可以获得冥王的终极力量！"]],["来挑战吧","让我准备一下"],[function():void
                  {
                     if(left > 0)
                     {
                        fight();
                     }
                     else
                     {
                        buyFight();
                     }
                  }]);
               }
            });
         });
      }
      
      private function fight() : void
      {
         FightManager.addEventListener("FIGHT_OVER",this.onOver);
         FightManager.startFightWithBoss(964);
      }
      
      private function request() : void
      {
      }
      
      private function buyFight() : void
      {
         var info:BuyPropInfo = new BuyPropInfo();
         info.itemId = 603806;
         info.buyComplete = function(param1:*):void
         {
            fight();
         };
         ShopManager.buyVirtualItem(info);
      }
      
      private function onOver(param1:FightStartEvent) : void
      {
         FightManager.removeEventListener("FIGHT_OVER",this.onOver);
         if(FightManager.fightWinnerSide == 1)
         {
            ModuleManager.showModule(URLUtil.getAppModule("MingWangWinDoorPanel"),"");
         }
         else
         {
            ModuleManager.showModule(URLUtil.getAppModule("MingWangLoseDoorPanel"),"");
         }
      }
      
      override public function dispose() : void
      {
         this.npc.removeEventListener("click",this.onNpc);
         super.dispose();
      }
   }
}

