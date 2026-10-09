package com.taomee.seer2.app.actives
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.info.BuyPropInfo;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.utils.FightHelpUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class LuoChaQingDiAct
   {
      
      private static var _instance:LuoChaQingDiAct;
      
      private var ui:Sprite;
      
      private var exitBtn:SimpleButton;
      
      private var totalDamageTxt:TextField;
      
      private var canGetNumTxt:TextField;
      
      private var totalDamage:int;
      
      private var canGetNum:int;
      
      private var canFight:int;
      
      private var buyTurnNum:int;
      
      private var npc:Sprite;
      
      private const FIGHT_BOSS_ID:int = 1767;
      
      private const damage_get_count:Array = [10,5,3,2,1];
      
      private const damage_get_value:Array = [30000,15000,10000,5000,2000];
      
      private const FOR_LIST:Array = [206296];
      
      private const DAY_LIST:Array = [1881];
      
      public function LuoChaQingDiAct()
      {
         super();
      }
      
      public static function getInstance() : LuoChaQingDiAct
      {
         if(_instance == null)
         {
            _instance = new LuoChaQingDiAct();
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
         this.exitBtn = this.ui["exitBtn"];
         this.totalDamageTxt = this.ui["totalDamageTxt"];
         this.totalDamageTxt.text = "0";
         this.canGetNumTxt = this.ui["canGetNumTxt"];
         this.canGetNumTxt.text = "0";
         new FightHelpUtil(this.ui["petBagBtn"],this.ui["reBloodBtn"]);
      }
      
      private function getData() : void
      {
         ActiveCountManager.requestActiveCountList(this.FOR_LIST,function(param1:Parser_1142):void
         {
            var par:Parser_1142 = param1;
            DayLimitListManager.getDaylimitList(DAY_LIST,(function():*
            {
               var callBack:Function;
               return callBack = function(param1:DayLimitListInfo):void
               {
                  var i:int = 0;
                  var info:DayLimitListInfo = param1;
                  totalDamage = par.infoVec[0];
                  canFight = 5 - info.getCount(DAY_LIST[0]);
                  var canGet:uint = 0;
                  if(SceneManager.prevSceneType == 2 && FightManager.currentFightRecord.initData.positionIndex == 1767)
                  {
                     if(FightManager.fightWinnerSide == 1)
                     {
                        canGet = 10;
                        totalDamage = 30000;
                        canGetNumTxt.text = canGet.toString();
                        totalDamageTxt.text = totalDamage.toString();
                        AlertManager.showAlert("由于你赢得了胜利,你将获得【极速结晶】" + canGet + "个",function():void
                        {
                           ServerBufferManager.updateServerBuffer(452,1,0);
                           SceneManager.changeScene(1,70);
                           TweenNano.delayedCall(1,function():void
                           {
                              ModuleManager.showAppModule("LuoChaQingDiModeOnePanel");
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
         var info:BuyPropInfo = null;
         var e:MouseEvent = param1;
         if(this.canFight > 0)
         {
            ServerBufferManager.getServerBuffer(452,function(param1:ServerBuffer):void
            {
               var _loc2_:Boolean = Boolean(param1.readDataAtPostion(1));
               if(!_loc2_)
               {
                  ServerBufferManager.updateServerBuffer(452,1,1);
                  FightManager.startFightWithBoss(1767);
               }
               else
               {
                  AlertManager.showAlert("本次战斗已结束，请离开场景后再次挑战！");
               }
            });
         }
         else
         {
            info = new BuyPropInfo();
            info.itemId = 606856;
            info.buyComplete = this.buyOver;
            ShopManager.buyVirtualItem(info);
         }
      }
      
      private function buyOver(param1:*) : void
      {
         FightManager.startFightWithBoss(1767);
      }
      
      private function initEvent() : void
      {
         this.exitBtn.addEventListener("click",this.onExitBtn);
      }
      
      private function onExitBtn(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         AlertManager.showConfirm("离开地图将结束挑战，你确定要离开吗？",function():void
         {
            ServerBufferManager.updateServerBuffer(452,1,0);
            SceneManager.changeScene(1,70);
            TweenNano.delayedCall(1,function():void
            {
               ModuleManager.showAppModule("LuoChaQingDiModeOnePanel");
            });
         });
      }
   }
}

