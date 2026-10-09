package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_16 extends ArenaProcessor
   {
      
      public function Processor_16(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_UPDATE_ANGER_16,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc6_:IDataInput = param1.message.getRawData();
         var _loc8_:uint = _loc6_.readUnsignedInt();
         var _loc7_:uint = _loc6_.readUnsignedInt();
         var _loc3_:uint = _loc6_.readUnsignedInt();
         this.updateAnger(_loc8_,_loc7_,_loc3_);
         var _loc2_:uint = _loc6_.readUnsignedInt();
         var _loc5_:uint = _loc6_.readUnsignedInt();
         var _loc4_:uint = _loc6_.readUnsignedInt();
         this.updateAnger(_loc2_,_loc5_,_loc4_);
         arenaUIController.updateAngerBar();
      }
      
      private function updateAnger(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:Fighter = null;
         _loc4_ = _secne.arenaData.getFighter(param1,param2);
         _loc4_.updateAnger(param3);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_UPDATE_ANGER_16,this.processor);
      }
   }
}

