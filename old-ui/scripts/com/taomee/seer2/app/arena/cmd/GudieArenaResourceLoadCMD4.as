package com.taomee.seer2.app.arena.cmd
{
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.data.FighterTeam;
   import com.taomee.seer2.app.arena.data.TeamInfo;
   import flash.utils.ByteArray;
   
   public class GudieArenaResourceLoadCMD4 implements IArenaBaseCMD
   {
      
      private var _arenaData:ArenaDataInfo;
      
      private var _onGetInfoComplete:Function;
      
      public function GudieArenaResourceLoadCMD4(param1:ArenaDataInfo, param2:Function)
      {
         super();
         this._arenaData = param1;
         this._onGetInfoComplete = param2;
      }
      
      public function init() : void
      {
      }
      
      public function send() : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(1);
         _loc2_.writeByte(1);
         _loc2_.writeUnsignedInt(50233);
         _loc2_.writeUnsignedInt(1);
         _loc2_.writeUnsignedInt(50233);
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUTFBytes("233");
         _loc1_.length = 16;
         _loc2_.writeBytes(_loc1_,0,16);
         _loc2_.writeUnsignedInt(1);
         _loc2_.writeUnsignedInt(1);
         _loc2_.writeUnsignedInt(100);
         _loc2_.writeUnsignedInt(830);
         _loc2_.writeByte(1);
         _loc2_.writeShort(60);
         _loc2_.writeUnsignedInt(500);
         _loc2_.writeUnsignedInt(500);
         _loc2_.writeUnsignedInt(5);
         _loc2_.writeUnsignedInt(16317);
         _loc2_.writeUnsignedInt(16318);
         _loc2_.writeUnsignedInt(16319);
         _loc2_.writeUnsignedInt(16320);
         _loc2_.writeUnsignedInt(16321);
         _loc2_.writeUnsignedInt(0);
         _loc2_.writeUnsignedInt(0);
         _loc2_.writeByte(2);
         _loc2_.writeUnsignedInt(0);
         _loc2_.writeUnsignedInt(1);
         _loc2_.writeUnsignedInt(0);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes("XXX");
         _loc3_.length = 16;
         _loc2_.writeBytes(_loc3_,0,16);
         _loc2_.writeUnsignedInt(1);
         _loc2_.writeUnsignedInt(2);
         _loc2_.writeUnsignedInt(20);
         _loc2_.writeUnsignedInt(13);
         _loc2_.writeByte(1);
         _loc2_.writeShort(20);
         _loc2_.writeUnsignedInt(50);
         _loc2_.writeUnsignedInt(50);
         _loc2_.writeUnsignedInt(5);
         _loc2_.writeUnsignedInt(13077);
         _loc2_.writeUnsignedInt(13078);
         _loc2_.writeUnsignedInt(13082);
         _loc2_.writeUnsignedInt(13087);
         _loc2_.writeUnsignedInt(13086);
         _loc2_.writeUnsignedInt(0);
         _loc2_.writeUnsignedInt(0);
         _loc2_.writeByte(0);
         _loc2_.writeByte(0);
         this.onGetResourceInfo(_loc2_);
      }
      
      private function onGetResourceInfo(param1:ByteArray) : void
      {
         param1.position = 0;
         this._arenaData.fightMode = param1.readUnsignedByte();
         var _loc2_:TeamInfo = new TeamInfo(param1,this._arenaData.fightMode);
         var _loc3_:TeamInfo = new TeamInfo(param1,this._arenaData.fightMode);
         if(_loc2_.clientSide == 1)
         {
            this._arenaData.leftTeam = new FighterTeam(_loc2_);
            this._arenaData.rightTeam = new FighterTeam(_loc3_);
         }
         else
         {
            this._arenaData.rightTeam = new FighterTeam(_loc2_);
            this._arenaData.leftTeam = new FighterTeam(_loc3_);
         }
         if(this._arenaData.leftTeam.subFighterInfo != null || this._arenaData.rightTeam.subFighterInfo != null)
         {
            this._arenaData.isDoubleMode = true;
         }
         this._arenaData.fightWeather = param1.readUnsignedByte();
         this._arenaData.canCatch = param1.readUnsignedByte() == 0;
         this._onGetInfoComplete();
         this.dispose();
      }
      
      public function dispose() : void
      {
      }
   }
}

