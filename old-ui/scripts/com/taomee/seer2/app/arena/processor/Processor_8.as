package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_8 extends ArenaProcessor
   {
      
      public function Processor_8(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_CHANGED_NOTIFY_8,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc4_:Parser_8 = new Parser_8(_loc2_);
         fightController.changeFighter(_loc4_.userId,_loc4_.fighterId,_loc4_.angerValue,1);
         fightController.leftTeam.getFighter(_loc4_.userId,_loc4_.fighterId).updateAnger(_loc4_.angerValue);
         _loc3_ = fightController.leftTeam.containsFighter(_loc4_.userId,_loc4_.fighterId);
         if(_loc3_ == true)
         {
            _secne.leftTeam.mainFighter.updateFighterBuffer(_loc4_.parserFighterBuffInfo(_loc2_));
            arenaUIController.updateStatusPanel();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_CHANGED_NOTIFY_8,this.processor);
      }
   }
}

