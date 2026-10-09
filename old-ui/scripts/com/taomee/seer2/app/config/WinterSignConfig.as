package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.WinterSignInfo;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import org.taomee.ds.HashMap;
   
   public class WinterSignConfig
   {
      
      private static var _xml:XML;
      
      private static var _dayInfoList:Vector.<WinterSignInfo>;
      
      private static var _forInfoList:Vector.<WinterSignInfo>;
      
      public static var startTime:Array;
      
      public static var endTime:Array;
      
      public static var miBuyList:Array;
      
      public static var freeSign:Array;
      
      public static var par:Parser_1142;
      
      public static var info:DayLimitListInfo;
      
      private static var _xmlClass:Class = WinterSignConfig__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      public static var dayList:Array = [];
      
      public static var forList:Array = [];
      
      public static var swapList:Array = [];
      
      setup();
      
      public function WinterSignConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc7_:WinterSignInfo = null;
         var _loc10_:XML = null;
         var _loc9_:WinterSignInfo = null;
         var _loc4_:int = 0;
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc5_:String = null;
         var _loc1_:Array = null;
         var _loc16_:Vector.<uint> = null;
         var _loc18_:int = 0;
         var _loc13_:String = null;
         var _loc15_:Array = null;
         var _loc22_:Vector.<uint> = null;
         var _loc23_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc2_:Vector.<uint> = null;
         var _loc17_:String = null;
         var _loc19_:Array = null;
         var _loc14_:Vector.<uint> = null;
         _xml = XML(new _xmlClass());
         startTime = String(_xml.attribute("startTime")).split("-");
         endTime = String(_xml.attribute("endTime")).split("-");
         dayList = String(_xml.attribute("dayList")).split(",");
         forList = String(_xml.attribute("forList")).split(",");
         swapList = String(_xml.attribute("swapList")).split(",");
         miBuyList = String(_xml.attribute("miBuyList")).split(",");
         freeSign = String(_xml.attribute("freeSign")).split(",");
         _forInfoList = Vector.<WinterSignInfo>([]);
         var _loc8_:XMLList = _xml.descendants("forItem");
         for each(_loc10_ in _loc8_)
         {
            _loc7_ = new WinterSignInfo();
            _loc4_ = int(_loc10_.attribute("index"));
            _loc3_ = String(_loc10_.attribute("tip"));
            _loc6_ = int(_loc10_.attribute("totalWin"));
            _loc5_ = String(_loc10_.attribute("itemList"));
            _loc1_ = _loc5_.split(",");
            _loc16_ = Vector.<uint>([]);
            _loc18_ = 0;
            while(_loc18_ < _loc1_.length)
            {
               _loc16_.push(uint(_loc1_[_loc18_]));
               _loc18_++;
            }
            _loc13_ = String(_loc10_.attribute("itemCount"));
            _loc15_ = _loc13_.split(",");
            _loc22_ = Vector.<uint>([]);
            _loc23_ = 0;
            while(_loc23_ < _loc15_.length)
            {
               _loc22_.push(uint(_loc15_[_loc23_]));
               _loc23_++;
            }
            _loc7_.type = "for";
            _loc7_.index = _loc4_;
            _loc7_.tip = _loc3_;
            _loc7_.totalWin = _loc6_;
            _loc7_.countList = _loc22_;
            _loc7_.itemList = _loc16_;
            _forInfoList.push(_loc7_);
         }
         _dayInfoList = Vector.<WinterSignInfo>([]);
         _loc8_ = _xml.descendants("dayItem");
         for each(_loc10_ in _loc8_)
         {
            _loc9_ = new WinterSignInfo();
            _loc20_ = int(_loc10_.attribute("index"));
            _loc21_ = String(_loc10_.attribute("tip"));
            _loc11_ = String(_loc10_.attribute("itemList"));
            _loc12_ = _loc11_.split(",");
            _loc2_ = Vector.<uint>([]);
            _loc18_ = 0;
            while(_loc18_ < _loc12_.length)
            {
               _loc2_.push(uint(_loc12_[_loc18_]));
               _loc18_++;
            }
            _loc17_ = String(_loc10_.attribute("itemCount"));
            _loc19_ = _loc17_.split(",");
            _loc14_ = Vector.<uint>([]);
            _loc23_ = 0;
            while(_loc23_ < _loc19_.length)
            {
               _loc14_.push(uint(_loc19_[_loc23_]));
               _loc23_++;
            }
            _loc9_.type = "day";
            _loc9_.index = _loc20_;
            _loc9_.tip = _loc21_;
            _loc9_.countList = _loc14_;
            _loc9_.itemList = _loc2_;
            _dayInfoList.push(_loc9_);
         }
         _forInfoList.sort(forSort);
         _dayInfoList.sort(daySort);
      }
      
      private static function rankingSort(param1:WinterSignInfo, param2:WinterSignInfo) : int
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
      
      private static function daySort(param1:WinterSignInfo, param2:WinterSignInfo) : int
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
      
      private static function forSort(param1:WinterSignInfo, param2:WinterSignInfo) : int
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
      
      public static function getForInfoVec() : Vector.<WinterSignInfo>
      {
         if(_forInfoList.length < 1)
         {
            return null;
         }
         return _forInfoList;
      }
      
      public static function getDayInfoVec() : Vector.<WinterSignInfo>
      {
         if(_dayInfoList.length < 1)
         {
            return null;
         }
         return _dayInfoList;
      }
   }
}

