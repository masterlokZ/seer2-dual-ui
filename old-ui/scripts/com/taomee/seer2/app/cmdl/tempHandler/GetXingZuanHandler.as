package com.taomee.seer2.app.cmdl.tempHandler
{
   import com.adobe.crypto.MD5;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1548;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   
   public class GetXingZuanHandler implements IHandler
   {
      
      public function GetXingZuanHandler()
      {
         super();
      }
      
      public function handle(param1:Parser_1548) : void
      {
         var _loc2_:int = 0;
         if(param1 && param1.eventDataVec && param1.eventDataVec.length > 0)
         {
            _loc2_ = int(param1.eventDataVec[0]);
            ServerMessager.addMessage("恭喜你获得" + _loc2_ + "个星钻");
         }
         Connection.send(CommandSet.CLI_MONEY_COUNT_1253,this.getResult());
      }
      
      private function getResult() : LittleEndianByteArray
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         var _loc4_:LittleEndianByteArray = new LittleEndianByteArray();
         var _loc3_:String = MD5.hash("0");
         var _loc6_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc2_ = _loc3_.substr(_loc5_,2);
            _loc1_ = parseInt(_loc2_,16);
            _loc4_.writeByte(_loc1_);
            _loc5_ += 2;
         }
         return _loc4_;
      }
   }
}

