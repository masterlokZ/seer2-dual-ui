package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.gameRule.fish.Fish;
   import org.taomee.ds.HashMap;
   
   public class FishConfig
   {
      
      private static var _xmlClass:Class = FishConfig__xmlClass;
      
      private static var fishMap:HashMap = new HashMap();
      
      initlize();
      
      public function FishConfig()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc4_:Fish = null;
         var _loc3_:XML = null;
         var _loc2_:XML = XML(new _xmlClass());
         var _loc1_:XMLList = _loc2_.child("fish");
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new Fish();
            _loc4_.id = _loc3_.@id;
            _loc4_.name = _loc3_.@name;
            _loc4_.description = _loc3_.@description;
            _loc4_.minWeight = _loc3_.@minWeight;
            _loc4_.maxWeight = _loc3_.@maxWeight;
            _loc4_.minLength = _loc3_.@minLength;
            _loc4_.maxLength = _loc3_.@maxLength;
            _loc4_.mapIds = String(_loc3_.@mapId).split(",");
            fishMap.add(_loc4_.id,_loc4_);
         }
      }
      
      public static function getFishDefiniation(param1:uint) : Fish
      {
         if(fishMap.containsKey(param1))
         {
            return fishMap.getValue(param1);
         }
         return null;
      }
      
      public static function getAllFishDefiniation() : Vector.<Fish>
      {
         return Vector.<Fish>(fishMap.getValues());
      }
   }
}

