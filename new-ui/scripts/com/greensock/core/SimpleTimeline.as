package com.greensock.core
{
   public class SimpleTimeline extends TweenCore
   {
      
      public var autoRemoveChildren:Boolean;
      
      protected var _lastChild:TweenCore;
      
      protected var _firstChild:TweenCore;
      
      public function SimpleTimeline(param1:Object = null)
      {
         super(0,param1);
      }
      
      public function get rawTime() : Number
      {
         return this.cachedTotalTime;
      }
      
      public function insert(param1:TweenCore, param2:* = 0) : TweenCore
      {
         if(!param1.cachedOrphan && Boolean(param1.timeline))
         {
            param1.timeline.remove(param1,true);
         }
         param1.timeline = this;
         param1.cachedStartTime = Number(param2) + param1.delay;
         if(param1.gc)
         {
            param1.setEnabled(true,true);
         }
         if(param1.cachedPaused)
         {
            param1.cachedPauseTime = param1.cachedStartTime + (this.rawTime - param1.cachedStartTime) / param1.cachedTimeScale;
         }
         if(_lastChild)
         {
            _lastChild.nextNode = param1;
         }
         else
         {
            _firstChild = param1;
         }
         param1.prevNode = _lastChild;
         _lastChild = param1;
         param1.nextNode = null;
         param1.cachedOrphan = false;
         return param1;
      }
      
      override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc4_:TweenCore = null;
         var _loc6_:TweenCore = _firstChild;
         this.cachedTotalTime = param1;
         this.cachedTime = param1;
         while(_loc6_)
         {
            _loc4_ = _loc6_.nextNode;
            if(_loc6_.active || param1 >= _loc6_.cachedStartTime && !_loc6_.cachedPaused && !_loc6_.gc)
            {
               if(!_loc6_.cachedReversed)
               {
                  _loc6_.renderTime((param1 - _loc6_.cachedStartTime) * _loc6_.cachedTimeScale,param2,false);
               }
               else
               {
                  _loc5_ = _loc6_.cacheIsDirty ? _loc6_.totalDuration : _loc6_.cachedTotalDuration;
                  _loc6_.renderTime(_loc5_ - (param1 - _loc6_.cachedStartTime) * _loc6_.cachedTimeScale,param2,false);
               }
            }
            _loc6_ = _loc4_;
         }
      }
      
      public function remove(param1:TweenCore, param2:Boolean = false) : void
      {
         if(param1.cachedOrphan)
         {
            return;
         }
         if(!param2)
         {
            param1.setEnabled(false,true);
         }
         if(param1.nextNode)
         {
            param1.nextNode.prevNode = param1.prevNode;
         }
         else if(_lastChild == param1)
         {
            _lastChild = param1.prevNode;
         }
         if(param1.prevNode)
         {
            param1.prevNode.nextNode = param1.nextNode;
         }
         else if(_firstChild == param1)
         {
            _firstChild = param1.nextNode;
         }
         param1.cachedOrphan = true;
      }
   }
}

