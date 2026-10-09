package com.taomee.seer2.app.arena.data
{
   import flash.utils.IDataInput;
   
   public class FightUserInfo
   {
      
      private var _userId:int;
      
      private var _nick:String;
      
      private var _fighterInfoVec:Vector.<FighterInfo>;
      
      private var _changeFighterInfoVec:Vector.<FighterInfo>;
      
      public function FightUserInfo(param1:IDataInput)
      {
         var _loc4_:FighterInfo = null;
         var _loc2_:FighterInfo = null;
         super();
         this._userId = param1.readUnsignedInt();
         this._nick = param1.readUTFBytes(16);
         var _loc3_:int = int(param1.readUnsignedInt());
         this._fighterInfoVec = new Vector.<FighterInfo>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = new FighterInfo(this._userId,param1);
            _loc4_.isChangePet = false;
            _loc4_.isChange = 0;
            this._fighterInfoVec.push(_loc4_);
            _loc5_++;
         }
         _loc3_ = int(param1.readUnsignedInt());
         this._changeFighterInfoVec = Vector.<FighterInfo>([]);
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_ = new FighterInfo(this._userId,param1);
            _loc2_.isChangePet = true;
            _loc2_.isChange = 0;
            this._changeFighterInfoVec.push(_loc2_);
            _loc5_++;
         }
      }
      
      public function printInfomation(param1:String = "") : void
      {
         var _loc2_:FighterInfo = null;
         for each(_loc2_ in this._fighterInfoVec)
         {
            _loc2_.printInfomation(param1 + "     ");
         }
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function get nick() : String
      {
         return this._nick;
      }
      
      public function get fighterInfoVec() : Vector.<FighterInfo>
      {
         return this._fighterInfoVec;
      }
      
      public function get changeFighterInfoVec() : Vector.<FighterInfo>
      {
         return this._changeFighterInfoVec;
      }
   }
}

