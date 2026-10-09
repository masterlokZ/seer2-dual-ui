package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   
   public class TotalHurtFightPetAct
   {
      
      private static var _instance:TotalHurtFightPetAct;
      
      private const ITEM_ID:Array = [500556,500557,500558,500559,500560];
      
      private const maxBloodNum:uint = 1300000;
      
      private const turnId:uint = 202245;
      
      private const hurtId:int = 202240;
      
      private const defaultBloodWidth:int = 168;
      
      private const fightIndex:uint = 425;
      
      private var itemTxt:TextField;
      
      private var turnTxt:TextField;
      
      private var allHurtTxt:TextField;
      
      private var hpTxt:TextField;
      
      private var exitBtn:SimpleButton;
      
      private var buyBtn:SimpleButton;
      
      private var hpBar:MovieClip;
      
      private var turnValue:int;
      
      private var hurtValue:int;
      
      private var leftBlood:int;
      
      private var _npc:Mobile;
      
      private var isToFight:Boolean = false;
      
      private var petBagBtn:SimpleButton;
      
      public function TotalHurtFightPetAct()
      {
         super();
      }
      
      public static function getInstance() : TotalHurtFightPetAct
      {
         if(!_instance)
         {
            _instance = new TotalHurtFightPetAct();
         }
         return _instance;
      }
      
      public function dispose() : void
      {
         this._npc.removeEventListener("click",this.toFight);
         TooltipManager.remove(this._npc);
         ModuleManager.removeEventListener("TotalHurtAlertPanel","dispose",this.closeAlert);
         ModuleManager.removeEventListener("TotalHurtBuyPanel","dispose",this.closeBuy);
         if(!this.isToFight)
         {
            (SceneManager.active as LobbyScene).showToolbar();
         }
         this.exitBtn.removeEventListener("click",this.toExit);
         this.buyBtn.removeEventListener("click",this.toBuy);
         this.petBagBtn.removeEventListener("click",this.openPanel);
      }
      
      public function setup() : void
      {
         this.initUI();
         this.getData();
         this.createNpc();
         this.initEvent();
         this.isToFight = false;
         (SceneManager.active as LobbyScene).hideToolbar();
      }
      
      private function initUI() : void
      {
         var _loc1_:Sprite = SceneManager.active.mapModel.front;
         this.itemTxt = _loc1_["itemTxt"];
         this.turnTxt = _loc1_["turnTxt"];
         this.allHurtTxt = _loc1_["allHurtTxt"];
         this.hpTxt = _loc1_["hpTxt"];
         this.hpBar = _loc1_["hpBar"];
         this.buyBtn = _loc1_["buyBtn"];
         this.exitBtn = _loc1_["exitBtn"];
         this.petBagBtn = _loc1_["petBtn"];
      }
      
      private function createNpc() : void
      {
         if(!this._npc)
         {
            this._npc = new Mobile();
            this._npc.x = 500;
            this._npc.y = 210;
            this._npc.buttonMode = true;
            this._npc.mouseChildren = false;
         }
         this._npc.resourceUrl = URLUtil.getActivityMobile("TotalHurtBoss");
         this._npc.addEventListener("click",this.toFight);
         TooltipManager.addCommonTip(this._npc," 点我开始战斗！【离开】后就会结束狩猎并输出奖励，\n小赛尔，请珍惜每一轮和我战斗的机会哦！");
         MobileManager.addMobile(this._npc,"npc");
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         if(this.turnValue > 0)
         {
            this.isToFight = true;
            FightManager.startFightWithBoss(425);
         }
         else
         {
            this.toExit();
         }
      }
      
      private function getData() : void
      {
         this.requestItem();
         this.requestForeverLimit();
      }
      
      private function initEvent() : void
      {
         this.exitBtn.addEventListener("click",this.toExit);
         this.buyBtn.addEventListener("click",this.toBuy);
         this.petBagBtn.addEventListener("click",this.openPanel);
      }
      
      private function openPanel(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PetBagPanel"));
      }
      
      private function toBuy(param1:MouseEvent) : void
      {
         ModuleManager.addEventListener("TotalHurtBuyPanel","dispose",this.closeBuy);
         ModuleManager.toggleModule(URLUtil.getAppModule("TotalHurtBuyPanel"));
      }
      
      private function closeBuy(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("TotalHurtBuyPanel","dispose",this.closeBuy);
         this.requestItem();
      }
      
      private function toExit(param1:MouseEvent = null) : void
      {
         ModuleManager.addEventListener("TotalHurtAlertPanel","dispose",this.closeAlert);
         ModuleManager.toggleModule(URLUtil.getAppModule("TotalHurtAlertPanel"),"",{
            "hurt":this.hurtValue,
            "leftCount":this.turnValue
         });
      }
      
      private function closeAlert(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("TotalHurtAlertPanel","dispose",this.closeAlert);
         this.requestForeverLimit();
      }
      
      private function requestForeverLimit() : void
      {
         ActiveCountManager.requestActiveCountList([202245,202240],this.getNewInfo);
      }
      
      private function getNewInfo(param1:Parser_1142) : void
      {
         this.turnValue = param1.infoVec[0];
         this.hurtValue = param1.infoVec[1];
         this.leftBlood = 1300000 - this.hurtValue;
         this.updateBlood();
         if(this.leftBlood <= 0)
         {
            SwapManager.swapItem(1264,1,this.closeSwap);
         }
      }
      
      private function closeSwap(param1:IDataInput) : void
      {
         new SwapInfo(param1);
         SceneManager.changeScene(1,70);
      }
      
      private function updateBlood() : void
      {
         this.turnTxt.text = this.turnValue.toString();
         this.hpBar.width = this.leftBlood / 1300000 * 168;
         this.hpTxt.text = this.leftBlood + "/" + 1300000;
         this.allHurtTxt.text = this.hurtValue.toString();
      }
      
      private function requestItem() : void
      {
         ItemManager.addEventListener1("requestSpecialItemSuccess",this.checkItem);
         ItemManager.requestSpecialItemList();
      }
      
      private function checkItem(param1:ItemEvent) : void
      {
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.checkItem);
         var _loc2_:int = 0;
         while(_loc2_ < this.ITEM_ID.length)
         {
            if(Boolean(ItemManager.getSpecialItem(this.ITEM_ID[_loc2_])) && ItemManager.getSpecialItem(this.ITEM_ID[_loc2_]).quantity > 0)
            {
               this.itemTxt.text = "当前荣耀:" + ItemConfig.getItemName(this.ITEM_ID[_loc2_]) + "," + ItemConfig.getItemDefinition(this.ITEM_ID[_loc2_]).tip;
               break;
            }
            this.itemTxt.text = "当前荣耀:";
            _loc2_++;
         }
      }
   }
}

