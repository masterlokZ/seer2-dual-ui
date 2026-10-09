package com.taomee.seer2.core.map.grids
{
   import flash.geom.Point;
   
   public class GameMapUtils
   {
      
      public function GameMapUtils()
      {
         super();
      }
      
      public static function getArrByStr(param1:String, param2:int, param3:int) : Array
      {
         var _loc7_:Array = null;
         var _loc4_:uint = 0;
         var _loc9_:Array = [];
         var _loc6_:Array = param1.split(",");
         var _loc5_:uint = 0;
         var _loc8_:uint = 0;
         while(_loc8_ < param3)
         {
            _loc7_ = [];
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               _loc7_.push(_loc6_[_loc5_]);
               _loc5_++;
               _loc4_++;
            }
            _loc9_.push(_loc7_);
            _loc8_++;
         }
         return _loc9_;
      }
      
      public static function getCellPoint(param1:int, param2:int, param3:int, param4:int) : Point
      {
         var _loc10_:int = 0;
         var _loc8_:int = 0;
         var _loc5_:int = 0;
         var _loc9_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         _loc10_ = int(param3 / param1) * param1 + param1 / 2;
         _loc8_ = int(param4 / param2) * param2 + param2 / 2;
         _loc5_ = (param3 - _loc10_) * param2 / 2;
         _loc9_ = (param4 - _loc8_) * param1 / 2;
         if(Math.abs(_loc5_) + Math.abs(_loc9_) <= param1 * param2 / 4)
         {
            _loc7_ = param3 / param1;
            _loc6_ = int(param4 / param2) * 2;
         }
         else
         {
            _loc7_ = int(param3 / param1) + 1;
            param4 -= param2 / 2;
            _loc6_ = int(param4 / param2) * 2 + 1;
         }
         return new Point(_loc7_ - (_loc6_ & 1),_loc6_);
      }
      
      public static function getDirectPoint(param1:Point, param2:int) : Point
      {
         var _loc3_:Point = new Point();
         if(param1.y & 1)
         {
            _loc3_.x = Math.floor(param1.x - param1.y / 2 + 1 + (param2 - 1) / 2);
         }
         else
         {
            _loc3_.x = param1.x - param1.y / 2 + Math.ceil((param2 - 1) / 2);
         }
         _loc3_.y = Math.floor(param1.y / 2 + param1.x + (param1.y & 1));
         return _loc3_;
      }
      
      public static function getDirectPointByPixel(param1:int, param2:int, param3:int, param4:int, param5:int) : Point
      {
         return getDirectPoint(getCellPoint(param1,param2,param3,param4),param5);
      }
      
      public static function getPixelPoint(param1:int, param2:int, param3:int, param4:int) : Point
      {
         var _loc6_:int = 0;
         _loc6_ = param3 * param1 + param1 / 2;
         var _loc5_:int = _loc6_ + (param4 & 1) * param1 / 2;
         var _loc7_:int = (param4 + 1) * param2 / 2;
         return new Point(_loc5_,_loc7_);
      }
      
      public static function getStrByArr(param1:Array, param2:int = 0) : String
      {
         var _loc4_:uint = 0;
         var _loc3_:int = 0;
         var _loc5_:String = null;
         var _loc7_:String = "";
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1[0].length)
            {
               _loc3_ = int(param1[_loc6_][_loc4_]);
               switch(_loc3_)
               {
                  case 0:
                     if(param2 == 0)
                     {
                        _loc5_ = "0";
                     }
                     else if(param2 == 1)
                     {
                        _loc5_ = "1";
                     }
                     break;
                  case 1:
                     _loc5_ = "0";
                     break;
                  case 2:
                     _loc5_ = "1";
                     break;
                  default:
                     throw new Error("地图信息数组中有未知因素！");
               }
               if(_loc7_.length > 0)
               {
                  _loc7_ += ",";
               }
               _loc7_ += _loc5_;
               _loc4_++;
            }
            _loc6_++;
         }
         return _loc7_;
      }
      
      public static function getDArrayByArr(param1:Array, param2:int, param3:int, param4:HashMap) : Array
      {
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Point = null;
         var _loc14_:Point = null;
         var _loc7_:Array = [];
         var _loc6_:Point = getDirectPoint(new Point(param3,0),param2);
         var _loc9_:Point = getDirectPoint(new Point(param3,param2),param2);
         var _loc8_:int = 0;
         while(_loc8_ < _loc9_.y + 1)
         {
            _loc12_ = [];
            _loc13_ = 0;
            while(_loc13_ < _loc6_.x + 1)
            {
               _loc12_[_loc13_] = {};
               _loc12_[_loc13_].value = 0;
               _loc13_++;
            }
            _loc7_.push(_loc12_);
            _loc8_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param2)
         {
            _loc10_ = 0;
            while(_loc10_ < param3)
            {
               _loc11_ = getDirectPoint(new Point(_loc10_,_loc5_),param2);
               _loc7_[_loc11_.y][_loc11_.x].value = param1[_loc5_][_loc10_];
               _loc7_[_loc11_.y][_loc11_.x].px = _loc10_;
               _loc7_[_loc11_.y][_loc11_.x].py = _loc5_;
               _loc14_ = new Point(_loc10_,_loc5_);
               param4.put(_loc11_.y + "-" + _loc11_.x,_loc7_[_loc11_.y][_loc11_.x]);
               _loc10_++;
            }
            _loc5_++;
         }
         return _loc7_;
      }
      
      public static function getMaxDirectPoint(param1:int, param2:int) : Point
      {
         var _loc4_:Point = getDirectPoint(new Point(param2,0),param1);
         var _loc3_:Point = getDirectPoint(new Point(param2,param1),param1);
         return new Point(_loc4_.x,_loc3_.y);
      }
   }
}

