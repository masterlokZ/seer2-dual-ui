package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   
   public class Processor_12 extends ArenaProcessor
   {
      
      public function Processor_12(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_ESCAPE_NOTIFY_12,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc2_:uint = param1.message.getRawData().readUnsignedInt();
         if(fightController.leftTeam.containsFightUser(_loc2_))
         {
            fightController.changeFighterState("escape");
            fightController.leftMainFighter.disappear(1);
            if(fightController.leftSubFighter != null)
            {
               fightController.leftSubFighter.disappear(1);
            }
         }
         else
         {
            fightController.changeFighterState("oppositeEscape");
            fightController.rightMainFighter.disappear(2);
            if(fightController.rightSubFighter != null)
            {
               fightController.rightSubFighter.disappear(1);
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_ESCAPE_NOTIFY_12,this.processor);
      }
   }
}

