package com.taomee.seer2.app.arena.resource
{
   import com.taomee.seer2.app.arena.data.FighterInfo;
   import com.taomee.seer2.app.arena.ui.status.FightInfoRelation;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.app.config.FightLoadingTipConfig;
   import com.taomee.seer2.app.config.PetPressConfig;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.NumberUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.taomee.utils.Tick;
   
   public class ArenaLoadingBar extends Sprite
   {
      
      private var _isLoaded:Boolean;
      
      private var _loadingBar:MovieClip;
      
      private var _digitalVec:Vector.<MovieClip>;
      
      private var _infoHolder:MovieClip;
      
      private var _animation:MovieClip;
      
      private var _leftFighterNameTxt:TextField;
      
      private var _leftLevelTxt:TextField;
      
      private var _leftIconDisplayer:IconDisplayer;
      
      private var _leftPetTypeIcon:PetTypeIcon;
      
      private var _leftIconHolder:MovieClip;
      
      private var _rightFighterNameTxt:TextField;
      
      private var _rightLevelTxt:TextField;
      
      private var _rightIconDisplayer:IconDisplayer;
      
      private var _rightPetTypeIcon:PetTypeIcon;
      
      private var _rightIconHolder:MovieClip;
      
      private var _lHolder:MovieClip;
      
      private var _leftSubIconHolder:MovieClip;
      
      private var _leftSubIconDisplayer:IconDisplayer;
      
      private var _rHolder:MovieClip;
      
      private var _rightSubIconHolder:MovieClip;
      
      private var _rightSubIconDisplayer:IconDisplayer;
      
      private var _fightInfo:FightInfoRelation;
      
      private var _TipTxt:TextField;
      
      private var _format:TextFormat;
      
      private var _tipList:Array;
      
      private var _curIndex:int = -1;
      
      public function ArenaLoadingBar()
      {
         super();
         this.initialize();
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
         this._loadingBar = FightUIManager.getMovieClip("UI_FightLoading");
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
         this._TipTxt.selectable = false;
         this._TipTxt.wordWrap = true;
         this._TipTxt.multiline = true;
         this._TipTxt.x = 338;
         this._TipTxt.y = 56;
         this._TipTxt.width = 488;
         this._tipList = FightLoadingTipConfig.getTipList();
         this.updateTip(0);
         Tick.instance.addRender(this.updateTip,3000);
         addChild(this._TipTxt);
      }
      
      private function RGB(param1:uint, param2:uint, param3:uint) : uint
      {
         return param1 << 16 | param2 << 8 | param3;
      }
      
      private function updateTip(param1:Number) : void
      {
         var _loc2_:uint = 0;
         if(this._curIndex == -1)
         {
            _loc2_ = this._tipList.length * Math.random();
            this._curIndex = _loc2_;
            this.updateTxt();
         }
         else if(this._curIndex + 1 < this._tipList.length)
         {
            _loc2_ = this._curIndex + 1;
            this._curIndex = _loc2_;
            this.updateTxt();
         }
         else
         {
            _loc2_ = 0;
            this._curIndex = _loc2_;
            this.updateTxt();
         }
      }
      
      private function updateTxt() : void
      {
         this._format.color = this.RGB(255,uint(255 * Math.random()),uint(255 * Math.random()));
         this._format.color = 16777062;
         this._TipTxt.defaultTextFormat = this._format;
         this._TipTxt.htmlText = "<font color=\'#FFFF66\'>小贴士:</font>" + this._tipList[this._curIndex];
      }
      
      public function setLeftFighterInfo(param1:FighterInfo, param2:FighterInfo) : void
      {
         this._leftFighterNameTxt.text = param1.name;
         this._leftLevelTxt.text = param1.level.toString();
         if(this._leftIconDisplayer == null)
         {
            this._leftIconDisplayer = new IconDisplayer();
         }
         if(this._leftPetTypeIcon == null)
         {
            this._leftPetTypeIcon = new PetTypeIcon();
            this._leftPetTypeIcon.x = 60;
            this._leftPetTypeIcon.y = 65;
         }
         this.pushIcon(this._leftIconHolder,this._leftIconDisplayer,this._leftPetTypeIcon,param1,-5,-8);
         if(param2 != null)
         {
            this._lHolder.visible = true;
            if(this._leftSubIconDisplayer == null)
            {
               this._leftSubIconDisplayer = new IconDisplayer();
            }
            this.pushIcon(this._leftSubIconHolder,this._leftSubIconDisplayer,this._leftPetTypeIcon,param2,3,-8);
         }
         else
         {
            this._lHolder.visible = false;
         }
      }
      
      private function pushIcon(param1:MovieClip, param2:IconDisplayer, param3:PetTypeIcon, param4:FighterInfo, param5:int = 3, param6:int = -8) : void
      {
         var _loc8_:String = null;
         var _loc7_:uint = 0;
         var _loc9_:MovieClip = null;
         param2.x = param5;
         param2.y = 2;
         param2.scaleX = param2.scaleY = 1.5;
         param1.addChild(param2);
         param3.type = param4.typeId;
         param1.addChild(param3);
         var _loc10_:String = URLUtil.getPetIcon(param4.resourceId);
         param2.setIconUrl(_loc10_);
      }
      
      public function setRightFighterInfo(param1:FighterInfo, param2:FighterInfo) : void
      {
         this._rightFighterNameTxt.text = param1.name;
         this._rightLevelTxt.text = param1.level.toString();
         if(this._rightIconDisplayer == null)
         {
            this._rightIconDisplayer = new IconDisplayer();
         }
         if(this._rightPetTypeIcon == null)
         {
            this._rightPetTypeIcon = new PetTypeIcon();
            this._rightPetTypeIcon.x = 70;
            this._rightPetTypeIcon.y = 56;
         }
         this.pushIcon(this._rightIconHolder,this._rightIconDisplayer,this._rightPetTypeIcon,param1,8,8);
         if(param2 != null)
         {
            this._rHolder.visible = true;
            if(this._rightSubIconDisplayer == null)
            {
               this._rightSubIconDisplayer = new IconDisplayer();
            }
            this.pushIcon(this._rightSubIconHolder,this._rightSubIconDisplayer,this._rightPetTypeIcon,param2,3,8);
         }
         else
         {
            this._rHolder.visible = false;
         }
      }
      
      public function setFightPress(param1:FighterInfo, param2:FighterInfo, param3:FighterInfo, param4:FighterInfo) : void
      {
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         _loc6_ = PetPressConfig.getPressColor(param1.typeId,param3.typeId);
         if(_loc6_ > -1)
         {
         }
         if(param2 != null && param4 != null)
         {
            _loc5_ = PetPressConfig.getPressColor(param2.typeId,param4.typeId);
            if(_loc5_ > -1)
            {
            }
         }
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
         if(param1 == 100 && this._isLoaded == false)
         {
            this._isLoaded = true;
            this._animation.gotoAndPlay("vanish");
            this._infoHolder.visible = false;
         }
      }
      
      public function addFightInfoRelation(param1:int) : void
      {
         if(this._fightInfo == null)
         {
            this._fightInfo = new FightInfoRelation();
            this._fightInfo.x = 160;
            this._fightInfo.y = 70;
            this._fightInfo.showRelation(param1);
         }
         addChild(this._fightInfo);
      }
      
      public function dispose() : void
      {
         this._animation.gotoAndStop(this._animation.totalFrames);
         this._animation = null;
         if(this._leftIconDisplayer != null)
         {
            this._leftIconDisplayer.dispose();
            this._leftIconDisplayer = null;
         }
         if(this._leftSubIconDisplayer != null)
         {
            this._leftSubIconDisplayer.dispose();
            this._leftSubIconDisplayer = null;
         }
         if(this._rightIconDisplayer != null)
         {
            this._rightIconDisplayer.dispose();
            this._rightIconDisplayer = null;
         }
         if(this._rightSubIconDisplayer != null)
         {
            this._rightSubIconDisplayer.dispose();
            this._rightSubIconDisplayer = null;
         }
         this._loadingBar.gotoAndStop(2);
         DisplayObjectUtil.removeFromParent(this._loadingBar);
         this._loadingBar = null;
         Tick.instance.removeRender(this.updateTip);
         DisplayObjectUtil.removeFromParent(this._TipTxt);
         this._TipTxt = null;
         this._format = null;
         this._curIndex = -1;
         if(this._fightInfo)
         {
            this._fightInfo.dispose();
            this._fightInfo = null;
         }
      }
   }
}

