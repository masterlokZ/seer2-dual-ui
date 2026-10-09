package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   import org.taomee.manager.EventManager;
   
   public class SetPetStorageStatusListener extends BaseBean
   {
      
      private static const PUT_TO_BAG_FLAG_ARR:Array = [1,3];
      
      public function SetPetStorageStatusListener()
      {
         super();
      }
      
      override public function start() : void
      {
         Connection.addCommandListener(CommandSet.PET_SET_STORAGE_STATUS_1020,this.onData);
         Connection.addCommandListener(CommandSet.CLI_SET_MON_STATUS_VIP_1260,this.onData1);
         Connection.addCommandListener(CommandSet.CLI_EXCHANGE_MON_BETWEEN_BAG_AND_VIP_BAG_1261,this.onData2);
         finish();
      }
      
      private function onData(param1:MessageEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc5_:PetInfo = null;
         var _loc4_:int = 0;
         var _loc6_:ByteArray = param1.message.getRawDataCopy();
         var _loc8_:uint = _loc6_.readUnsignedInt();
         var _loc7_:uint = _loc6_.readUnsignedInt();
         var _loc3_:int = int(_loc6_.readUnsignedByte());
         _loc2_ = PUT_TO_BAG_FLAG_ARR.indexOf(_loc3_) != -1;
         if(_loc2_ == true)
         {
            _loc4_ = int(_loc6_.readUnsignedInt());
            _loc5_ = new PetInfo();
            PetInfo.readPetInfo(_loc5_,_loc6_);
            if(_loc3_ == 3)
            {
               _loc5_.isInitialPet = true;
            }
            PetInfoManager.addPetInfo(_loc5_);
            PetInfoManager.dispatchEvent("petPutToBag",_loc5_);
            ServerMessager.addMessage(_loc5_.name + "已经放入精灵背包");
         }
         else
         {
            _loc5_ = PetInfoManager.getPetInfoFromBag(_loc7_);
            if(_loc5_ != null)
            {
               PetInfoManager.removePetInfoFromBagById(_loc7_);
               PetInfoManager.dispatchEvent("petPutToStorage",_loc5_);
               if(_loc7_ != 271 && _loc3_ != 5)
               {
                  ServerMessager.addMessage(_loc5_.name + "已经放入仓库");
               }
            }
         }
         PetInfoManager.setFirst(_loc8_);
         EventManager.dispatchEvent(new Event("PetReCount"));
      }
      
      private function onData1(param1:MessageEvent) : void
      {
         var _loc6_:int = 0;
         var _loc3_:PetInfo = null;
         var _loc2_:int = 0;
         var _loc4_:PetInfo = null;
         var _loc5_:ByteArray = param1.message.getRawDataCopy();
         var _loc7_:uint = _loc5_.readUnsignedInt();
         _loc6_ = int(_loc5_.readUnsignedByte());
         if(_loc6_ == 0)
         {
            _loc3_ = PetInfoManager.getPetInfoFromBagStorage(_loc7_);
            if(_loc3_ != null)
            {
               PetInfoManager.removePetInfoFromBagStorageById(_loc7_);
               PetInfoManager.dispatchEvent("petPutToStorage",_loc3_);
               if(_loc7_ != 271 && _loc6_ != 5)
               {
                  ServerMessager.addMessage(_loc3_.name + "已经放入仓库");
               }
            }
         }
         else
         {
            _loc2_ = int(_loc5_.readUnsignedInt());
            _loc3_ = new PetInfo();
            PetInfo.readPetInfo(_loc3_,_loc5_);
            _loc3_.isInStorageBag = true;
            PetInfoManager.addPetInfo1(_loc3_);
            _loc4_ = PetInfoManager.getPetInfoFromMap(_loc3_.catchTime);
            if(_loc4_)
            {
               _loc4_.isInStorageBag = true;
            }
            PetInfoManager.dispatchEvent("petPutToBagStorage",_loc3_);
            ServerMessager.addMessage(_loc3_.name + "已经放入精灵背包仓库");
         }
      }
      
      private function onData2(param1:MessageEvent) : void
      {
         var _loc2_:PetInfo = null;
         var _loc3_:ByteArray = param1.message.getRawDataCopy();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc4_:uint = _loc3_.readUnsignedInt();
         if(_loc5_ == 0 && _loc4_ != 0)
         {
            _loc2_ = PetInfoManager.getPetInfoFromBag(_loc4_);
            if(_loc2_ != null)
            {
               PetInfoManager.removePetInfoFromBagById(_loc4_);
               _loc2_.isInStorageBag = true;
               PetInfoManager.addPetInfo1(_loc2_);
               PetInfoManager.dispatchEvent("petBagStorageChange",null);
               ServerMessager.addMessage(_loc2_.name + "已经放入精灵背包仓库");
            }
         }
         else if(_loc5_ != 0 && _loc4_ == 0)
         {
            _loc2_ = PetInfoManager.getPetInfoFromBagStorage(_loc5_);
            if(_loc2_ != null)
            {
               PetInfoManager.removePetInfoFromBagStorageById(_loc5_);
               _loc2_.isInStorageBag = false;
               PetInfoManager.addPetInfo(_loc2_);
               PetInfoManager.dispatchEvent("petBagStorageChange",null);
               ServerMessager.addMessage(_loc2_.name + "已经放入精灵背包");
            }
         }
         else if(_loc5_ != 0 && _loc4_ != 0)
         {
            _loc2_ = PetInfoManager.getPetInfoFromBagStorage(_loc5_);
            if(_loc2_ != null)
            {
               PetInfoManager.removePetInfoFromBagStorageById(_loc5_);
               _loc2_.isInStorageBag = false;
               PetInfoManager.addPetInfo(_loc2_);
               _loc2_ = PetInfoManager.getPetInfoFromBag(_loc4_);
               if(_loc2_ != null)
               {
                  _loc2_.isInStorageBag = true;
                  PetInfoManager.addPetInfo1(_loc2_);
                  PetInfoManager.dispatchEvent("petBagStorageChange",null);
                  ServerMessager.addMessage("精灵交换成功哦!");
               }
            }
         }
         EventManager.dispatchEvent(new Event("PetReCount"));
      }
   }
}

