package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.NewPetDicThisWeekInfo;
   import org.taomee.ds.HashMap;
   
   public class NewPetDicThisWeekListConfig
   {
      
      private static var _infos:HashMap;
      
      private static var _setting:Class = NewPetDicThisWeekListConfig__setting;
      
      private static var _newPetIdList:Array = [];
      
      public function NewPetDicThisWeekListConfig()
      {
         super();
      }
      
      public static function getPetIDForDic() : Vector.<int>
      {
         var _loc2_:NewPetDicThisWeekInfo = null;
         var _loc1_:int = 0;
         var _loc4_:HashMap = getInfos();
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc6_:Array = _loc4_.getValues();
         _loc3_.push(0);
         var _loc5_:Array = [];
         for each(_loc2_ in _loc6_)
         {
            _loc5_.push(_loc2_);
         }
         _loc5_.sort(sortPetIdForDic);
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc3_.push(_loc5_[_loc1_].petId);
            _loc1_++;
         }
         return _loc3_;
      }
      
      private static function sortPetIdForDic(param1:NewPetDicThisWeekInfo, param2:NewPetDicThisWeekInfo) : int
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
         var _loc1_:NewPetDicThisWeekInfo = null;
         var _loc4_:XML = XML(new _setting());
         _newPetIdList = String(_loc4_.@newPetId).split("|");
         var _loc3_:XMLList = _loc4_.child("pet");
         var _loc6_:uint = uint(_loc3_.length());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc6_)
         {
            _loc2_ = _loc3_[_loc5_];
            _loc1_ = new NewPetDicThisWeekInfo();
            _loc1_.petId = _loc2_.@id;
            _loc1_.index = int(_loc2_.@index);
            _infos.add(_loc1_.petId,_loc1_);
            _loc5_++;
         }
      }
   }
}

