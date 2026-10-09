package com.taomee.seer2.app.inventory
{
   import com.taomee.seer2.app.inventory.item.CollectionItem;
   import com.taomee.seer2.app.inventory.item.EmblemItem;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.inventory.item.MedalItem;
   import com.taomee.seer2.app.inventory.item.PetItem;
   import com.taomee.seer2.app.inventory.item.PetSpirtTrainItem;
   import com.taomee.seer2.app.inventory.utils.ItemCategoryUtil;
   import com.taomee.seer2.core.inventory.Inventory;
   import com.taomee.seer2.core.inventory.Item;
   import org.taomee.ds.HashMap;
   
   internal class SeerIIInventory extends Inventory
   {
      
      private var _equipMap:HashMap;
      
      private var _petRelateMap:HashMap;
      
      private var _emblemMap:HashMap;
      
      private var _collectionMap:HashMap;
      
      private var _medalMap:HashMap;
      
      private var _petSpirtTrainMap:HashMap;
      
      public function SeerIIInventory()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._equipMap = new HashMap();
         this._petRelateMap = new HashMap();
         this._emblemMap = new HashMap();
         this._collectionMap = new HashMap();
         this._medalMap = new HashMap();
         this._petSpirtTrainMap = new HashMap();
      }
      
      public function addEquipItem(param1:EquipItem) : void
      {
         addItem(param1);
         this.addItemToMap(this._equipMap,param1);
      }
      
      public function removeEquip(param1:EquipItem) : void
      {
         removeItem(param1);
         this.removeItemFromMap(this._equipMap,param1.referenceId);
      }
      
      public function getEquipVec() : Vector.<EquipItem>
      {
         return Vector.<EquipItem>(this._equipMap.getValues());
      }
      
      public function getEquipItem(param1:int) : EquipItem
      {
         return this._equipMap.getValue(param1);
      }
      
      public function addPetItem(param1:PetItem) : void
      {
         addItem(param1);
         this.addItemToMap(this._petRelateMap,param1);
      }
      
      public function removePetItem(param1:PetItem) : void
      {
         removeItem(param1);
         this.removeItemFromMap(this._petRelateMap,param1.referenceId);
      }
      
      public function getPetRelateVec() : Vector.<PetItem>
      {
         return Vector.<PetItem>(this._petRelateMap.getValues());
      }
      
      public function getPetRelateItem(param1:int) : PetItem
      {
         return this._petRelateMap.getValue(param1);
      }
      
      public function addEmblemItem(param1:EmblemItem) : void
      {
         addItem(param1);
         this.addItemToMap(this._emblemMap,param1);
      }
      
      public function removeEmblemItem(param1:EmblemItem) : void
      {
         removeItem(param1);
         this.removeItemFromMap(this._emblemMap,param1.referenceId);
      }
      
      public function getEmblemVec() : Vector.<EmblemItem>
      {
         return Vector.<EmblemItem>(this._emblemMap.getValues());
      }
      
      public function addCollectionItem(param1:CollectionItem) : void
      {
         addItem(param1);
         this.addItemToMap(this._collectionMap,param1);
      }
      
      public function addPetSpirtTrainItem(param1:PetSpirtTrainItem) : void
      {
         addItem(param1);
         this.addItemToMap(this._petSpirtTrainMap,param1);
      }
      
      public function removeCollectionItem(param1:CollectionItem) : void
      {
         removeItem(param1);
         this.removeItemFromMap(this._collectionMap,param1.referenceId);
      }
      
      public function removePetSpirtTrainItem(param1:PetSpirtTrainItem) : void
      {
         removeItem(param1);
         this.removeItemFromMap(this._petSpirtTrainMap,param1.referenceId);
      }
      
      public function getCollectionVec() : Vector.<CollectionItem>
      {
         return Vector.<CollectionItem>(this._collectionMap.getValues());
      }
      
      public function getPetSpirtTrainVec() : Vector.<PetSpirtTrainItem>
      {
         return Vector.<PetSpirtTrainItem>(this._petSpirtTrainMap.getValues());
      }
      
      public function getCollection(param1:uint) : CollectionItem
      {
         return this._collectionMap.getValue(param1);
      }
      
      public function getPetSpirtTrain(param1:uint) : PetSpirtTrainItem
      {
         return this._petSpirtTrainMap.getValue(param1);
      }
      
      public function addMedalItem(param1:MedalItem) : void
      {
         addItem(param1);
         this.addItemToMap(this._medalMap,param1);
      }
      
      public function removeMedalItem(param1:MedalItem) : void
      {
         removeItem(param1);
         this.removeItemFromMap(this._medalMap,param1.referenceId);
      }
      
      public function getMedalVec() : Vector.<MedalItem>
      {
         return Vector.<MedalItem>(this._medalMap.getValues());
      }
      
      public function getItemArr() : Array
      {
         var _loc1_:Array = this._petRelateMap.getValues();
         _loc1_ = _loc1_.concat(this._emblemMap.getValues());
         _loc1_ = _loc1_.concat(this._collectionMap.getValues());
         return _loc1_.concat(this._medalMap.getValues());
      }
      
      private function addItemToMap(param1:HashMap, param2:Item) : void
      {
         if(param1.containsKey(param2.referenceId) == false)
         {
            param1.add(param2.referenceId,param2);
         }
      }
      
      private function removeItemFromMap(param1:HashMap, param2:int) : void
      {
         if(param1.containsKey(param2))
         {
            param1.remove(param2);
         }
         else
         {
            _logger.error("Item doesn\'t exist in this itemmap");
         }
      }
      
      override public function removeItemByReferenceId(param1:int) : void
      {
         var _loc2_:int = ItemCategoryUtil.findItemCategoryByReferenceId(param1);
         switch(_loc2_ - 1)
         {
            case 0:
               this.removeItemFromMap(this._equipMap,param1);
               break;
            case 1:
               this.removeItemFromMap(this._petRelateMap,param1);
               break;
            case 2:
               this.removeItemFromMap(this._emblemMap,param1);
               break;
            case 3:
               this.removeItemFromMap(this._collectionMap,param1);
               break;
            case 4:
               this.removeItemFromMap(this._medalMap,param1);
               break;
            case 7:
               this.removeItemFromMap(this._petSpirtTrainMap,param1);
         }
         removeItemByUniqueId(param1);
      }
      
      override public function reduceItemQuantity(param1:int, param2:int) : void
      {
         var _loc3_:int = getItemQuantityByUniqueId(param1);
         if(param2 >= _loc3_)
         {
            this.removeItemByReferenceId(param1);
         }
         else
         {
            super.reduceItemQuantity(param1,param2);
         }
      }
      
      public function clearEquip() : void
      {
         var _loc1_:EquipItem = null;
         var _loc2_:Vector.<EquipItem> = this.getEquipVec();
         for each(_loc1_ in _loc2_)
         {
            removeItem(_loc1_);
         }
         this._equipMap.clear();
      }
      
      public function clearItem() : void
      {
         var _loc1_:Item = null;
         var _loc2_:Array = this.getItemArr();
         for each(_loc1_ in _loc2_)
         {
            removeItem(_loc1_);
         }
         this._petRelateMap.clear();
         this._emblemMap.clear();
         this._collectionMap.clear();
         this._medalMap.clear();
         this._petSpirtTrainMap.clear();
      }
   }
}

