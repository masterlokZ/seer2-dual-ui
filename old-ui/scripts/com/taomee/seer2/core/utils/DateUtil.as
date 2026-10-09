package com.taomee.seer2.core.utils
{
   import com.taomee.seer2.core.manager.TimeManager;
   
   public class DateUtil
   {
      
      public static const MILLISECONDS_PER_SECOND:uint = 1000;
      
      public static const SECONDS_PER_MINUTE:uint = 60;
      
      public static const SECONDS_PER_HOUR:uint = 3600;
      
      public static const SECONDS_PER_DAY:uint = 86400;
      
      public static const SEER2_BASE_YEAR:uint = 1970;
      
      public function DateUtil()
      {
         super();
      }
      
      public static function convertSecondsToHours(param1:uint) : int
      {
         return int(param1 / 3600);
      }
      
      public static function convertSecondsToDays(param1:uint) : uint
      {
         return uint(param1 / 86400);
      }
      
      public static function formatCalendarWithYearMonthDay(param1:uint) : String
      {
         var _loc3_:Date = new Date(param1 * 1000);
         var _loc5_:int = _loc3_.fullYear;
         var _loc4_:int = _loc3_.month + 1;
         var _loc2_:int = _loc3_.date;
         return _loc5_ + "年" + _loc4_ + "月" + _loc2_ + "日";
      }
      
      public static function formatCalendarWithMonthDay(param1:uint) : String
      {
         var _loc2_:Date = new Date(param1 * 1000);
         var _loc4_:int = _loc2_.month + 1;
         var _loc3_:int = _loc2_.date;
         return _loc4_ + "月" + _loc3_ + "日";
      }
      
      public static function formatCalendarWithMonthDayWhenBranch(param1:uint) : String
      {
         var _loc5_:Date = new Date(param1 * 1000);
         var _loc7_:int = _loc5_.month + 1;
         var _loc6_:int = _loc5_.date;
         var _loc3_:int = _loc5_.hours;
         var _loc2_:int = _loc5_.minutes;
         var _loc4_:int = _loc5_.seconds;
         return _loc7_ + "月" + _loc6_ + "日" + _loc3_ + "时" + _loc2_ + "分" + _loc4_ + "秒";
      }
      
      public static function formatCalendarWithHyphen(param1:uint) : String
      {
         var _loc3_:Date = new Date(param1 * 1000);
         var _loc5_:int = _loc3_.fullYear;
         var _loc4_:int = _loc3_.month + 1;
         var _loc2_:int = _loc3_.date;
         return _loc5_ + "-" + _loc4_ + "-" + _loc2_;
      }
      
      public static function formatCalendarWithoutMark(param1:uint, param2:String = "") : String
      {
         var _loc6_:Date = new Date(param1 * 1000);
         var _loc5_:int = _loc6_.fullYear;
         var _loc4_:int = _loc6_.month + 1;
         var _loc3_:int = _loc6_.date;
         return _loc5_.toString() + param2 + _loc4_.toString() + param2 + _loc3_.toString();
      }
      
      public static function isNight() : Boolean
      {
         var _loc1_:int = TimeManager.getServerTime() / 3600;
         return _loc1_ % 2 == 0;
      }
      
      public static function getDHMS(param1:uint) : String
      {
         var _loc4_:String = Math.floor(param1 / 86400).toString();
         var _loc6_:uint = param1 % 86400;
         var _loc5_:String = Math.floor(_loc6_ / 3600).toString();
         _loc6_ = param1 % 3600;
         var _loc3_:String = Math.floor(_loc6_ / 60).toString();
         var _loc2_:String = (_loc6_ % 60).toString();
         _loc4_ = uint(_loc4_) < 10 ? "0" + _loc4_ : _loc4_;
         _loc5_ = uint(_loc5_) < 10 ? "0" + _loc5_ : _loc5_;
         _loc3_ = uint(_loc3_) < 10 ? "0" + _loc3_ : _loc3_;
         _loc2_ = uint(_loc2_) < 10 ? "0" + _loc2_ : _loc2_;
         return _loc4_ + "天" + _loc5_ + "时" + _loc3_ + "分" + _loc2_ + "秒";
      }
      
      public static function getHMS(param1:uint) : String
      {
         var _loc3_:String = Math.floor(param1 / 3600).toString();
         var _loc5_:uint = param1 % 3600;
         var _loc4_:String = Math.floor(_loc5_ / 60).toString();
         var _loc2_:String = (_loc5_ % 60).toString();
         _loc3_ = uint(_loc3_) < 10 ? "0" + _loc3_ : _loc3_;
         _loc4_ = uint(_loc4_) < 10 ? "0" + _loc4_ : _loc4_;
         _loc2_ = uint(_loc2_) < 10 ? "0" + _loc2_ : _loc2_;
         return _loc3_ + ":" + _loc4_ + ":" + _loc2_;
      }
      
      public static function getDateBtweenDays(param1:Date, param2:Date) : int
      {
         var _loc5_:int = 0;
         var _loc4_:Date = new Date(param1.fullYear,param1.month,param1.date);
         var _loc3_:Date = new Date(param2.fullYear,param2.month,param2.date);
         if(_loc4_.getTime() > _loc3_.getTime())
         {
            _loc5_ = -1;
         }
         else
         {
            _loc5_ = (_loc3_.getTime() - _loc4_.getTime()) / (86400 * 1000);
         }
         return _loc5_;
      }
      
      public static function getMS(param1:uint) : String
      {
         var _loc2_:String = Math.floor(param1 / 60).toString();
         var _loc3_:String = (param1 % 60).toString();
         _loc2_ = uint(_loc2_) < 10 ? "0" + _loc2_ : _loc2_;
         _loc3_ = uint(_loc3_) < 10 ? "0" + _loc3_ : _loc3_;
         return _loc2_ + ":" + _loc3_;
      }
      
      public static function formatCalendarWithWeekHourMinuteSecond(param1:uint) : String
      {
         var _loc4_:Date = new Date(param1 * 1000);
         var _loc6_:int = _loc4_.day;
         var _loc5_:int = _loc4_.hours;
         var _loc3_:int = _loc4_.minutes + 1;
         var _loc2_:int = _loc4_.seconds + 1;
         return _loc6_ + "-" + _loc5_ + "-" + _loc3_ + "-" + _loc2_;
      }
      
      public static function formatCaleandarWithHour(param1:uint) : int
      {
         var _loc2_:Date = new Date(param1 * 1000);
         return int(_loc2_.hours);
      }
      
      public static function parse(param1:String) : Date
      {
         var _loc2_:Array = param1.split("-");
         if(_loc2_.length > 1)
         {
            return new Date(int(_loc2_[0]),int(_loc2_[1]) - 1,_loc2_[2]);
         }
         return null;
      }
      
      public static function isInHourScope(param1:uint, param2:uint, param3:uint = 0, param4:uint = 0) : Boolean
      {
         var _loc7_:Date = null;
         _loc7_ = new Date(TimeManager.getServerTime() * 1000);
         var _loc6_:int = _loc7_.hours;
         var _loc9_:int = _loc7_.minutes + 1;
         var _loc8_:Date = new Date(_loc7_.fullYear,_loc7_.month,_loc7_.date,param1,param3);
         var _loc5_:Date = new Date(_loc7_.fullYear,_loc7_.month,_loc7_.date,param2,param4);
         if(_loc8_ <= _loc7_ && _loc5_ >= _loc7_)
         {
            return true;
         }
         return false;
      }
      
      public static function isInMonthDayScope(param1:uint, param2:uint, param3:uint, param4:uint) : Boolean
      {
         var _loc6_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc5_:Date = new Date(_loc6_.fullYear,param1,param2);
         var _loc7_:Date = new Date(_loc6_.fullYear,param3,param4);
         if(_loc6_ <= _loc7_ && _loc6_ >= _loc5_)
         {
            return true;
         }
         return false;
      }
      
      public static function isInDayAndHourScope(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint = 0, param6:uint = 0) : Boolean
      {
         var _loc9_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc8_:Date = new Date(_loc9_.fullYear,_loc9_.month,_loc9_.date,param3,param5);
         var _loc7_:Date = new Date(_loc9_.fullYear,_loc9_.month,_loc9_.date,param4,param6);
         if(_loc9_.date >= param1 && _loc9_.date <= param2 && _loc8_ <= _loc9_ && _loc7_ >= _loc9_)
         {
            return true;
         }
         return false;
      }
      
      public static function isInDayAndHourScope2(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : Boolean
      {
         var _loc9_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc8_:Date = new Date(_loc9_.fullYear,param1 - 1,param2,param3);
         var _loc7_:Date = new Date(_loc9_.fullYear,param4 - 1,param5,param6);
         if(_loc9_ <= _loc7_ && _loc9_ >= _loc8_)
         {
            return true;
         }
         return false;
      }
      
      public static function isDay(param1:uint, param2:uint, param3:uint) : Boolean
      {
         var _loc7_:Date = null;
         _loc7_ = new Date(TimeManager.getServerTime() * 1000);
         var _loc5_:int = _loc7_.fullYear;
         var _loc4_:int = _loc7_.month + 1;
         var _loc6_:int = _loc7_.date;
         return param1 == _loc5_ && param2 == _loc4_ && param3 == _loc6_;
      }
      
      public static function isInTime(param1:Date, param2:Date) : Boolean
      {
         var _loc3_:Number = TimeManager.getServerTime() * 1000;
         if(_loc3_ > param1.getTime() && _loc3_ < param2.getTime())
         {
            return true;
         }
         return false;
      }
      
      public static function inInDateScope(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint = 0) : Boolean
      {
         var _loc7_:int = 0;
         var _loc6_:Date = null;
         _loc6_ = new Date(TimeManager.getServerTime() * 1000);
         _loc7_ = _loc6_.day;
         if(_loc7_ == param1)
         {
            return isInHourScope(param2,param4,param3,param5);
         }
         return false;
      }
   }
}

