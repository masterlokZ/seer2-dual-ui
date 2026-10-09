package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_11 extends ArenaProcessor
   {
      
      public function Processor_11(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_FEATRUE_RESULT_11,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc2_:int = 0;
         var _loc5_:Array = null;
         var _loc4_:Fighter = null;
         var _loc6_:IDataInput = param1.message.getRawData();
         var _loc8_:uint = _loc6_.readUnsignedInt();
         var _loc7_:uint = _loc6_.readUnsignedInt();
         var _loc3_:uint = _loc6_.readUnsignedInt();
         _loc2_ = int(_loc6_.readUnsignedByte());
         if(_loc2_ == 0)
         {
            _loc5_ = _secne.arenaData.hpPackage11;
            _loc5_.push({
               "userId":_loc8_,
               "fighterId":_loc7_,
               "fighterHp":_loc3_
            });
         }
         else
         {
            _loc4_ = _secne.arenaData.getFighter(_loc8_,_loc7_);
            _loc4_.fighterInfo.hp = _loc3_;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_FEATRUE_RESULT_11,this.processor);
      }
   }
}

