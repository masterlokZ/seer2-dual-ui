package com.taomee.seer2.app.arena.data
{
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.ui.ButtonPanelData;
   
   public class ArenaDataInfo
   {
      
      private var _turnCount:uint = 0;
      
      public var fightMode:uint;
      
      public var leftTeam:FighterTeam;
      
      public var rightTeam:FighterTeam;
      
      public var fightWeather:uint;
      
      public var isFightEnd:Boolean;
      
      public var isChagingFitPet:Boolean = false;
      
      public var canCatchAfterSptDeadNow:Boolean = false;
      
      public var canCatchAfterSptDead:Boolean = false;
      
      public var canCatch:Boolean = false;
      
      private var _btnPanelData:ButtonPanelData;
      
      public var isDoubleMode:Boolean = false;
      
      public var hpPackage11:Array = [];
      
      public function ArenaDataInfo()
      {
         super();
      }
      
      public function effectHpPackage11() : void
      {
         var _loc3_:Object = null;
         var _loc2_:uint = 0;
         var _loc5_:uint = 0;
         var _loc4_:uint = 0;
         var _loc1_:Fighter = null;
         while(this.hpPackage11.length > 0)
         {
            _loc3_ = this.hpPackage11.pop();
            _loc2_ = uint(_loc3_.userId);
            _loc5_ = uint(_loc3_.fighterHp);
            _loc4_ = uint(_loc3_.fighterId);
            _loc1_ = this.getFighter(_loc2_,_loc4_);
            _loc1_.fighterInfo.hp = _loc5_;
         }
      }
      
      public function dispose() : void
      {
         this.leftTeam = null;
         this.rightTeam = null;
         this.turnCount = 1;
      }
      
      public function get btnPanelData() : ButtonPanelData
      {
         if(this._btnPanelData == null)
         {
            this._btnPanelData = new ButtonPanelData();
         }
         return this._btnPanelData;
      }
      
      public function set btnPanelData(param1:ButtonPanelData) : void
      {
         this._btnPanelData = param1;
      }
      
      public function getFighter(param1:uint, param2:uint) : Fighter
      {
         var _loc3_:Fighter = this.leftTeam.getFighter(param1,param2);
         if(_loc3_ == null)
         {
            _loc3_ = this.rightTeam.getFighter(param1,param2);
         }
         return _loc3_;
      }
      
      public function get turnCount() : uint
      {
         return this._turnCount;
      }
      
      public function set turnCount(param1:uint) : void
      {
         this._turnCount = param1;
      }
      
      public function fighterInfo(userId:int, catchTime:uint) : FighterInfo
      {
         var teamInfo:TeamInfo = null;
         var i:int = 0;
         if(userId === this.leftTeam.teamInfo.leaderId)
         {
            teamInfo = this.leftTeam.teamInfo;
         }
         else
         {
            teamInfo = this.rightTeam.teamInfo;
         }
         var fighterInfoVec:Vector.<FighterInfo> = teamInfo.fightUserInfoVec[0].fighterInfoVec;
         for(i = 0; i < fighterInfoVec.length; )
         {
            if(fighterInfoVec[i].catchTime === catchTime)
            {
               return fighterInfoVec[i];
            }
            i++;
         }
         fighterInfoVec = teamInfo.fightUserInfoVec[0].changeFighterInfoVec;
         for(i = 0; i < fighterInfoVec.length; )
         {
            if(fighterInfoVec[i].catchTime === catchTime)
            {
               return fighterInfoVec[i];
            }
            i++;
         }
         throw new Error("invalid");
      }
   }
}

