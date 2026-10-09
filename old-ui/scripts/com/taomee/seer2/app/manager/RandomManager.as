package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.app.info.RandomInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1140;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   
   public class RandomManager
   {
      
      private static var _callBack:Function;
      
      private static var _isBusy:Boolean;
      
      private static var _currentInfo:RandomInfo;
      
      private static var _waitVec:Vector.<RandomInfo> = new Vector.<RandomInfo>();
      
      public function RandomManager()
      {
         super();
      }
      
      public static function getRandom(param1:uint, param2:Function, param3:Array = null) : void
      {
         var _loc4_:RandomInfo = null;
         _loc4_ = new RandomInfo();
         _loc4_.index = param1;
         if(param3)
         {
            _loc4_.data = param3;
         }
         _loc4_.callBack = param2;
         _waitVec.push(_loc4_);
         if(_isBusy == false)
         {
            connectServer();
         }
      }
      
      private static function connectServer() : void
      {
         var _loc2_:LittleEndianByteArray = null;
         var _loc1_:int = 0;
         if(_waitVec.length >= 1)
         {
            _currentInfo = _waitVec.shift();
            _callBack = _currentInfo.callBack;
            Connection.addCommandListener(CommandSet.RANDOM_EVENT_1140,onRandom);
            Connection.addErrorHandler(CommandSet.RANDOM_EVENT_1140,onError);
            _loc2_ = new LittleEndianByteArray();
            _loc2_.writeUnsignedInt(_currentInfo.index);
            _loc2_.writeUnsignedInt(_currentInfo.data.length);
            _loc1_ = 0;
            while(_loc1_ < _currentInfo.data.length)
            {
               _loc2_.writeUnsignedInt(_currentInfo.data[_loc1_]);
               _loc1_++;
            }
            Connection.send(CommandSet.RANDOM_EVENT_1140,_loc2_);
            _isBusy = true;
         }
      }
      
      private static function onError(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,onRandom);
         Connection.removeErrorHandler(CommandSet.RANDOM_EVENT_1140,onError);
         _isBusy = false;
         connectServer();
      }
      
      private static function onRandom(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,onRandom);
         Connection.removeErrorHandler(CommandSet.RANDOM_EVENT_1140,onError);
         var _loc2_:Parser_1140 = new Parser_1140(param1.message.getRawData());
         _callBack(_loc2_);
         _callBack = null;
         _isBusy = false;
         connectServer();
      }
   }
}

