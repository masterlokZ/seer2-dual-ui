package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.config.FitConfig;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_18 extends ArenaProcessor
   {
      
      public function Processor_18(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIT_CHANGE_HP_POS_18,this.processor);
         Connection.blockCommand(CommandSet.FIT_CHANGE_HP_POS_18);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc8_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         var _loc5_:Fighter = null;
         var _loc2_:Fighter = null;
         var _loc10_:SkillInfo = null;
         var _loc7_:IDataInput = param1.message.getRawData();
         var _loc9_:uint = _loc7_.readUnsignedInt();
         var _loc12_:int = 0;
         while(_loc12_ < _loc9_)
         {
            _loc8_ = _loc7_.readUnsignedInt();
            _loc4_ = _loc7_.readUnsignedInt();
            _loc3_ = _loc7_.readUnsignedInt();
            _loc5_ = _secne.arenaData.getFighter(_loc8_,_loc4_);
            _loc5_.fighterInfo.hp = _loc3_;
            if(FitConfig.isPetFit(_loc5_.fighterInfo.bunchId))
            {
               _loc2_ = _loc5_;
            }
            _loc12_++;
         }
         var _loc13_:uint = _loc7_.readUnsignedInt();
         var _loc11_:Vector.<SkillInfo> = Vector.<SkillInfo>([]);
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_)
         {
            _loc10_ = new SkillInfo(_loc7_.readUnsignedInt());
            _loc11_.push(_loc10_);
            _loc14_++;
         }
         if(_loc13_ != 0)
         {
            _loc2_.fighterInfo.setSkillList(_loc11_);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIT_CHANGE_HP_POS_18,this.processor);
      }
   }
}

