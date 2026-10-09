package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.data.BuffResultInfo;
   import com.taomee.seer2.app.arena.data.BuffResultInfoRoundData;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class Processor_9 extends ArenaProcessor
   {
      
      public function Processor_9(param1:ArenaScene)
      {
         super(param1);
      }
      
      public static function parse(param1:MessageEvent) : BuffResultInfo
      {
         var _loc4_:IDataInput = param1.message.getRawData();
         var _loc6_:BuffResultInfo = new BuffResultInfo();
         _loc6_.userId = _loc4_.readUnsignedInt();
         _loc6_.fighterId = _loc4_.readUnsignedInt();
         _loc6_.isDying = _loc4_.readUnsignedByte() == 1;
         var _loc5_:Vector.<BuffResultInfoRoundData> = new Vector.<BuffResultInfoRoundData>();
         var _loc3_:int = int(_loc4_.readUnsignedInt());
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_.push(new BuffResultInfoRoundData(_loc4_));
            _loc2_++;
         }
         _loc6_.buffResultInfoRoundDatas = _loc5_;
         return _loc6_;
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_BUFF_RESULT_NOTIFY_9,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         fightController.addBuffResultInfo(parse(param1));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_BUFF_RESULT_NOTIFY_9,this.processor);
      }
   }
}

