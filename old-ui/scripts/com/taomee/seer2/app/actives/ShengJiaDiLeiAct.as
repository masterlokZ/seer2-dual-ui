package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.info.BuyPropInfo;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   
   public class ShengJiaDiLeiAct
   {
      
      private static var _instance:ShengJiaDiLeiAct;
      
      private var ui:Sprite;
      
      private var buyRongYao:Sprite;
      
      private var exitBtn:SimpleButton;
      
      private var totalDamageTxt:TextField;
      
      private var canGetNumTxt:TextField;
      
      private var canFightTxt:TextField;
      
      private var petBagBtn:SimpleButton;
      
      private var itemShopBtn:SimpleButton;
      
      private var totalDamage:int;
      
      private var canGetNum:int;
      
      private var canFight:int;
      
      private var buyTurnNum:int;
      
      private var npc:Sprite;
      
      private const current_turn_id:int = 203844;
      
      private const current_damage_id:int = 203845;
      
      private const buy_turn_id:int = 206256;
      
      private const fight_index:int = 1754;
      
      private const fight_chance_item_id:int = 606820;
      
      private const damage_get_count:Array = [20,15,10,5,2,1];
      
      private const damage_get_value:Array = [200000,100000,50000,30000,10000,5000];
      
      private const leave_map_swap_id:int = 4471;
      
      private const buy_rong_yao_id:int = 606819;
      
      private const DAY_LIST:Array = [1872,1873];
      
      public function ShengJiaDiLeiAct()
      {
         super();
      }
      
      public static function getInstance() : ShengJiaDiLeiAct
      {
         if(_instance == null)
         {
            _instance = new ShengJiaDiLeiAct();
         }
         return _instance;
      }
      
      public function dispose() : void
      {
         if(this.npc)
         {
            TooltipManager.remove(this.npc);
            this.npc.removeEventListener("click",this.onCLick);
            DisplayObjectUtil.removeFromParent(this.npc);
         }
         if(this.exitBtn)
         {
            this.exitBtn.removeEventListener("click",this.onExitBtn);
            DisplayObjectUtil.removeFromParent(this.exitBtn);
         }
         if(this.buyRongYao)
         {
            this.buyRongYao.removeEventListener("click",this.onBuyRongYao);
            DisplayObjectUtil.removeFromParent(this.exitBtn);
         }
         if(this.petBagBtn)
         {
            this.petBagBtn.removeEventListener("click",this.openPanel);
         }
      }
      
      public function setUp() : void
      {
         this.initUI();
         this.getData();
         this.createNpc();
         this.initEvent();
         (SceneManager.active as LobbyScene).hideToolbar();
      }
      
      private function initUI() : void
      {
         this.ui = SceneManager.active.mapModel.front;
         this.buyRongYao = this.ui["buyRongYao"];
         this.buyRongYao.buttonMode = true;
         this.exitBtn = this.ui["exitBtn"];
         this.totalDamageTxt = this.ui["totalDamageTxt"];
         this.totalDamageTxt.text = "0";
         this.canGetNumTxt = this.ui["canGetNumTxt"];
         this.canGetNumTxt.text = "0";
         this.canFightTxt = this.ui["canFightTxt"];
         this.canFightTxt.text = "";
         this.petBagBtn = this.ui["petBag"];
         this.itemShopBtn = this.ui["itemShop"];
      }
      
      private function getData() : void
      {
         ActiveCountManager.requestActiveCount(206256,function(param1:uint, param2:int):void
         {
            var type:uint = param1;
            var count:int = param2;
            DayLimitListManager.getDaylimitList(DAY_LIST,(function():*
            {
               var callBack:Function;
               return callBack = function(param1:DayLimitListInfo):void
               {
                  var canGet:uint;
                  var i:int = 0;
                  var info:DayLimitListInfo = param1;
                  canFight = ActsHelperUtil.getCanNum(info.getCount(DAY_LIST[0]),count,5);
                  totalDamage = info.getCount(DAY_LIST[1]);
                  canFightTxt.text = canFight.toString();
                  canGet = 0;
                  if(SceneManager.prevSceneType == 2 && FightManager.currentFightRecord.initData.positionIndex == 1754)
                  {
                     if(FightManager.fightWinnerSide == 1)
                     {
                        canGet = 25;
                        totalDamage = 250000;
                        canGetNumTxt.text = canGet.toString();
                        totalDamageTxt.text = totalDamage.toString();
                        AlertManager.showAlert("由于你赢得了胜利,你将获得【地之卫甲】" + canGet + "个",function():void
                        {
                           SwapManager.swapItem(4471,1,function(param1:IDataInput):void
                           {
                              new SwapInfo(param1);
                              SceneManager.changeScene(1,70);
                           });
                        });
                     }
                     else
                     {
                        for(i = 0; i < damage_get_value.length; )
                        {
                           if(totalDamage >= damage_get_value[i])
                           {
                              canGet = uint(damage_get_count[i]);
                              break;
                           }
                           i++;
                        }
                        canGetNumTxt.text = canGet.toString();
                        totalDamageTxt.text = totalDamage.toString();
                     }
                  }
               };
            })());
         });
      }
      
      private function createNpc() : void
      {
         this.npc = this.ui["npc"];
         this.npc.buttonMode = true;
         TooltipManager.addCommonTip(this.npc,"点我开始战斗，【离开】后结束挑战输出奖励");
         this.npc.addEventListener("click",this.onCLick);
      }
      
      private function onCLick(param1:MouseEvent) : void
      {
         var _loc2_:BuyPropInfo = null;
         if(this.canFight > 0)
         {
            FightManager.startFightWithBoss(1754);
         }
         else
         {
            _loc2_ = new BuyPropInfo();
            _loc2_.itemId = 606820;
            _loc2_.buyComplete = this.buyOver;
            ShopManager.buyVirtualItem(_loc2_);
         }
      }
      
      private function buyOver(param1:*) : void
      {
         FightManager.startFightWithBoss(1754);
      }
      
      private function initEvent() : void
      {
         this.buyRongYao.addEventListener("click",this.onBuyRongYao);
         this.exitBtn.addEventListener("click",this.onExitBtn);
         this.petBagBtn.addEventListener("click",this.openPanel);
         this.itemShopBtn.addEventListener("click",this.onItemShopBtn);
      }
      
      private function openPanel(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PetBagPanel"));
      }
      
      private function onItemShopBtn(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("MedicineShopPanel");
      }
      
      private function onBuyRongYao(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var info1:BuyPropInfo = new BuyPropInfo();
         info1.itemId = 606819;
         info1.buyComplete = function(param1:*):void
         {
         };
         ShopManager.buyVirtualItem(info1);
      }
      
      private function onExitBtn(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         AlertManager.showConfirm("离开地图将结束此轮挑战，你确定要离开吗？",function():void
         {
            SwapManager.swapItem(4471,1,function(param1:IDataInput):void
            {
               new SwapInfo(param1);
               SceneManager.changeScene(1,70);
            });
         });
      }
   }
}

