package com.taomee.seer2.app.rarePet.config
{
   import com.taomee.seer2.app.rarePet.info.RarePetInfo;
   import com.taomee.seer2.app.rarePet.info.RarePetTimeInfo;
   import org.taomee.ds.HashMap;
   
   public class RarePetConfig
   {
      
      private static var _xml:XML;
      
      private static var _hashMap:HashMap;
      
      private static var _class:Class = RarePetConfig__class;
      
      setup();
      
      public function RarePetConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc5_:XML = null;
         var _loc8_:RarePetInfo = null;
         var _loc7_:XMLList = null;
         var _loc2_:XML = null;
         var _loc1_:RarePetTimeInfo = null;
         var _loc4_:String = null;
         var _loc3_:String = null;
         _hashMap = new HashMap();
         _xml = XML(new _class());
         var _loc6_:XMLList = _xml.descendants("pet");
         for each(_loc5_ in _loc6_)
         {
            _loc8_ = new RarePetInfo();
            _loc8_.index = int(_loc5_.attribute("index"));
            _loc8_.id = int(_loc5_.attribute("id"));
            _loc8_.name = _loc5_.attribute("name");
            _loc8_.level = int(_loc5_.attribute("level"));
            _loc8_.mapId = int(_loc5_.attribute("mapId"));
            _loc8_.intervalTime = int(_loc5_.attribute("intervalTime"));
            _loc8_.DayLimitType = int(_loc5_.attribute("DayLimitType"));
            _loc8_.DayMaxNum = int(_loc5_.attribute("DayMaxNum"));
            _loc7_ = _loc5_.descendants("Time");
            for each(_loc2_ in _loc7_)
            {
               _loc1_ = new RarePetTimeInfo();
               _loc1_.day = int(_loc2_.attribute("Day"));
               _loc4_ = _loc2_.attribute("startTime");
               _loc3_ = _loc2_.attribute("endTime");
               _loc1_.startTime = int(_loc4_.split(" ")[0]) * 60 + int(_loc4_.split(" ")[1]);
               _loc1_.endTime = int(_loc3_.split(" ")[0]) * 60 + int(_loc3_.split(" ")[1]);
               _loc8_.timeInfoMap.add(_loc1_.day,_loc1_);
            }
            _hashMap.add(_loc8_.id,_loc8_);
         }
      }
      
      public static function getRarePetInfo(param1:int) : RarePetInfo
      {
         return _hashMap.getValue(param1);
      }
      
      public static function getAllRarePetIds() : Vector.<int>
      {
         return Vector.<int>(_hashMap.getKeys());
      }
      
      public static function getAllRelatedMapIds() : Vector.<int>
      {
         var _loc3_:RarePetInfo = null;
         var _loc2_:Vector.<int> = new Vector.<int>();
         var _loc1_:Array = _hashMap.getValues();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.mapId != 0 && _loc2_.indexOf(_loc3_.mapId) == -1)
            {
               _loc2_.push(_loc3_.mapId);
            }
         }
         return _loc2_;
      }
   }
}

