package animation.loading
{
   import animation.common.IconDisplay;
   import animation.common.PetIconDisplay;
   import data.pet.PetData;
   import data.pet.TeamData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import ui.splash.UI_FightLoading;
   import ui.splash.UI_FightLoading_An;
   import utils.NumberUtil;
   import utils.an.DisplayObjectUtil;
   
   public class ArenaLoadingBar extends Sprite
   {
      
      private var _isLoaded:Boolean;
      
      private var _loadingBar:MovieClip;
      
      private var _digitalVec:Vector.<MovieClip>;
      
      private var _infoHolder:MovieClip;
      
      private var _animation:UI_FightLoading_An;
      
      private var _leftFighterNameTxt:TextField;
      
      private var _leftLevelTxt:TextField;
      
      private var _leftIconDisplayer:PetIconDisplay;
      
      private var _leftPetTypeIcon:IconDisplay;
      
      private var _leftIconHolder:MovieClip;
      
      private var _rightFighterNameTxt:TextField;
      
      private var _rightLevelTxt:TextField;
      
      private var _rightIconDisplayer:PetIconDisplay;
      
      private var _rightPetTypeIcon:IconDisplay;
      
      private var _rightIconHolder:MovieClip;
      
      private var _lHolder:MovieClip;
      
      private var _leftSubIconHolder:MovieClip;
      
      private var _leftSubIconDisplayer:IconDisplay;
      
      private var _rHolder:MovieClip;
      
      private var _rightSubIconHolder:MovieClip;
      
      private var _rightSubIconDisplayer:IconDisplay;
      
      private var _TipTxt:TextField;
      
      private var _format:TextFormat;
      
      private var _tipList:Vector.<String>;
      
      private var _tipInterval:int;
      
      private var _curIndex:int = -1;
      
      public function ArenaLoadingBar()
      {
         super();
         this.initialize();
      }
      
      public function initData(param1:TeamData, param2:TeamData, param3:Vector.<String>) : void
      {
         this.setLeftFighterInfo(param1.master,param1.slave ? param1.slave : null);
         this.setRightFighterInfo(param2.master,param2.slave ? param2.slave : null);
         this.setFightPress(param1.master,param1.slave ? param1.slave : null,param2.master,param2.slave ? param2.slave : null);
         this._tipList = param3;
         this._curIndex = -1;
         this.updateTip();
      }
      
      private function initialize() : void
      {
         DisplayObjectUtil.disableSprite(this);
         this._isLoaded = false;
         this.createChildren();
         this.addAnimationEventListener();
      }
      
      private function createChildren() : void
      {
         this._loadingBar = new UI_FightLoading();
         this._animation = this._loadingBar["animation"];
         this._infoHolder = this._loadingBar["fighterInfoHolder"];
         this._infoHolder.visible = false;
         this._digitalVec = Vector.<MovieClip>([this._loadingBar["digital0"],this._loadingBar["digital1"],this._loadingBar["digital2"]]);
         this._leftFighterNameTxt = this._infoHolder["leftNameTxt"];
         this._rightFighterNameTxt = this._infoHolder["rightNameTxt"];
         this._leftLevelTxt = this._infoHolder["leftLevelTxt"];
         this._rightLevelTxt = this._infoHolder["rightLevelTxt"];
         this._leftIconHolder = this._infoHolder["leftIconHolder"];
         this._rightSubIconHolder = this._infoHolder["rightSubIconHolder"];
         this._rightIconHolder = this._infoHolder["rightIconHolder"];
         this._leftSubIconHolder = this._infoHolder["leftSubIconHolder"];
         this._rightIconHolder.scaleX = -1;
         this._rightSubIconHolder.scaleX = -1;
         this._lHolder = this._infoHolder["lHolder"];
         this._rHolder = this._infoHolder["rHolder"];
         addChild(this._loadingBar);
         this.updateDigitalVec(this._digitalVec,0);
         this._TipTxt = new TextField();
         this._format = new TextFormat("_sans");
         this._format.size = 14;
         this._format.align = "center";
         this._TipTxt.defaultTextFormat = this._format;
         this._TipTxt.selectable = true;
         this._TipTxt.wordWrap = true;
         this._TipTxt.multiline = true;
         this._TipTxt.x = 338;
         this._TipTxt.y = 56;
         this._TipTxt.width = 488;
         this._tipList = new Vector.<String>();
         this.updateTip();
         this._tipInterval = setInterval(updateTip,3000);
         addChild(this._TipTxt);
      }
      
      private function RGB(param1:uint, param2:uint, param3:uint) : uint
      {
         return param1 << 16 | param2 << 8 | param3;
      }
      
      private function updateTip() : void
      {
         var _loc1_:uint = 0;
         if(this._curIndex == -1)
         {
            _loc1_ = this._tipList.length * Math.random();
            this._curIndex = _loc1_;
            this.updateTxt();
         }
         else if(this._curIndex + 1 < this._tipList.length)
         {
            _loc1_ = this._curIndex + 1;
            this._curIndex = _loc1_;
            this.updateTxt();
         }
         else
         {
            _loc1_ = 0;
            this._curIndex = _loc1_;
            this.updateTxt();
         }
      }
      
      private function updateTxt() : void
      {
         var _loc1_:* = undefined;
         this._format.color = this.RGB(255,uint(255 * Math.random()),uint(255 * Math.random()));
         this._format.color = 16777062;
         this._TipTxt.defaultTextFormat = this._format;
         if(_curIndex >= _tipList.length)
         {
            this._TipTxt.htmlText = "<a href=\'https://github.com/arcadia-star/seer2-fight-ui\' target=\'_blank\'>https://github.com/arcadia-star/seer2-fight-ui</a>";
         }
         else
         {
            _loc1_ = this._tipList[this._curIndex];
            this._TipTxt.htmlText = "<font color=\'#FFFF66\'>小贴士:</font>" + _loc1_;
         }
      }
      
      private function setLeftFighterInfo(param1:PetData, param2:PetData) : void
      {
         this._leftFighterNameTxt.text = param1.name;
         this._leftLevelTxt.text = param1.level.toString();
         if(this._leftIconDisplayer == null)
         {
            this._leftIconDisplayer = new PetIconDisplay();
         }
         if(this._leftPetTypeIcon == null)
         {
            this._leftPetTypeIcon = new IconDisplay();
            this._leftPetTypeIcon.x = 60;
            this._leftPetTypeIcon.y = 65;
         }
         this.pushIcon(this._leftIconHolder,this._leftIconDisplayer,this._leftPetTypeIcon,param1,-5,-8);
         if(param2 != null)
         {
            this._lHolder.visible = true;
            if(this._leftSubIconDisplayer == null)
            {
               this._leftSubIconDisplayer = new IconDisplay();
            }
            this.pushIcon(this._leftSubIconHolder,this._leftSubIconDisplayer,this._leftPetTypeIcon,param2,3,-8);
         }
         else
         {
            this._lHolder.visible = false;
         }
      }
      
      private function pushIcon(param1:MovieClip, param2:IconDisplay, param3:IconDisplay, param4:PetData, param5:int = 3, param6:int = -8) : void
      {
         param2.x = param5;
         param2.y = 2;
         param2.scaleX = param2.scaleY = 1.5;
         param1.addChild(param2);
         param3.initData(param4.typeIcon);
         param1.addChild(param3);
         param2.initData(param4.petIcon);
      }
      
      private function setRightFighterInfo(param1:PetData, param2:PetData) : void
      {
         this._rightFighterNameTxt.text = param1.name;
         this._rightLevelTxt.text = param1.level.toString();
         if(this._rightIconDisplayer == null)
         {
            this._rightIconDisplayer = new PetIconDisplay();
         }
         if(this._rightPetTypeIcon == null)
         {
            this._rightPetTypeIcon = new IconDisplay();
            this._rightPetTypeIcon.x = 70;
            this._rightPetTypeIcon.y = 56;
         }
         this.pushIcon(this._rightIconHolder,this._rightIconDisplayer,this._rightPetTypeIcon,param1,8,8);
         if(param2 != null)
         {
            this._rHolder.visible = true;
            if(this._rightSubIconDisplayer == null)
            {
               this._rightSubIconDisplayer = new IconDisplay();
            }
            this.pushIcon(this._rightSubIconHolder,this._rightSubIconDisplayer,this._rightPetTypeIcon,param2,3,8);
         }
         else
         {
            this._rHolder.visible = false;
         }
      }
      
      private function setFightPress(param1:PetData, param2:PetData, param3:PetData, param4:PetData) : void
      {
      }
      
      private function createShape(param1:int, param2:MovieClip) : void
      {
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(param1);
         _loc3_.graphics.drawRect(2,2,param2.width - 2,param2.height - 2);
         _loc3_.filters = [new BlurFilter()];
         _loc3_.graphics.endFill();
         param2.addChildAt(_loc3_,param2.numChildren - 1);
      }
      
      private function addAnimationEventListener() : void
      {
         this._animation.addEventListener("enterFrame",this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._animation.currentFrame == this._animation.totalFrames)
         {
            this._animation.removeEventListener("enterFrame",this.onEnterFrame);
            dispatchEvent(new Event("close"));
         }
         else if(this._animation.currentFrame == 40)
         {
            this._infoHolder.visible = true;
         }
      }
      
      private function updateDigitalVec(param1:Vector.<MovieClip>, param2:int) : void
      {
         var _loc6_:* = undefined;
         var _loc5_:MovieClip = null;
         var _loc7_:int = int(param1.length);
         _loc6_ = NumberUtil.parseNumberToDigitVec(param2);
         var _loc4_:int = _loc6_.length - 1;
         var _loc3_:int = _loc7_ - 1;
         while(_loc3_ >= 0)
         {
            _loc5_ = param1[_loc3_];
            _loc5_.gotoAndStop(1);
            _loc5_.visible = false;
            if(_loc4_ >= 0)
            {
               _loc5_.gotoAndStop(_loc6_[_loc4_] + 1);
               _loc5_.visible = true;
               _loc4_--;
            }
            _loc3_--;
         }
      }
      
      public function updateProgress(param1:int) : void
      {
         this.updateDigitalVec(this._digitalVec,param1);
         if(param1 == 100 && !this._isLoaded)
         {
            this._isLoaded = true;
            this._animation.gotoAndPlay("vanish");
            this._infoHolder.visible = false;
         }
      }
      
      public function dispose() : void
      {
         DisplayObjectUtil.removeFromParent(this);
         clearInterval(_tipInterval);
      }
   }
}

