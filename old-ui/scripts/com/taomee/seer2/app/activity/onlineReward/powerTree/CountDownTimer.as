package com.taomee.seer2.app.activity.onlineReward.powerTree
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.manager.EventManager;
   
   public class CountDownTimer
   {
      
      public var _countdownTimer:Timer;
      
      private var _sec:int;
      
      private var TimerUI:MovieClip;
      
      private var light_mc:MovieClip;
      
      public function CountDownTimer(param1:MovieClip, param2:int)
      {
         super();
         this._sec = param2;
         this._countdownTimer = new Timer(1000,param2);
         this._countdownTimer.addEventListener("timer",this.countdownEvery);
         this._countdownTimer.addEventListener("timerComplete",this.countdownOver);
         this._countdownTimer.start();
      }
      
      private function countdownEvery(param1:TimerEvent) : void
      {
         var _loc3_:int = this._sec - this._countdownTimer.currentCount;
         var _loc5_:int = _loc3_ / 3600;
         var _loc4_:int = _loc3_ / 60;
         var _loc2_:int = _loc3_ % 60;
         if(_loc4_ >= 0 && _loc2_ >= 0)
         {
         }
         EventManager.dispatchEvent(new CountDownTimerEvent("TIMER_DOWN",_loc4_,_loc2_));
      }
      
      public function showscore(param1:MovieClip, param2:uint) : void
      {
         var _loc5_:Array = null;
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         while(_loc6_ < param1.numChildren)
         {
            param1["mc" + _loc6_].gotoAndStop(1);
            _loc6_++;
         }
         _loc5_ = param2.toString().split("");
         _loc5_ = _loc5_.reverse();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc3_ = uint(_loc5_[_loc4_]) + 1;
            param1["mc" + _loc4_].gotoAndStop(_loc3_);
            _loc4_++;
         }
      }
      
      private function countdownOver(param1:TimerEvent = null) : void
      {
         this._countdownTimer.removeEventListener("timer",this.countdownEvery);
         this._countdownTimer.removeEventListener("timerComplete",this.countdownOver);
         this._countdownTimer = null;
      }
      
      public function destroy() : void
      {
         this.TimerUI = null;
         this._countdownTimer.stop();
         this._countdownTimer.removeEventListener("timer",this.countdownEvery);
         this._countdownTimer.removeEventListener("timerComplete",this.countdownOver);
         this._countdownTimer = null;
      }
   }
}

