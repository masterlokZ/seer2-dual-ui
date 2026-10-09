package com.taomee.seer2.app.processor.activity.moPetProcessAct
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.FightVerifyManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   import org.taomee.utils.DomainUtil;
   
   public class MoFightAct
   {
      
      private static var _self:MoFightAct;
      
      private static const MAX_BLOOD_NUM:uint = 680000;
      
      private static const TURN_FOR:uint = 203189;
      
      private static const MI_TURN_FOR:uint = 203190;
      
      private static const ALL_HURT_FOR:int = 203188;
      
      private static const DEFAULT_BLOOD_WIDTH:int = 168;
      
      private static const FIGHT_INDEX:uint = 587;
      
      private static const EXIT_MAP_SWAP:int = 1883;
      
      private static const ITEM_ID:Vector.<uint> = Vector.<uint>([500583,500584,500585,500586,500587]);
      
      private var _map:MapModel;
      
      private var _resLib:ApplicationDomain;
      
      private var _menu:MovieClip;
      
      private var _itemTxt:TextField;
      
      private var _turnTxt:TextField;
      
      private var _allHurtTxt:TextField;
      
      private var _hpTxt:TextField;
      
      private var _exitBtn:SimpleButton;
      
      private var _buyBtn:SimpleButton;
      
      private var _hpBar:MovieClip;
      
      private var _petBagBtn:SimpleButton;
      
      private var _tip:MovieClip;
      
      private var _turnValue:int;
      
      private var _hurtValue:int;
      
      private var _leftBlood:int;
      
      private var _npc:Mobile;
      
      private var _isToFight:Boolean = false;
      
      public function MoFightAct()
      {
         super();
         SceneManager.addEventListener("switchComplete",this.onSwitchComplete);
      }
      
      public static function getInstance() : MoFightAct
      {
         if(_self == null)
         {
            _self = new MoFightAct();
         }
         return _self;
      }
      
      public function setup(param1:MapModel) : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.getPositionIndex() == 587 && FightManager.isWinWar())
         {
            SwapManager.swapItem(1883,1,this.closeSwap);
            return;
         }
         this._map = param1;
         this.getURL();
      }
      
      private function getURL() : void
      {
         QueueLoader.load(URLUtil.getActivityAnimation("moPetProcessAct/MoFightAct"),"swf",function(param1:ContentInfo):void
         {
            _resLib = param1.domain;
            init();
         });
      }
      
      private function init() : void
      {
         this.initSet();
         this.initEvent();
         this.show();
      }
      
      private function getMovie(param1:String) : MovieClip
      {
         if(this._resLib)
         {
            return DomainUtil.getMovieClip(param1,this._resLib);
         }
         return null;
      }
      
      private function initSet() : void
      {
         this._menu = this.getMovie("Menu");
         this._itemTxt = this._menu["itemTxt"];
         this._turnTxt = this._menu["turnTxt"];
         this._allHurtTxt = this._menu["allHurtTxt"];
         this._hpTxt = this._menu["hpTxt"];
         this._hpBar = this._menu["hpBar"];
         this._buyBtn = this._menu["buyBtn"];
         this._exitBtn = this._menu["exitBtn"];
         this._petBagBtn = this._menu["petBtn"];
         this._tip = this._menu["tip"];
         this._tip.mouseEnabled = this._tip.mouseChildren = this._tip.visible = false;
         this._isToFight = false;
         (SceneManager.active as LobbyScene).hideToolbar();
         this.addNpc();
      }
      
      private function show() : void
      {
         this.update();
         this._map.content.addChild(this._menu);
      }
      
      private function addNpc() : void
      {
         if(!this._npc)
         {
            this._npc = new Mobile();
            this._npc.x = 435;
            this._npc.y = 300;
            this._npc.buttonMode = true;
         }
         this._npc.resourceUrl = URLUtil.getActivityMobile("MoProcessBoss");
         MobileManager.addMobile(this._npc,"npc");
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         if(this._turnValue > 0)
         {
            if(this.fightFilter())
            {
               this._isToFight = true;
               FightManager.startFightWithBoss(587);
            }
         }
         else
         {
            this.toExit();
         }
      }
      
      private function fightFilter() : Boolean
      {
         var _loc1_:Boolean = true;
         if(!FightVerifyManager.validateFightStart())
         {
            _loc1_ = false;
         }
         if(!this.isHasPetInBagByLevel(100))
         {
            _loc1_ = false;
            AlertManager.showAlert("精灵背包中至少有一只满级精灵才可以挑战哦!");
         }
         return _loc1_;
      }
      
      private function isHasPetInBagByType(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc4_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_.length)
         {
            if(_loc4_[_loc3_].type == param1)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function isHasPetInBagByLevel(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc4_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_.length)
         {
            if(_loc4_[_loc3_].level == param1)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function update() : void
      {
         this.requestItem();
         this.requestForeverLimit();
      }
      
      private function initEvent() : void
      {
         this._exitBtn.addEventListener("click",this.toExit);
         this._buyBtn.addEventListener("click",this.toBuy);
         this._petBagBtn.addEventListener("click",this.openPanel);
         this._npc.addEventListener("click",this.toFight);
         this._npc.addEventListener("rollOver",this.onNpcOver);
         this._npc.addEventListener("rollOut",this.onNpcOut);
      }
      
      private function onNpcOver(param1:MouseEvent) : void
      {
         this._tip.visible = true;
      }
      
      private function onNpcOut(param1:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      private function openPanel(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PetBagPanel"));
      }
      
      private function toBuy(param1:MouseEvent) : void
      {
         ModuleManager.addEventListener("BuyHurtItemPanel","dispose",this.closeBuy);
         ModuleManager.toggleModule(URLUtil.getAppModule("BuyHurtItemPanel"),"正在打开购买伤害面板...",{"type":1});
      }
      
      private function closeBuy(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("BuyHurtItemPanel","dispose",this.closeBuy);
         this.requestItem();
      }
      
      private function toExit(param1:MouseEvent = null) : void
      {
         ModuleManager.addEventListener("MoPetProcessHurtAlertPanel","dispose",this.closeAlert);
         ModuleManager.toggleModule(URLUtil.getAppModule("MoPetProcessHurtAlertPanel"),"",{
            "hurt":this._hurtValue,
            "leftCount":this._turnValue
         });
      }
      
      private function closeAlert(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("MoPetProcessHurtAlertPanel","dispose",this.closeAlert);
         this.updateTurns();
      }
      
      private function updateTurns() : void
      {
         this._npc.mouseEnabled = this._npc.mouseChildren = false;
         ActiveCountManager.requestActiveCountList([203189,203190],function(param1:Parser_1142):void
         {
            _turnValue = 5 - param1.infoVec[0] + param1.infoVec[1];
            _npc.mouseEnabled = _npc.mouseChildren = true;
            _turnTxt.text = _turnValue.toString();
         });
      }
      
      private function requestForeverLimit() : void
      {
         this._npc.mouseEnabled = this._npc.mouseChildren = false;
         ActiveCountManager.requestActiveCountList([203189,203190,203188],this.getNewInfo);
      }
      
      private function getNewInfo(param1:Parser_1142) : void
      {
         this._turnValue = 5 - param1.infoVec[0] + param1.infoVec[1];
         this._npc.mouseEnabled = this._npc.mouseChildren = true;
         this._hurtValue = param1.infoVec[2];
         this._leftBlood = 680000 - this._hurtValue;
         this.updateBlood();
         if(this._turnValue == 0)
         {
            this.toExit();
         }
      }
      
      private function closeSwap(param1:IDataInput) : void
      {
         new SwapInfo(param1);
         SceneManager.changeScene(1,70);
      }
      
      private function updateBlood() : void
      {
         this._turnTxt.text = this._turnValue.toString();
         this._hpBar.width = this._leftBlood / 680000 * 168;
         this._hpTxt.text = this._leftBlood + "/" + 680000;
         this._allHurtTxt.text = this._hurtValue.toString();
      }
      
      private function requestItem() : void
      {
         ItemManager.addEventListener1("requestSpecialItemSuccess",this.checkItem);
         ItemManager.requestSpecialItemList(true);
      }
      
      private function checkItem(param1:ItemEvent) : void
      {
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.checkItem);
         var _loc2_:int = 0;
         while(_loc2_ < ITEM_ID.length)
         {
            if(Boolean(ItemManager.getSpecialItem(ITEM_ID[_loc2_])) && ItemManager.getSpecialItem(ITEM_ID[_loc2_]).quantity > 0)
            {
               this._itemTxt.text = "当前魔神荣耀:" + ItemConfig.getItemDefinition(ITEM_ID[_loc2_]).tip;
               break;
            }
            this._itemTxt.text = "当前魔神荣耀:";
            _loc2_++;
         }
      }
      
      public function onSwitchComplete(param1:SceneEvent) : void
      {
         if(SceneManager.active.mapID == 70)
         {
            SceneManager.removeEventListener("switchComplete",this.onSwitchComplete);
            ModuleManager.showModule(URLUtil.getAppModule("MoPetProcessActPanel"),"正在打开魔圣前传(上):魔之刃面板...");
            _self = null;
         }
      }
      
      public function dispose() : void
      {
         this._npc.removeEventListener("click",this.toFight);
         ModuleManager.removeEventListener("MoPetProcessHurtAlertPanel","dispose",this.closeAlert);
         ModuleManager.removeEventListener("BuyHurtItemPanel","dispose",this.closeBuy);
         if(!this._isToFight)
         {
            (SceneManager.active as LobbyScene).showToolbar();
         }
         this._exitBtn.removeEventListener("click",this.toExit);
         this._buyBtn.removeEventListener("click",this.toBuy);
         this._petBagBtn.removeEventListener("click",this.openPanel);
      }
   }
}

