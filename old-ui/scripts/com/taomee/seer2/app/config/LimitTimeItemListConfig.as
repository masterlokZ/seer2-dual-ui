package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.LimitTimeItemInfo;
   
   public class LimitTimeItemListConfig
   {
      
      private static var _xml:XML;
      
      private static var _infoVec:Vector.<LimitTimeItemInfo>;
      
      private static var _timeStr:String;
      
      private static var _xmlClass:Class = LimitTimeItemListConfig__xmlClass;
      
      setup();
      
      public function LimitTimeItemListConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc10_:LimitTimeItemInfo = null;
         var _loc11_:XML = null;
         var _loc4_:uint = 0;
         var _loc2_:Array = null;
         var _loc7_:Array = null;
         var _loc5_:uint = 0;
         var _loc1_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:uint = 0;
         _xml = XML(new _xmlClass());
         _infoVec = Vector.<LimitTimeItemInfo>([]);
         var _loc9_:XMLList = _xml.descendants("item");
         var _loc12_:XMLList = _xml.descendants("title");
         _timeStr = (_loc12_[0] as XML).attribute("time").toString();
         for each(_loc11_ in _loc9_)
         {
            _loc10_ = new LimitTimeItemInfo();
            _loc4_ = uint(_loc11_.attribute("id"));
            _loc2_ = String(_loc11_.attribute("startTime")).split("_");
            _loc7_ = String(_loc11_.attribute("endTime")).split("_");
            _loc5_ = uint(_loc11_.attribute("limitCount"));
            _loc1_ = uint(_loc11_.attribute("isNew"));
            _loc6_ = Number(_loc11_.attribute("prevPrice"));
            _loc8_ = Number(_loc11_.attribute("currPrice"));
            _loc3_ = uint(_loc11_.attribute("shopId"));
            _loc10_.id = _loc4_;
            _loc10_.startTime = _loc2_;
            _loc10_.endTime = _loc7_;
            _loc10_.limitCount = _loc5_;
            _loc10_.isNew = _loc1_;
            _loc10_.prevPrice = _loc6_;
            _loc10_.currPrice = _loc8_;
            _loc10_.shopId = _loc3_;
            _infoVec.push(_loc10_);
         }
      }
      
      public static function getInfoVec() : Vector.<LimitTimeItemInfo>
      {
         if(_infoVec.length < 1)
         {
            return null;
         }
         return _infoVec;
      }
      
      public static function getTitleStr() : String
      {
         return _timeStr;
      }
   }
}

