package com.taomee.seer2.app.pet
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.data.PetItemInfo;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class PetItemUpdate
   {
      
      public function PetItemUpdate()
      {
         super();
      }
      
      public static function setup() : void
      {
         Connection.addCommandListener(CommandSet.UPDATE_PET_ITEM_INFO_1235,onUpdatePet);
      }
      
      private static function onUpdatePet(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            updatePetItem(_loc2_);
            _loc3_++;
         }
      }
      
      private static function updatePetItem(param1:IDataInput) : void
      {
         var _loc6_:PetInfo = null;
         var _loc3_:uint = 0;
         var _loc2_:PetItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:uint = param1.readUnsignedInt();
         var _loc7_:Vector.<PetInfo> = PetInfoManager.getTotalBagPetInfo();
         for each(_loc6_ in _loc7_)
         {
            if(_loc6_.catchTime == _loc5_)
            {
               _loc6_.itemList = Vector.<PetItemInfo>([]);
               _loc3_ = param1.readUnsignedInt();
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc2_ = new PetItemInfo();
                  _loc2_.itemId = param1.readUnsignedInt();
                  _loc2_.itemCurrCount = param1.readUnsignedInt();
                  _loc6_.itemList.push(_loc2_);
                  _loc4_++;
               }
               PetInfoManager.dispatchEvent("petFightItem",_loc6_);
               return;
            }
         }
      }
   }
}

