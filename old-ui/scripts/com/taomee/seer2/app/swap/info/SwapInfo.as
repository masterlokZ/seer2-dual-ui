package com.taomee.seer2.app.swap.info
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import flash.utils.IDataInput;
   
   public class SwapInfo
   {
      
      private var _petID:uint;
      
      public var swapCoins:uint;
      
      public var itemID:uint;
      
      public var itemCount:uint;
      
      public var addSwapIdList:Vector.<uint>;
      
      public var addSwapIdCountList:Vector.<uint>;
      
      public var deleteSwapIdList:Vector.<uint>;
      
      public var deleteSwapCountList:Vector.<uint>;
      
      public function SwapInfo(param1:IDataInput, param2:Boolean = true)
      {
         super();
         if(param1 != null)
         {
            this.deleteItem(param1);
            this.addItem(param1,param2);
            this.addPet(param1);
            this.honor(param1,param2);
         }
      }
      
      private function deleteItem(param1:IDataInput) : void
      {
         var _loc5_:uint = 0;
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         this.deleteSwapIdList = Vector.<uint>([]);
         this.deleteSwapCountList = Vector.<uint>([]);
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedShort();
            _loc2_ = param1.readUnsignedInt();
            this.deleteSwapIdList.push(_loc5_);
            this.deleteSwapCountList.push(_loc3_);
            if(_loc5_ == 1)
            {
               ActorManager.actorInfo.coins -= _loc3_;
            }
            else
            {
               ItemManager.reduceItemQuantity(_loc5_,_loc3_);
            }
            _loc6_++;
         }
      }
      
      private function addItem(param1:IDataInput, param2:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = param1.readUnsignedInt();
         this.swapCoins = 0;
         this.addSwapIdList = Vector.<uint>([]);
         this.addSwapIdCountList = Vector.<uint>([]);
         var _loc6_:int = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_ = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedShort();
            _loc5_ = param1.readUnsignedInt();
            this.addSwapIdList.push(_loc4_);
            this.addSwapIdCountList.push(_loc3_);
            this.itemID = _loc4_;
            this.itemCount = _loc3_;
            if(ItemConfig.getItemDefinition(_loc4_) != null)
            {
               if(_loc4_ == 1)
               {
                  ActorManager.actorInfo.coins += _loc3_;
                  this.swapCoins = _loc3_;
                  if(param2)
                  {
                     AlertManager.showCoinsGainedAlert(_loc3_);
                  }
               }
               else if(!ItemConfig.getItemDefinition(_loc4_).isHide)
               {
                  ItemManager.addItem(_loc4_,_loc3_,_loc5_);
                  if(_loc4_ > 603000 && _loc4_ <= 610000 || _loc4_ >= 400266 && _loc4_ <= 400268)
                  {
                     if(param2)
                     {
                        ServerMessager.addMessage("恭喜你获得了" + _loc3_ + "个[" + ItemConfig.getItemName(_loc4_) + "]");
                     }
                  }
                  else if(param2 && this.itemID != 36 && _loc4_ != 37)
                  {
                     if(ItemConfig.getItemCategory(_loc4_) == 5)
                     {
                        AlertManager.showMedalGainedAlert(this.itemID);
                        if(ItemConfig.getMedalDefinition(this.itemID).title != "")
                        {
                           ServerMessager.addMessage("恭喜你获得了[" + ItemConfig.getMedalDefinition(this.itemID).title + "称号]");
                        }
                     }
                     else if(ItemConfig.getItemCategory(_loc4_) == 8)
                     {
                        AlertManager.showGetPetSpiritAlert(_loc4_,_loc3_);
                     }
                     else
                     {
                        AlertManager.showItemGainedAlert(_loc4_,_loc3_);
                     }
                  }
               }
            }
            _loc6_++;
         }
      }
      
      private function addPet(param1:IDataInput) : void
      {
         var _loc2_:uint = param1.readUnsignedInt();
         this._petID = param1.readUnsignedInt();
         if(_loc2_ != 0)
         {
            if(PetInfoManager.isBagFull() == true)
            {
               AlertManager.showGetPetInStorageAlert(_loc2_,1);
            }
            else
            {
               AlertManager.showGetPetInBagAlert(_loc2_,1);
            }
         }
      }
      
      public function getPetId() : uint
      {
         return this._petID;
      }
      
      private function honor(param1:IDataInput, param2:Boolean) : void
      {
         var _loc3_:PetInfo = null;
         var _loc6_:uint = param1.readUnsignedInt();
         var _loc5_:uint = param1.readUnsignedInt();
         var _loc4_:uint = param1.readUnsignedInt();
         if(_loc6_ != 0 && _loc5_ != 0)
         {
            _loc3_ = PetInfoManager.getPetInfoFromAllBag(_loc5_);
            if(_loc6_ > 700000 && _loc6_ <= 700999)
            {
               _loc3_.decorationId = _loc6_;
            }
            else if(_loc6_ >= 900001)
            {
               if(_loc3_)
               {
                  _loc3_.petRideChipId = _loc6_;
                  _loc3_.chipPutOnTime = _loc4_;
               }
            }
            else
            {
               _loc3_.emblemId = _loc6_;
            }
            if(param2)
            {
               if(_loc6_ <= 999999)
               {
                  AlertManager.showHonorAlert(_loc6_,1);
               }
            }
         }
      }
   }
}

