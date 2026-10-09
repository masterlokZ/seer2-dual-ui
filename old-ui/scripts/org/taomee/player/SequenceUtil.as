package org.taomee.player
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SequenceUtil
   {
      
      private static var _rect:Rectangle = new Rectangle();
      
      private static var _pos:Point = new Point();
      
      public function SequenceUtil()
      {
         super();
      }
      
      public static function makeList(param1:BitmapData, param2:int, param3:int, param4:int, param5:Array, param6:int = 0, param7:int = 0) : Vector.<FrameInfo>
      {
         var _loc9_:FrameInfo = null;
         var _loc13_:FrameInfo = null;
         var _loc11_:ValidFrameInfo = null;
         var _loc14_:FrameInfo = null;
         var _loc8_:Vector.<FrameInfo> = new Vector.<FrameInfo>(param4,true);
         var _loc12_:int = param1.width / param2;
         var _loc10_:int = 0;
         while(_loc10_ < param4)
         {
            for each(_loc11_ in param5)
            {
               if(_loc11_.keyFrame == _loc10_)
               {
                  _loc13_ = null;
                  for each(_loc14_ in _loc8_)
                  {
                     if(_loc14_)
                     {
                        if(_loc11_.index == _loc14_.index)
                        {
                           _loc13_ = _loc14_;
                           break;
                        }
                     }
                  }
                  _loc9_ = new FrameInfo();
                  if(_loc13_)
                  {
                     _loc9_.data = _loc13_.data;
                  }
                  else
                  {
                     _rect.x = int(_loc11_.index % _loc12_) * param2;
                     _rect.y = int(_loc11_.index / _loc12_) * param3;
                     _rect.width = _loc11_.width;
                     _rect.height = _loc11_.height;
                     _loc9_.data = new BitmapData(_loc11_.width,_loc11_.height);
                     _loc9_.data.copyPixels(param1,_rect,_pos);
                  }
                  _loc9_.index = _loc11_.index;
                  _loc9_.offsetX = param6 + _loc11_.offsetX;
                  _loc9_.offsetY = param7 + _loc11_.offsetY;
                  break;
               }
            }
            _loc8_[_loc10_] = _loc9_;
            _loc10_++;
         }
         return _loc8_;
      }
   }
}

