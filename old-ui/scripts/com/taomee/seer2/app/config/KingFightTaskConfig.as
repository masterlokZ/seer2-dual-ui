package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.KingFightTaskInfo;
   import org.taomee.ds.HashMap;
   
   public class KingFightTaskConfig
   {
      
      private static var _xml:XML;
      
      private static var _dayInfoList:Vector.<KingFightTaskInfo>;
      
      private static var _forInfoList:Vector.<KingFightTaskInfo>;
      
      private static var _xmlClass:Class = KingFightTaskConfig__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      public static var dayList:Array = [];
      
      public static var forList:Array = [];
      
      public static var swapList:Array = [];
      
      setup();
      
      public function KingFightTaskConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc7_:KingFightTaskInfo = null;
         var _loc10_:XML = null;
         var _loc9_:KingFightTaskInfo = null;
         var _loc4_:int = 0;
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc5_:String = null;
         var _loc1_:Array = null;
         var _loc17_:Vector.<uint> = null;
         var _loc19_:int = 0;
         var _loc13_:String = null;
         var _loc15_:Array = null;
         var _loc23_:Vector.<uint> = null;
         var _loc24_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:String = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc2_:Array = null;
         var _loc18_:Vector.<uint> = null;
         var _loc20_:String = null;
         var _loc14_:Array = null;
         var _loc16_:Vector.<uint> = null;
         _xml = XML(new _xmlClass());
         dayList = String(_xml.attribute("dayList")).split(",");
         forList = String(_xml.attribute("forList")).split(",");
         swapList = String(_xml.attribute("swapList")).split(",");
         _forInfoList = Vector.<KingFightTaskInfo>([]);
         var _loc8_:XMLList = _xml.descendants("forItem");
         for each(_loc10_ in _loc8_)
         {
            _loc7_ = new KingFightTaskInfo();
            _loc4_ = int(_loc10_.attribute("index"));
            _loc3_ = String(_loc10_.attribute("tip"));
            _loc6_ = int(_loc10_.attribute("totalWin"));
            _loc5_ = String(_loc10_.attribute("itemList"));
            _loc1_ = _loc5_.split(",");
            _loc17_ = Vector.<uint>([]);
            _loc19_ = 0;
            while(_loc19_ < _loc1_.length)
            {
               _loc17_.push(uint(_loc1_[_loc19_]));
               _loc19_++;
            }
            _loc13_ = String(_loc10_.attribute("itemCount"));
            _loc15_ = _loc13_.split(",");
            _loc23_ = Vector.<uint>([]);
            _loc24_ = 0;
            while(_loc24_ < _loc15_.length)
            {
               _loc23_.push(uint(_loc15_[_loc24_]));
               _loc24_++;
            }
            _loc7_.type = "for";
            _loc7_.index = _loc4_;
            _loc7_.tip = _loc3_;
            _loc7_.totalWin = _loc6_;
            _loc7_.countList = _loc23_;
            _loc7_.itemList = _loc17_;
            _forInfoList.push(_loc7_);
         }
         _dayInfoList = Vector.<KingFightTaskInfo>([]);
         _loc8_ = _xml.descendants("dayItem");
         for each(_loc10_ in _loc8_)
         {
            _loc9_ = new KingFightTaskInfo();
            _loc21_ = int(_loc10_.attribute("index"));
            _loc22_ = String(_loc10_.attribute("tip"));
            _loc11_ = int(_loc10_.attribute("totalWin"));
            _loc12_ = String(_loc10_.attribute("itemList"));
            _loc2_ = _loc12_.split(",");
            _loc18_ = Vector.<uint>([]);
            _loc19_ = 0;
            while(_loc19_ < _loc2_.length)
            {
               _loc18_.push(uint(_loc2_[_loc19_]));
               _loc19_++;
            }
            _loc20_ = String(_loc10_.attribute("itemCount"));
            _loc14_ = _loc20_.split(",");
            _loc16_ = Vector.<uint>([]);
            _loc24_ = 0;
            while(_loc24_ < _loc15_.length)
            {
               _loc16_.push(uint(_loc14_[_loc24_]));
               _loc24_++;
            }
            _loc9_.type = "day";
            _loc9_.index = _loc21_;
            _loc9_.tip = _loc22_;
            _loc9_.totalWin = _loc11_;
            _loc9_.countList = _loc16_;
            _loc9_.itemList = _loc18_;
            _dayInfoList.push(_loc9_);
         }
         _forInfoList.sort(forSort);
         _dayInfoList.sort(daySort);
      }
      
      private static function rankingSort(param1:KingFightTaskInfo, param2:KingFightTaskInfo) : int
      {
         if(param1.index > param2.index)
         {
            return 1;
         }
         if(param1.index < param2.index)
         {
            return -1;
         }
         return 0;
      }
      
      private static function daySort(param1:KingFightTaskInfo, param2:KingFightTaskInfo) : int
      {
         if(param1.index > param2.index)
         {
            return 1;
         }
         if(param1.index < param2.index)
         {
            return -1;
         }
         return 0;
      }
      
      private static function forSort(param1:KingFightTaskInfo, param2:KingFightTaskInfo) : int
      {
         if(param1.index > param2.index)
         {
            return 1;
         }
         if(param1.index < param2.index)
         {
            return -1;
         }
         return 0;
      }
      
      public static function getForInfoVec() : Vector.<KingFightTaskInfo>
      {
         if(_forInfoList.length < 1)
         {
            return null;
         }
         return _forInfoList;
      }
      
      public static function getDayInfoVec() : Vector.<KingFightTaskInfo>
      {
         if(_dayInfoList.length < 1)
         {
            return null;
         }
         return _dayInfoList;
      }
   }
}

