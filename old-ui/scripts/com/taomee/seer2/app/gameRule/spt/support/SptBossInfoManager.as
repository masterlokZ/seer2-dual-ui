package com.taomee.seer2.app.gameRule.spt.support
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   
   public class SptBossInfoManager
   {
      
      public static const UNWIN:uint = 0;
      
      public static const WIN:uint = 1;
      
      public static const CATCH:uint = 2;
      
      public static const CHALLENGE_RULE_1:uint = 11;
      
      public static const CHALLENGE_RULE_2:uint = 12;
      
      private static var _callback:Function;
      
      public function SptBossInfoManager()
      {
         super();
      }
      
      public static function getSptBossInfo(param1:Function) : void
      {
         _callback = param1;
         Connection.addCommandListener(CommandSet.SPT_GET_INFO_1059,onGetBossInfo);
         Connection.send(CommandSet.SPT_GET_INFO_1059);
      }
      
      private static function onGetBossInfo(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.SPT_GET_INFO_1059,onGetBossInfo);
         var _loc2_:LittleEndianByteArray = param1.message.getRawData();
         _callback(_loc2_);
      }
      
      public static function resolveSpt(param1:uint, param2:LittleEndianByteArray) : uint
      {
         var _loc4_:uint = 0;
         var _loc3_:int = 0;
         var _loc6_:uint = param2.readUnsignedInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param2.readUnsignedInt();
            _loc3_ = int(param2.readUnsignedByte());
            if(param1 == _loc4_)
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return 0;
      }
      
      public static function getSptCount(param1:LittleEndianByteArray) : uint
      {
         var _loc3_:uint = 0;
         var _loc2_:int = 0;
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc6_:uint = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.readUnsignedInt();
            _loc2_ = int(param1.readUnsignedByte());
            if(_loc2_ == 2)
            {
               _loc6_ += 1;
            }
            if(_loc2_ == 11)
            {
               _loc6_ += 2;
            }
            else if(_loc2_ == 12)
            {
               _loc6_ += 3;
            }
            _loc5_++;
         }
         return _loc6_;
      }
   }
}

