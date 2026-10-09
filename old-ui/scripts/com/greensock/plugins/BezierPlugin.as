package com.greensock.plugins
{
   import com.greensock.*;
   
   public class BezierPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected static const _RAD2DEG:Number = 57.29577951308232;
      
      protected var _future:Object = {};
      
      protected var _orient:Boolean;
      
      protected var _orientData:Array;
      
      protected var _target:Object;
      
      protected var _beziers:Object;
      
      public function BezierPlugin()
      {
         super();
         this.propName = "bezier";
         this.overwriteProps = [];
      }
      
      public static function parseBeziers(param1:Object, param2:Boolean = false) : Object
      {
         var _loc7_:int = 0;
         var _loc6_:Array = null;
         var _loc4_:Object = null;
         var _loc3_:String = null;
         var _loc5_:Object = {};
         if(param2)
         {
            for(_loc3_ in param1)
            {
               _loc6_ = param1[_loc3_];
               _loc5_[_loc3_] = _loc4_ = [];
               if(_loc6_.length > 2)
               {
                  _loc4_[_loc4_.length] = [_loc6_[0],_loc6_[1] - (_loc6_[2] - _loc6_[0]) / 4,_loc6_[1]];
                  _loc7_ = 1;
                  while(_loc7_ < _loc6_.length - 1)
                  {
                     _loc4_[_loc4_.length] = [_loc6_[_loc7_],_loc6_[_loc7_] + (_loc6_[_loc7_] - _loc4_[_loc7_ - 1][1]),_loc6_[_loc7_ + 1]];
                     _loc7_ += 1;
                  }
               }
               else
               {
                  _loc4_[_loc4_.length] = [_loc6_[0],(_loc6_[0] + _loc6_[1]) / 2,_loc6_[1]];
               }
            }
         }
         else
         {
            for(_loc3_ in param1)
            {
               _loc6_ = param1[_loc3_];
               _loc5_[_loc3_] = _loc4_ = [];
               if(_loc6_.length > 3)
               {
                  _loc4_[_loc4_.length] = [_loc6_[0],_loc6_[1],(_loc6_[1] + _loc6_[2]) / 2];
                  _loc7_ = 2;
                  while(_loc7_ < _loc6_.length - 2)
                  {
                     _loc4_[_loc4_.length] = [_loc4_[_loc7_ - 2][2],_loc6_[_loc7_],(_loc6_[_loc7_] + _loc6_[_loc7_ + 1]) / 2];
                     _loc7_ += 1;
                  }
                  _loc4_[_loc4_.length] = [_loc4_[_loc4_.length - 1][2],_loc6_[_loc6_.length - 2],_loc6_[_loc6_.length - 1]];
               }
               else if(_loc6_.length == 3)
               {
                  _loc4_[_loc4_.length] = [_loc6_[0],_loc6_[1],_loc6_[2]];
               }
               else if(_loc6_.length == 2)
               {
                  _loc4_[_loc4_.length] = [_loc6_[0],(_loc6_[0] + _loc6_[1]) / 2,_loc6_[1]];
               }
            }
         }
         return _loc5_;
      }
      
      override public function killProps(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in _beziers)
         {
            if(_loc2_ in param1)
            {
               delete _beziers[_loc2_];
            }
         }
         super.killProps(param1);
      }
      
      protected function init(param1:TweenLite, param2:Array, param3:Boolean) : void
      {
         var _loc8_:Object = null;
         var _loc4_:int = 0;
         var _loc7_:String = null;
         var _loc6_:Object = null;
         _target = param1.target;
         _loc8_ = param1.vars.isTV == true ? param1.vars.exposedVars : param1.vars;
         if(_loc8_.orientToBezier == true)
         {
            _orientData = [["x","y","rotation",0,0.01]];
            _orient = true;
         }
         else if(_loc8_.orientToBezier is Array)
         {
            _orientData = _loc8_.orientToBezier;
            _orient = true;
         }
         var _loc5_:Object = {};
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            for(_loc7_ in param2[_loc4_])
            {
               if(_loc5_[_loc7_] == undefined)
               {
                  _loc5_[_loc7_] = [param1.target[_loc7_]];
               }
               if(typeof param2[_loc4_][_loc7_] == "number")
               {
                  _loc5_[_loc7_].push(param2[_loc4_][_loc7_]);
               }
               else
               {
                  _loc5_[_loc7_].push(param1.target[_loc7_] + Number(param2[_loc4_][_loc7_]));
               }
            }
            _loc4_ += 1;
         }
         for(_loc7_ in _loc5_)
         {
            this.overwriteProps[this.overwriteProps.length] = _loc7_;
            if(_loc8_[_loc7_] != undefined)
            {
               if(typeof _loc8_[_loc7_] == "number")
               {
                  _loc5_[_loc7_].push(_loc8_[_loc7_]);
               }
               else
               {
                  _loc5_[_loc7_].push(param1.target[_loc7_] + Number(_loc8_[_loc7_]));
               }
               _loc6_ = {};
               _loc6_[_loc7_] = true;
               param1.killVars(_loc6_,false);
               delete _loc8_[_loc7_];
            }
         }
         _beziers = parseBeziers(_loc5_,param3);
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param2 is Array))
         {
            return false;
         }
         init(param3,param2 as Array,false);
         return true;
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc7_:* = 0;
         var _loc9_:String = null;
         var _loc8_:Object = null;
         var _loc4_:Number = NaN;
         var _loc3_:int = 0;
         var _loc6_:Number = NaN;
         var _loc5_:Object = null;
         var _loc2_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         var _loc14_:Boolean = false;
         _changeFactor = param1;
         if(param1 == 1)
         {
            for(_loc9_ in _beziers)
            {
               _loc7_ = _beziers[_loc9_].length - 1;
               _target[_loc9_] = _beziers[_loc9_][_loc7_][2];
            }
         }
         else
         {
            for(_loc9_ in _beziers)
            {
               _loc3_ = int(_beziers[_loc9_].length);
               if(param1 < 0)
               {
                  _loc7_ = 0;
               }
               else if(param1 >= 1)
               {
                  _loc7_ = _loc3_ - 1;
               }
               else
               {
                  _loc7_ = _loc3_ * param1 >> 0;
               }
               _loc4_ = (param1 - _loc7_ * (1 / _loc3_)) * _loc3_;
               _loc8_ = _beziers[_loc9_][_loc7_];
               if(this.round)
               {
                  _loc6_ = _loc8_[0] + _loc4_ * (2 * (1 - _loc4_) * (_loc8_[1] - _loc8_[0]) + _loc4_ * (_loc8_[2] - _loc8_[0]));
                  if(_loc6_ > 0)
                  {
                     _target[_loc9_] = _loc6_ + 0.5 >> 0;
                  }
                  else
                  {
                     _target[_loc9_] = _loc6_ - 0.5 >> 0;
                  }
               }
               else
               {
                  _target[_loc9_] = _loc8_[0] + _loc4_ * (2 * (1 - _loc4_) * (_loc8_[1] - _loc8_[0]) + _loc4_ * (_loc8_[2] - _loc8_[0]));
               }
            }
         }
         if(_orient)
         {
            _loc7_ = int(_orientData.length);
            _loc5_ = {};
            while(_loc7_--)
            {
               _loc13_ = _orientData[_loc7_];
               _loc5_[_loc13_[0]] = _target[_loc13_[0]];
               _loc5_[_loc13_[1]] = _target[_loc13_[1]];
            }
            _loc11_ = _target;
            _loc14_ = this.round;
            _target = _future;
            this.round = false;
            _orient = false;
            _loc7_ = int(_orientData.length);
            while(_loc7_--)
            {
               _loc13_ = _orientData[_loc7_];
               this.changeFactor = param1 + (_loc13_[4] || 0.01);
               _loc10_ = Number(Number(_loc13_[3]) || 0);
               _loc2_ = _future[_loc13_[0]] - _loc5_[_loc13_[0]];
               _loc12_ = _future[_loc13_[1]] - _loc5_[_loc13_[1]];
               _loc11_[_loc13_[2]] = Math.atan2(_loc12_,_loc2_) * 57.29577951308232 + _loc10_;
            }
            _target = _loc11_;
            this.round = _loc14_;
            _orient = true;
         }
      }
   }
}

