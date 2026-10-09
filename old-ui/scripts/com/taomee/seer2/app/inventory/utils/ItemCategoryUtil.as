package com.taomee.seer2.app.inventory.utils
{
   import com.taomee.seer2.app.inventory.constant.ItemIdRange;
   
   public class ItemCategoryUtil
   {
      
      public function ItemCategoryUtil()
      {
         super();
      }
      
      public static function findItemCategoryByReferenceId(param1:uint) : int
      {
         if(checkInRange(param1,ItemIdRange.BASIC))
         {
            return 0;
         }
         if(checkInRange(param1,ItemIdRange.EQUIP))
         {
            return 1;
         }
         if(checkInRange(param1,ItemIdRange.PET_RELATE))
         {
            return 2;
         }
         if(checkInRange(param1,ItemIdRange.EMBLEM))
         {
            return 3;
         }
         if(checkInRange(param1,ItemIdRange.COLLECTION))
         {
            return 4;
         }
         if(checkInRange(param1,ItemIdRange.MEDAL))
         {
            return 5;
         }
         if(checkInRange(param1,ItemIdRange.SPECIAL_ITEM))
         {
            return 101;
         }
         if(checkInRange(param1,ItemIdRange.PET_SPIRT_TRAIN))
         {
            return 8;
         }
         return 4;
      }
      
      private static function checkInRange(param1:int, param2:Vector.<int>) : Boolean
      {
         if(param1 >= param2[0] && param1 <= param2[1])
         {
            return true;
         }
         return false;
      }
      
      public static function isMedal(param1:int) : Boolean
      {
         return ItemCategoryUtil.findItemCategoryByReferenceId(param1) == 5;
      }
      
      public static function isEmblem(param1:int) : Boolean
      {
         return ItemCategoryUtil.findItemCategoryByReferenceId(param1) == 3;
      }
   }
}

