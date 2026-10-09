package com.taomee.seer2.app.lobby.messageHandler
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.MonsterManager;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.net.message.IMessageHandler;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.IDataInput;
   
   public class MessageHandlerPetSpawn implements IMessageHandler
   {
      
      public function MessageHandlerPetSpawn()
      {
         super();
      }
      
      public function setup() : void
      {
         Connection.addCommandListener(CommandSet.PET_SPAWN_1103,this.onMessage);
      }
      
      public function onMessage(param1:MessageEvent) : void
      {
         var _loc9_:IDataInput = null;
         var _loc8_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:SpawnedPet = null;
         var _loc7_:uint = uint(SceneManager.active.mapID);
         if(_loc7_ == 192)
         {
            if(QuestManager.isStepComplete(9,1) && !QuestManager.isStepComplete(9,3))
            {
               return;
            }
         }
         if(_loc7_ != 1 && _loc7_ != 139 && _loc7_ != 220)
         {
            MobileManager.clearMobileVec("spawnedPet");
            _loc9_ = param1.message.getRawDataCopy();
            _loc8_ = int(_loc9_.readUnsignedInt());
            _loc4_ = 0;
            while(_loc4_ < _loc8_)
            {
               _loc3_ = int(_loc9_.readUnsignedInt());
               _loc6_ = int(_loc9_.readUnsignedInt());
               _loc5_ = int(_loc9_.readUnsignedShort());
               _loc9_.readUnsignedInt();
               _loc9_.readUnsignedByte();
               _loc2_ = new SpawnedPet(_loc6_,_loc3_,_loc5_);
               MobileManager.addMobile(_loc2_,"spawnedPet");
               _loc4_++;
            }
            if(MonsterManager.isShow == false)
            {
               MobileManager.hideMoileVec("spawnedPet");
            }
         }
      }
      
      public function dispose() : void
      {
         Connection.removeCommandListener(CommandSet.PET_SPAWN_1103,this.onMessage);
      }
   }
}

