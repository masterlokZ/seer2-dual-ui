package org.taomee.utils
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class Tick
   {
      
      public static var timeScaleAll:Number = 1;
      
      private static var _instance:Tick;
      
      private static var _o:Shape = new Shape();
      
      private var _running:Boolean;
      
      private var _renderoutLength:int;
      
      private var _nextTime:Number;
      
      private var _timeoutMap:Dictionary = new Dictionary();
      
      private var _renderoutMap:Dictionary = new Dictionary();
      
      private var _valueTime:uint;
      
      private var _renderMap:Dictionary = new Dictionary();
      
      private var _timeoutLength:int;
      
      private var _renderLength:int;
      
      public var timeScale:Number = 1;
      
      private var _prevTime:Number;
      
      public function Tick()
      {
         super();
      }
      
      public static function get instance() : Tick
      {
         if(_instance == null)
         {
            _instance = new Tick();
            _instance.start();
         }
         return _instance;
      }
      
      public function removeRender(param1:Function) : void
      {
         if(param1 in _renderMap)
         {
            delete _renderMap[param1];
            --_renderLength;
         }
      }
      
      public function stop() : void
      {
         _o.removeEventListener("enterFrame",onEnter);
      }
      
      public function removeTimeout(param1:Function) : void
      {
         if(param1 in _timeoutMap)
         {
            delete _timeoutMap[param1];
            --_timeoutLength;
         }
      }
      
      public function hasRenderAndOut(param1:Function) : Boolean
      {
         return param1 in _renderoutMap;
      }
      
      public function addTimeout(param1:uint, param2:Function) : void
      {
         if(param2 in _timeoutMap == false)
         {
            _timeoutMap[param2] = new TimeoutInfo(param1);
            ++_timeoutLength;
         }
      }
      
      public function removeRenderAndOut(param1:Function) : void
      {
         if(param1 in _renderoutMap)
         {
            delete _renderoutMap[param1];
            --_renderoutLength;
         }
      }
      
      public function hasTimeout(param1:Function) : Boolean
      {
         return param1 in _timeoutMap;
      }
      
      private function onRender() : void
      {
         var _loc2_:TimeoutInfo = null;
         var _loc1_:* = undefined;
         if(_renderLength > 0)
         {
            for(_loc1_ in _renderMap)
            {
               _loc2_ = _renderMap[_loc1_];
               if(_loc2_.delay > 0)
               {
                  if(_loc2_.count >= _loc2_.delay)
                  {
                     _loc1_(_loc2_.count);
                     _loc2_.count = 0;
                  }
               }
               else
               {
                  _loc1_(_valueTime);
               }
               _loc2_.count += _valueTime;
            }
         }
      }
      
      public function addRender(param1:Function, param2:int = 0) : void
      {
         if(param1 in _renderMap == false)
         {
            _renderMap[param1] = new TimeoutInfo(param2);
            ++_renderLength;
         }
      }
      
      public function dispose() : void
      {
         stop();
         _renderMap = null;
         _timeoutMap = null;
         _renderoutMap = null;
      }
      
      public function start() : void
      {
         _o.addEventListener("enterFrame",onEnter);
      }
      
      private function onTimeout() : void
      {
         var _loc2_:TimeoutInfo = null;
         var _loc1_:* = undefined;
         if(_timeoutLength > 0)
         {
            for(_loc1_ in _timeoutMap)
            {
               _loc2_ = _timeoutMap[_loc1_];
               if(_loc2_.count >= _loc2_.delay)
               {
                  delete _timeoutMap[_loc1_];
                  --_timeoutLength;
                  _loc1_();
               }
               else
               {
                  _loc2_.count += _valueTime;
               }
            }
         }
      }
      
      private function onRenderAndOut() : void
      {
         var _loc2_:TimeoutInfo = null;
         var _loc1_:* = undefined;
         if(_renderoutLength > 0)
         {
            for(_loc1_ in _renderoutMap)
            {
               _loc2_ = _renderoutMap[_loc1_];
               if(_loc2_.count >= _loc2_.delay)
               {
                  delete _renderoutMap[_loc1_];
                  --_renderoutLength;
                  _loc1_(true);
               }
               else
               {
                  _loc1_(false);
                  _loc2_.count += _valueTime;
               }
            }
         }
      }
      
      public function addRenderAndOut(param1:uint, param2:Function) : void
      {
         if(param2 in _renderoutMap == false)
         {
            _renderoutMap[param2] = new TimeoutInfo(param1);
            ++_renderoutLength;
         }
      }
      
      public function hasRender(param1:Function) : Boolean
      {
         return param1 in _renderMap;
      }
      
      private function onEnter(param1:Event) : void
      {
         _nextTime = new Date().getTime();
         if(_prevTime > 0)
         {
            _valueTime = (_nextTime - _prevTime) * timeScale * timeScaleAll;
            onRender();
            onTimeout();
            onRenderAndOut();
         }
         _prevTime = _nextTime;
      }
   }
}

class TimeoutInfo
{
   
   public var delay:uint;
   
   public var count:uint;
   
   public function TimeoutInfo(param1:uint)
   {
      super();
      this.delay = param1;
   }
}
