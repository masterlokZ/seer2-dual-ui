package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.animation.ArenaAnimationManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_7 extends ArenaProcessor
   {
      
      public function Processor_7(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_NEXT_TURN_7,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc3_:IDataInput = param1.message.getRawData();
         var _loc5_:uint = _loc3_.readUnsignedByte();
         _secne.arenaData.turnCount = _loc5_;
         var _loc4_:uint = _loc3_.readUnsignedByte();
         _secne.updateWeather(_loc4_);
         var _loc2_:String = fightController.state;
         ArenaAnimationManager.abortCountDown();
         ArenaAnimationManager.hideWaiting();
         if(_loc2_ == "changeLeftFighter")
         {
            return;
         }
         if(_loc2_ == "catchFighterFailed")
         {
            return;
         }
         fightController.parseTurnResult();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_NEXT_TURN_7,this.processor);
      }
   }
}

