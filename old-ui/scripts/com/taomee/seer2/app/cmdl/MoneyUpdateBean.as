package com.taomee.seer2.app.cmdl
{
   import com.adobe.crypto.MD5;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.events.UserInfoEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   import org.taomee.bean.BaseBean;
   
   public class MoneyUpdateBean extends BaseBean
   {
      
      public function MoneyUpdateBean()
      {
         super();
         Connection.addCommandListener(CommandSet.MI_BUY_ITEM_1224,this.onUpdate);
         Connection.addCommandListener(CommandSet.CLI_MONEY_COUNT_1253,this.onMoneyCount);
         Connection.send(CommandSet.CLI_MONEY_COUNT_1253,this.getResult());
         finish();
      }
      
      private function getResult() : LittleEndianByteArray
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         var _loc4_:LittleEndianByteArray = new LittleEndianByteArray();
         var _loc3_:String = MD5.hash("0");
         var _loc6_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc2_ = _loc3_.substr(_loc5_,2);
            _loc1_ = parseInt(_loc2_,16);
            _loc4_.writeByte(_loc1_);
            _loc5_ += 2;
         }
         return _loc4_;
      }
      
      private function onMoneyCount(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc3_:uint = _loc2_.readUnsignedInt();
         ActorManager.actorInfo.moneyCount = _loc3_ / 100;
         if(ActorManager.actorInfo.hasEventListener("UPDATE_MONEY"))
         {
            ActorManager.actorInfo.dispatchEvent(new UserInfoEvent("UPDATE_MONEY"));
         }
      }
      
      private function onUpdate(param1:MessageEvent = null) : void
      {
         Connection.send(CommandSet.CLI_MONEY_COUNT_1253,this.getResult());
      }
   }
}

