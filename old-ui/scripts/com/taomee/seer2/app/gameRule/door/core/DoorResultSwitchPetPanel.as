package com.taomee.seer2.app.gameRule.door.core
{
   import com.greensock.TweenLite;
   import com.taomee.seer2.app.common.ResourceLibraryLoader;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.item.BasisItemDefinition;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.popup.alert.DoorRewardVO;
   import com.taomee.seer2.app.utils.PetUtil;
   import com.taomee.seer2.core.map.ResourceLibrary;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DoorResultSwitchPetPanel extends Sprite
   {
      
      public static const SELECT_SWITCH_COMPLETE:String = "selectSwitchComplete";
      
      public static const CONFIRM_COMPLETE:String = "confirmComplete";
      
      public static const LOAD_COMPLETE_SHOW_PANEL:String = "loadCompleteShowPanel";
      
      private var _switchUI:MovieClip;
      
      private var _s0:MovieClip;
      
      private var _confirmBtn:SimpleButton;
      
      private var _enableBtn:Boolean;
      
      private var _rewardCanvas:Vector.<MovieClip>;
      
      private var _useRewardCanvas:Vector.<DoorRewardVO>;
      
      private var _rewardId:uint;
      
      private var _serverRewardList:Vector.<ServerReward>;
      
      private var _resLoader:ResourceLibraryLoader;
      
      private var _tweenIndex:uint = 1;
      
      public function DoorResultSwitchPetPanel(param1:uint, param2:Vector.<ServerReward>, param3:Boolean = false)
      {
         super();
         this._rewardId = param1;
         this._serverRewardList = param2;
         this._enableBtn = param3;
         this.initSwitchPetPanel();
      }
      
      private function initSwitchPetPanel() : void
      {
         this._resLoader = new ResourceLibraryLoader(URLUtil.getRes("publicRes/doorResult.swf"));
         this._resLoader.getLib(this.onGetLib);
      }
      
      private function onGetLib(param1:ResourceLibrary) : void
      {
         this._switchUI = param1.getMovieClip("DoorWinMulSelectUI");
         addChild(this._switchUI);
         this._s0 = this._switchUI["s0"];
         this._confirmBtn = this._switchUI["confirmBtn"];
         this._confirmBtn.addEventListener("click",this.onConfirm);
         this._confirmBtn.visible = false;
         this._confirmBtn.mouseEnabled = false;
         this._rewardCanvas = new Vector.<MovieClip>();
         this._rewardCanvas.push(this._switchUI["cav0"]);
         this._rewardCanvas.push(this._switchUI["cav1"]);
         this._rewardCanvas.push(this._switchUI["cav2"]);
         this._rewardCanvas.push(this._switchUI["cav3"]);
         this._rewardCanvas.push(this._switchUI["cav4"]);
         this._rewardCanvas.push(this._switchUI["cav5"]);
         this._useRewardCanvas = new Vector.<DoorRewardVO>();
         this.dispatchEvent(new Event("loadCompleteShowPanel"));
         this.addReward(this._serverRewardList.shift());
      }
      
      public function dispose() : void
      {
         this._rewardCanvas = null;
         this._useRewardCanvas = null;
         removeChild(this._switchUI);
         this._switchUI = null;
         this._s0 = null;
         this._serverRewardList = null;
         this._confirmBtn.removeEventListener("click",this.onConfirm);
         this._confirmBtn = null;
         this._resLoader.dispose();
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         if(this._enableBtn)
         {
            this.dispatchEvent(new Event("confirmComplete"));
         }
      }
      
      private function layout() : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:uint = 0;
         var _loc5_:uint = 0;
         var _loc4_:uint = 0;
         var _loc1_:DoorRewardVO = null;
         for each(_loc3_ in this._rewardCanvas)
         {
            _loc3_.visible = false;
         }
         _loc2_ = this._useRewardCanvas.length;
         _loc5_ = 192;
         _loc4_ = 107;
         if(_loc2_ <= 3)
         {
            _loc4_ = 169;
         }
         this._s0.x = _loc5_;
         this._s0.y = _loc4_;
         for each(_loc1_ in this._useRewardCanvas)
         {
            _loc1_.canvas.x = _loc5_;
            _loc1_.canvas.y = _loc4_;
            _loc5_ += 204;
            if(_loc5_ > 601)
            {
               _loc5_ = 192;
               _loc4_ += 160;
            }
         }
      }
      
      private function addReward(param1:ServerReward) : void
      {
         param1.printInfo();
         if(param1.rewardType == 1)
         {
            this.addPet(param1);
         }
         else if(param1.rewardType == 2)
         {
            this.addItem(param1);
         }
      }
      
      private function addItem(param1:ServerReward) : void
      {
         var itemIconUrl:String;
         var itemDefiniation:BasisItemDefinition = null;
         var rewardSprite:MovieClip = null;
         var icon:IconDisplayer = null;
         var onContentLoaded:Function = null;
         var reward:ServerReward = param1;
         onContentLoaded = function():void
         {
            rewardSprite = _rewardCanvas.shift();
            rewardSprite.addChild(icon);
            rewardSprite["nameTxt"].text = itemDefiniation.name;
            icon.x = 25;
            icon.y = 25;
            var _loc1_:DoorRewardVO = new DoorRewardVO();
            _loc1_.canvas = rewardSprite;
            _loc1_.icon = icon;
            _loc1_.reward = reward;
            _useRewardCanvas.push(_loc1_);
            if(_serverRewardList.length > 0)
            {
               addReward(_serverRewardList.shift());
            }
            else
            {
               start();
            }
         };
         itemDefiniation = ItemConfig.getItemDefinition(reward.rewardId);
         if(itemDefiniation == null)
         {
            throw new Error("ItemConfig 配置表未查找到该Id的物品定义:" + reward.rewardId);
         }
         itemIconUrl = ItemConfig.getItemIconUrl(reward.rewardId);
         icon = new IconDisplayer();
         icon.setBoundary(100,100);
         icon.setIconUrl(itemIconUrl,onContentLoaded);
      }
      
      private function addPet(param1:ServerReward) : void
      {
         var url:String;
         var petDefiniton:PetDefinition = null;
         var petSprite:MovieClip = null;
         var icon:IconDisplayer = null;
         var onContentLoaded:Function = null;
         var reward:ServerReward = param1;
         onContentLoaded = function():void
         {
            petSprite = _rewardCanvas.shift();
            petSprite.addChild(icon);
            petSprite["nameTxt"].text = petDefiniton.name;
            icon.x = 25;
            icon.y = 25;
            var _loc1_:DoorRewardVO = new DoorRewardVO();
            _loc1_.canvas = petSprite;
            _loc1_.icon = icon;
            _loc1_.reward = reward;
            _useRewardCanvas.push(_loc1_);
            if(_serverRewardList.length > 0)
            {
               addReward(_serverRewardList.shift());
            }
            else
            {
               start();
            }
         };
         petDefiniton = PetConfig.getPetDefinition(reward.rewardId);
         petDefiniton = PetUtil.getMinStatusPet(petDefiniton.bunchId);
         reward.rewardId = petDefiniton.resId;
         if(petDefiniton == null)
         {
            return;
         }
         url = URLUtil.getPetIcon(petDefiniton.resId);
         icon = new IconDisplayer();
         icon.setBoundary(100,100);
         icon.setIconUrl(url,onContentLoaded);
      }
      
      private function start() : void
      {
         this.layout();
         if(this._tweenIndex <= this._useRewardCanvas.length)
         {
            this._tweenIndex = this._useRewardCanvas.length - 1;
         }
         this.startSwitchPet(this._useRewardCanvas[this._tweenIndex].canvas.x,this._useRewardCanvas[this._tweenIndex].canvas.y);
      }
      
      private function startSwitchPet(param1:Number, param2:Number) : void
      {
         TweenLite.to(this._s0,0.5,{
            "x":param1,
            "y":param2,
            "onComplete":this.onTweenCompleteHandler
         });
      }
      
      private function onTweenCompleteHandler() : void
      {
         if(this._tweenIndex == this._useRewardCanvas.length - 1)
         {
            this.switchEnd();
         }
         else
         {
            ++this._tweenIndex;
            this.startSwitchPet(this._useRewardCanvas[this._tweenIndex].canvas.x,this._useRewardCanvas[this._tweenIndex].canvas.y);
         }
      }
      
      private function switchEnd() : void
      {
         var _loc1_:DoorRewardVO = this.findReward();
         if(_loc1_ != null)
         {
            TweenLite.to(this._s0,0.5,{
               "x":_loc1_.canvas.x,
               "y":_loc1_.canvas.y,
               "onComplete":this.onResultTweenCompleteHandler
            });
         }
         else
         {
            this.onResultTweenCompleteHandler();
         }
      }
      
      private function onResultTweenCompleteHandler() : void
      {
         if(this._enableBtn)
         {
            this._confirmBtn.visible = true;
            this._confirmBtn.mouseEnabled = true;
         }
         this.dispatchEvent(new Event("selectSwitchComplete"));
      }
      
      private function findReward() : DoorRewardVO
      {
         var _loc2_:DoorRewardVO = null;
         var _loc1_:DoorRewardVO = null;
         for each(_loc1_ in this._useRewardCanvas)
         {
            if(_loc1_.reward.rewardId == this._rewardId)
            {
               _loc2_ = _loc1_;
               break;
            }
         }
         return _loc2_;
      }
   }
}

