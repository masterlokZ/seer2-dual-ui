package com.taomee.seer2.app.arena.animation.imples
{
   import com.taomee.seer2.app.arena.animation.core.BaseAnimation;
   import com.taomee.seer2.app.arena.animation.event.ArenaAnimationEvent;
   import com.taomee.seer2.app.arena.resource.FightAnimationResourcePool;
   import com.taomee.seer2.core.effects.SoundEffects;
   import com.taomee.seer2.core.player.FighterMoviePlayer;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class CatchFighterSuccessAnimation extends BaseAnimation
   {
      
      private static const SUCCESS_RESOURCE_NAME:String = "UI_FightCatchSuccess";
      
      private static const EVT_SUCCEDD_FRAME_COUNTER:uint = 89;
      
      private var _onCatchSuccess:Function;
      
      private var _successAnimation:MovieClip;
      
      private var _timeOutIndex:uint;
      
      private var _moviePlayer:FighterMoviePlayer;
      
      public function CatchFighterSuccessAnimation()
      {
         super();
         this.initialize();
      }
      
      override public function initData(param1:Object) : void
      {
         this._onCatchSuccess = param1["onCatchSuccessFun"];
      }
      
      override public function initialize() : void
      {
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      override public function play() : void
      {
         if(this._successAnimation == null)
         {
            this._successAnimation = FightAnimationResourcePool.checkOutMC("UI_FightCatchSuccess");
            this._successAnimation.scaleX = -1;
            this._successAnimation.x = LayerManager.root.width - 50;
         }
         addChild(this._successAnimation);
         this._moviePlayer = new FighterMoviePlayer(this._successAnimation,this.onAnimationEnd,40);
         this._timeOutIndex = setTimeout(this.onSuccess,89 * 40);
      }
      
      private function onAnimationEnd() : void
      {
         DisplayObjectUtil.removeFromParent(this._successAnimation);
         dispatchEvent(new ArenaAnimationEvent("animationEnd"));
         SoundEffects.playFightSound("Sound_Catch_Win1");
      }
      
      private function onSuccess() : void
      {
         this._timeOutIndex = 0;
         if(this._onCatchSuccess != null)
         {
            this._onCatchSuccess();
            this._onCatchSuccess = null;
         }
      }
      
      override public function dispose() : void
      {
         if(this._timeOutIndex != 0)
         {
            clearTimeout(this._timeOutIndex);
         }
         if(this._moviePlayer != null)
         {
            this._moviePlayer.destroy();
            this._moviePlayer = null;
         }
         if(this._successAnimation != null)
         {
            this._successAnimation.scaleX = 1;
            DisplayObjectUtil.removeFromParent(this._successAnimation);
            FightAnimationResourcePool.checkInMC("UI_FightCatchSuccess",this._successAnimation);
            this._successAnimation = null;
         }
         this._onCatchSuccess = null;
         super.dispose();
      }
   }
}

