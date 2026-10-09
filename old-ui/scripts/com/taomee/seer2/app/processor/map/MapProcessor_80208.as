package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.config.ShopPanelConfig;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.shopManager.PayManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   
   public class MapProcessor_80208 extends MapProcessor
   {
      
      public static var havewin:Boolean = false;
      
      private const FIGHT_DAY:int = 1163;
      
      private const FIGHT_SWAP:int = 2853;
      
      private const MI_BUY_NUM_FOR:uint = 204273;
      
      private const POWER:uint = 204271;
      
      private const MAX:uint = 200000;
      
      private const ITEM_LIST:Vector.<uint> = Vector.<uint>([400498]);
      
      private const FIGHT_ID:int = 1024;
      
      private const YAO_ID:int = 500607;
      
      private const MI_BUY_LIST:int = 603897;
      
      private const MI_BUY_YAO:int = 1;
      
      private var isToFight:Boolean = false;
      
      public function MapProcessor_80208(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.isToFight = false;
         _map.front["fightUI"]["win"].visible = false;
         _map.front["fightUI"]["win"].visible = false;
         this.update();
         this.initEvent();
         (SceneManager.active as LobbyScene).hideToolbar();
      }
      
      override public function dispose() : void
      {
         if(!this.isToFight)
         {
            (SceneManager.active as LobbyScene).showToolbar();
         }
      }
      
      private function initEvent() : void
      {
         if(!_map.front["fightUI"]["leaveBtn"].hasEventListener("click"))
         {
            _map.front["fightUI"]["leaveBtn"].addEventListener("click",this.onClick);
         }
         if(!_map.front["openVipBtn"].hasEventListener("click"))
         {
            _map.front["openVipBtn"].addEventListener("click",this.onVip);
         }
         if(!_map.front["petBtn"].hasEventListener("click"))
         {
            _map.front["petBtn"].addEventListener("click",this.onPetBag);
         }
         if(!_map.front["help"].hasEventListener("click"))
         {
            _map.front["help"].addEventListener("click",this.onHelp);
         }
         if(!_map.front["yao"].hasEventListener("click"))
         {
            _map.front["yao"].addEventListener("click",this.onClickYao);
         }
         if(!_map.content["pet"].hasEventListener("click"))
         {
            _map.content["pet"].addEventListener("click",this.onClickPet);
         }
         _map.content["pet"].buttonMode = true;
         if(!_map.front["fightUI"]["win"]["okBtn"].hasEventListener("click"))
         {
            _map.front["fightUI"]["win"]["okBtn"].addEventListener("click",this.onGoShowOk);
         }
      }
      
      private function onGoShowClose(param1:MouseEvent) : void
      {
      }
      
      private function onGoShowOk(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         SwapManager.swapItem(2853,1,function(param1:IDataInput):void
         {
            new SwapInfo(param1);
            SceneManager.changeScene(1,70);
         },null,null);
      }
      
      private function onHelp(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("MedicineShopPanel");
      }
      
      private function onPetBag(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("PetBagPanel");
      }
      
      private function onVip(param1:MouseEvent) : void
      {
         VipManager.navigateToPayPage();
      }
      
      private function onClickPet(param1:MouseEvent) : void
      {
         this.onSpeak1();
      }
      
      private function onClickYao(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         AlertManager.showConfirm("你确定花费" + ShopPanelConfig.getItemPrice(500607) + "星钻购买断魂药剂?",function():void
         {
            PayManager.buyItem(500607,function():void
            {
               update();
            });
         });
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         havewin = false;
         _map.front["fightUI"]["win"].visible = true;
      }
      
      private function onSpeak1() : void
      {
         NpcDialog.show(694,"黑武士",[[0,"我的剑可以斩断一切，因为我信奉武士道精神！我来挑战下武士道精神！"]],["让我体验下武士道精神！"," 让我准备一下"],[function():void
         {
            if(uint(_map.front["fightUI"]["times"].text) <= 0)
            {
               AlertManager.showConfirm("你确定花费" + ShopPanelConfig.getItemPrice(603897) + "星钻增加次数吗?",function():void
               {
                  PayManager.buyItem(603897,function():void
                  {
                     update();
                  });
               });
               return;
            }
            SceneManager.addEventListener("switchComplete",onOver);
            isToFight = true;
            havewin = false;
            FightManager.startFightWithWild(1024);
         },null]);
      }
      
      private function onOver(param1:Event) : void
      {
         if(FightManager.getPositionIndex() != 1024)
         {
            return;
         }
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1)
         {
            havewin = true;
            this.showWin();
         }
         else if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 2)
         {
         }
      }
      
      private function showWin() : void
      {
         if(havewin)
         {
            AlertManager.showAlert("由于你赢的了胜利,你将获得25个武魂！",function():void
            {
               onGoShowOk(null);
            });
            havewin = false;
         }
      }
      
      private function update() : void
      {
         var miBuyVal:int = 0;
         var power:int = 0;
         var practiceVal:int = 0;
         DayLimitManager.getDoCount(1163,function(param1:int):void
         {
            var val:int = param1;
            ActiveCountManager.requestActiveCountList([204273,204271],function(param1:Parser_1142):void
            {
               var _loc2_:int = val;
               miBuyVal = param1.infoVec[0];
               power = param1.infoVec[1];
               var _loc4_:uint = 5;
               if(_loc2_ > _loc4_)
               {
                  practiceVal = miBuyVal;
               }
               else
               {
                  practiceVal = _loc4_ - _loc2_ + miBuyVal;
               }
               _map.front["fightUI"]["times"].text = practiceVal + "";
               _map.front["fightUI"]["totle"].text = power + "";
               _map.front["fightUI"]["win"]["score"].text = power + "";
               var _loc3_:int = 0;
               if(power >= 200000)
               {
                  _loc3_ = 20;
               }
               else if(power >= 100000)
               {
                  _loc3_ = 15;
               }
               else if(power >= 50000)
               {
                  _loc3_ = 10;
               }
               else if(power >= 30000)
               {
                  _loc3_ = 5;
               }
               else if(power >= 10000)
               {
                  _loc3_ = 2;
               }
               else if(power >= 5000)
               {
                  _loc3_ = 1;
               }
               if(havewin)
               {
                  _loc3_ = 25;
               }
               _map.front["fightUI"]["win"]["numText"].text = "" + _loc3_;
            });
         });
         this.updateItem();
      }
      
      private function updateItem() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.ITEM_LIST.length)
         {
            if(ItemManager.getSpecialItem(this.ITEM_LIST[_loc1_]))
            {
               _map.front["fightUI"]["itemText"].text = ItemManager.getSpecialItem(this.ITEM_LIST[_loc1_]).quantity + "";
            }
            _loc1_++;
         }
      }
      
      private function updateBar(param1:uint) : void
      {
         _map.front["fightUI"]["bar"].gotoAndStop(1);
         _map.front["fightUI"]["bar"].gotoAndStop(uint(param1 * 100 / 200000));
      }
   }
}

