package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   
   public class OnlyFlagManager
   {
      
      private static const FLAG_MAX:int = 1024;
      
      private static var _isGetFlag:Boolean = false;
      
      private static var _callBack:Function;
      
      private static var _flagMap:HashMap = new HashMap();
      
      public function OnlyFlagManager()
      {
         super();
      }
      
      public static function RequestFlag(param1:Function = null) : void
      {
         _callBack = param1;
         if(_isGetFlag)
         {
            doCallBack();
         }
         else
         {
            Connection.addCommandListener(CommandSet.PET_REWARD_STATUS_1058,onGetFlag);
            Connection.send(CommandSet.PET_REWARD_STATUS_1058);
         }
      }
      
      private static function doCallBack() : void
      {
         if(_callBack != null)
         {
            _callBack();
            _callBack = null;
         }
      }
      
      private static function onGetFlag(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_REWARD_STATUS_1058,onGetFlag);
         var _loc2_:ByteArray = param1.message.getRawDataCopy();
         var _loc3_:int = 1;
         while(_loc3_ <= 1024)
         {
            _flagMap.add(_loc3_,readPosition(_loc2_,_loc3_));
            _loc3_++;
         }
         _isGetFlag = true;
         doCallBack();
      }
      
      private static function readPosition(param1:ByteArray, param2:int) : int
      {
         var _loc5_:int = Math.floor((param2 - 1) / 8);
         var _loc4_:int = (param2 - 1) % 8;
         param1.position = _loc5_;
         var _loc3_:int = int(param1.readUnsignedByte());
         if((_loc3_ | 1 << _loc4_) == _loc3_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function reset() : void
      {
         _isGetFlag = false;
         _flagMap.clear();
      }
      
      public static function getFlag(param1:int) : int
      {
         if(_flagMap.containsKey(param1))
         {
            return _flagMap.getValue(param1);
         }
         return 0;
      }
      
      public static function updataFlag(param1:int, param2:int) : void
      {
         _flagMap.add(param1,param2);
      }
   }
}

