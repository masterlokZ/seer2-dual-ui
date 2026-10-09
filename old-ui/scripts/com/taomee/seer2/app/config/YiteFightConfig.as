package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.YiteFightInfo;
   
   public class YiteFightConfig
   {
      
      private static var _xml:XML;
      
      private static var _infoVec:Vector.<YiteFightInfo>;
      
      private static var _xmlClass:Class = YiteFightConfig__xmlClass;
      
      setup();
      
      public function YiteFightConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc4_:YiteFightInfo = null;
         var _loc6_:XML = null;
         var _loc5_:uint = 0;
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         _xml = XML(new _xmlClass());
         _infoVec = Vector.<YiteFightInfo>([]);
         var _loc3_:XMLList = _xml.descendants("yite");
         for each(_loc6_ in _loc3_)
         {
            _loc4_ = new YiteFightInfo();
            _loc5_ = uint(_loc6_.attribute("index"));
            _loc2_ = uint(_loc6_.attribute("checkTime"));
            _loc1_ = uint(_loc6_.attribute("resId"));
            _loc4_.index = _loc5_;
            _loc4_.checkTime = _loc2_;
            _loc4_.resId = _loc1_;
            _infoVec.push(_loc4_);
         }
      }
      
      public static function getInfoVec() : Vector.<YiteFightInfo>
      {
         if(_infoVec.length < 1)
         {
            return null;
         }
         return _infoVec;
      }
   }
}

