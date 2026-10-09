package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.PlanetInfo;
   
   public class PlanetConfig
   {
      
      private static var _configXML:XML;
      
      private static var _list:Vector.<PlanetInfo>;
      
      private static var _xmlClass:Class = PlanetConfig__xmlClass;
      
      setup();
      
      public function PlanetConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc4_:uint = 0;
         var _loc1_:PlanetInfo = null;
         var _loc3_:XML = null;
         _configXML = XML(new _xmlClass());
         var _loc5_:XMLList = _configXML.descendants("planet");
         var _loc7_:Array = [];
         var _loc6_:Array = [];
         var _loc2_:Array = [];
         _list = Vector.<PlanetInfo>([]);
         for each(_loc3_ in _loc5_)
         {
            _loc4_ = uint(_loc3_.@mapId);
            _loc7_ = String(_loc3_.@idList).split("|");
            _loc6_ = String(_loc3_.@swapList).split("|");
            _loc2_ = String(_loc3_.@tipList).split("|");
            _loc1_ = new PlanetInfo();
            _loc1_.mapId = _loc4_;
            _loc1_.idList = _loc7_;
            _loc1_.swapList = _loc6_;
            _loc1_.tipList = _loc2_;
            _list.push(_loc1_);
         }
      }
      
      public static function getInfo(param1:uint) : PlanetInfo
      {
         var _loc2_:PlanetInfo = null;
         var _loc3_:PlanetInfo = null;
         for each(_loc3_ in _list)
         {
            if(_loc3_.mapId == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public static function getTip(param1:uint) : String
      {
         var _loc2_:PlanetInfo = null;
         var _loc3_:int = 0;
         for each(_loc2_ in _list)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.idList.length)
            {
               if(param1 == _loc2_.idList[_loc3_])
               {
                  return _loc2_.tipList[_loc3_];
               }
               _loc3_++;
            }
         }
         return "";
      }
   }
}

