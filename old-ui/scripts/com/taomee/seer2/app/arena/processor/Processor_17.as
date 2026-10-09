package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.data.PvpFightChangeInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.IDataInput;
   
   public class Processor_17 extends ArenaProcessor
   {
      
      public function Processor_17(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.PVP_FIGHT_NOTIFY_MON_POS_17,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc3_:PvpFightChangeInfo = null;
         var _loc7_:ArenaScene = null;
         var _loc5_:Fighter = null;
         var _loc2_:PvpFightChangeInfo = null;
         var _loc6_:ArenaScene = null;
         var _loc8_:Fighter = null;
         var _loc9_:IDataInput = param1.message.getRawData();
         var _loc11_:uint = _loc9_.readUnsignedInt();
         var _loc10_:uint = 0;
         while(_loc10_ < _loc11_)
         {
            _loc3_ = new PvpFightChangeInfo();
            _loc3_.user_id = _loc9_.readUnsignedInt();
            _loc3_.catch_time = _loc9_.readUnsignedInt();
            _loc3_.anger = _loc9_.readUnsignedInt();
            _loc3_.position = _loc10_ + 1;
            fightController.addPvpFightInfo(_loc3_);
            _loc7_ = SceneManager.active as ArenaScene;
            _loc5_ = _loc7_.arenaData.getFighter(_loc3_.user_id,_loc3_.catch_time);
            _loc10_++;
         }
         _loc11_ = _loc9_.readUnsignedInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc11_)
         {
            _loc2_ = new PvpFightChangeInfo();
            _loc2_.user_id = _loc9_.readUnsignedInt();
            _loc2_.catch_time = _loc9_.readUnsignedInt();
            _loc2_.anger = _loc9_.readUnsignedInt();
            _loc2_.position = _loc4_ + 1;
            fightController.addPvpFightInfo(_loc2_);
            _loc6_ = SceneManager.active as ArenaScene;
            _loc8_ = _loc6_.arenaData.getFighter(_loc2_.user_id,_loc2_.catch_time);
            _loc4_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.PVP_FIGHT_NOTIFY_MON_POS_17,this.processor);
      }
   }
}

