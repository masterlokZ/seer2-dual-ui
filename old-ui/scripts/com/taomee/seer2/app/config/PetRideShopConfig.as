package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.PetRideShopInfo;
   import org.taomee.ds.HashMap;
   
   public class PetRideShopConfig
   {
      
      private static var _infos:HashMap;
      
      private static var _setting:Class = PetRideShopConfig__setting;
      
      public function PetRideShopConfig()
      {
         super();
      }
      
      public static function getInfoList() : Vector.<PetRideShopInfo>
      {
         var _loc3_:PetRideShopInfo = null;
         var _loc2_:HashMap = getInfos();
         var _loc1_:Array = _loc2_.getValues();
         var _loc4_:Vector.<PetRideShopInfo> = new Vector.<PetRideShopInfo>();
         for each(_loc3_ in _loc1_)
         {
            _loc4_.push(_loc3_);
         }
         _loc4_.sort(sortFunction);
         return _loc4_;
      }
      
      public static function getMiBiList() : Vector.<PetRideShopInfo>
      {
         var _loc3_:PetRideShopInfo = null;
         var _loc2_:HashMap = getInfos();
         var _loc1_:Array = _loc2_.getValues();
         var _loc4_:Vector.<PetRideShopInfo> = new Vector.<PetRideShopInfo>();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isCostMiBi == 1)
            {
               _loc4_.push(_loc3_);
            }
         }
         _loc4_.sort(sortFunction);
         return _loc4_;
      }
      
      public static function getFreeList() : Vector.<PetRideShopInfo>
      {
         var _loc3_:PetRideShopInfo = null;
         var _loc2_:HashMap = getInfos();
         var _loc1_:Array = _loc2_.getValues();
         var _loc4_:Vector.<PetRideShopInfo> = new Vector.<PetRideShopInfo>();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isCostMiBi == 0)
            {
               _loc4_.push(_loc3_);
            }
         }
         _loc4_.sort(sortFunction);
         return _loc4_;
      }
      
      public static function getFreeChipIdByPetId(param1:int) : int
      {
         var _loc2_:Vector.<PetRideShopInfo> = getFreeList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].petResourceId == param1)
            {
               return _loc2_[_loc3_].chipId;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public static function getMiBiChipIdByPetId(param1:int) : int
      {
         var _loc2_:Vector.<PetRideShopInfo> = getMiBiList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].petResourceId == param1)
            {
               return _loc2_[_loc3_].chipId;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public static function getEquipIdByPetId(param1:int) : int
      {
         var _loc2_:Vector.<PetRideShopInfo> = getInfoList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].petResourceId == param1)
            {
               return _loc2_[_loc3_].equipId;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public static function isCanRidePet(param1:int) : Boolean
      {
         var _loc2_:Vector.<PetRideShopInfo> = getInfoList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].petResourceId == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function getSwapIdByItemId(param1:int) : int
      {
         var _loc2_:Vector.<PetRideShopInfo> = getInfoList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].chipId == param1)
            {
               return _loc2_[_loc3_].swapId;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public static function getEquipIdByChipBackId(param1:int) : int
      {
         var _loc2_:Vector.<PetRideShopInfo> = getInfoList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].chipBackId == param1)
            {
               return _loc2_[_loc3_].equipId;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public static function isRidePetEquip(param1:int) : Boolean
      {
         var _loc2_:Vector.<PetRideShopInfo> = getInfoList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].equipId == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function isRidePetBunch(param1:int) : Boolean
      {
         var _loc2_:Vector.<PetRideShopInfo> = getInfoList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].bunchId == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function isThisPetOfThisChip(param1:int, param2:int) : Boolean
      {
         var _loc4_:Vector.<PetRideShopInfo> = getInfoList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_.length)
         {
            if(_loc4_[_loc3_].chipId == param1 && _loc4_[_loc3_].petResourceId == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private static function getInfos() : HashMap
      {
         if(_infos == null)
         {
            _infos = new HashMap();
            setUp();
         }
         return _infos;
      }
      
      private static function setUp() : void
      {
         var _loc5_:XML = null;
         var _loc2_:PetRideShopInfo = null;
         var _loc4_:XML = XML(new _setting());
         var _loc3_:XMLList = _loc4_.child("pet");
         var _loc6_:int = _loc3_.length();
         var _loc1_:int = 0;
         while(_loc1_ < _loc6_)
         {
            _loc5_ = _loc3_[_loc1_];
            _loc2_ = new PetRideShopInfo();
            _loc2_.chipId = int(_loc5_.@chipId);
            _loc2_.chipBackId = int(_loc5_.@chipBackId);
            _loc2_.index = int(_loc5_.@index);
            _loc2_.petResourceId = int(_loc5_.@petResourceId);
            _loc2_.bunchId = int(_loc5_.@petBunchId);
            _loc2_.equipId = int(_loc5_.@equipId);
            _loc2_.chipName = String(_loc5_.@name);
            _loc2_.isCostMiBi = int(_loc5_.@mibi);
            _loc2_.swapId = int(_loc5_.@swapId);
            _loc2_.getPetType = String(_loc5_.@getPetType);
            _loc2_.whereToGet = String(_loc5_.@whereToGet);
            _infos.add(_loc2_.chipId,_loc2_);
            _loc1_++;
         }
      }
      
      private static function sortFunction(param1:PetRideShopInfo, param2:PetRideShopInfo) : int
      {
         if(param1.index > param2.index)
         {
            return 1;
         }
         if(param1.index < param2.index)
         {
            return -1;
         }
         return 0;
      }
   }
}

