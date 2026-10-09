package com.taomee.seer2.app.arena.animation.imples
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Expo;
   import com.taomee.seer2.app.arena.animation.core.BaseAnimation;
   import com.taomee.seer2.app.arena.animation.event.ArenaAnimationEvent;
   import com.taomee.seer2.app.arena.resource.FightAnimationResourcePool;
   import com.taomee.seer2.core.utils.NumberUtil;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class HpDecreaseAnimation extends BaseAnimation
   {
      
      private static const DIGIT_WIDTH:int = 30;
      
      private static const DIGIT_HEIGHT:int = 38;
      
      private static const DIGIT_VERTICAL_GAP:int = 2;
      
      private var _back:MovieClip;
      
      private var _digitSpriteVec:Vector.<MovieClip>;
      
      private var _digitResNameVec:Vector.<String>;
      
      private var _reducedHp:int;
      
      private var _initChangeHp:int;
      
      private var _fightSide:int;
      
      private var _isBaoJi:Boolean;
      
      private var _skillTypeRelation:uint;
      
      private var _isShowTip:Boolean;
      
      public function HpDecreaseAnimation()
      {
         super();
         this.initialize();
      }
      
      override public function initData(param1:Object) : void
      {
         this._reducedHp = param1["reducedHp"];
         this._initChangeHp = param1["initChangeHp"];
         this._fightSide = param1["fightSide"];
         this._isBaoJi = param1["isBaoJi"];
         this._skillTypeRelation = param1["skillTypeRelation"];
      }
      
      override public function initialize() : void
      {
         if(this._back == null)
         {
            this._back = FightAnimationResourcePool.checkOutMC("UI_FightSplash");
         }
         this._back.gotoAndStop(1);
         addChild(this._back);
      }
      
      override public function play() : void
      {
         var _loc2_:Number = NaN;
         this.y = 200;
         this.x = this._fightSide == 1 ? 200 : 760;
         var _loc5_:uint = 1;
         if(this._skillTypeRelation == 2)
         {
            _loc5_ = 2;
         }
         else if(this._skillTypeRelation == 1)
         {
            _loc5_ = 3;
         }
         this._back.gotoAndStop(_loc5_);
         this._digitSpriteVec = new Vector.<MovieClip>();
         this._digitResNameVec = new Vector.<String>();
         this.createHurtTip();
         this.createDigitSpriteVec();
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:Number = Math.random() * 100;
         if(this._fightSide == 1)
         {
            _loc2_ = 300;
            if(_loc6_ > 50 && _loc6_ < 80)
            {
               _loc2_ = 200;
            }
            else if(_loc6_ < 50)
            {
               _loc2_ = 350;
            }
            _loc4_ = _loc2_ + NumberUtil.getRandomInt(80);
            _loc7_ = 75 + NumberUtil.getRandomInt(40);
         }
         else
         {
            _loc2_ = 500;
            if(_loc6_ > 30 && _loc6_ < 60)
            {
               _loc2_ = 600;
            }
            else if(_loc6_ > 60 && _loc6_ < 80)
            {
               _loc2_ = 650;
            }
            else if(_loc6_ > 80)
            {
               _loc2_ = 450;
            }
            _loc4_ = _loc2_ + NumberUtil.getRandomInt(80);
            _loc7_ = 75 + NumberUtil.getRandomInt(40);
         }
         var _loc1_:uint = 2;
         var _loc3_:uint = 2;
         if(this._isBaoJi == true)
         {
            _loc1_ = _loc3_ = 3;
         }
         TweenLite.to(this,0.5,{
            "x":_loc4_,
            "y":_loc7_,
            "scaleX":_loc1_,
            "scaleY":_loc3_,
            "ease":Expo.easeOut,
            "onComplete":this.onAnimateComplete
         });
      }
      
      private function onAnimateComplete() : void
      {
         TweenLite.to(this,1,{
            "alpha":0,
            "ease":Expo.easeOut,
            "onComplete":this.onPlayComplete
         });
      }
      
      private function onPlayComplete() : void
      {
         dispatchEvent(new ArenaAnimationEvent("animationEnd"));
      }
      
      override public function dispose() : void
      {
         var _loc2_:int = 0;
         var _loc1_:uint = 0;
         TweenLite.killTweensOf(this);
         if(this._back != null)
         {
            FightAnimationResourcePool.checkInMC("UI_FightSplash",this._back);
            DisplayUtil.removeForParent(this._back);
            this._back = null;
         }
         if(this._digitSpriteVec != null)
         {
            _loc2_ = int(this._digitSpriteVec.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               FightAnimationResourcePool.checkInMC(this._digitResNameVec[_loc1_],this._digitSpriteVec[_loc1_]);
               DisplayUtil.removeForParent(this._digitSpriteVec[_loc1_]);
               _loc1_++;
            }
            this._digitSpriteVec = null;
         }
         this._digitResNameVec = null;
         super.dispose();
      }
      
      private function deployDigitSpriteVec() : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:int = int(this._digitSpriteVec.length);
         var _loc4_:int = _loc5_ * 30;
         var _loc7_:int = _loc5_ * 2 + 38;
         var _loc6_:int = 100 - _loc4_ >> 1;
         var _loc2_:int = 100 - _loc7_ >> 1;
         var _loc1_:int = 0;
         while(_loc1_ < _loc5_)
         {
            _loc3_ = this._digitSpriteVec[_loc1_];
            if(_loc1_ == 0 && this._isShowTip)
            {
               _loc3_.x = _loc6_ - 10;
               _loc3_.y = _loc2_ + 10;
            }
            else
            {
               _loc3_.x = _loc6_ + _loc1_ * 30;
               _loc3_.y = _loc2_ + _loc1_ * 2;
            }
            _loc1_++;
         }
      }
      
      private function createHurtTip() : void
      {
         var _loc2_:MovieClip = FightAnimationResourcePool.checkOutMC("UI_FightHurtTip");
         var _loc1_:int = 1;
         if(this._isBaoJi)
         {
            _loc1_ = 4;
         }
         else if(this._skillTypeRelation == 2)
         {
            _loc1_ = 2;
         }
         else if(this._skillTypeRelation == 1)
         {
            _loc1_ = 3;
         }
         if(_loc1_ == 1)
         {
            return;
         }
         this._isShowTip = true;
         _loc2_.gotoAndStop(_loc1_);
         _loc2_.x = -_loc2_.width;
         addChild(_loc2_);
         this._digitSpriteVec.push(_loc2_);
         this._digitResNameVec.push("UI_FightHurtTip");
      }
      
      private function createDigitSpriteVec(param1:uint = 1) : void
      {
         var _loc2_:MovieClip = null;
         var _loc4_:MovieClip = FightAnimationResourcePool.checkOutMC("UI_FightSplashMinus");
         _loc4_.gotoAndStop(param1);
         this._digitSpriteVec.push(_loc4_);
         this._digitResNameVec.push("UI_FightSplashMinus");
         addChild(_loc4_);
         var _loc6_:Vector.<int> = NumberUtil.parseNumberToDigitVec(this._reducedHp);
         var _loc5_:int = int(_loc6_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = FightAnimationResourcePool.checkOutMC("UI_FightSplash" + _loc6_[_loc3_]);
            _loc2_.gotoAndStop(param1);
            this._digitSpriteVec.push(_loc2_);
            this._digitResNameVec.push("UI_FightSplash" + _loc6_[_loc3_]);
            addChild(_loc2_);
            _loc3_++;
         }
         this.deployDigitSpriteVec();
      }
   }
}

