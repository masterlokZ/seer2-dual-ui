package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1065;
   import com.taomee.seer2.core.debugTools.MapPanelProtocolPanel;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class DayLimitListManager
   {
      
      private static var _isBusy:Boolean = false;
      
      private static var _callBack:Function;
      
      private static var _currentInfo:DayLimitListInfo;
      
      private static var _waitVec:Vector.<DayLimitListInfo> = new Vector.<DayLimitListInfo>();
      
      public function DayLimitListManager()
      {
         super();
      }
      
      public static function getDoCount(param1:LittleEndianByteArray, param2:Function) : void
      {
         var _loc3_:DayLimitListInfo = new DayLimitListInfo();
         _loc3_.data = param1;
         _loc3_.callBack = param2;
         _waitVec.push(_loc3_);
         if(_isBusy == false)
         {
            connectServer();
         }
      }
      
      public static function getDaylimitList(param1:Array, param2:Function) : void
      {
         var _loc3_:DayLimitListInfo = null;
         var _loc6_:LittleEndianByteArray = new LittleEndianByteArray();
         var _loc5_:uint = param1.length;
         _loc6_.writeUnsignedInt(_loc5_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.writeUnsignedInt(param1[_loc4_]);
            _loc4_++;
         }
         _loc3_ = new DayLimitListInfo();
         _loc3_.data = _loc6_;
         _loc3_.callBack = param2;
         _waitVec.push(_loc3_);
         if(_isBusy == false)
         {
            connectServer();
         }
      }
      
      private static function connectServer() : void
      {
         if(_waitVec.length >= 1)
         {
            _currentInfo = _waitVec.shift();
            _callBack = _currentInfo.callBack;
            Connection.addCommandListener(CommandSet.DAY_LIMIT_LIST_1241,onGetDoCount);
            Connection.addErrorHandler(CommandSet.DAY_LIMIT_LIST_1241,onGetDoCountError);
            Connection.send(CommandSet.DAY_LIMIT_LIST_1241,_currentInfo.data);
            _isBusy = true;
            MapPanelProtocolPanel.instance().addLog(4,"\n每日限制： " + CommandSet.DAY_LIMIT_LIST_1241.toString());
         }
      }
      
      private static function onGetDoCount(param1:MessageEvent) : void
      {
         var _loc2_:Parser_1065 = null;
         Connection.removeCommandListener(CommandSet.DAY_LIMIT_LIST_1241,onGetDoCount);
         Connection.removeErrorHandler(CommandSet.DAY_LIMIT_LIST_1241,onGetDoCountError);
         var _loc3_:IDataInput = param1.message.getRawData();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _currentInfo.dayLimitList.push(new Parser_1065(_loc3_));
            _loc4_++;
         }
         _callBack(_currentInfo);
         _callBack = null;
         _isBusy = false;
         connectServer();
         MapPanelProtocolPanel.instance().addLog(4,"\n每日限制：成功回包\n");
         _loc4_ = 0;
         while(_loc4_ < _currentInfo.dayLimitList.length)
         {
            _loc2_ = _currentInfo.dayLimitList[_loc4_] as Parser_1065;
            MapPanelProtocolPanel.instance().addLog(4,_loc2_.id + "=" + _loc2_.count + ";");
            if((_loc4_ + 1) % 3 == 0 && _loc4_ + 1 != _currentInfo.dayLimitList.length)
            {
               MapPanelProtocolPanel.instance().addLog(4,"\n");
            }
            else
            {
               MapPanelProtocolPanel.instance().addLog(4,"   \t");
            }
            _loc4_++;
         }
      }
      
      private static function onGetDoCountError(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.DAY_LIMIT_LIST_1241,onGetDoCount);
         Connection.removeErrorHandler(CommandSet.DAY_LIMIT_LIST_1241,onGetDoCountError);
         _isBusy = false;
         MapPanelProtocolPanel.instance().addLog(4,"\n每日限制：回包异常");
         connectServer();
      }
   }
}

