package com.taomee.seer2.app.arena.animation
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.animation.core.IArenaAnimation;
   import com.taomee.seer2.app.arena.animation.event.ArenaAnimationEvent;
   import com.taomee.seer2.app.arena.animation.imples.*;
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.data.FighterBuffInfo;
   import com.taomee.seer2.app.arena.data.TurnResultInfo;
   import com.taomee.seer2.app.arena.newUI.toolbar.NewFightControlPanel;
   import com.taomee.seer2.app.arena.util.ArenaUtil;
   import com.taomee.seer2.app.arena.util.FightMode;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.taomee.ds.HashMap;
   
   public class ArenaAnimationManager
   {
      
      private static var _animationPool:HashMap;
      
      private static var _par:Sprite;
      
      private static var _waitingAnimation:IArenaAnimation;
      
      private static var _countDownAnimation:IArenaAnimation;
      
      private static var _indicatorAnimation:IndicatorAnimation;
      
      public static var showCountDownTime:int = 0;
      
      public static var forCheckStuck:int = -1;
      
      public function ArenaAnimationManager()
      {
         super();
      }
      
      public static function initAnimation() : void
      {
         _animationPool = new HashMap();
         _animationPool.add("com.taomee.seer2.app.arena.animation.BaoJiHitAnimation",BaoJiHitAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.CatchFighterFailAnimation",CatchFighterFailAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.CatchFighterSuccessAnimation",CatchFighterSuccessAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.CatchHintAnimation",CatchHintAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.ItemUseAnimation",ItemUseAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.KOAnimation",KOAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.PresentAnimation",PresentAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.FightAbsorbAnimation",FightAbsorbAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.FightCountDownAnimation",FightCountDownAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.FightMissAnimation",FightMissAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.HpDecreaseAnimation",HpDecreaseAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.HPIncreaseAnimation",HPIncreaseAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.PowSkillHitAnimation",PowSkillHitAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.PowSkillStartAnimation",PowSkillStartAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.FightWaitingAnimation",FightWaitingAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.imples.IndicatorAnimation",IndicatorAnimation);
         _animationPool.add("com.taomee.seer2.app.arena.animation.imples.BuffDisabledAnimation",BuffDisabledAnimation);
      }
      
      public static function addPar(param1:Sprite) : void
      {
         _par = param1;
      }
      
      public static function environmentFeedback(param1:Fighter, param2:MapModel, param3:Boolean) : void
      {
         var _loc6_:* = undefined;
         var _loc4_:int = 0;
         var _loc7_:uint = param1.fighterTurnResultInfo.skillId;
         var _loc5_:SkillInfo = param1.fighterInfo.getSkillInfo(_loc7_);
         if(param1.turnResultInfo.isCritical)
         {
            if(_loc5_.category == "物理" && !param3)
            {
               ArenaUtil.drift(param1.fighterSide,param2);
            }
         }
         _loc4_ = param1.turnResultInfo.changedHp;
         _loc6_ = _loc4_ / param1.fighterInfo.maxHp > 0.33;
         if(_loc6_ == true)
         {
            ArenaUtil.vibrate(param2);
         }
      }
      
      public static function showAtkeeHpReduceSplash(param1:Fighter, param2:TurnResultInfo, param3:Number = 1) : void
      {
         var _loc5_:int = 0;
         var _loc4_:HpDecreaseAnimation = null;
         var _loc6_:int = int(param1.fighterInfo.hp);
         _loc5_ = int(param2.changedHp * param3);
         if(_loc5_ > 0)
         {
            if(param1.x == 0)
            {
               _loc4_ = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.HpDecreaseAnimation",{
                  "reducedHp":_loc5_,
                  "initChangeHp":param2.changedHp,
                  "fighter":param1,
                  "fightSide":1,
                  "isBaoJi":param2.isCritical,
                  "skillTypeRelation":param2.skillTypeDelation
               }) as HpDecreaseAnimation;
            }
            else
            {
               _loc4_ = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.HpDecreaseAnimation",{
                  "reducedHp":_loc5_,
                  "initChangeHp":param2.changedHp,
                  "fighter":param1,
                  "fightSide":2,
                  "isBaoJi":param2.isCritical,
                  "skillTypeRelation":param2.skillTypeDelation
               }) as HpDecreaseAnimation;
            }
         }
         else if(_loc5_ == 0)
         {
            if(param2.atkTimes == 0)
            {
               if(param1.x == 0)
               {
                  ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.FightMissAnimation",{"side":1});
               }
               else
               {
                  ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.FightMissAnimation",{"side":2});
               }
            }
            else if(param1.x == 0)
            {
               ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.FightAbsorbAnimation",{"side":1});
            }
            else
            {
               ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.FightAbsorbAnimation",{"side":2});
            }
         }
      }
      
      public static function showBuffDisabledAnimation(param1:Vector.<FighterBuffInfo>, param2:int) : void
      {
         var _loc4_:BuffDisabledAnimation = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(BuffDisabledAnimation.BUFF_ID_LIST.indexOf(param1[_loc3_].buffId) != -1)
            {
               _loc4_ = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.imples.BuffDisabledAnimation",{
                  "buffId":param1[_loc3_].buffId,
                  "side":param2
               }) as BuffDisabledAnimation;
               TweenNano.delayedCall(_loc3_ * 0.5,_loc4_.play);
            }
            _loc3_++;
         }
      }
      
      public static function getAnimation(param1:String) : Class
      {
         if(_animationPool == null)
         {
            initAnimation();
         }
         return _animationPool.getValue(param1);
      }
      
      public static function createAnimation(param1:String, param2:Object = null, param3:Function = null, param4:Object = null) : IArenaAnimation
      {
         var _loc5_:IArenaAnimation = null;
         var _loc6_:Class = null;
         _loc6_ = getAnimation(param1);
         _loc5_ = new _loc6_();
         if(_loc5_ != null)
         {
            _loc5_.addEventListener("animationEnd",onAnimationEnd);
            _loc5_.initData(param2);
            _loc5_.onComplete = param3;
            _loc5_.completeParams = param4;
            _par.addChild(_loc5_ as DisplayObject);
            _loc5_.play();
            return _loc5_;
         }
         throw new Error("阿嗲你个娘列,没有这个动画的！！" + param1);
      }
      
      private static function onAnimationEnd(param1:ArenaAnimationEvent) : void
      {
         var _loc2_:IArenaAnimation = param1.currentTarget as IArenaAnimation;
         _loc2_.removeEventListener("animationEnd",onAnimationEnd);
         DisplayObjectUtil.removeFromParent(_loc2_ as DisplayObject);
         if(_loc2_.onComplete != null)
         {
            if(_loc2_.completeParams != null)
            {
               _loc2_.onComplete(_loc2_.completeParams);
            }
            else
            {
               _loc2_.onComplete();
            }
         }
         _loc2_.dispose();
      }
      
      public static function fighterPresentAnimation(param1:Fighter, param2:ArenaDataInfo, param3:Function, param4:Object = null) : void
      {
         var onFighterPresent:Function = null;
         var targetY:Number = NaN;
         var fighter:Fighter = param1;
         var arenaData:ArenaDataInfo = param2;
         var onAnimationEnd:Function = param3;
         var onAnimationEndParams:Object = param4;
         onFighterPresent = function():void
         {
            fighter.visible = true;
            fighter.playFighterSound();
         };
         var animation:PresentAnimation = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.PresentAnimation",{"onFighterPresentFun":onFighterPresent},onAnimationEnd,onAnimationEndParams) as PresentAnimation;
         if(arenaData.isDoubleMode)
         {
            if(fighter.fighterInfo.position == 2)
            {
               animation.scaleX = animation.scaleY = Fighter.FIX_SCALE;
               animation.x = (1 - Fighter.FIX_SCALE) * LayerManager.root.width / 2;
               targetY = (1 - Fighter.FIX_SCALE) * LayerManager.root.height / 2;
               targetY += Fighter.SUB_FIGHTER_Y * Fighter.FIX_SCALE;
               animation.y = targetY;
            }
            else
            {
               animation.y = Fighter.MAIN_FIGHTER_Y;
            }
         }
      }
      
      public static function showWaiting(param1:uint) : void
      {
         if(_waitingAnimation != null)
         {
            hideWaiting();
         }
         if(FightMode.isPVPMode(param1))
         {
            _waitingAnimation = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.FightWaitingAnimation");
         }
      }
      
      public static function hideWaiting() : void
      {
         if(_waitingAnimation != null)
         {
            _waitingAnimation.dispose();
            _waitingAnimation = null;
         }
      }
      
      public static function showCountDown(param1:uint, param2:*) : void
      {
         var onCountDownEnd:Function = null;
         var controlPanel:* = param2;
         showCountDownTime++;
         onCountDownEnd = function():void
         {
            if(FightMode.isPVPMode(param1) && forCheckStuck == showCountDownTime - 1)
            {
               controlPanel.runOp();
               return;
            }
            forCheckStuck = showCountDownTime;
            controlPanel.automate();
         };
         abortCountDown();
         _countDownAnimation = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.FightCountDownAnimation",null,onCountDownEnd);
      }
      
      public static function showCountDownNew(param1:uint, param2:NewFightControlPanel) : void
      {
         var onCountDownEnd:Function = null;
         var fightMode:uint = param1;
         var controlPanel:NewFightControlPanel = param2;
         onCountDownEnd = function():void
         {
            controlPanel.automate();
         };
         abortCountDown();
         _countDownAnimation = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.FightCountDownAnimation",null,onCountDownEnd);
      }
      
      public static function abortCountDown() : void
      {
         if(_countDownAnimation != null)
         {
            _countDownAnimation.dispose();
            _countDownAnimation = null;
         }
      }
      
      public static function showIndiator(param1:Fighter) : void
      {
         hideIndiator();
         _indicatorAnimation = ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.imples.IndicatorAnimation") as IndicatorAnimation;
         _indicatorAnimation.x = param1.x + 200 * param1.scaleX;
         _indicatorAnimation.y = param1.y + 80 * param1.scaleY;
      }
      
      public static function hideIndiator() : void
      {
         if(_indicatorAnimation != null)
         {
            _indicatorAnimation.stopPlay();
            _indicatorAnimation = null;
         }
      }
   }
}

