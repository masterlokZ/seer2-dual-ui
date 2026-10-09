package com.taomee.seer2.app.lobby.messageHandler
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.group.UserGroupManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.helper.UserInfoParseHelper;
   import com.taomee.seer2.app.notify.NoticeManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.net.message.IMessageHandler;
   import com.taomee.seer2.core.net.message.Message;
   import flash.utils.IDataInput;
   
   public class MessageHandlerBuddy implements IMessageHandler
   {
      
      private static const COOKIE_NAME:String = "buddyList";
      
      public function MessageHandlerBuddy()
      {
         super();
      }
      
      public function setup() : void
      {
         Connection.addCommandListener(CommandSet.BUDDY_ADD_1024,this.onMessage);
         Connection.addCommandListener(CommandSet.BUDDY_NOTIFY_ADD_1026,this.onMessage);
         Connection.addCommandListener(CommandSet.BUDDY_REPLY_ADD_1027,this.onMessage);
         Connection.addCommandListener(CommandSet.BUDDY_REMOVE_1025,this.onMessage);
      }
      
      public function onMessage(param1:MessageEvent) : void
      {
         switch(param1.message.commandId)
         {
            case CommandSet.BUDDY_ADD_1024.id:
               this.parseAddBuddy(param1.message);
               break;
            case CommandSet.BUDDY_NOTIFY_ADD_1026.id:
               this.parseNotifyAddBuddy(param1.message);
               break;
            case CommandSet.BUDDY_REPLY_ADD_1027.id:
               this.parseReplyAddBuddy(param1.message);
               break;
            case CommandSet.BUDDY_REMOVE_1025.id:
               this.parseRemoveBuddy(param1.message);
         }
      }
      
      private function parseAddBuddy(param1:Message) : void
      {
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc5_:IDataInput = param1.getRawData();
         var _loc7_:UserInfo = new UserInfo();
         UserInfoParseHelper.parseUserSimpleInfo(_loc7_,_loc5_);
         var _loc6_:Boolean = Boolean(_loc5_.readUnsignedByte());
         var _loc3_:Boolean = Boolean(_loc5_.readUnsignedByte());
         if(_loc6_ == false)
         {
            _loc2_ = "buddy";
            _loc4_ = _loc7_.nick + "已经成为你的好友";
         }
         else
         {
            _loc2_ = "black";
            _loc4_ = _loc7_.nick + "已经加入黑名单";
         }
         if(_loc3_ == true)
         {
            _loc7_.serverID = 1;
         }
         else
         {
            _loc7_.serverID = 0;
         }
         UserGroupManager.addUser(_loc2_,_loc7_);
         ServerMessager.addMessage(_loc4_);
      }
      
      private function parseRemoveBuddy(param1:Message) : void
      {
         var _loc2_:UserInfo = null;
         var _loc5_:String = null;
         var _loc4_:String = null;
         var _loc6_:IDataInput = param1.getRawData();
         var _loc8_:uint = _loc6_.readUnsignedInt();
         var _loc7_:String = _loc6_.readUTFBytes(16);
         var _loc3_:Boolean = Boolean(_loc6_.readUnsignedByte());
         _loc2_ = new UserInfo();
         _loc2_.id = _loc8_;
         _loc2_.nick = _loc7_;
         if(_loc3_ == false)
         {
            _loc5_ = "buddy";
            _loc4_ = _loc2_.nick + "已经从你的好友列表中删除";
         }
         else
         {
            _loc5_ = "black";
            _loc4_ = _loc2_.nick + "已经从你的黑名单中删除";
         }
         UserGroupManager.removeUser(_loc5_,_loc2_);
         ServerMessager.addMessage(_loc4_);
      }
      
      private function parseNotifyAddBuddy(param1:Message) : void
      {
         var _loc2_:IDataInput = param1.getRawData();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         var _loc3_:String = _loc2_.readUTFBytes(16);
         NoticeManager.addBuddyNotice(_loc4_,_loc3_);
      }
      
      private function parseReplyAddBuddy(param1:Message) : void
      {
         var _loc3_:UserInfo = null;
         var _loc2_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:IDataInput = param1.getRawData();
         var _loc7_:uint = _loc5_.readUnsignedInt();
         var _loc6_:String = _loc5_.readUTFBytes(16);
         _loc3_ = new UserInfo();
         _loc3_.id = _loc7_;
         _loc3_.nick = _loc6_;
         _loc2_ = Boolean(_loc5_.readUnsignedByte());
         if(_loc2_ == false)
         {
            _loc4_ = "buddy";
         }
         else
         {
            _loc4_ = "black";
         }
         UserGroupManager.addUser(_loc4_,_loc3_);
      }
      
      public function dispose() : void
      {
         Connection.removeCommandListener(CommandSet.BUDDY_ADD_1024,this.onMessage);
         Connection.removeCommandListener(CommandSet.BUDDY_NOTIFY_ADD_1026,this.onMessage);
         Connection.removeCommandListener(CommandSet.BUDDY_REPLY_ADD_1027,this.onMessage);
         Connection.removeCommandListener(CommandSet.BUDDY_REMOVE_1025,this.onMessage);
      }
   }
}

