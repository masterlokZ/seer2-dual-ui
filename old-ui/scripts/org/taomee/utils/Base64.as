package org.taomee.utils
{
   import flash.utils.ByteArray;
   
   public class Base64
   {
      
      public static const version:String = "1.0.0";
      
      private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      
      public function Base64()
      {
         super();
         throw new Error("Base64 class is static container only");
      }
      
      public static function encode(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return encodeByteArray(_loc2_);
      }
      
      public static function encodeByteArray(param1:ByteArray) : String
      {
         var _loc7_:Array = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = "";
         var _loc6_:Array = new Array(4);
         param1.position = 0;
         while(param1.bytesAvailable > 0)
         {
            _loc7_ = [];
            _loc3_ = 0;
            while(_loc3_ < 3 && param1.bytesAvailable > 0)
            {
               _loc7_[_loc3_] = param1.readUnsignedByte();
               _loc3_++;
            }
            _loc6_[0] = (_loc7_[0] & 0xFC) >> 2;
            _loc6_[1] = (_loc7_[0] & 3) << 4 | _loc7_[1] >> 4;
            _loc6_[2] = (_loc7_[1] & 0x0F) << 2 | _loc7_[2] >> 6;
            _loc6_[3] = _loc7_[2] & 0x3F;
            _loc2_ = _loc7_.length;
            while(_loc2_ < 3)
            {
               _loc6_[_loc2_ + 1] = 64;
               _loc2_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               _loc5_ += "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".charAt(_loc6_[_loc4_]);
               _loc4_++;
            }
         }
         return _loc5_;
      }
      
      public static function decode(param1:String) : String
      {
         var _loc2_:ByteArray = decodeToByteArray(param1);
         return _loc2_.readUTFBytes(_loc2_.length);
      }
      
      public static function decodeToByteArray(param1:String) : ByteArray
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:ByteArray = new ByteArray();
         var _loc7_:Array = new Array(4);
         var _loc6_:Array = new Array(3);
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = 0;
            while(_loc2_ < 4 && _loc3_ + _loc2_ < param1.length)
            {
               _loc7_[_loc2_] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".indexOf(param1.charAt(_loc3_ + _loc2_));
               _loc2_++;
            }
            _loc6_[0] = (_loc7_[0] << 2) + ((_loc7_[1] & 0x30) >> 4);
            _loc6_[1] = ((_loc7_[1] & 0x0F) << 4) + ((_loc7_[2] & 0x3C) >> 2);
            _loc6_[2] = ((_loc7_[2] & 3) << 6) + _loc7_[3];
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               if(_loc7_[_loc4_ + 1] == 64)
               {
                  break;
               }
               _loc5_.writeByte(_loc6_[_loc4_]);
               _loc4_++;
            }
            _loc3_ += 4;
         }
         _loc5_.position = 0;
         return _loc5_;
      }
   }
}

