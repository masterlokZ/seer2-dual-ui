package com.taomee.seer2.core.net.message
{
   import flash.utils.ByteArray;
   import seer2.next.fcc.MDecrypt;
   import seer2.next.fcc.MEncrypt;
   
   public class MessageEncrypt
   {
      
      private static var NO_ENCRYPT_LEN:int = 6;
      
      public function MessageEncrypt()
      {
         super();
      }
      
      public static function encrypt(param1:ByteArray) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc2_:int = param1.readUnsignedInt() - NO_ENCRYPT_LEN;
         var _loc4_:int = int(param1.readUnsignedShort());
         _loc3_ = new ByteArray();
         _loc3_.endian = "littleEndian";
         _loc3_.writeUnsignedInt(0);
         _loc3_.writeShort(_loc4_);
         MEncrypt(param1,_loc2_,_loc3_);
         _loc3_.position = 0;
         _loc3_.writeUnsignedInt(_loc3_.length);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function decrypt(param1:ByteArray) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc2_:int = param1.readUnsignedInt() - NO_ENCRYPT_LEN;
         var _loc4_:int = int(param1.readUnsignedShort());
         _loc3_ = new ByteArray();
         _loc3_.endian = "littleEndian";
         _loc3_.writeUnsignedInt(0);
         _loc3_.writeShort(_loc4_);
         MDecrypt(param1,_loc2_,_loc3_);
         _loc3_.position = 0;
         _loc3_.writeUnsignedInt(_loc3_.length);
         _loc3_.position = 0;
         return _loc3_;
      }
   }
}

