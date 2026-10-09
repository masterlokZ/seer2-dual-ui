package com.taomee.seer2.app.arena.record
{
   public class UUID
   {
      
      private static var _aUniqueIDs:Array;
      
      public function UUID()
      {
         super();
      }
      
      public static function floor(param1:Number, param2:Number = 1) : Number
      {
         return Math.floor(param1 / param2) * param2;
      }
      
      public static function random(param1:Number, param2:Number = 0, param3:Number = 1) : Number
      {
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1 > param2)
         {
            _loc4_ = param1;
            param1 = param2;
            param2 = _loc4_;
         }
         var _loc6_:Number = param2 - param1 + 1 * param3;
         _loc5_ = Math.random() * _loc6_;
         _loc5_ = _loc5_ + param1;
         return floor(_loc5_,param3);
      }
      
      public static function getUnique() : Number
      {
         if(_aUniqueIDs == null)
         {
            _aUniqueIDs = [];
         }
         var _loc2_:Date = new Date();
         var _loc1_:Number = _loc2_.getTime();
         while(!isUnique(_loc1_))
         {
            _loc1_ += UUID.random(_loc2_.getTime(),2 * _loc2_.getTime());
         }
         _aUniqueIDs.push(_loc1_);
         return _loc1_;
      }
      
      private static function isUnique(param1:Number) : Boolean
      {
         var _loc2_:Number = 0;
         while(_loc2_ < _aUniqueIDs.length)
         {
            if(_aUniqueIDs[_loc2_] == param1)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
   }
}

