package com.greensock
{
   import com.greensock.core.*;
   import com.greensock.events.TweenEvent;
   import com.greensock.plugins.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TweenMax extends TweenLite implements IEventDispatcher
   {
      
      public static const version:Number = 11.66;
      
      private static var _overwriteMode:int = OverwriteManager.enabled ? OverwriteManager.mode : OverwriteManager.init(2);
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      TweenPlugin.activate([AutoAlphaPlugin,EndArrayPlugin,FramePlugin,RemoveTintPlugin,TintPlugin,VisiblePlugin,VolumePlugin,BevelFilterPlugin,BezierPlugin,BezierThroughPlugin,BlurFilterPlugin,ColorMatrixFilterPlugin,ColorTransformPlugin,DropShadowFilterPlugin,FrameLabelPlugin,GlowFilterPlugin,HexColorsPlugin,RoundPropsPlugin,ShortRotationPlugin,{}]);
      
      protected var _cyclesComplete:int = 0;
      
      protected var _dispatcher:EventDispatcher;
      
      protected var _hasUpdateListener:Boolean;
      
      protected var _easeType:int;
      
      protected var _repeatDelay:Number = 0;
      
      public var yoyo:Boolean;
      
      protected var _easePower:int;
      
      protected var _repeat:int = 0;
      
      public function TweenMax(param1:Object, param2:Number, param3:Object)
      {
         super(param1,param2,param3);
         if(false)
         {
            throw new Error("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com.");
         }
         this.yoyo = Boolean(this.vars.yoyo);
         _repeat = uint(this.vars.repeat);
         _repeatDelay = this.vars.repeatDelay ? Number(this.vars.repeatDelay) : 0;
         this.cacheIsDirty = true;
         if(Boolean(this.vars.onCompleteListener) || Boolean(this.vars.onInitListener) || Boolean(this.vars.onUpdateListener) || Boolean(this.vars.onStartListener) || Boolean(this.vars.onRepeatListener) || Boolean(this.vars.onReverseCompleteListener))
         {
            initDispatcher();
            if(param2 == 0 && _delay == 0)
            {
               _dispatcher.dispatchEvent(new TweenEvent("change"));
               _dispatcher.dispatchEvent(new TweenEvent("complete"));
            }
         }
         if(Boolean(this.vars.timeScale) && !(this.target is TweenCore))
         {
            this.cachedTimeScale = this.vars.timeScale;
         }
      }
      
      public static function set globalTimeScale(param1:Number) : void
      {
         if(param1 == 0)
         {
            param1 = 0.0001;
         }
         if(TweenLite.rootTimeline == null)
         {
            TweenLite.to({},0,{});
         }
         var _loc2_:SimpleTimeline = TweenLite.rootTimeline;
         var _loc3_:Number = getTimer() * 0.001;
         _loc2_.cachedStartTime = _loc3_ - (_loc3_ - _loc2_.cachedStartTime) * _loc2_.cachedTimeScale / param1;
         _loc2_ = TweenLite.rootFramesTimeline;
         _loc3_ = TweenLite.rootFrame;
         _loc2_.cachedStartTime = _loc3_ - (_loc3_ - _loc2_.cachedStartTime) * _loc2_.cachedTimeScale / param1;
         TweenLite.rootFramesTimeline.cachedTimeScale = TweenLite.rootTimeline.cachedTimeScale = param1;
      }
      
      public static function fromTo(param1:Object, param2:Number, param3:Object, param4:Object) : TweenMax
      {
         param4.startAt = param3;
         if(param3.immediateRender)
         {
            param4.immediateRender = true;
         }
         return new TweenMax(param1,param2,param4);
      }
      
      public static function allFromTo(param1:Array, param2:Number, param3:Object, param4:Object, param5:Number = 0, param6:Function = null, param7:Array = null) : Array
      {
         param4.startAt = param3;
         if(param3.immediateRender)
         {
            param4.immediateRender = true;
         }
         return allTo(param1,param2,param4,param5,param6,param7);
      }
      
      public static function pauseAll(param1:Boolean = true, param2:Boolean = true) : void
      {
         changePause(true,param1,param2);
      }
      
      public static function getTweensOf(param1:Object) : Array
      {
         var _loc2_:* = undefined;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = masterList[param1];
         var _loc6_:Array = [];
         if(_loc4_)
         {
            _loc5_ = int(_loc4_.length);
            _loc3_ = 0;
            while(--_loc5_ > -1)
            {
               if(!TweenLite(_loc4_[_loc5_]).gc)
               {
                  _loc6_[_loc2_ = _loc3_++] = _loc4_[_loc5_];
               }
            }
         }
         return _loc6_;
      }
      
      public static function get globalTimeScale() : Number
      {
         return TweenLite.rootTimeline == null ? 1 : TweenLite.rootTimeline.cachedTimeScale;
      }
      
      public static function killChildTweensOf(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         var _loc5_:Object = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc6_:Array = getAllTweens();
         var _loc3_:int = int(_loc6_.length);
         while(--_loc3_ > -1)
         {
            _loc5_ = _loc6_[_loc3_].target;
            if(_loc5_ is DisplayObject)
            {
               _loc4_ = _loc5_.parent;
               while(_loc4_)
               {
                  if(_loc4_ == param1)
                  {
                     if(param2)
                     {
                        _loc6_[_loc3_].complete(false);
                     }
                     else
                     {
                        _loc6_[_loc3_].setEnabled(false,false);
                     }
                  }
                  _loc4_ = _loc4_.parent;
               }
            }
         }
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null, param4:Boolean = false) : TweenMax
      {
         return new TweenMax(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "immediateRender":false,
            "useFrames":param4,
            "overwrite":0
         });
      }
      
      public static function isTweening(param1:Object) : Boolean
      {
         var _loc3_:TweenLite = null;
         var _loc2_:Array = getTweensOf(param1);
         var _loc4_:int = int(_loc2_.length);
         while(--_loc4_ > -1)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_.active || _loc3_.cachedStartTime == _loc3_.timeline.cachedTime && _loc3_.timeline.active)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function killAll(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc6_:Array = null;
         var _loc5_:Boolean = false;
         _loc6_ = getAllTweens();
         var _loc4_:int = int(_loc6_.length);
         while(--_loc4_ > -1)
         {
            _loc5_ = _loc6_[_loc4_].target == _loc6_[_loc4_].vars.onComplete;
            if(_loc5_ == param3 || _loc5_ != param2)
            {
               if(param1)
               {
                  _loc6_[_loc4_].complete(false);
               }
               else
               {
                  _loc6_[_loc4_].setEnabled(false,false);
               }
            }
         }
      }
      
      private static function changePause(param1:Boolean, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc6_:Array = null;
         var _loc5_:Boolean = false;
         _loc6_ = getAllTweens();
         var _loc4_:int = int(_loc6_.length);
         while(--_loc4_ > -1)
         {
            _loc5_ = TweenLite(_loc6_[_loc4_]).target == TweenLite(_loc6_[_loc4_]).vars.onComplete;
            if(_loc5_ == param3 || _loc5_ != param2)
            {
               TweenCore(_loc6_[_loc4_]).paused = param1;
            }
         }
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenMax
      {
         param3.runBackwards = true;
         if(!("immediateRender" in param3))
         {
            param3.immediateRender = true;
         }
         return new TweenMax(param1,param2,param3);
      }
      
      public static function allFrom(param1:Array, param2:Number, param3:Object, param4:Number = 0, param5:Function = null, param6:Array = null) : Array
      {
         param3.runBackwards = true;
         if(!("immediateRender" in param3))
         {
            param3.immediateRender = true;
         }
         return allTo(param1,param2,param3,param4,param5,param6);
      }
      
      public static function getAllTweens() : Array
      {
         var _loc2_:* = undefined;
         var _loc5_:Array = null;
         var _loc1_:int = 0;
         var _loc4_:Dictionary = masterList;
         var _loc3_:int = 0;
         var _loc6_:Array = [];
         for each(_loc5_ in _loc4_)
         {
            _loc1_ = int(_loc5_.length);
            while(--_loc1_ > -1)
            {
               if(!TweenLite(_loc5_[_loc1_]).gc)
               {
                  _loc6_[_loc2_ = _loc3_++] = _loc5_[_loc1_];
               }
            }
         }
         return _loc6_;
      }
      
      public static function resumeAll(param1:Boolean = true, param2:Boolean = true) : void
      {
         changePause(false,param1,param2);
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenMax
      {
         return new TweenMax(param1,param2,param3);
      }
      
      public static function allTo(param1:Array, param2:Number, param3:Object, param4:Number = 0, param5:Function = null, param6:Array = null) : Array
      {
         var i:int = 0;
         var varsDup:Object = null;
         var p:String = null;
         var onCompleteProxy:Function = null;
         var onCompleteParamsProxy:Array = null;
         var targets:Array = param1;
         var duration:Number = param2;
         var vars:Object = param3;
         var stagger:Number = param4;
         var onCompleteAll:Function = param5;
         var onCompleteAllParams:Array = param6;
         var l:int = int(targets.length);
         var a:Array = [];
         var curDelay:Number = "delay" in vars ? Number(vars.delay) : 0;
         onCompleteProxy = vars.onComplete;
         onCompleteParamsProxy = vars.onCompleteParams;
         var lastIndex:int = l - 1;
         i = 0;
         while(i < l)
         {
            varsDup = {};
            for(p in vars)
            {
               varsDup[p] = vars[p];
            }
            varsDup.delay = curDelay;
            if(i == lastIndex && onCompleteAll != null)
            {
               varsDup.onComplete = function():void
               {
                  if(onCompleteProxy != null)
                  {
                     onCompleteProxy.apply(null,onCompleteParamsProxy);
                  }
                  onCompleteAll.apply(null,onCompleteAllParams);
               };
            }
            a[i] = new TweenMax(targets[i],duration,varsDup);
            curDelay += stagger;
            i += 1;
         }
         return a;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _dispatcher == null ? false : _dispatcher.dispatchEvent(param1);
      }
      
      public function set timeScale(param1:Number) : void
      {
         if(param1 == 0)
         {
            param1 = 0.0001;
         }
         var _loc2_:Number = Boolean(this.cachedPauseTime) || this.cachedPauseTime == 0 ? this.cachedPauseTime : this.timeline.cachedTotalTime;
         this.cachedStartTime = _loc2_ - (_loc2_ - this.cachedStartTime) * this.cachedTimeScale / param1;
         this.cachedTimeScale = param1;
         setDirtyCache(false);
      }
      
      override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc9_:Number = this.cacheIsDirty ? this.totalDuration : this.cachedTotalDuration;
         var _loc6_:Number = this.cachedTotalTime;
         if(param1 >= _loc9_)
         {
            this.cachedTotalTime = _loc9_;
            this.cachedTime = this.cachedDuration;
            this.ratio = 1;
            _loc5_ = true;
            if(this.cachedDuration == 0)
            {
               if((param1 == 0 || _rawPrevTime < 0) && _rawPrevTime != param1)
               {
                  param3 = true;
               }
               _rawPrevTime = param1;
            }
         }
         else if(param1 <= 0)
         {
            if(param1 < 0)
            {
               this.active = false;
               if(this.cachedDuration == 0)
               {
                  if(_rawPrevTime >= 0)
                  {
                     param3 = true;
                     _loc5_ = true;
                  }
                  _rawPrevTime = param1;
               }
            }
            else if(param1 == 0 && !this.initted)
            {
               param3 = true;
            }
            this.cachedTotalTime = this.cachedTime = this.ratio = 0;
            if(this.cachedReversed && _loc6_ != 0)
            {
               _loc5_ = true;
            }
         }
         else
         {
            this.cachedTotalTime = this.cachedTime = param1;
            _loc7_ = true;
         }
         if(_repeat != 0)
         {
            _loc12_ = this.cachedDuration + _repeatDelay;
            _loc13_ = _cyclesComplete;
            _cyclesComplete = this.cachedTotalTime / _loc12_ >> 0;
            if(_cyclesComplete == this.cachedTotalTime / _loc12_)
            {
               --_cyclesComplete;
            }
            if(_loc13_ != _cyclesComplete)
            {
               _loc8_ = true;
            }
            if(_loc5_)
            {
               if(this.yoyo && Boolean(_repeat % 2))
               {
                  this.cachedTime = this.ratio = 0;
               }
            }
            else if(param1 > 0)
            {
               this.cachedTime = (this.cachedTotalTime / _loc12_ - _cyclesComplete) * _loc12_;
               if(this.yoyo && Boolean(_cyclesComplete % 2))
               {
                  this.cachedTime = this.cachedDuration - this.cachedTime;
               }
               else if(this.cachedTime >= this.cachedDuration)
               {
                  this.cachedTime = this.cachedDuration;
                  this.ratio = 1;
                  _loc7_ = false;
               }
               if(this.cachedTime <= 0)
               {
                  this.cachedTime = this.ratio = 0;
                  _loc7_ = false;
               }
            }
            else
            {
               _cyclesComplete = 0;
            }
         }
         if(_loc6_ == this.cachedTotalTime && !param3)
         {
            return;
         }
         if(!this.initted)
         {
            init();
         }
         if(!this.active && !this.cachedPaused)
         {
            this.active = true;
         }
         if(_loc7_)
         {
            if(_easeType)
            {
               _loc10_ = _easePower;
               _loc11_ = this.cachedTime / this.cachedDuration;
               if(_easeType == 2)
               {
                  this.ratio = _loc11_ = 1 - _loc11_;
                  while(--_loc10_ > -1)
                  {
                     this.ratio = _loc11_ * this.ratio;
                  }
                  this.ratio = 1 - this.ratio;
               }
               else if(_easeType == 1)
               {
                  this.ratio = _loc11_;
                  while(--_loc10_ > -1)
                  {
                     this.ratio = _loc11_ * this.ratio;
                  }
               }
               else if(_loc11_ < 0.5)
               {
                  this.ratio = _loc11_ *= 2;
                  while(--_loc10_ > -1)
                  {
                     this.ratio = _loc11_ * this.ratio;
                  }
                  this.ratio *= 0.5;
               }
               else
               {
                  this.ratio = _loc11_ = (1 - _loc11_) * 2;
                  while(--_loc10_ > -1)
                  {
                     this.ratio = _loc11_ * this.ratio;
                  }
                  this.ratio = 1 - 0.5 * this.ratio;
               }
            }
            else
            {
               this.ratio = _ease(this.cachedTime,0,1,this.cachedDuration);
            }
         }
         if(_loc6_ == 0 && (this.cachedTotalTime != 0 || this.cachedDuration == 0) && !param2)
         {
            if(this.vars.onStart)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(_dispatcher)
            {
               _dispatcher.dispatchEvent(new TweenEvent("start"));
            }
         }
         var _loc4_:PropTween = this.cachedPT1;
         while(_loc4_)
         {
            _loc4_.target[_loc4_.property] = _loc4_.start + this.ratio * _loc4_.change;
            _loc4_ = _loc4_.nextNode;
         }
         if(_hasUpdate && !param2)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_hasUpdateListener && !param2)
         {
            _dispatcher.dispatchEvent(new TweenEvent("change"));
         }
         if(_loc8_ && !param2 && !this.gc)
         {
            if(this.vars.onRepeat)
            {
               this.vars.onRepeat.apply(null,this.vars.onRepeatParams);
            }
            if(_dispatcher)
            {
               _dispatcher.dispatchEvent(new TweenEvent("repeat"));
            }
         }
         if(_loc5_ && !this.gc)
         {
            if(_hasPlugins && Boolean(this.cachedPT1))
            {
               onPluginEvent("onComplete",this);
            }
            complete(true,param2);
         }
      }
      
      override public function set totalDuration(param1:Number) : void
      {
         if(_repeat == -1)
         {
            return;
         }
         this.duration = (param1 - _repeat * _repeatDelay) / (_repeat + 1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(_dispatcher == null)
         {
            initDispatcher();
         }
         if(param1 == "change")
         {
            _hasUpdateListener = true;
         }
         _dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      override protected function init() : void
      {
         var _loc1_:TweenMax = null;
         if(this.vars.startAt)
         {
            this.vars.startAt.overwrite = 0;
            this.vars.startAt.immediateRender = true;
            _loc1_ = new TweenMax(this.target,0,this.vars.startAt);
         }
         if(_dispatcher)
         {
            _dispatcher.dispatchEvent(new TweenEvent("init"));
         }
         super.init();
         if(_ease in fastEaseLookup)
         {
            _easeType = fastEaseLookup[_ease][0];
            _easePower = fastEaseLookup[_ease][1];
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(_dispatcher)
         {
            _dispatcher.removeEventListener(param1,param2,param3);
         }
      }
      
      public function setDestination(param1:String, param2:*, param3:Boolean = true) : void
      {
         var _loc4_:Object = null;
         _loc4_ = {};
         _loc4_[param1] = param2;
         updateTo(_loc4_,!param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _dispatcher == null ? false : _dispatcher.willTrigger(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _dispatcher == null ? false : _dispatcher.hasEventListener(param1);
      }
      
      protected function initDispatcher() : void
      {
         if(_dispatcher == null)
         {
            _dispatcher = new EventDispatcher(this);
         }
         if(this.vars.onInitListener is Function)
         {
            _dispatcher.addEventListener("init",this.vars.onInitListener,false,0,true);
         }
         if(this.vars.onStartListener is Function)
         {
            _dispatcher.addEventListener("start",this.vars.onStartListener,false,0,true);
         }
         if(this.vars.onUpdateListener is Function)
         {
            _dispatcher.addEventListener("change",this.vars.onUpdateListener,false,0,true);
            _hasUpdateListener = true;
         }
         if(this.vars.onCompleteListener is Function)
         {
            _dispatcher.addEventListener("complete",this.vars.onCompleteListener,false,0,true);
         }
         if(this.vars.onRepeatListener is Function)
         {
            _dispatcher.addEventListener("repeat",this.vars.onRepeatListener,false,0,true);
         }
         if(this.vars.onReverseCompleteListener is Function)
         {
            _dispatcher.addEventListener("reverseComplete",this.vars.onReverseCompleteListener,false,0,true);
         }
      }
      
      public function set currentProgress(param1:Number) : void
      {
         if(_cyclesComplete == 0)
         {
            setTotalTime(this.duration * param1,false);
         }
         else
         {
            setTotalTime(this.duration * param1 + _cyclesComplete * this.cachedDuration,false);
         }
      }
      
      public function get totalProgress() : Number
      {
         return this.cachedTotalTime / this.totalDuration;
      }
      
      public function set totalProgress(param1:Number) : void
      {
         setTotalTime(this.totalDuration * param1,false);
      }
      
      public function updateTo(param1:Object, param2:Boolean = false) : void
      {
         var _loc6_:String = null;
         var _loc4_:Number = NaN;
         var _loc3_:PropTween = null;
         var _loc5_:Number = NaN;
         var _loc7_:Number = this.ratio;
         if(param2 && this.timeline != null && this.cachedStartTime < this.timeline.cachedTime)
         {
            this.cachedStartTime = this.timeline.cachedTime;
            this.setDirtyCache(false);
            if(this.gc)
            {
               this.setEnabled(true,false);
            }
            else
            {
               this.timeline.insert(this,this.cachedStartTime - _delay);
            }
         }
         for(_loc6_ in param1)
         {
            this.vars[_loc6_] = param1[_loc6_];
         }
         if(this.initted)
         {
            this.initted = false;
            if(!param2)
            {
               if(_notifyPluginsOfEnabled && Boolean(this.cachedPT1))
               {
                  onPluginEvent("onDisable",this);
               }
               init();
               if(!param2 && this.cachedTime > 0 && this.cachedTime < this.cachedDuration)
               {
                  _loc4_ = 1 / (1 - _loc7_);
                  _loc3_ = this.cachedPT1;
                  while(_loc3_)
                  {
                     _loc5_ = _loc3_.start + _loc3_.change;
                     _loc3_.change *= _loc4_;
                     _loc3_.start = _loc5_ - _loc3_.change;
                     _loc3_ = _loc3_.nextNode;
                  }
               }
            }
         }
      }
      
      public function get currentProgress() : Number
      {
         return this.cachedTime / this.duration;
      }
      
      public function get repeat() : int
      {
         return _repeat;
      }
      
      override public function set currentTime(param1:Number) : void
      {
         if(_cyclesComplete != 0)
         {
            if(this.yoyo && _cyclesComplete % 2 == 1)
            {
               param1 = this.duration - param1 + _cyclesComplete * (this.cachedDuration + _repeatDelay);
            }
            else
            {
               param1 += _cyclesComplete * (this.duration + _repeatDelay);
            }
         }
         setTotalTime(param1,false);
      }
      
      public function get repeatDelay() : Number
      {
         return _repeatDelay;
      }
      
      public function killProperties(param1:Array) : void
      {
         var _loc2_:Object = {};
         var _loc3_:int = int(param1.length);
         while(--_loc3_ > -1)
         {
            _loc2_[param1[_loc3_]] = true;
         }
         killVars(_loc2_);
      }
      
      public function set repeatDelay(param1:Number) : void
      {
         _repeatDelay = param1;
         setDirtyCache(true);
      }
      
      public function set repeat(param1:int) : void
      {
         _repeat = param1;
         setDirtyCache(true);
      }
      
      override public function complete(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.complete(param1,param2);
         if(!param2 && Boolean(_dispatcher))
         {
            if(this.cachedTotalTime == this.cachedTotalDuration && !this.cachedReversed)
            {
               _dispatcher.dispatchEvent(new TweenEvent("complete"));
            }
            else if(this.cachedReversed && this.cachedTotalTime == 0)
            {
               _dispatcher.dispatchEvent(new TweenEvent("reverseComplete"));
            }
         }
      }
      
      override public function invalidate() : void
      {
         this.yoyo = this.vars.yoyo == true;
         _repeat = this.vars.repeat ? int(Number(this.vars.repeat)) : 0;
         _repeatDelay = this.vars.repeatDelay ? Number(this.vars.repeatDelay) : 0;
         _hasUpdateListener = false;
         if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
         {
            initDispatcher();
         }
         setDirtyCache(true);
         super.invalidate();
      }
      
      public function get timeScale() : Number
      {
         return this.cachedTimeScale;
      }
      
      override public function get totalDuration() : Number
      {
         if(this.cacheIsDirty)
         {
            this.cachedTotalDuration = _repeat == -1 ? 999999999999 : this.cachedDuration * (_repeat + 1) + _repeatDelay * _repeat;
            this.cacheIsDirty = false;
         }
         return this.cachedTotalDuration;
      }
   }
}

