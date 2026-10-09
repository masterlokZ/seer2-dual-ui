package com.taomee.seer2.app.serverBuffer
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   
   public class UpdateServerBufferList implements IUpdateServerBufferHandler
   {
      
      public var serverBufferType:int;
      
      public var day:int;
      
      public var vec:Vector.<int>;
      
      public function UpdateServerBufferList(param1:int, param2:int, param3:Vector.<int>)
      {
         super();
         this.serverBufferType = param1;
         this.day = param2;
         this.vec = param3;
      }
      
      public function updateServerBufferHandler(param1:ServerBuffer) : void
      {
         var _loc5_:int = 0;
         var _loc3_:LittleEndianByteArray = new LittleEndianByteArray();
         _loc3_.writeByte(this.day);
         _loc5_ = 50 - (this.vec.length + 1);
         var _loc4_:int = 0;
         while(_loc4_ < this.vec.length)
         {
            _loc3_.writeByte(this.vec[_loc4_]);
            _loc4_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_.writeByte(0);
            _loc2_++;
         }
         Connection.send(CommandSet.CLIENT_SET_BUFFER_INFO_1063,this.serverBufferType,_loc3_);
         this.serverBufferType = 0;
         this.day = 0;
         this.vec = null;
      }
   }
}

