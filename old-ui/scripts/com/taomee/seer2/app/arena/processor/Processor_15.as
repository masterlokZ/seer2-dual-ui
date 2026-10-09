package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.IDataInput;
   
   public class Processor_15 extends ArenaProcessor
   {
      
      public function Processor_15(param1:ArenaScene)
      {
         super(param1);
      }
      
      public static function parserTeamData(param1:IDataInput) : Vector.<ChangeFighterInfo>
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         var _loc5_:uint = 0;
         var _loc4_:uint = 0;
         var _loc6_:Vector.<ChangeFighterInfo> = new Vector.<ChangeFighterInfo>();
         var _loc8_:uint = param1.readUnsignedInt();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc8_)
         {
            _loc3_ = param1.readUnsignedInt();
            _loc2_ = param1.readUnsignedInt();
            _loc5_ = param1.readUnsignedInt();
            _loc4_ = _loc7_ + 1;
            if(_loc2_ != 0)
            {
               _loc6_.push(new ChangeFighterInfo(_loc3_,_loc2_,_loc5_,_loc4_));
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_NOTIFY_MON_POS_15,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawData();
         this.parserLeftTeamData(_loc2_);
         this.parserRightTeamData(_loc2_);
         fightController.checkRightFighterChanged();
      }
      
      private function parserLeftTeamData(param1:IDataInput) : void
      {
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         var _loc7_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:ArenaScene = null;
         var _loc6_:Fighter = null;
         var _loc8_:ChangeFighterInfo = null;
         var _loc9_:Vector.<ChangeFighterInfo> = new Vector.<ChangeFighterInfo>();
         var _loc11_:uint = param1.readUnsignedInt();
         var _loc10_:uint = 0;
         while(_loc10_ < _loc11_)
         {
            _loc4_ = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedInt();
            _loc7_ = param1.readUnsignedInt();
            _loc5_ = _loc10_ + 1;
            _loc2_ = SceneManager.active as ArenaScene;
            _loc6_ = _loc2_.arenaData.getFighter(_loc4_,_loc3_);
            if(_loc3_ != 0)
            {
               _loc9_.push(new ChangeFighterInfo(_loc4_,_loc3_,_loc7_,_loc5_));
            }
            _loc10_++;
         }
         while(_loc9_.length > 0)
         {
            _loc8_ = _loc9_.shift();
            fightController.changeFighter(_loc8_.userId,_loc8_.petCatchTime,_loc8_.angerValue,_loc8_.position);
         }
      }
      
      private function parserRightTeamData(param1:IDataInput) : void
      {
         var _loc8_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         var _loc5_:ArenaScene = null;
         var _loc2_:Fighter = null;
         var _loc7_:uint = param1.readUnsignedInt();
         var _loc9_:uint = 0;
         while(_loc9_ < _loc7_)
         {
            _loc8_ = param1.readUnsignedInt();
            _loc4_ = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedInt();
            _loc6_ = _loc9_ + 1;
            _loc5_ = SceneManager.active as ArenaScene;
            _loc2_ = _loc5_.arenaData.getFighter(_loc8_,_loc4_);
            if(_loc4_ != 0)
            {
               fightController.changeFighter(_loc8_,_loc4_,_loc3_,_loc6_);
            }
            _loc9_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_NOTIFY_MON_POS_15,this.processor);
      }
   }
}

