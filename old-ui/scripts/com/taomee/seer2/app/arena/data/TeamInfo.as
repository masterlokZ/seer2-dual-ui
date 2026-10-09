package com.taomee.seer2.app.arena.data
{
   import com.taomee.seer2.app.actor.ActorManager;
   import flash.utils.IDataInput;
   
   public class TeamInfo
   {
      
      private var _leaderId:int;
      
      private var _serverSide:int;
      
      private var _clientSide:int;
      
      private var _fightUserInfoVec:Vector.<FightUserInfo>;
      
      public function TeamInfo(param1:IDataInput, param2:uint)
      {
         var _loc3_:FightUserInfo = null;
         super();
         this._serverSide = param1.readUnsignedByte();
         this._clientSide = this._serverSide;
         this._leaderId = param1.readUnsignedInt();
         var _loc5_:int = int(param1.readUnsignedInt());
         this._fightUserInfoVec = new Vector.<FightUserInfo>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new FightUserInfo(param1);
            this._fightUserInfoVec.push(_loc3_);
            _loc4_++;
         }
         if(param2 >= 100)
         {
            if(this.leaderId == ActorManager.actorInfo.id)
            {
               this._clientSide = 1;
            }
            else
            {
               this._clientSide = 2;
            }
         }
      }
      
      public function printInfomation(param1:String = "") : void
      {
         var _loc2_:FightUserInfo = null;
         for each(_loc2_ in this._fightUserInfoVec)
         {
            _loc2_.printInfomation(param1 + "     ");
         }
      }
      
      public function get fightUserInfoVec() : Vector.<FightUserInfo>
      {
         return this._fightUserInfoVec;
      }
      
      public function get serverSide() : int
      {
         return this._serverSide;
      }
      
      public function get clientSide() : int
      {
         return this._clientSide;
      }
      
      public function get leaderId() : int
      {
         return this._leaderId;
      }
   }
}

