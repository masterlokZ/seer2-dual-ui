package org.taomee.utils
{
   public class BitUtil
   {
      
      public function BitUtil()
      {
         super();
      }
      
      public static function setBit(param1:uint, param2:int, param3:Boolean) : uint
      {
         if(param3)
         {
            param1 |= 1 << param2;
         }
         else
         {
            param1 &= ~(1 << param2);
         }
         return param1;
      }
      
      public static function toBitArray(param1:uint, param2:int) : Array
      {
         var _loc4_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            _loc4_[_loc3_] = Boolean(param1 & 1);
            param1 >>= 1;
            _loc3_++;
         }
         return _loc4_;
      }
      
      public static function getBit(param1:uint, param2:int) : Boolean
      {
         return param1 == (param1 | 1 << param2);
      }
   }
}

