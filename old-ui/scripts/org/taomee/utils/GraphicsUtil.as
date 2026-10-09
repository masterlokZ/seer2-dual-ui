package org.taomee.utils
{
   import flash.display.Graphics;
   
   public class GraphicsUtil
   {
      
      public function GraphicsUtil()
      {
         super();
      }
      
      public static function drawWedge(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number = NaN) : void
      {
         var _loc8_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         param1.moveTo(param2,param3);
         if(isNaN(param7))
         {
            param7 = param6;
         }
         if(Math.abs(param5) > 360)
         {
            param5 = 360;
         }
         var _loc9_:int = Math.ceil(Math.abs(param5) / 45);
         _loc8_ = param5 / _loc9_;
         var _loc14_:Number = -(_loc8_ / 180) * 3.141592653589793;
         var _loc15_:Number = -(param4 / 180) * 3.141592653589793;
         if(_loc9_ > 0)
         {
            _loc12_ = param2 + Math.cos(param4 / 180 * 3.141592653589793) * param6;
            _loc13_ = param3 + Math.sin(-param4 / 180 * 3.141592653589793) * param7;
            param1.lineTo(_loc12_,_loc13_);
            _loc18_ = 0;
            while(_loc18_ < _loc9_)
            {
               _loc15_ += _loc14_;
               _loc19_ = _loc15_ - _loc14_ / 2;
               _loc16_ = param2 + Math.cos(_loc15_) * param6;
               _loc17_ = param3 + Math.sin(_loc15_) * param7;
               _loc10_ = param2 + Math.cos(_loc19_) * (param6 / Math.cos(_loc14_ / 2));
               _loc11_ = param3 + Math.sin(_loc19_) * (param7 / Math.cos(_loc14_ / 2));
               param1.curveTo(_loc10_,_loc11_,_loc16_,_loc17_);
               _loc18_++;
            }
            param1.lineTo(param2,param3);
         }
      }
      
      public static function drawDashedLine(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 10, param7:Number = 10) : void
      {
         var _loc9_:Number = param6 + param7;
         var _loc8_:Number = param4 - param2;
         var _loc12_:Number = param5 - param3;
         var _loc13_:Number = Math.sqrt(Math.pow(_loc8_,2) + Math.pow(_loc12_,2));
         var _loc10_:int = Math.floor(Math.abs(_loc13_ / _loc9_));
         var _loc11_:Number = Math.atan2(_loc12_,_loc8_);
         var _loc15_:Number = param2;
         var _loc16_:Number = param3;
         _loc8_ = Math.cos(_loc11_) * _loc9_;
         _loc12_ = Math.sin(_loc11_) * _loc9_;
         var _loc14_:int = 0;
         while(_loc14_ < _loc10_)
         {
            param1.moveTo(_loc15_,_loc16_);
            param1.lineTo(_loc15_ + Math.cos(_loc11_) * param6,_loc16_ + Math.sin(_loc11_) * param6);
            _loc15_ += _loc8_;
            _loc16_ += _loc12_;
            _loc14_++;
         }
         param1.moveTo(_loc15_,_loc16_);
         _loc13_ = Math.sqrt((param4 - _loc15_) * (param4 - _loc15_) + (param5 - _loc16_) * (param5 - _loc16_));
         if(_loc13_ > param6)
         {
            param1.lineTo(_loc15_ + Math.cos(_loc11_) * param6,_loc16_ + Math.sin(_loc11_) * param6);
         }
         else if(_loc13_ > 0)
         {
            param1.lineTo(_loc15_ + Math.cos(_loc11_) * _loc13_,_loc16_ + Math.sin(_loc11_) * _loc13_);
         }
         param1.moveTo(param4,param5);
      }
   }
}

