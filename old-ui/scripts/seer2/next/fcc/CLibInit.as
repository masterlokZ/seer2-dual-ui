package seer2.next.fcc
{
   import flash.utils.ByteArray;
   
   public class CLibInit
   {
      
      public static const KEY_RAW:String = "taomee_seer2_k_~#t";
      
      public static const NO_ENCRYPT_LEN:int = 6;
      
      public static const KEY:Array = [116,97,111,109,101,101,95,115,101,101,114,50,95,107,95,126,35,116];
      
      public function CLibInit()
      {
         super();
      }
      
      public static function Desc(cid:uint, len:int, last_seq:int) : int
      {
         var t:int = last_seq / 7;
         return cid % 13 + len % 21 + last_seq + 147 - t;
      }
      
      public static function encrypt(bytes:ByteArray, outBytes:ByteArray) : void
      {
         outBytes.length = bytes.length + 1;
         var i:int = 0;
         var j:int = 6;
         var len:int = int(bytes.length);
         while(j < len)
         {
            if(i == KEY.length)
            {
               i = 0;
            }
            outBytes[j] = KEY[i] ^ bytes[j];
            i++;
            j++;
         }
         j = outBytes.length - 1;
         while(j > 6)
         {
            outBytes[j] |= (outBytes[j - 1] & 0xFF) >> 3;
            outBytes[j - 1] <<= 5;
            j--;
         }
         var _loc7_:int = 6;
         var _loc6_:int = outBytes[_loc7_] | 3;
         outBytes[_loc7_] = _loc6_;
      }
      
      public static function decrypt(bytes:ByteArray, outBytes:ByteArray) : void
      {
         outBytes.length = bytes.length - 1;
         var i:int = 0;
         var j:int = 6;
         var len:int = int(outBytes.length);
         while(j < len)
         {
            if(i == KEY.length)
            {
               i = 0;
            }
            outBytes[j] = (bytes[j] & 0xFF) >> 5 | bytes[j + 1] << 3;
            outBytes[j] ^= KEY[i];
            i++;
            j++;
         }
      }
   }
}

