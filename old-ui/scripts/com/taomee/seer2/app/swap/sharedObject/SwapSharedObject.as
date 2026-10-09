package com.taomee.seer2.app.swap.sharedObject
{
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.swap.item.SwapItem;
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import flash.net.SharedObject;
   
   public class SwapSharedObject
   {
      
      private static var _instance:SwapSharedObject;
      
      private const DAY:int = 1;
      
      private const WEEK:int = 2;
      
      private const MONTH:int = 3;
      
      private const LIFETIME:int = 4;
      
      private var _swapItem:SwapItem;
      
      public function SwapSharedObject()
      {
         super();
      }
      
      public static function get instance() : SwapSharedObject
      {
         if(_instance == null)
         {
            _instance = new SwapSharedObject();
         }
         return _instance;
      }
      
      public function startCheck(param1:SwapItem) : Boolean
      {
         this._swapItem = param1;
         if(this.swapNumber() <= 0)
         {
            return false;
         }
         return true;
      }
      
      public function setRewardNum() : void
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("swap");
         var _loc1_:String = this.generateDateKey();
         var _loc4_:uint = this.generateMineKey();
         var _loc3_:Object = _loc2_.data[_loc1_][_loc4_];
         _loc3_.diggedNum += 1;
         SharedObjectManager.flush(_loc2_);
      }
      
      private function swapNumber() : int
      {
         var _loc1_:Object = null;
         var _loc4_:Boolean = false;
         var _loc3_:SharedObject = SharedObjectManager.getUserSharedObject("swap");
         var _loc2_:String = this.generateDateKey();
         var _loc5_:uint = this.generateMineKey();
         if(_loc3_.data[_loc2_] == null)
         {
            _loc3_.clear();
            _loc3_.data[_loc2_] = {};
            _loc4_ = true;
         }
         _loc1_ = _loc3_.data[_loc2_][_loc5_];
         if(_loc1_ == null)
         {
            _loc1_ = {};
            _loc1_.diggedNum = 0;
            _loc3_.data[_loc2_][_loc5_] = _loc1_;
            _loc4_ = true;
         }
         if(_loc4_)
         {
            SharedObjectManager.flush(_loc3_);
         }
         return this._swapItem.dayMaxNum - _loc1_.diggedNum;
      }
      
      private function generateDateKey() : String
      {
         var _loc1_:Date = new Date();
         switch(this._swapItem.timeLimit - 1)
         {
            case 0:
               return _loc1_.fullYear + "_" + (_loc1_.month + 1) + "_" + _loc1_.date;
            case 1:
               return String(_loc1_.day);
            case 2:
               return _loc1_.fullYear + "_" + (_loc1_.month + 1);
            case 3:
               return String(_loc1_.fullYear);
            default:
               return _loc1_.fullYear + "_" + _loc1_.month + "_" + _loc1_.date;
         }
      }
      
      private function generateMineKey() : uint
      {
         return Connection.netType + this._swapItem.swapId;
      }
   }
}

