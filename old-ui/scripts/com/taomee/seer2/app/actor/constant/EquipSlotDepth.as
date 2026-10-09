package com.taomee.seer2.app.actor.constant
{
   public class EquipSlotDepth
   {
      
      private static var _upDirDefinition:Vector.<uint> = Vector.<uint>([3,11,8,2,6,9,4,5,10,1,7]);
      
      private static var _downDirDefinition:Vector.<uint> = Vector.<uint>([7,2,6,9,4,5,8,1,10,3,11]);
      
      public function EquipSlotDepth()
      {
         super();
      }
      
      public static function getDepthByDirection(param1:uint, param2:uint) : int
      {
         if(param2 & 2)
         {
            return findDepthIndex(_upDirDefinition,param1);
         }
         return findDepthIndex(_downDirDefinition,param1);
      }
      
      private static function findDepthIndex(param1:Vector.<uint>, param2:uint) : int
      {
         var _loc4_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            if(param2 == param1[_loc3_])
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
   }
}

