package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.config.FitConfig;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_1502 extends ArenaProcessor
   {
      
      public function Processor_1502(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_USE_SKILL_1502,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc3_:Fighter = null;
         var _loc6_:SkillInfo = null;
         var _loc5_:Fighter = null;
         var _loc2_:Fighter = null;
         var _loc7_:IDataInput = param1.message.getRawData();
         var _loc9_:uint = ActorManager.actorInfo.id;
         var _loc8_:uint = _loc7_.readUnsignedInt();
         var _loc4_:uint = _loc7_.readUnsignedInt();
         _loc3_ = _secne.leftTeam.getFighter(_loc9_,_loc8_);
         if(_loc3_ == null)
         {
            _loc3_ = _secne.leftTeam.getChangeFighter(_loc9_,_loc8_);
         }
         _loc6_ = _loc3_.fighterInfo.getSkillInfo(_loc4_);
         if(_loc6_ != null)
         {
            _loc3_.fighterInfo.fightAnger -= _loc6_.anger;
         }
         if(FitConfig.formSkillIdGetPetFitDefinition(_loc4_))
         {
            if(_loc9_ == ActorManager.actorInfo.id)
            {
               _loc5_ = _secne.leftTeam.getFighter(_loc9_,_loc8_);
               _loc2_ = _secne.leftTeam.getFighterToBounchId(FitConfig.formSkillIdGetPetFitDefinition(_loc4_).id);
               if(_loc5_ == null || _loc2_ == null)
               {
                  return;
               }
               if(_loc4_ == 11618 || _loc4_ == 11619)
               {
                  _loc2_.fighterInfo.hp = _loc2_.fighterInfo.maxHp;
                  return;
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_USE_SKILL_1502,this.processor);
      }
   }
}

