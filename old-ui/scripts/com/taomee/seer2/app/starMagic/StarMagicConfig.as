package com.taomee.seer2.app.starMagic
{
   public class StarMagicConfig
   {
      
      private static var _xml:XML;
      
      private static var _starHunInfoVec:Vector.<StarInfo>;
      
      private static var _xmlClass:Class = StarMagicConfig__xmlClass;
      
      setup();
      
      public function StarMagicConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc7_:StarInfo = null;
         var _loc9_:XML = null;
         var _loc8_:String = null;
         var _loc3_:uint = 0;
         var _loc2_:String = null;
         var _loc5_:String = null;
         var _loc4_:String = null;
         var _loc1_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc10_:String = null;
         _xml = XML(new _xmlClass());
         _starHunInfoVec = Vector.<StarInfo>([]);
         var _loc6_:XMLList = _xml.descendants("runes");
         for each(_loc9_ in _loc6_)
         {
            _loc7_ = new StarInfo();
            _loc8_ = String(_loc9_.attribute("type"));
            _loc3_ = uint(_loc9_.attribute("max_lvl"));
            _loc2_ = String(_loc9_.attribute("name"));
            _loc5_ = String(_loc9_.attribute("value"));
            _loc4_ = String(_loc9_.attribute("lvl_cof"));
            _loc1_ = String(_loc9_.attribute("index"));
            _loc13_ = String(_loc9_.attribute("desc"));
            _loc14_ = String(_loc9_.attribute("needExp"));
            _loc11_ = String(_loc9_.attribute("effdesc"));
            _loc12_ = uint(_loc9_.attribute("buffSwf"));
            _loc17_ = String(_loc9_.attribute("effv"));
            _loc10_ = String(_loc9_.attribute("itemIcon"));
            _loc18_ = _loc14_.split(",");
            _loc7_.id = int(_loc1_);
            _loc7_.buffId = int(_loc1_);
            _loc7_.level_cof = int(_loc4_);
            _loc7_.maxLevel = int(_loc3_);
            _loc7_.sell_exp = int(_loc5_);
            _loc7_.type = int(_loc8_);
            _loc7_.nameT = _loc2_;
            _loc7_.nextExpArr = _loc18_;
            _loc7_.buffSwf = _loc12_;
            _loc7_.effdesc = _loc11_;
            _loc7_.desc = _loc13_.split(";");
            _loc7_.itemIcon = int(_loc10_);
            _loc18_ = _loc17_.split(";");
            _loc15_ = [];
            _loc16_ = 0;
            while(_loc16_ < _loc18_.length)
            {
               _loc15_.push(_loc18_[_loc16_].split(","));
               _loc16_++;
            }
            _loc7_.effvalue = _loc15_;
            _starHunInfoVec.push(_loc7_);
         }
      }
      
      public static function getInfoVec() : Vector.<StarInfo>
      {
         if(_starHunInfoVec.length < 1)
         {
            return null;
         }
         return _starHunInfoVec;
      }
      
      public static function getInfo(param1:int, param2:int) : StarInfo
      {
         if(_starHunInfoVec.length < 1)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _starHunInfoVec.length)
         {
            if(_starHunInfoVec[_loc3_].id == param1 && _starHunInfoVec[_loc3_].type == param2)
            {
               return _starHunInfoVec[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function getInfoById(param1:int) : StarInfo
      {
         if(_starHunInfoVec.length < 1)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _starHunInfoVec.length)
         {
            if(_starHunInfoVec[_loc2_].id == param1)
            {
               return _starHunInfoVec[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

