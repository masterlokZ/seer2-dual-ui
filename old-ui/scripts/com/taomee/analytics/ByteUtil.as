package com.taomee.analytics
{
   import flash.utils.ByteArray;
   
   internal class ByteUtil
   {
      
      public function ByteUtil()
      {
         super();
      }
      
      public static function toString(param1:ByteArray) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         var _loc4_:uint = param1.position;
         param1.position = 0;
         while(param1.bytesAvailable)
         {
            _loc3_ = param1.readUnsignedByte().toString(16);
            _loc2_ += _loc3_.length == 1 ? "0" + _loc3_ : _loc3_;
         }
         param1.position = _loc4_;
         return _loc2_;
      }
   }
}

