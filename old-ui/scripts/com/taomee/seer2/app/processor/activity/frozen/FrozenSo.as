package com.taomee.seer2.app.processor.activity.frozen
{
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import flash.net.SharedObject;
   
   public class FrozenSo
   {
      
      public function FrozenSo()
      {
         super();
      }
      
      public static function setRewardNum(param1:uint) : void
      {
         var _loc3_:Array = null;
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("activity");
         var _loc4_:String = generateDateKey();
         _loc3_ = _loc2_.data[_loc4_];
         if(_loc3_ == null)
         {
            resetSharedObject(_loc2_,_loc4_);
            _loc3_ = _loc2_.data[_loc4_];
         }
         _loc3_.push(param1);
         _loc2_.flush();
      }
      
      public static function getRewardNum() : Array
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("activity");
         var _loc1_:String = generateDateKey();
         var _loc3_:Array = _loc2_.data[_loc1_];
         if(_loc3_ == null)
         {
            resetSharedObject(_loc2_,_loc1_);
            _loc3_ = _loc2_.data[_loc1_];
         }
         return _loc3_;
      }
      
      public static function clearSo() : void
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("activity");
         var _loc1_:String = generateDateKey();
         resetSharedObject(_loc2_,_loc1_);
      }
      
      private static function generateDateKey() : String
      {
         var _loc1_:Date = new Date();
         return _loc1_.fullYear + "_" + (_loc1_.month + 1) + "_" + _loc1_.date;
      }
      
      private static function resetSharedObject(param1:SharedObject, param2:String) : void
      {
         param1.clear();
         var _loc3_:Array = [];
         param1.data[param2] = _loc3_;
         param1.flush();
      }
   }
}

