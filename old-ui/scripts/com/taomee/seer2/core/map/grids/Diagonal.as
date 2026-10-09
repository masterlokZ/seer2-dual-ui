package com.taomee.seer2.core.map.grids
{
   import flash.geom.Point;
   
   public class Diagonal
   {
      
      public function Diagonal()
      {
         super();
      }
      
      public static function each(param1:Point, param2:Point) : Array
      {
         var _loc9_:int = 0;
         var _loc8_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc7_:Array = [];
         var _loc14_:int = 0;
         var _loc15_:Boolean = param1.x < param2.x == param1.y < param2.y;
         if(param1.x < param2.x)
         {
            _loc5_ = param1.x;
            _loc4_ = param1.y;
            _loc9_ = param2.x - _loc5_;
            _loc8_ = Math.abs(param2.y - _loc4_);
         }
         else
         {
            _loc5_ = param2.x;
            _loc4_ = param2.y;
            _loc9_ = param1.x - _loc5_;
            _loc8_ = Math.abs(param1.y - _loc4_);
         }
         if(_loc9_ == _loc8_)
         {
            _loc11_ = 0;
            while(_loc11_ <= _loc9_)
            {
               if(_loc15_)
               {
                  _loc7_.push(new Point(_loc5_ + _loc11_,_loc4_ + _loc11_));
               }
               else
               {
                  _loc7_.push(new Point(_loc5_ + _loc11_,_loc4_ - _loc11_));
               }
               if(_loc11_ > 0)
               {
                  if(_loc15_)
                  {
                     _loc7_.push(new Point(_loc5_ + _loc11_ - 1,_loc4_ + _loc11_));
                  }
                  else
                  {
                     _loc7_.push(new Point(_loc5_ + _loc11_ - 1,_loc4_ - _loc11_));
                  }
               }
               if(_loc11_ < _loc9_)
               {
                  if(_loc15_)
                  {
                     _loc7_.push(new Point(_loc5_ + _loc11_ + 1,_loc4_ + _loc11_));
                  }
                  else
                  {
                     _loc7_.push(new Point(_loc5_ + _loc11_ + 1,_loc4_ - _loc11_));
                  }
               }
               _loc11_++;
            }
         }
         else if(_loc9_ > _loc8_)
         {
            _loc6_ = _loc8_ / _loc9_;
            _loc7_.push(new Point(_loc5_,_loc4_));
            _loc11_ = 1;
            while(_loc11_ <= _loc9_)
            {
               _loc3_ = (_loc11_ - 0.5) * _loc6_;
               _loc12_ = (_loc11_ + 0.5) * _loc6_;
               _loc13_ = _loc3_ > _loc14_ - 0.5 && _loc3_ < _loc14_ + 0.5;
               _loc10_ = _loc12_ > _loc14_ - 0.5 && _loc12_ < _loc14_ + 0.5;
               if(_loc13_ || _loc10_)
               {
                  if(_loc15_)
                  {
                     _loc7_.push(new Point(_loc5_ + _loc11_,_loc4_ + _loc14_));
                  }
                  else
                  {
                     _loc7_.push(new Point(_loc5_ + _loc11_,_loc4_ - _loc14_));
                  }
                  if(!_loc10_)
                  {
                     _loc14_++;
                     if(_loc15_)
                     {
                        _loc7_.push(new Point(_loc5_ + _loc11_,_loc4_ + _loc14_));
                     }
                     else
                     {
                        _loc7_.push(new Point(_loc5_ + _loc11_,_loc4_ - _loc14_));
                     }
                  }
               }
               _loc11_++;
            }
         }
         else if(_loc9_ < _loc8_)
         {
            _loc6_ = _loc9_ / _loc8_;
            _loc7_.push(new Point(_loc5_,_loc4_));
            _loc11_ = 1;
            while(_loc11_ <= _loc8_)
            {
               _loc3_ = (_loc11_ - 0.5) * _loc6_;
               _loc12_ = (_loc11_ + 0.5) * _loc6_;
               _loc13_ = _loc3_ > _loc14_ - 0.5 && _loc3_ < _loc14_ + 0.5;
               _loc10_ = _loc12_ > _loc14_ - 0.5 && _loc12_ < _loc14_ + 0.5;
               if(_loc13_ || _loc10_)
               {
                  if(_loc15_)
                  {
                     _loc7_.push(new Point(_loc5_ + _loc14_,_loc4_ + _loc11_));
                  }
                  else
                  {
                     _loc7_.push(new Point(_loc5_ + _loc14_,_loc4_ - _loc11_));
                  }
                  if(!_loc10_)
                  {
                     _loc14_++;
                     if(_loc15_)
                     {
                        _loc7_.push(new Point(_loc5_ + _loc14_,_loc4_ + _loc11_));
                     }
                     else
                     {
                        _loc7_.push(new Point(_loc5_ + _loc14_,_loc4_ - _loc11_));
                     }
                  }
               }
               _loc11_++;
            }
         }
         return _loc7_;
      }
   }
}

