package com.taomee.seer2.app.lobby.messageHandler
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.net.message.IMessageHandler;
   import flash.utils.ByteArray;
   
   public class MessageHandlerSetPetFollow implements IMessageHandler
   {
      
      private static const FOLLOWING_FLAG:int = 1;
      
      public function MessageHandlerSetPetFollow()
      {
         super();
      }
      
      public function setup() : void
      {
         Connection.addCommandListener(CommandSet.PET_SET_FOLLOWING_1019,this.onMessage);
      }
      
      public function onMessage(param1:MessageEvent) : void
      {
         var _loc4_:* = 0;
         var _loc3_:uint = 0;
         var _loc6_:PetInfo = null;
         var _loc5_:uint = 0;
         var _loc2_:PetInfo = null;
         var _loc7_:ByteArray = param1.message.getRawDataCopy();
         var _loc9_:uint = _loc7_.readUnsignedInt();
         var _loc8_:uint = _loc7_.readUnsignedInt();
         _loc4_ = _loc7_.readUnsignedByte();
         if(_loc4_ == 1)
         {
            _loc3_ = _loc7_.readUnsignedInt();
            _loc6_ = new PetInfo();
            _loc6_.catchTime = _loc7_.readUnsignedInt();
            _loc6_.resourceId = _loc7_.readUnsignedInt();
            _loc6_.sex = _loc7_.readUnsignedByte();
            _loc6_.level = _loc7_.readUnsignedByte();
            _loc6_.character = _loc7_.readUnsignedInt();
            _loc6_.potential = _loc7_.readUnsignedInt();
            _loc6_.flag = _loc7_.readUnsignedInt();
            _loc6_.petRideChipId = _loc7_.readUnsignedInt();
            _loc6_.chipPutOnTime = _loc7_.readUnsignedInt();
            _loc6_.evolveLevel = _loc7_.readUnsignedInt();
            this.createFollowingPet(_loc9_,_loc6_);
         }
         else if(_loc4_ == 0)
         {
            this.finishFollowingPet(_loc9_,_loc8_);
         }
         else if(_loc4_ == 2)
         {
            this.removePetRIde(_loc9_,_loc8_);
         }
         else if(_loc4_ == 3)
         {
            _loc5_ = _loc7_.readUnsignedInt();
            _loc2_ = new PetInfo();
            _loc2_.catchTime = _loc7_.readUnsignedInt();
            _loc2_.resourceId = _loc7_.readUnsignedInt();
            _loc2_.sex = _loc7_.readUnsignedByte();
            _loc2_.level = _loc7_.readUnsignedByte();
            _loc2_.character = _loc7_.readUnsignedInt();
            _loc2_.potential = _loc7_.readUnsignedInt();
            _loc2_.flag = _loc7_.readUnsignedInt();
            _loc2_.petRideChipId = _loc7_.readUnsignedInt();
            _loc2_.chipPutOnTime = _loc7_.readUnsignedInt();
            _loc2_.isPetRiding = true;
            _loc2_.evolveLevel = _loc7_.readUnsignedInt();
            this.createPetRide(_loc9_,_loc2_);
         }
      }
      
      private function finishFollowingPet(param1:uint, param2:uint) : void
      {
         var _loc3_:RemoteActor = null;
         if(param1 == ActorManager.actorInfo.id)
         {
            ActorManager.getActor().getInfo().setFollowingPetInfo(null);
         }
         else
         {
            _loc3_ = ActorManager.getRemoteActor(param1);
            if(_loc3_ != null)
            {
               _loc3_.getInfo().setFollowingPetInfo(null);
            }
         }
      }
      
      private function createFollowingPet(param1:uint, param2:PetInfo) : void
      {
         var _loc3_:Actor = null;
         if(param1 == ActorManager.actorInfo.id)
         {
            _loc3_ = ActorManager.getActor();
         }
         else
         {
            _loc3_ = ActorManager.getRemoteActor(param1);
         }
         if(_loc3_ != null)
         {
            _loc3_.getInfo().setFollowingPetInfo(param2);
         }
      }
      
      private function createPetRide(param1:uint, param2:PetInfo) : void
      {
         var _loc3_:Actor = null;
         if(param1 == ActorManager.actorInfo.id)
         {
            _loc3_ = ActorManager.getActor();
         }
         else
         {
            _loc3_ = ActorManager.getRemoteActor(param1);
         }
         if(_loc3_ != null)
         {
            _loc3_.getInfo().setPetRidePetInfo(param2);
         }
      }
      
      private function removePetRIde(param1:int, param2:uint) : void
      {
         var _loc3_:RemoteActor = null;
         if(param1 == ActorManager.actorInfo.id)
         {
            ActorManager.getActor().getInfo().setPetRidePetInfo(null);
         }
         else
         {
            _loc3_ = ActorManager.getRemoteActor(param1);
            if(_loc3_ != null)
            {
               _loc3_.getInfo().setPetRidePetInfo(null);
            }
         }
      }
      
      public function dispose() : void
      {
         Connection.removeCommandListener(CommandSet.PET_SET_FOLLOWING_1019,this.onMessage);
      }
   }
}

