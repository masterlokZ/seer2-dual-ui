package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.PetDictionarySpeakListInfo;
   import org.taomee.ds.HashMap;
   
   public class PetDictionarySpeakListConfig
   {
      
      private static var _infos:HashMap;
      
      private static var _setting:Class = PetDictionarySpeakListConfig__setting;
      
      private static var _newPetIdList:Array = [];
      
      public function PetDictionarySpeakListConfig()
      {
         super();
      }
      
      public static function getNewPetId() : Array
      {
         var _loc1_:HashMap = getInfos();
         return _newPetIdList;
      }
      
      public static function getInfoData(param1:uint) : PetDictionarySpeakListInfo
      {
         var _loc2_:HashMap = getInfos();
         return _loc2_.getValue(param1);
      }
      
      public static function getPetIdList() : Vector.<int>
      {
         var _loc3_:PetDictionarySpeakListInfo = null;
         var _loc2_:HashMap = getInfos();
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc4_:Array = _loc2_.getValues();
         for each(_loc3_ in _loc4_)
         {
            _loc1_.push(_loc3_.petId);
         }
         return _loc1_;
      }
      
      private static function getInfos() : HashMap
      {
         if(_infos == null)
         {
            _infos = new HashMap();
            setup();
         }
         return _infos;
      }
      
      private static function setup() : void
      {
         var _loc2_:XML = null;
         var _loc1_:PetDictionarySpeakListInfo = null;
         var _loc4_:XML = XML(new _setting());
         _newPetIdList = String(_loc4_.@newPetId).split("|");
         var _loc3_:XMLList = _loc4_.child("pet");
         var _loc6_:uint = uint(_loc3_.length());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc6_)
         {
            _loc2_ = _loc3_[_loc5_];
            _loc1_ = new PetDictionarySpeakListInfo();
            _loc1_.petId = _loc2_.@id;
            _loc1_.frameIndex = _loc2_.@frame;
            _loc1_.fightIndex = _loc2_.@fightIndex;
            _loc1_.mapId = _loc2_.@mapId;
            _infos.add(_loc1_.petId,_loc1_);
            _loc5_++;
         }
      }
   }
}

