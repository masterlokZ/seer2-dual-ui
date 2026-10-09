package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.SeedGetInfo;
   import com.taomee.seer2.app.config.info.SeedInfo;
   import org.taomee.ds.HashMap;
   
   public class SeedConfig
   {
      
      private static var _xml:XML;
      
      private static var _hashMap:HashMap;
      
      private static var _class:Class = SeedConfig__class;
      
      setup();
      
      public function SeedConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc6_:SeedInfo = null;
         var _loc5_:XMLList = null;
         var _loc2_:XML = null;
         var _loc1_:SeedGetInfo = null;
         _hashMap = new HashMap();
         _xml = XML(new _class());
         var _loc4_:XMLList = _xml.descendants("Item");
         for each(_loc3_ in _loc4_)
         {
            _loc6_ = new SeedInfo();
            _loc6_.id = int(_loc3_.attribute("ID"));
            _loc6_.seedId = int(_loc3_.attribute("seed_id"));
            _loc6_.name = _loc3_.attribute("name");
            _loc6_.level = int(_loc3_.attribute("level"));
            _loc6_.harvestTime = int(_loc3_.attribute("harvest_time"));
            _loc6_.season = int(_loc3_.attribute("season"));
            _loc6_.shopType = int(_loc3_.attribute("shop_type"));
            _loc5_ = _loc3_.descendants("Item");
            _loc6_.getList = Vector.<SeedGetInfo>([]);
            for each(_loc2_ in _loc5_)
            {
               _loc1_ = new SeedGetInfo();
               _loc1_.id = int(_loc2_.attribute("id"));
               _loc1_.rate = int(_loc2_.attribute("rate"));
               _loc1_.stealRate = int(_loc2_.attribute("steal_rate"));
               _loc1_.num = int(_loc2_.attribute("num"));
               _loc6_.getList.push(_loc1_);
            }
            _hashMap.add(_loc6_.seedId,_loc6_);
         }
      }
      
      public static function getSeedInfo(param1:int) : SeedInfo
      {
         return _hashMap.getValue(param1);
      }
      
      public static function getAllSeedInfo() : Vector.<SeedInfo>
      {
         var _loc1_:Vector.<SeedInfo> = Vector.<SeedInfo>(_hashMap.getValues());
         _loc1_.sort(sortUpdate);
         return _loc1_;
      }
      
      private static function sortUpdate(param1:SeedInfo, param2:SeedInfo) : int
      {
         if(param1.id > param2.id)
         {
            return 1;
         }
         if(param1.id < param2.id)
         {
            return -1;
         }
         return 0;
      }
   }
}

