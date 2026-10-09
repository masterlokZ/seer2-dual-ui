package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.StoneInfo;
   import org.taomee.ds.HashMap;
   
   public class StoneConfig
   {
      
      private static var _configXML:XML;
      
      private static var _map:HashMap;
      
      private static var _minMap:HashMap;
      
      private static var _xmlClass:Class = StoneConfig__xmlClass;
      
      initialize();
      
      public function StoneConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _map = new HashMap();
         _minMap = new HashMap();
         setup();
      }
      
      private static function setup() : void
      {
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         var _loc5_:StoneInfo = null;
         var _loc2_:XML = null;
         var _loc1_:XMLList = null;
         _configXML = XML(new _xmlClass());
         var _loc4_:XMLList = _configXML.descendants("stoneTotal");
         for each(_loc2_ in _loc4_)
         {
            _loc5_ = new StoneInfo();
            _loc1_ = _loc2_.descendants("stone");
            _loc3_ = uint(_loc1_[0].@itemId);
            _loc6_ = uint(_loc1_[0].@petId);
            _loc5_.id = _loc3_;
            _loc5_.petId = _loc6_;
            _loc5_.list = initXML(_loc2_);
            _map.add(_loc3_,_loc5_);
         }
      }
      
      private static function initXML(param1:XML) : Array
      {
         var _loc5_:Array = null;
         var _loc3_:uint = 0;
         var _loc2_:XML = null;
         var _loc4_:XMLList = param1.descendants("stone");
         var _loc6_:Array = [];
         for each(_loc2_ in _loc4_)
         {
            _loc3_ = uint(_loc2_.@itemId);
            _loc5_ = [_loc3_,uint(_loc2_.@decoratinId),uint(_loc2_.@petId),uint(_loc2_.@swapId)];
            _loc6_.push(_loc5_);
         }
         _minMap.add(_loc3_,_loc6_);
         return _loc6_;
      }
      
      public static function formIdGetStoneInfo(param1:uint) : Array
      {
         return _minMap.getValue(param1);
      }
      
      public static function getInfo(param1:uint) : StoneInfo
      {
         return _map.getValue(param1);
      }
   }
}

