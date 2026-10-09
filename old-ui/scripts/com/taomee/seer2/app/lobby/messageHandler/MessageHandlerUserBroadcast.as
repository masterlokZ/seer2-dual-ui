package com.taomee.seer2.app.lobby.messageHandler
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.net.message.IMessageHandler;
   import com.taomee.seer2.core.net.message.Message;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class MessageHandlerUserBroadcast implements IMessageHandler
   {
      
      public static const GO_TO_ARENA:uint = 1;
      
      public static const LEAVE:uint = 0;
      
      public function MessageHandlerUserBroadcast()
      {
         super();
      }
      
      public function setup() : void
      {
         Connection.addCommandListener(CommandSet.SYNC_POSITION_1101,this.onMessage);
         Connection.addCommandListener(CommandSet.USER_CHANGE_NICK_1099,this.onMessage);
         Connection.addCommandListener(CommandSet.USER_CHANGE_MEDAL_1008,this.onMessage);
      }
      
      public function onMessage(param1:MessageEvent) : void
      {
         switch(param1.message.commandId)
         {
            case CommandSet.SYNC_POSITION_1101.id:
               this.parseSyncPosition(param1.message);
               break;
            case CommandSet.USER_CHANGE_NICK_1099.id:
               this.parseUserChangeNick(param1.message);
               break;
            case CommandSet.USER_CHANGE_MEDAL_1008.id:
               this.parseUserChangeMedal(param1.message);
         }
      }
      
      private function parseSyncPosition(param1:Message) : void
      {
         var _loc4_:Actor = null;
         var _loc5_:IDataInput = param1.getRawData();
         var _loc7_:int = int(_loc5_.readUnsignedInt());
         var _loc6_:int = int(_loc5_.readUnsignedInt());
         var _loc3_:int = int(_loc5_.readUnsignedInt());
         var _loc2_:int = int(ActorManager.actorInfo.id);
         if(_loc7_ != ActorManager.actorInfo.id)
         {
            _loc4_ = ActorManager.getActorById(_loc7_);
            if(_loc4_)
            {
               _loc4_.walk(_loc6_,_loc3_);
            }
         }
      }
      
      private function parseUserChangeNick(param1:Message) : void
      {
         var _loc2_:Actor = null;
         var _loc3_:ByteArray = param1.getRawDataCopy();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc4_:String = _loc3_.readUTFBytes(16);
         _loc2_ = ActorManager.getActorById(_loc5_);
         if(_loc2_)
         {
            _loc2_.updateNick(_loc4_);
         }
      }
      
      private function parseUserChangeMedal(param1:Message) : void
      {
         var _loc2_:Actor = null;
         var _loc3_:LittleEndianByteArray = param1.getRawData();
         _loc3_.position = 0;
         var _loc5_:uint = _loc3_.readUnsignedInt();
         var _loc4_:uint = _loc3_.readUnsignedInt();
         _loc2_ = ActorManager.getActorById(_loc5_);
         if(_loc2_)
         {
            _loc2_.updateMedal(_loc4_);
         }
      }
      
      public function dispose() : void
      {
         Connection.removeCommandListener(CommandSet.SYNC_POSITION_1101,this.onMessage);
         Connection.removeCommandListener(CommandSet.USER_CHANGE_NICK_1099,this.onMessage);
         Connection.removeCommandListener(CommandSet.USER_CHANGE_MEDAL_1008,this.onMessage);
      }
   }
}

