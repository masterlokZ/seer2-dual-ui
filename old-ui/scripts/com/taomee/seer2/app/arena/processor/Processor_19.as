package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_19 extends ArenaProcessor
   {
      
      public static var isChangeIng:Boolean;
      
      public function Processor_19(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_CHANGE_PET_19,this.processor);
         Connection.blockCommand(CommandSet.FIGHT_CHANGE_PET_19);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc11_:uint = 0;
         var _loc5_:uint = 0;
         var _loc3_:uint = 0;
         var _loc8_:int = 0;
         var _loc2_:Fighter = null;
         var _loc6_:Boolean = false;
         var _loc9_:Fighter = null;
         var _loc4_:Boolean = false;
         var _loc10_:IDataInput = param1.message.getRawData();
         var _loc12_:int = int(_loc10_.readUnsignedInt());
         var _loc7_:int = 0;
         while(_loc7_ < _loc12_)
         {
            _loc11_ = _loc10_.readUnsignedInt();
            _loc8_ = int(_loc10_.readUnsignedByte());
            _loc5_ = _loc10_.readUnsignedInt();
            _loc3_ = _loc10_.readUnsignedInt();
            if(_loc11_ == ActorManager.actorInfo.id)
            {
               if(_loc8_ == 0)
               {
                  fightController.leftTeam.mainFighter.fighterInfo.isChangeStatus = 1;
                  isChangeIng = true;
                  arenaUIController.changeTeam("changePet",_loc5_,_loc3_);
                  _loc2_ = fightController.leftTeam.getFighter(_loc11_,_loc3_);
                  _loc2_.fighterInfo.hp = _loc2_.fighterInfo.maxHp;
                  fightController.changeFighter(_loc11_,_loc2_.fighterInfo.catchTime,_loc2_.fighterInfo.fightAnger,1);
                  fightController.leftTeam.getFighter(_loc11_,_loc2_.fighterInfo.catchTime).updateAnger(_loc2_.fighterInfo.fightAnger);
                  _loc6_ = fightController.leftTeam.containsFighter(_loc11_,_loc2_.fighterInfo.catchTime);
                  if(_loc6_ == true)
                  {
                     _secne.leftTeam.mainFighter.updateFighterBuffer(_secne.leftTeam.mainFighter.fighterInfo.fightBuffInfoVec);
                     arenaUIController.updateStatusPanel();
                  }
               }
               else if(_loc8_ == 1)
               {
                  arenaUIController.changeTeam("die",_loc5_,_loc3_);
               }
            }
            else if(_loc8_ == 0)
            {
               fightController.rightTeam.mainFighter.fighterInfo.isChangeStatus = 1;
               _loc9_ = fightController.rightTeam.getFighter(_loc11_,_loc3_);
               fightController.changeFighter(_loc11_,_loc9_.fighterInfo.catchTime,_loc9_.fighterInfo.fightAnger,1);
               fightController.rightTeam.getFighter(_loc11_,_loc9_.fighterInfo.catchTime).updateAnger(_loc9_.fighterInfo.fightAnger);
               _loc4_ = fightController.rightTeam.containsFighter(_loc11_,_loc9_.fighterInfo.catchTime);
               if(_loc4_ == true)
               {
                  _secne.rightTeam.mainFighter.updateFighterBuffer(_secne.rightTeam.mainFighter.fighterInfo.fightBuffInfoVec);
                  arenaUIController.updateStatusPanel();
               }
            }
            _loc7_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_CHANGE_PET_19,this.processor);
      }
   }
}

