package com.taomee.seer2.app.config
{
   import com.taomee.seer2.core.manager.TimeManager;
   import org.taomee.ds.HashMap;
   
   public class TimeLimitConfig
   {
      
      private static var _configXML:XML;
      
      private static var _timeActivityMap:HashMap;
      
      private static var _xmlClass:Class = TimeLimitConfig__xmlClass;
      
      initialize();
      
      public function TimeLimitConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _timeActivityMap = new HashMap();
         setup();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc2_:TimeLimitInfo = null;
         var _loc5_:Vector.<TimeLimitDay> = null;
         var _loc4_:XML = null;
         var _loc1_:XML = null;
         _configXML = XML(new _xmlClass());
         for each(_loc3_ in _configXML.children())
         {
            _loc2_ = new TimeLimitInfo();
            _loc5_ = new Vector.<TimeLimitDay>();
            _loc2_.ID = uint(_loc3_.@ID);
            _loc2_.NAME = _loc3_.@NAME;
            _loc2_.FromDate = _loc3_.@FromDate;
            _loc2_.ToDate = _loc3_.@ToDate;
            _loc2_.dayArr = _loc5_;
            for each(_loc4_ in _loc3_.children())
            {
               for each(_loc1_ in _loc4_.children())
               {
                  initone(_loc5_,_loc1_);
               }
            }
            _timeActivityMap.add(_loc2_.ID,_loc2_);
         }
      }
      
      private static function initone(param1:Vector.<TimeLimitDay>, param2:XML) : void
      {
         var _loc3_:TimeLimitDay = new TimeLimitDay();
         _loc3_.WeekDay = uint(param2.@WeekDay);
         _loc3_.TimeStart = String(param2.@TimeStart);
         _loc3_.TimeEnd = String(param2.@TimeEnd);
         param1.push(_loc3_);
      }
      
      private static function getLimitTypeByID(param1:uint) : *
      {
         if(_timeActivityMap.containsKey(param1))
         {
            return _timeActivityMap.getValue(param1);
         }
         return null;
      }
      
      public static function getFromDate(param1:uint) : Date
      {
         var _loc8_:Array = null;
         var _loc7_:String = null;
         var _loc3_:String = null;
         var _loc2_:Array = null;
         var _loc5_:Array = null;
         var _loc4_:Date = null;
         var _loc6_:TimeLimitInfo = getLimitTypeByID(param1);
         if(_loc6_)
         {
            _loc8_ = _loc6_.FromDate.split(" ");
            _loc7_ = String(_loc8_[0]);
            _loc3_ = String(_loc8_[1]);
            _loc2_ = _loc7_.split("-");
            _loc5_ = _loc3_.split(":");
            return new Date(uint(_loc2_[0]),uint(_loc2_[1]) - 1,uint(_loc2_[2]),uint(_loc5_[0]),uint(_loc5_[1]));
         }
         return null;
      }
      
      public static function getEndDate(param1:uint) : Date
      {
         var _loc8_:Array = null;
         var _loc7_:String = null;
         var _loc3_:String = null;
         var _loc2_:Array = null;
         var _loc5_:Array = null;
         var _loc4_:Date = null;
         var _loc6_:TimeLimitInfo = getLimitTypeByID(param1);
         if(_loc6_)
         {
            _loc8_ = _loc6_.ToDate.split(" ");
            _loc7_ = String(_loc8_[0]);
            _loc3_ = String(_loc8_[1]);
            _loc2_ = _loc7_.split("-");
            _loc5_ = _loc3_.split(":");
            return new Date(uint(_loc2_[0]),uint(_loc2_[1]) - 1,uint(_loc2_[2]),uint(_loc5_[0]),uint(_loc5_[1]));
         }
         return null;
      }
      
      public static function InLimitTime(param1:uint) : Boolean
      {
         var _loc9_:Date = null;
         var _loc8_:Array = null;
         var _loc4_:String = null;
         var _loc3_:String = null;
         var _loc6_:Array = null;
         var _loc5_:Array = null;
         var _loc2_:Date = null;
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Date = null;
         var _loc7_:TimeLimitInfo = getLimitTypeByID(param1);
         if(_loc7_)
         {
            _loc9_ = new Date(TimeManager.getServerTime() * 1000);
            if(!_loc7_.FromDate)
            {
               return inLimitDay(_loc7_);
            }
            _loc8_ = _loc7_.FromDate.split(" ");
            _loc4_ = String(_loc8_[0]);
            _loc3_ = String(_loc8_[1]);
            _loc6_ = _loc4_.split("-");
            _loc5_ = _loc3_.split(":");
            _loc2_ = new Date(uint(_loc6_[0]),uint(_loc6_[1]) - 1,uint(_loc6_[2]),uint(_loc5_[0]),uint(_loc5_[1]));
            _loc12_ = _loc7_.ToDate.split(" ");
            _loc13_ = String(_loc12_[0]);
            _loc10_ = String(_loc12_[1]);
            _loc11_ = _loc13_.split("-");
            _loc14_ = _loc10_.split(":");
            _loc15_ = new Date(uint(_loc11_[0]),uint(_loc11_[1]) - 1,uint(_loc11_[2]),uint(_loc14_[0]),uint(_loc14_[1]));
            if(_loc2_.time <= _loc9_.time && _loc9_.time <= _loc15_.time)
            {
               if(_loc7_.dayArr.length > 0)
               {
                  return inLimitDay(_loc7_);
               }
               return true;
            }
         }
         return false;
      }
      
      public static function isStartFront(param1:uint) : Boolean
      {
         var _loc9_:Date = null;
         var _loc8_:Array = null;
         var _loc4_:String = null;
         var _loc3_:String = null;
         var _loc6_:Array = null;
         var _loc5_:Array = null;
         var _loc2_:Date = null;
         var _loc7_:TimeLimitInfo = getLimitTypeByID(param1);
         if(_loc7_)
         {
            _loc9_ = new Date(TimeManager.getServerTime() * 1000);
            _loc8_ = _loc7_.FromDate.split(" ");
            _loc4_ = String(_loc8_[0]);
            _loc3_ = String(_loc8_[1]);
            _loc6_ = _loc4_.split("-");
            _loc5_ = _loc3_.split(":");
            _loc2_ = new Date(uint(_loc6_[0]),uint(_loc6_[1]) - 1,uint(_loc6_[2]),uint(_loc5_[0]),uint(_loc5_[1]));
            if(_loc9_.time < _loc2_.time)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function inLimitDay(param1:TimeLimitInfo) : Boolean
      {
         var _loc9_:Date = null;
         var _loc8_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         var _loc5_:Date = null;
         var _loc2_:Date = null;
         var _loc7_:TimeLimitDay = GetLimitDay(param1.dayArr);
         if(_loc7_)
         {
            _loc9_ = new Date(TimeManager.getServerTime() * 1000);
            _loc8_ = uint(_loc7_.TimeStart.split(" ")[0]);
            _loc4_ = uint(_loc7_.TimeStart.split(" ")[1]);
            _loc3_ = uint(_loc7_.TimeEnd.split(" ")[0]);
            _loc6_ = uint(_loc7_.TimeEnd.split(" ")[1]);
            _loc5_ = new Date(_loc9_.fullYear,_loc9_.month,_loc9_.date,_loc8_,_loc4_);
            _loc2_ = new Date(_loc9_.fullYear,_loc9_.month,_loc9_.date,_loc3_,_loc6_);
            if(_loc5_.time <= _loc9_.time && _loc9_.time <= _loc2_.time)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function GetLimitDay(param1:Vector.<TimeLimitDay>) : TimeLimitDay
      {
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc4_:uint = _loc2_.day;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].WeekDay == _loc4_)
            {
               return param1[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
   }
}

