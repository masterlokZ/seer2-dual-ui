package com.taomee.seer2.app.lobby.messageHandler
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.PetRideShopConfig;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.net.message.IMessageHandler;
   import flash.utils.IDataInput;
   
   public class MessageHandlerEquipChange implements IMessageHandler
   {
      
      public function MessageHandlerEquipChange()
      {
         super();
      }
      
      public function setup() : void
      {
         Connection.addCommandListener(CommandSet.EQUIP_CHANGE_1098,this.onMessage);
      }
      
      public function onMessage(param1:MessageEvent) : void
      {
         var _loc12_:* = undefined;
         var _loc13_:Actor = null;
         var _loc10_:uint = 0;
         var _loc11_:EquipItem = null;
         var _loc15_:PetInfo = null;
         var _loc16_:int = 0;
         var _loc14_:EquipItem = null;
         var _loc7_:IDataInput = param1.message.getRawData();
         var _loc9_:uint = _loc7_.readUnsignedInt();
         var _loc8_:uint = _loc7_.readUnsignedInt();
         var _loc4_:Vector.<EquipItem> = new Vector.<EquipItem>();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc8_)
         {
            _loc10_ = _loc7_.readUnsignedInt();
            _loc11_ = new EquipItem(_loc10_);
            _loc4_.push(_loc11_);
            _loc3_++;
         }
         var _loc6_:uint = _loc7_.readUnsignedInt();
         var _loc5_:uint = 0;
         var _loc2_:int = 0;
         while(_loc2_ < _loc6_)
         {
            _loc5_ = _loc7_.readUnsignedInt();
            _loc2_++;
         }
         _loc12_ = _loc9_ == ActorManager.actorInfo.id;
         if(_loc12_)
         {
            _loc13_ = ActorManager.getActor();
            this.updateItemManager(_loc4_);
            _loc13_.getNono().nonoInfo.equipId = _loc5_;
            _loc13_.getNono().updateNonoView();
         }
         else
         {
            _loc13_ = ActorManager.getRemoteActor(_loc9_);
         }
         if(_loc13_)
         {
            _loc15_ = _loc13_.getInfo().ridingPetInfo;
            if(_loc15_)
            {
               _loc16_ = PetRideShopConfig.getEquipIdByChipBackId(_loc15_.petRideChipId);
               _loc14_ = new EquipItem(_loc16_);
               if(_loc13_.getInfo().vipInfo.isVip() == false)
               {
                  if(TimeManager.getServerTime() - _loc15_.chipPutOnTime <= 604800)
                  {
                     if(_loc15_.isPetRiding && Boolean(_loc14_))
                     {
                        _loc4_.push(_loc14_);
                        if(_loc12_)
                        {
                           this.updateItemManager(_loc4_);
                        }
                     }
                  }
               }
               else if(_loc15_.isPetRiding && Boolean(_loc14_))
               {
                  _loc4_.push(_loc14_);
                  if(_loc12_)
                  {
                     this.updateItemManager(_loc4_);
                  }
               }
            }
            _loc13_.getInfo().updateEquipVec(_loc4_);
            _loc13_.getNono().nonoInfo.equipId = _loc5_;
            _loc13_.getNono().updateNonoView();
         }
      }
      
      private function updateItemManager(param1:Vector.<EquipItem>) : void
      {
         var _loc4_:EquipItem = null;
         var _loc3_:EquipItem = null;
         var _loc2_:Vector.<EquipItem> = ItemManager.getEquipVec();
         for each(_loc4_ in _loc2_)
         {
            _loc4_.isEquiped = false;
            for each(_loc3_ in param1)
            {
               if(_loc4_.referenceId == _loc3_.referenceId)
               {
                  _loc4_.isEquiped = true;
                  break;
               }
            }
         }
      }
      
      public function dispose() : void
      {
         Connection.removeCommandListener(CommandSet.EQUIP_CHANGE_1098,this.onMessage);
      }
   }
}

