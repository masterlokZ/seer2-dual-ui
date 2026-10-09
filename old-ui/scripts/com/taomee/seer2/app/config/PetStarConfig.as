package com.taomee.seer2.app.config
{
   import org.taomee.ds.HashMap;
   
   public class PetStarConfig
   {
      
      private static var _xml:XML;
      
      private static var _xmlClass:Class = PetStarConfig__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      setup();
      
      public function PetStarConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:XML = null;
         var _loc6_:int = 0;
         var _loc5_:Array = null;
         var _loc2_:Vector.<uint> = null;
         var _loc1_:int = 0;
         _xml = XML(new _xmlClass());
         var _loc4_:XMLList = _xml.descendants("pet");
         for each(_loc3_ in _loc4_)
         {
            _loc6_ = int(_loc3_.attribute("level"));
            _loc5_ = _loc3_.attribute("idList").split(",");
            _loc2_ = Vector.<uint>([]);
            _loc1_ = 0;
            while(_loc1_ < _loc5_.length)
            {
               _loc2_.push(uint(_loc5_[_loc1_]));
               _loc1_++;
            }
            _map.add(_loc6_,_loc2_);
         }
      }
      
      public static function getStars(param1:int) : Vector.<uint>
      {
         return _map.getValue(param1);
      }
   }
}

