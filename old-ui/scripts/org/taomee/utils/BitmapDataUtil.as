package org.taomee.utils
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapDataUtil
   {
      
      public function BitmapDataUtil()
      {
         super();
      }
      
      public static function makeList(param1:BitmapData, param2:int, param3:int, param4:uint, param5:Array = null) : Array
      {
         var _loc14_:int = 0;
         var _loc7_:int = Math.min(param1.width,2880) / param2;
         var _loc9_:int = Math.min(param1.height,2880) / param3;
         var _loc8_:int = 0;
         var _loc6_:BitmapData = null;
         var _loc12_:Array = new Array(param4);
         var _loc13_:Rectangle = new Rectangle(0,0,param2,param3);
         var _loc10_:Point = new Point();
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            _loc14_ = 0;
            while(_loc14_ < _loc7_)
            {
               if(_loc8_ >= param4)
               {
                  return _loc12_;
               }
               _loc13_.x = _loc14_ * param2;
               _loc13_.y = _loc11_ * param3;
               if(param5)
               {
                  if(param5.indexOf(_loc8_) != -1)
                  {
                     _loc6_ = new BitmapData(param2,param3);
                     _loc6_.copyPixels(param1,_loc13_,_loc10_);
                     _loc12_[_loc8_] = _loc6_;
                  }
                  else
                  {
                     _loc12_[_loc8_] = null;
                  }
               }
               else
               {
                  _loc6_ = new BitmapData(param2,param3);
                  _loc6_.copyPixels(param1,_loc13_,_loc10_);
                  _loc12_[_loc8_] = _loc6_;
               }
               _loc8_++;
               _loc14_++;
            }
            _loc11_++;
         }
         return _loc12_;
      }
   }
}

