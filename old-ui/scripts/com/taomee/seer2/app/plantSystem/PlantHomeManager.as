package com.taomee.seer2.app.plantSystem
{
   public class PlantHomeManager
   {
      
      public static var homeLevel:uint;
      
      public static var plantList:Vector.<PlantLand>;
      
      public function PlantHomeManager()
      {
         super();
      }
      
      public static function getOpenCount() : uint
      {
         var _loc1_:PlantLand = null;
         var _loc2_:uint = 0;
         for each(_loc1_ in plantList)
         {
            if(_loc1_.info.plantIsOpen != 0 && _loc1_.info.plantIsVip != 1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public static function getVipOpenCount() : uint
      {
         var _loc1_:PlantLand = null;
         var _loc2_:uint = 0;
         for each(_loc1_ in plantList)
         {
            if(Boolean(_loc1_.info.plantIsOpen) && _loc1_.info.plantIsVip == 1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
   }
}

