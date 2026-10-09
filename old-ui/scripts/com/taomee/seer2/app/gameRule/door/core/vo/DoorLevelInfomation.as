package com.taomee.seer2.app.gameRule.door.core.vo
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class DoorLevelInfomation
   {
      
      private var _callBack:Function;
      
      private var _gateInfoVec:Vector.<HomeHonorGateInfo>;
      
      public function DoorLevelInfomation()
      {
         super();
      }
      
      public function getInformation(param1:Function) : void
      {
         this._callBack = param1;
         Connection.addCommandListener(CommandSet.HOME_GET_HONOR_INFO_1052,this.onQueryHomeHonor);
         Connection.send(CommandSet.HOME_GET_HONOR_INFO_1052,ActorManager.actorInfo.id);
      }
      
      public function getHomeHonorGateInfo(param1:int) : HomeHonorGateInfo
      {
         var _loc3_:HomeHonorGateInfo = null;
         var _loc4_:HomeHonorGateInfo = null;
         var _loc5_:int = int(this._gateInfoVec.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this._gateInfoVec[_loc2_];
            if(_loc4_.id == param1)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function getMaxLevelHistory(param1:int) : int
      {
         var _loc4_:HomeHonorGateInfo = null;
         var _loc3_:int = -1;
         var _loc5_:int = int(this._gateInfoVec.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this._gateInfoVec[_loc2_];
            if(_loc4_.id == param1)
            {
               _loc3_ = _loc4_.pveNormal > _loc4_.pveFifty ? _loc4_.pveNormal : _loc4_.pveFifty;
               break;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function getCMaxLevelPVENormalHistory(param1:int) : uint
      {
         var _loc4_:HomeHonorGateInfo = null;
         var _loc3_:uint = 1;
         var _loc5_:int = int(this._gateInfoVec.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this._gateInfoVec[_loc2_];
            if(_loc4_.id == param1)
            {
               _loc3_ = uint(_loc4_.pvelastNormal);
               break;
            }
            _loc2_++;
         }
         return _loc3_ > 1 ? _loc3_ : 1;
      }
      
      public function getMaxLevelPVENormalHistory(param1:int) : uint
      {
         var _loc4_:HomeHonorGateInfo = null;
         var _loc3_:uint = 1;
         var _loc5_:int = int(this._gateInfoVec.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this._gateInfoVec[_loc2_];
            if(_loc4_.id == param1)
            {
               _loc3_ = uint(_loc4_.pveNormal);
               break;
            }
            _loc2_++;
         }
         return _loc3_ > 1 ? _loc3_ : 1;
      }
      
      public function getCMaxLevelPVEFiftyHistory(param1:int) : uint
      {
         var _loc4_:HomeHonorGateInfo = null;
         var _loc3_:uint = 1;
         var _loc5_:int = int(this._gateInfoVec.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this._gateInfoVec[_loc2_];
            if(_loc4_.id == param1)
            {
               _loc3_ = uint(_loc4_.pvelastFifty);
               break;
            }
            _loc2_++;
         }
         return _loc3_ > 1 ? _loc3_ : 1;
      }
      
      public function getMaxLevelPVEFiftyHistory(param1:int) : uint
      {
         var _loc4_:HomeHonorGateInfo = null;
         var _loc3_:uint = 1;
         var _loc5_:int = int(this._gateInfoVec.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this._gateInfoVec[_loc2_];
            if(_loc4_.id == param1)
            {
               _loc3_ = uint(_loc4_.pveFifty);
               break;
            }
            _loc2_++;
         }
         return _loc3_ > 1 ? _loc3_ : 1;
      }
      
      private function onQueryHomeHonor(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.HOME_GET_HONOR_INFO_1052,this.onQueryHomeHonor);
         var _loc2_:IDataInput = param1.message.getRawData();
         this.parseHomeHonorData(param1.message.getRawData());
         this._callBack();
         this._callBack = null;
      }
      
      private function parseHomeHonorData(param1:IDataInput) : void
      {
         var _loc7_:Vector.<int> = new Vector.<int>();
         var _loc9_:int = int(param1.readUnsignedInt());
         var _loc8_:int = 0;
         while(_loc8_ < _loc9_)
         {
            _loc7_.push(param1.readUnsignedInt());
            _loc8_++;
         }
         var _loc4_:Vector.<HomeHonorSptInfo> = new Vector.<HomeHonorSptInfo>();
         var _loc3_:int = int(param1.readUnsignedInt());
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_.push(new HomeHonorSptInfo(param1));
            _loc6_++;
         }
         this._gateInfoVec = new Vector.<HomeHonorGateInfo>();
         var _loc5_:int = int(param1.readUnsignedInt());
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            this._gateInfoVec.push(new HomeHonorGateInfo(param1));
            _loc2_++;
         }
      }
   }
}

