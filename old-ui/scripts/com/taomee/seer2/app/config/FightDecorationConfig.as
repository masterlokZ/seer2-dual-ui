package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.FightDecorationInfo;
   import org.taomee.ds.HashMap;
   
   public class FightDecorationConfig
   {
      
      private static var _xml:XML;
      
      private static var _xmlClass:Class = FightDecorationConfig__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      setup();
      
      public function FightDecorationConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc3_:FightDecorationInfo = null;
         var _loc5_:XML = null;
         var _loc4_:uint = 0;
         var _loc1_:String = null;
         var _loc2_:XMLList = _xml.descendants("fight");
         for each(_loc5_ in _loc2_)
         {
            _loc3_ = new FightDecorationInfo();
            _loc4_ = uint(_loc5_.attribute("petId"));
            _loc1_ = String(_loc5_.attribute("fightType"));
            _loc3_.petId = _loc4_;
            _loc3_.fightType = _loc1_;
            _map.add(_loc4_,_loc3_);
         }
      }
      
      public static function getInfo(param1:uint) : FightDecorationInfo
      {
         if(_map.containsKey(param1))
         {
            return _map.getValue(param1);
         }
         return null;
      }
   }
}

