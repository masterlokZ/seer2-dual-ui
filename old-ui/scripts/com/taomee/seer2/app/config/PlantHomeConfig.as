package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.PlantHomeInfo;
   
   public class PlantHomeConfig
   {
      
      private static var _xml:XML;
      
      private static var _infoVec:Vector.<PlantHomeInfo>;
      
      private static var _xmlClass:Class = PlantHomeConfig__xmlClass;
      
      setup();
      
      public function PlantHomeConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc5_:PlantHomeInfo = null;
         var _loc7_:XML = null;
         var _loc6_:uint = 0;
         var _loc2_:String = null;
         var _loc1_:String = null;
         var _loc3_:String = null;
         _xml = XML(new _xmlClass());
         _infoVec = Vector.<PlantHomeInfo>([]);
         var _loc4_:XMLList = _xml.descendants("item");
         for each(_loc7_ in _loc4_)
         {
            _loc5_ = new PlantHomeInfo();
            _loc6_ = uint(_loc7_.attribute("level"));
            _loc2_ = String(_loc7_.attribute("idList"));
            _loc1_ = String(_loc7_.attribute("countList"));
            _loc3_ = String(_loc7_.attribute("nextLevelSpecialList"));
            _loc5_.level = _loc6_;
            _loc5_.idList = _loc2_.split("|");
            _loc5_.countList = _loc1_.split("|");
            _loc5_.nextLevelSpecialList = _loc3_.split("|");
            _infoVec.push(_loc5_);
         }
      }
      
      public static function getinfoVec() : Vector.<PlantHomeInfo>
      {
         if(_infoVec.length < 1)
         {
            return null;
         }
         return _infoVec;
      }
      
      public static function getLevelInfo(param1:uint) : PlantHomeInfo
      {
         var _loc2_:PlantHomeInfo = null;
         for each(_loc2_ in _infoVec)
         {
            if(_loc2_.level == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

