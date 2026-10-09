package com.taomee.seer2.core.net.message
{
   import flash.utils.ByteArray;
   import seer2.next.fcc.CLibInit;
   
   public class RequestPacker
   {
      
      private static var _sequenceNum:int = 0;
      
      private static var _descObj:Object;
      
      public function RequestPacker()
      {
         super();
      }
      
      public static function pack(param1:uint, param2:uint, param3:Array, param4:String = null) : ByteArray
      {
         var _loc6_:ByteArray = null;
         var _loc7_:ByteArray = null;
         if(param4 == null)
         {
            param4 = "littleEndian";
         }
         _loc6_ = new ByteArray();
         _loc6_.endian = param4;
         serializeBinary(_loc6_,param3);
         var _loc5_:ByteArray = packHead(param1,param2,_loc6_,_loc6_.length,param4);
         _loc7_ = new ByteArray();
         _loc7_.endian = param4;
         _loc7_.writeBytes(_loc5_);
         _loc7_.writeBytes(_loc6_);
         _loc7_.position = 0;
         return MessageEncrypt.encrypt(_loc7_);
      }
      
      private static function serializeBinary(param1:ByteArray, param2:Array) : void
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param2)
         {
            if(_loc3_ is Array)
            {
               serializeBinary(param1,_loc3_);
            }
            else if(_loc3_ is String)
            {
               param1.writeUTFBytes(_loc3_);
            }
            else if(_loc3_ is ByteArray)
            {
               param1.writeBytes(_loc3_);
            }
            else
            {
               param1.writeUnsignedInt(_loc3_);
            }
         }
      }
      
      private static function packHead(param1:uint, param2:uint, param3:ByteArray, param4:int, param5:String) : ByteArray
      {
         var _loc7_:ByteArray = null;
         var _loc8_:int = 0;
         var _loc6_:int = 0;
         _loc7_ = new ByteArray();
         _loc7_.endian = param5;
         _loc7_.writeUnsignedInt(18 + param4);
         _loc7_.writeShort(param2);
         _loc7_.writeUnsignedInt(param1);
         _loc7_.writeInt(generateNewSequenceNum(param2,18 + param4,_sequenceNum));
         var _loc9_:uint = 0;
         _loc7_.position = 0;
         _loc6_ = int(_loc7_.bytesAvailable);
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc9_ += _loc7_.readUnsignedByte();
            _loc8_++;
         }
         param3.position = 0;
         _loc6_ = param4;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc9_ += param3.readUnsignedByte();
            _loc8_++;
         }
         _loc9_ %= 100000;
         _loc7_.writeInt(_loc9_);
         return _loc7_;
      }
      
      private static function generateNewSequenceNum(param1:uint, param2:int, param3:int) : int
      {
         _sequenceNum = CLibInit.Desc(param1,param2,param3);
         return _sequenceNum;
      }
   }
}

