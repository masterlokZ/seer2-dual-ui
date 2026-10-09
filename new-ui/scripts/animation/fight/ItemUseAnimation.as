package animation.fight
{
   import animation.event.Events;
   import com.greensock.TweenLite;
   import com.greensock.easing.Expo;
   import data.location.FighterLocation;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import ui.splash.UI_FightAngerRecover;
   import ui.splash.UI_FightHpRecover;
   import ui.splash.UI_NumberAngerIncreaseN;
   import ui.splash.UI_NumberAngerIncreasePlus;
   import ui.splash.UI_NumberHpIncreaseN;
   import ui.splash.UI_NumberHpIncreasePlus;
   import utils.NumberUtil;
   import utils.Utils;
   import utils.an.DisplayObjectUtil;
   
   public class ItemUseAnimation extends Sprite
   {
      
      private var _digitSprite:Sprite;
      
      private var _animation:MovieClip;
      
      private var _numContainer:Sprite;
      
      private var _side:uint;
      
      private var _position:uint;
      
      private var _type:uint;
      
      private var _change:uint;
      
      public function ItemUseAnimation()
      {
         super();
         this.initialize();
      }
      
      public function initialize() : void
      {
         DisplayObjectUtil.disableSprite(this);
      }
      
      public function initData(param1:Object) : void
      {
         this._side = param1["side"];
         this._position = param1["position"];
         this._type = param1["type"];
         this._change = param1["change"];
      }
      
      public function play() : void
      {
         if(_type == 1)
         {
            this.playHpRecoverAnimation(_change);
         }
         else if(_type == 2)
         {
            this.playAngerRecoverAnimation(_change);
         }
      }
      
      public function dispose() : void
      {
         if(this._digitSprite != null)
         {
            TweenLite.killTweensOf(this._digitSprite);
         }
         if(this._animation != null)
         {
            DisplayObjectUtil.removeFromParent(this._animation);
            this._animation = null;
         }
      }
      
      private function playHpRecoverAnimation(param1:int) : void
      {
         if(this._animation == null)
         {
            this._animation = new UI_FightHpRecover();
            this._numContainer = new Sprite();
            addChild(this._numContainer);
         }
         this.deployAnimation(this._animation);
         addChild(this._animation);
         Utils.onComplete(this._animation,onAnimationEnd);
         this.createNumberSprites(param1,"UI_NumberHpIncrease");
      }
      
      private function playAngerRecoverAnimation(param1:int) : void
      {
         if(this._animation == null)
         {
            this._animation = new UI_FightAngerRecover();
         }
         if(this._numContainer == null)
         {
            this._numContainer = new Sprite();
            addChild(this._numContainer);
         }
         this.deployAnimation(this._animation);
         addChild(this._animation);
         Utils.onComplete(this._animation,onAnimationEnd);
         this.createNumberSprites(param1,"UI_NumberAngerIncrease");
      }
      
      private function onAnimationUpdate() : void
      {
         this.deployAnimation(this._animation);
      }
      
      private function onAnimationEnd() : void
      {
         DisplayObjectUtil.removeFromParent(this._animation);
         dispatchEvent(Events.animationEnd());
      }
      
      private function deployAnimation(param1:MovieClip) : void
      {
         var _loc2_:FighterLocation = FighterLocation.build(_side,1);
         if(_side == 2)
         {
            param1.x = 680;
         }
         else
         {
            param1.x = _loc2_.targetX;
         }
         param1.y = _loc2_.targetY;
         if(this._numContainer != null)
         {
            if(_side == 2)
            {
               this._numContainer.x = 1200 - _loc2_.targetX;
            }
            else
            {
               this._numContainer.x = _loc2_.targetX;
            }
            this._numContainer.y = _loc2_.targetY;
         }
      }
      
      private function createNumberSprites(param1:uint, param2:String) : void
      {
         this._digitSprite = this.createNumberSprite(param2,param1);
         this._numContainer.addChild(this._digitSprite);
         this.deployDigitSprite(this._digitSprite,this._side);
         var _loc3_:int = 150;
         TweenLite.to(this._digitSprite,2,{
            "y":_loc3_,
            "ease":Expo.easeOut,
            "onComplete":this.onAnimateComplete
         });
      }
      
      private function createNumberSprite(param1:String, param2:int) : Sprite
      {
         var _loc5_:Sprite = null;
         var _loc4_:* = undefined;
         var _loc8_:Class = null;
         var _loc3_:Sprite = null;
         var _loc10_:int = 25;
         var _loc9_:Sprite = new Sprite();
         if(_type == 1)
         {
            _loc5_ = new UI_NumberHpIncreasePlus();
         }
         else
         {
            _loc5_ = new UI_NumberAngerIncreasePlus();
         }
         _loc9_.addChild(_loc5_);
         _loc4_ = NumberUtil.parseNumberToDigitVec(param2);
         var _loc7_:int = int(_loc4_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc7_)
         {
            if(_type == 1)
            {
               _loc8_ = UI_NumberHpIncreaseN.find(_loc4_[_loc6_]);
            }
            else
            {
               _loc8_ = UI_NumberAngerIncreaseN.find(_loc4_[_loc6_]);
            }
            _loc3_ = new _loc8_();
            _loc3_.x = (_loc6_ + 1) * _loc10_;
            _loc9_.addChild(_loc3_);
            _loc6_++;
         }
         return _loc9_;
      }
      
      private function deployDigitSprite(param1:Sprite, param2:uint) : void
      {
         if(param2 == 1)
         {
            param1.x = 100;
            param1.y = 0;
         }
         else
         {
            param1.x = 760;
            param1.y = 0;
         }
      }
      
      private function onAnimateComplete() : void
      {
         TweenLite.to(this._digitSprite,2,{
            "alpha":0,
            "ease":Expo.easeOut,
            "onComplete":this.onPlayComplete
         });
      }
      
      private function onPlayComplete() : void
      {
         DisplayObjectUtil.removeFromParent(this._numContainer);
         DisplayObjectUtil.removeFromParent(this._digitSprite);
         this._digitSprite = null;
      }
   }
}

