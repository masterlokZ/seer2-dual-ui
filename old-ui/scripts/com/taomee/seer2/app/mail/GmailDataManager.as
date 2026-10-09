package com.taomee.seer2.app.mail
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.controls.ActorAvatarPanel;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.events.EventDispatcher;
   import flash.utils.IDataInput;
   
   public class GmailDataManager extends EventDispatcher
   {
      
      private static var _instance:GmailDataManager;
      
      private var dataList:Vector.<GmailDataObj>;
      
      private var _isSorting:Boolean;
      
      private var _sortType:int = 1;
      
      private var _initDataCompleted:Boolean;
      
      private var initOverFunc:Function;
      
      private var _waitList:Array = [];
      
      private var _isRequesting:Boolean = false;
      
      private var _successBack:Function;
      
      private var _requestId:int;
      
      public function GmailDataManager(param1:InterClass)
      {
         super();
      }
      
      public static function getInstance() : GmailDataManager
      {
         if(_instance == null)
         {
            _instance = new GmailDataManager(new InterClass());
         }
         return _instance;
      }
      
      public function initMailData(param1:Function = null) : void
      {
         this.initOverFunc = param1;
         this.dataList = new Vector.<GmailDataObj>();
         Connection.addCommandListener(CommandSet.GET_MAIL_LIST_DATA,this.onGetMailList);
         Connection.send(CommandSet.GET_MAIL_LIST_DATA,ActorManager.actorInfo.id);
      }
      
      public function updateMailNum() : void
      {
         this.initMailData(function():void
         {
            var _loc3_:int = 0;
            var _loc2_:int = 0;
            var _loc1_:Vector.<GmailDataObj> = GmailDataManager.getInstance().getAllData();
            if(Boolean(_loc1_) && _loc1_.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc1_.length)
               {
                  if(_loc1_[_loc3_].readSymble == false)
                  {
                     _loc2_++;
                  }
                  _loc3_++;
               }
            }
            ActorAvatarPanel.getInstance().setMailStatus(_loc2_);
         });
      }
      
      private function onGetMailList(param1:MessageEvent) : void
      {
         var _loc3_:GmailDataObj = null;
         var _loc2_:int = 0;
         Connection.removeCommandListener(CommandSet.GET_MAIL_LIST_DATA,this.onGetMailList);
         var _loc4_:IDataInput = param1.message.getRawData();
         var _loc6_:int = int(_loc4_.readUnsignedInt());
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = new GmailDataObj();
            _loc3_.mailId = _loc4_.readUnsignedInt();
            _loc3_.rawSendTime = _loc4_.readUnsignedInt();
            _loc2_ = int(_loc4_.readUnsignedInt());
            _loc3_.readSymble = _loc2_ == 1 ? true : false;
            _loc3_.type = _loc4_.readUnsignedInt();
            _loc3_.attachmentSymble = _loc4_.readUnsignedInt() == 1;
            _loc3_.senderId = _loc4_.readUnsignedInt();
            _loc3_.senderName = _loc4_.readUTFBytes(_loc4_.readUnsignedInt());
            _loc3_.mailTitle = _loc4_.readUTFBytes(_loc4_.readUnsignedInt());
            this.dataList.push(_loc3_);
            _loc5_++;
         }
         this.sortByType(1,false);
         this._initDataCompleted = true;
         if(this.initOverFunc != null)
         {
            this.initOverFunc();
            this.initOverFunc = null;
         }
      }
      
      public function get initDataCompleted() : Boolean
      {
         return this._initDataCompleted;
      }
      
      public function saveSingleData(param1:GmailDataObj) : void
      {
         if(this.dataList == null)
         {
            this.dataList = new Vector.<GmailDataObj>();
         }
         this.dataList.unshift(param1);
      }
      
      public function getAllData() : Vector.<GmailDataObj>
      {
         return this.dataList;
      }
      
      public function getMailDataById(param1:int) : GmailDataObj
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.dataList.length)
         {
            if(this.dataList[_loc2_].mailId == param1)
            {
               return this.dataList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getFullInfoFromServer(param1:int, param2:Function) : void
      {
         this._waitList.push({
            "id":param1,
            "success":param2
         });
         this.processNext();
      }
      
      private function processNext() : void
      {
         var _loc1_:Object = null;
         if(this._waitList.length > 0 && this._isRequesting == false)
         {
            this._isRequesting = true;
            _loc1_ = this._waitList.shift();
            this._requestId = _loc1_.id;
            this._successBack = _loc1_.success;
            Connection.addCommandListener(CommandSet.GET_SINGLE_MAIL_DATA,this.onGetMailFullData);
            Connection.send(CommandSet.GET_SINGLE_MAIL_DATA,ActorManager.actorInfo.id,int(_loc1_.id));
         }
      }
      
      private function onGetMailFullData(param1:MessageEvent) : void
      {
         var _loc2_:GmailAttachInfo = null;
         Connection.removeCommandListener(CommandSet.GET_SINGLE_MAIL_DATA,this.onGetMailFullData);
         var _loc4_:GmailDataObj = new GmailDataObj();
         var _loc6_:IDataInput = param1.message.getRawData();
         _loc4_.mailId = _loc6_.readUnsignedInt();
         _loc4_.rawSendTime = _loc6_.readUnsignedInt();
         _loc4_.type = _loc6_.readUnsignedInt();
         _loc4_.attachmentSymble = Boolean(_loc6_.readUnsignedInt());
         _loc4_.senderId = _loc6_.readUnsignedInt();
         _loc4_.senderName = _loc6_.readUTFBytes(_loc6_.readUnsignedInt());
         _loc4_.mailTitle = _loc6_.readUTFBytes(_loc6_.readUnsignedInt());
         _loc4_.contentTxt = _loc6_.readUTFBytes(_loc6_.readUnsignedInt());
         _loc4_.attachmentArray = [];
         var _loc5_:int = int(_loc6_.readUnsignedInt());
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = new GmailAttachInfo();
            _loc2_.itemId = _loc6_.readUnsignedInt();
            _loc2_.count = _loc6_.readUnsignedInt();
            _loc2_.flag = _loc6_.readUnsignedInt();
            _loc6_.readUnsignedInt();
            _loc6_.readUnsignedInt();
            _loc4_.attachmentArray.push(_loc2_);
            _loc3_++;
         }
         _loc4_.readSymble = _loc6_.readUnsignedInt() == 1;
         this._successBack(_loc4_);
         this._successBack = null;
         this._isRequesting = false;
         this.processNext();
      }
      
      public function getMailPosition(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.dataList.length)
         {
            if(this.dataList[_loc2_].mailId == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getMailByPosition(param1:int) : GmailDataObj
      {
         if(param1 <= this.dataList.length - 1)
         {
            return this.dataList[param1];
         }
         return null;
      }
      
      public function deleteMail(param1:Array) : void
      {
         if(param1 == null || param1.length <= 0)
         {
            return;
         }
         var _loc2_:int = -1;
         var _loc4_:LittleEndianByteArray = new LittleEndianByteArray();
         _loc4_.writeUnsignedInt(ActorManager.actorInfo.id);
         _loc4_.writeUnsignedInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_.writeUnsignedInt(param1[_loc3_]);
            _loc3_++;
         }
         Connection.send(CommandSet.DELETE_MAIL_ON_SERVER,_loc4_);
      }
      
      public function sortByType(param1:int = 1, param2:Boolean = true) : void
      {
         if(this._isSorting)
         {
            return;
         }
         this._isSorting = true;
         this._sortType = param1;
         switch(this._sortType - 1)
         {
            case 0:
               this.dataList.sort(this.sortNewToOld);
               break;
            case 1:
               this.dataList.sort(this.sortOldToNew);
         }
         this._isSorting = false;
         if(param2 == true)
         {
            dispatchEvent(new GmailEvent("MAIL_SORT_COMPLETED"));
         }
      }
      
      private function sortNewToOld(param1:GmailDataObj, param2:GmailDataObj) : int
      {
         if(param1.rawSendTime > param2.rawSendTime)
         {
            return -1;
         }
         if(param1.rawSendTime < param2.rawSendTime)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortOldToNew(param1:GmailDataObj, param2:GmailDataObj) : int
      {
         if(param1.rawSendTime > param2.rawSendTime)
         {
            return 1;
         }
         if(param1.rawSendTime < param2.rawSendTime)
         {
            return -1;
         }
         return 0;
      }
   }
}

class InterClass
{
   
   public function InterClass()
   {
      super();
   }
}
