package com.taomee.seer2.app.arena.data
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import flash.utils.IDataInput;
   
   public class FightResultInfo
   {
      
      private var _endReason:uint;
      
      private var _winnerSide:uint;
      
      private var _gainedEmblemPetId:uint;
      
      private var _gainedEmblemId:uint;
      
      private var _changedPetInfoVec:Vector.<PetInfo>;
      
      public function FightResultInfo(param1:IDataInput)
      {
         var _loc3_:PetInfo = null;
         super();
         this._endReason = param1.readUnsignedByte();
         this._winnerSide = param1.readUnsignedByte();
         this._changedPetInfoVec = new Vector.<PetInfo>();
         var _loc2_:int = int(param1.readUnsignedInt());
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new PetInfo();
            PetInfo.readBaseInfo(_loc3_,param1);
            PetInfo.readSkillInfo(_loc3_,param1);
            PetInfo.readGainedSkillInfo(_loc3_,param1);
            _loc3_.learningInfo.pointUnused = param1.readUnsignedShort();
            _loc3_.twoExp = param1.readUnsignedInt();
            _loc3_.threeExp = param1.readUnsignedInt();
            _loc3_.twoStudy = param1.readUnsignedInt();
            this._changedPetInfoVec.push(_loc3_);
            _loc4_++;
         }
         this._gainedEmblemPetId = param1.readUnsignedInt();
         this._gainedEmblemId = param1.readUnsignedInt();
         this.gainItems(param1);
      }
      
      public function updateWinnerSider(param1:uint, param2:FighterTeam, param3:FighterTeam) : void
      {
         if(param1 >= 100)
         {
            if(this._winnerSide == param2.teamInfo.serverSide)
            {
               this._winnerSide = 1;
            }
            else if(this._winnerSide == param3.teamInfo.serverSide)
            {
               this._winnerSide = 2;
            }
         }
      }
      
      private function gainItems(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = int(param1.readUnsignedInt());
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = int(param1.readUnsignedInt());
            _loc2_ = int(param1.readUnsignedInt());
            if(_loc4_ == 1)
            {
               ActorManager.actorInfo.coins += _loc2_;
            }
            else
            {
               ItemManager.addItem(_loc4_,_loc2_,0);
            }
            _loc5_++;
         }
      }
      
      public function get changedPetInfoVec() : Vector.<PetInfo>
      {
         return this._changedPetInfoVec;
      }
      
      public function get gainedEmblemPetId() : uint
      {
         return this._gainedEmblemPetId;
      }
      
      public function get gainedEmblemId() : uint
      {
         return this._gainedEmblemId;
      }
      
      public function get endReason() : uint
      {
         return this._endReason;
      }
      
      public function get showWinnerSider() : uint
      {
         return this._winnerSide;
      }
   }
}

