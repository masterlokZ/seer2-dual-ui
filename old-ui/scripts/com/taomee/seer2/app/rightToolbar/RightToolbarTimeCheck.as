package com.taomee.seer2.app.rightToolbar
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.rightToolbar.config.RightToolbarConfig;
   import com.taomee.seer2.app.rightToolbar.config.RightToolbarInfo;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import flash.utils.getDefinitionByName;
   import org.taomee.utils.BitUtil;
   
   public class RightToolbarTimeCheck
   {
      
      private static var _infoList:Vector.<RightToolbarInfo>;
      
      private static var _upInfoList:Vector.<RightToolbarInfo>;
      
      private static var _leftInfoList:Vector.<RightToolbarInfo>;
      
      private static var _isSortList:Boolean;
      
      private static var _currClearList:Vector.<RightToolbarInfo>;
      
      private static var _leftCurrClearList:Vector.<RightToolbarInfo>;
      
      private static var _upSendList:Vector.<RightToolbar> = Vector.<RightToolbar>([]);
      
      private static var _sendList:Vector.<RightToolbar> = Vector.<RightToolbar>([]);
      
      private static var _LeftSendList:Vector.<RightToolbar> = Vector.<RightToolbar>([]);
      
      private static var _sendInfoList:Vector.<RightToolbarInfo> = Vector.<RightToolbarInfo>([]);
      
      private static var _prevClearList:Vector.<RightToolbarInfo> = Vector.<RightToolbarInfo>([]);
      
      private static var _LeftPrevClearList:Vector.<RightToolbarInfo> = Vector.<RightToolbarInfo>([]);
      
      public function RightToolbarTimeCheck()
      {
         super();
      }
      
      public static function initList() : void
      {
         if(_isSortList == false)
         {
            _infoList = RightToolbarConfig.getInfoVec();
            _upInfoList = RightToolbarConfig.getUpVec();
            _leftInfoList = RightToolbarConfig.getLeftVec();
            _isSortList = true;
         }
      }
      
      public static function getServerBuf() : void
      {
         initList();
         ServerBufferManager.getServerBuffer(45,onGetServer);
      }
      
      private static function onGetServer(param1:ServerBuffer) : void
      {
         var server:ServerBuffer = param1;
         ActiveCountManager.requestActiveCount(205322,function(param1:uint, param2:uint):void
         {
            var _loc5_:RightToolbarInfo = null;
            var _loc4_:RightToolbarInfo = null;
            var _loc3_:RightToolbarInfo = null;
            for each(_loc5_ in _infoList)
            {
               _loc5_.showPointIndex = BitUtil.getBit(param2,_loc5_.sort) ? 1 : 0;
               if(_loc5_.bufIndex != -1)
               {
                  if(server.readDataAtPostion(_loc5_.bufIndex) == 1)
                  {
                     _loc5_.isBufOpen = true;
                  }
                  else
                  {
                     _loc5_.isBufOpen = false;
                  }
               }
               else
               {
                  _loc5_.isBufOpen = true;
               }
            }
            for each(_loc4_ in _upInfoList)
            {
               _loc4_.showPointIndex = BitUtil.getBit(param2,_loc4_.sort) ? 1 : 0;
            }
            for each(_loc3_ in _leftInfoList)
            {
               _loc3_.showPointIndex = BitUtil.getBit(param2,_loc3_.sort) ? 1 : 0;
               if(_loc3_.bufIndex != -1)
               {
                  if(server.readDataAtPostion(_loc3_.bufIndex) == 1)
                  {
                     _loc3_.isBufOpen = true;
                  }
                  else
                  {
                     _loc3_.isBufOpen = false;
                  }
               }
               else
               {
                  _loc3_.isBufOpen = true;
               }
            }
            updateRightToolbar();
            updateLeftRightToolbar();
         });
      }
      
      public static function openUIBuf(param1:int, param2:Boolean = true) : void
      {
         var _loc4_:RightToolbarInfo = null;
         var _loc3_:RightToolbarInfo = null;
         ServerBufferManager.updateServerBuffer(45,param1,1);
         for each(_loc4_ in _infoList)
         {
            if(_loc4_.bufIndex == param1)
            {
               _loc4_.isBufOpen = true;
               break;
            }
         }
         for each(_loc3_ in _leftInfoList)
         {
            if(_loc3_.bufIndex == param1)
            {
               _loc3_.isBufOpen = true;
               break;
            }
         }
         if(param2)
         {
            updateRightToolbar();
         }
      }
      
      public static function openLeftUIBuf(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:RightToolbarInfo = null;
         ServerBufferManager.updateServerBuffer(45,param1,1);
         for each(_loc3_ in _leftInfoList)
         {
            if(_loc3_.bufIndex == param1)
            {
               _loc3_.isBufOpen = true;
               break;
            }
         }
         if(param2)
         {
            updateLeftRightToolbar();
         }
      }
      
      public static function clearLeftUIBuf(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:RightToolbarInfo = null;
         ServerBufferManager.updateServerBuffer(45,param1,0);
         for each(_loc3_ in _leftInfoList)
         {
            if(_loc3_.bufIndex == param1)
            {
               _loc3_.isBufOpen = false;
               break;
            }
         }
         if(param2)
         {
            updateLeftRightToolbar();
         }
      }
      
      public static function updateLeftRightToolbar() : void
      {
         var _loc1_:RightToolbarInfo = null;
         _leftCurrClearList = Vector.<RightToolbarInfo>([]);
         for each(_loc1_ in _leftInfoList)
         {
            if(isTimeContent(_loc1_.startTime,_loc1_.endTime,_loc1_) && _loc1_.isBufOpen)
            {
               _leftCurrClearList.push(_loc1_);
            }
         }
         checkLeftNewList();
      }
      
      private static function checkLeftNewList() : void
      {
         if(_LeftPrevClearList.length == 0)
         {
            sendLeftList();
            return;
         }
         if(_LeftPrevClearList.length != _leftCurrClearList.length)
         {
            sendLeftList();
            return;
         }
         var _loc2_:Boolean = false;
         var _loc1_:int = 0;
         while(_loc1_ < _leftCurrClearList.length)
         {
            if(_leftCurrClearList[_loc1_].startTime != _LeftPrevClearList[_loc1_].startTime)
            {
               _loc2_ = true;
            }
            _loc1_++;
         }
         if(_loc2_)
         {
            sendLeftList();
         }
      }
      
      public static function clearUIBuf(param1:int, param2:Boolean = true) : void
      {
         var _loc4_:RightToolbarInfo = null;
         var _loc3_:RightToolbarInfo = null;
         ServerBufferManager.updateServerBuffer(45,param1,0);
         for each(_loc4_ in _infoList)
         {
            if(_loc4_.bufIndex == param1)
            {
               _loc4_.isBufOpen = false;
               break;
            }
         }
         for each(_loc3_ in _leftInfoList)
         {
            if(_loc3_.bufIndex == param1)
            {
               _loc3_.isBufOpen = false;
               break;
            }
         }
         if(param2)
         {
            updateRightToolbar();
         }
      }
      
      public static function updateRightToolbar() : void
      {
         var _loc2_:RightToolbarInfo = null;
         var _loc1_:RightToolbarInfo = null;
         for each(_loc2_ in _upInfoList)
         {
            sendUpClass(_loc2_);
         }
         _currClearList = Vector.<RightToolbarInfo>([]);
         for each(_loc1_ in _infoList)
         {
            if(isTimeContent(_loc1_.startTime,_loc1_.endTime,_loc1_) && _loc1_.isBufOpen)
            {
               _currClearList.push(_loc1_);
            }
         }
         checkNewList();
      }
      
      private static function checkNewList() : void
      {
         if(_prevClearList.length == 0)
         {
            sendList();
            return;
         }
         if(_prevClearList.length != _currClearList.length)
         {
            sendList();
            return;
         }
         var _loc2_:Boolean = false;
         var _loc1_:int = 0;
         while(_loc1_ < _currClearList.length)
         {
            if(_currClearList[_loc1_].startTime != _prevClearList[_loc1_].startTime)
            {
               _loc2_ = true;
            }
            _loc1_++;
         }
         if(_loc2_)
         {
            sendList();
         }
      }
      
      private static function sendLeftList() : void
      {
         var _loc1_:RightToolbarInfo = null;
         clearLeftClass();
         _LeftPrevClearList = Vector.<RightToolbarInfo>([]);
         for each(_loc1_ in _leftCurrClearList)
         {
            _LeftPrevClearList.push(_loc1_);
            sendLeftClass(_loc1_);
         }
      }
      
      private static function sendList() : void
      {
         var _loc1_:RightToolbarInfo = null;
         clearClass();
         _prevClearList = Vector.<RightToolbarInfo>([]);
         for each(_loc1_ in _currClearList)
         {
            _prevClearList.push(_loc1_);
            sendClass(_loc1_);
         }
      }
      
      public static function isTimeContent(param1:String, param2:String, param3:RightToolbarInfo = null) : Boolean
      {
         var _loc6_:Array = null;
         var _loc11_:Array = null;
         var _loc5_:uint = 0;
         var _loc8_:uint = 0;
         var _loc7_:uint = 0;
         var _loc12_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc9_:Date = new Date(TimeManager.getServerTime() * 1000);
         if(checkDay(param3,_loc9_.date) == false)
         {
            return false;
         }
         _loc6_ = param1.split("_");
         if(_loc6_[0] == "*")
         {
            _loc5_ = _loc9_.fullYear;
         }
         else
         {
            _loc5_ = uint(_loc6_[0]);
         }
         if(_loc6_[1] == "*")
         {
            _loc8_ = _loc9_.month + 1;
         }
         else
         {
            _loc8_ = uint(_loc6_[1]);
         }
         if(_loc6_[2] == "*")
         {
            _loc7_ = _loc9_.date;
         }
         else
         {
            _loc7_ = uint(_loc6_[2]);
         }
         var _loc4_:uint = uint(_loc6_[3]);
         var _loc13_:uint = uint(_loc6_[4]);
         var _loc14_:Number = new Date(_loc5_,_loc8_ - 1,_loc7_,_loc4_,_loc13_).getTime() / 1000;
         _loc11_ = param2.split("_");
         if(_loc11_[0] == "*")
         {
            _loc12_ = _loc9_.fullYear;
         }
         else
         {
            _loc12_ = uint(_loc11_[0]);
         }
         if(_loc6_[1] == "*")
         {
            _loc17_ = _loc9_.month + 1;
         }
         else
         {
            _loc17_ = uint(_loc11_[1]);
         }
         if(_loc11_[2] == "*")
         {
            _loc18_ = _loc9_.date;
         }
         else
         {
            _loc18_ = uint(_loc11_[2]);
         }
         var _loc15_:uint = uint(_loc11_[3]);
         var _loc16_:uint = uint(_loc11_[4]);
         var _loc10_:Number = new Date(_loc12_,_loc17_ - 1,_loc18_,_loc15_,_loc16_).getTime() / 1000;
         if(TimeManager.getServerTime() >= _loc14_ && TimeManager.getServerTime() < _loc10_)
         {
            return true;
         }
         return false;
      }
      
      private static function checkDay(param1:RightToolbarInfo, param2:Number) : Boolean
      {
         var _loc5_:Array = null;
         var _loc4_:Boolean = false;
         var _loc3_:int = 0;
         if(Boolean(param1) && param1.dayList != "")
         {
            _loc5_ = param1.dayList.split("|");
            _loc4_ = false;
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               if(Number(_loc5_[_loc3_]) == param2)
               {
                  _loc4_ = true;
               }
               _loc3_++;
            }
            return _loc4_;
         }
         return true;
      }
      
      private static function sendClass(param1:RightToolbarInfo) : void
      {
         var _loc2_:RightToolbar = null;
         var _loc3_:* = undefined;
         if(param1.classStr != "")
         {
            _loc3_ = getDefinitionByName("com.taomee.seer2.app.rightToolbar.toolbar." + param1.classStr);
            _loc2_ = new _loc3_() as RightToolbar;
         }
         else
         {
            _loc2_ = new RightToolbar();
         }
         _loc2_.init(param1);
         _sendList.push(_loc2_);
         var _loc4_:Vector.<String> = RightToolbarConfig.getRightRollList();
         if(_loc4_.indexOf(param1.sort.toString()) != -1)
         {
            RightToolbarConter.instance.addRollRightToolbar(_loc2_);
         }
         else if(RightToolbarConfig.getLeftRollList().indexOf(param1.sort.toString()) != -1)
         {
            RightToolbarConter.instance.addRollLeftToolbar(_loc2_);
         }
         else if(param1.type == "left")
         {
            RightToolbarConter.instance.addLeftToolbar(_loc2_,false);
         }
         else
         {
            RightToolbarConter.instance.addToolbar(_loc2_);
         }
      }
      
      private static function sendLeftClass(param1:RightToolbarInfo) : void
      {
         var _loc2_:RightToolbar = null;
         var _loc3_:* = undefined;
         if(param1.classStr != "")
         {
            _loc3_ = getDefinitionByName("com.taomee.seer2.app.rightToolbar.toolbar." + param1.classStr);
            _loc2_ = new _loc3_() as RightToolbar;
         }
         else
         {
            _loc2_ = new RightToolbar();
         }
         _loc2_.init(param1);
         _LeftSendList.push(_loc2_);
         if(RightToolbarConfig.getRightRollList().indexOf(param1.sort.toString()) != -1)
         {
            RightToolbarConter.instance.addRollRightToolbar(_loc2_);
         }
         else if(RightToolbarConfig.getLeftRollList().indexOf(param1.sort.toString()) != -1)
         {
            RightToolbarConter.instance.addRollLeftToolbar(_loc2_);
         }
         else if(param1.type == "left")
         {
            RightToolbarConter.instance.addLeftToolbar(_loc2_,false);
         }
      }
      
      private static function sendUpClass(param1:RightToolbarInfo) : void
      {
         var _loc2_:RightToolbar = null;
         var _loc3_:* = undefined;
         if(_sendInfoList.indexOf(param1) != -1)
         {
            return;
         }
         if(param1.classStr != "")
         {
            _loc3_ = getDefinitionByName("com.taomee.seer2.app.rightToolbar.toolbar." + param1.classStr);
            _loc2_ = new _loc3_() as RightToolbar;
         }
         else
         {
            _loc2_ = new RightToolbar();
         }
         _loc2_.init(param1);
         _upSendList.push(_loc2_);
         _sendInfoList.push(param1);
         if(RightToolbarConfig.getRightRollList().indexOf(param1.sort.toString()) != -1)
         {
            RightToolbarConter.instance.addRollRightToolbar(_loc2_);
         }
         else if(RightToolbarConfig.getLeftRollList().indexOf(param1.sort.toString()) != -1)
         {
            RightToolbarConter.instance.addRollLeftToolbar(_loc2_);
         }
         else
         {
            RightToolbarConter.instance.addUpToolbar(_loc2_);
         }
      }
      
      private static function clearUpClass(param1:RightToolbarInfo) : void
      {
         var _loc2_:int = _sendInfoList.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         RightToolbarConter.instance.removeUpToolbar(_sendList[_loc2_]);
         _upSendList.splice(_loc2_,1);
         _sendInfoList.splice(_loc2_,1);
      }
      
      private static function clearLeftClass() : void
      {
         var _loc1_:RightToolbar = null;
         for each(_loc1_ in _LeftSendList)
         {
            if(_loc1_.info.type == "left")
            {
               RightToolbarConter.instance.removeLeftToolbar(_loc1_);
            }
         }
         _LeftSendList = Vector.<RightToolbar>([]);
      }
      
      private static function clearClass() : void
      {
         var _loc1_:RightToolbar = null;
         for each(_loc1_ in _sendList)
         {
            if(_loc1_.info.type == "left")
            {
               RightToolbarConter.instance.removeLeftToolbar(_loc1_);
            }
            else
            {
               RightToolbarConter.instance.removeToolbar(_loc1_);
            }
         }
         _sendList = Vector.<RightToolbar>([]);
      }
   }
}

