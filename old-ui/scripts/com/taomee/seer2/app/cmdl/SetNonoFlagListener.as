package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   import org.taomee.bean.BaseBean;
   
   public class SetNonoFlagListener extends BaseBean
   {
      
      public function SetNonoFlagListener()
      {
         super();
      }
      
      override public function start() : void
      {
         Connection.addCommandListener(CommandSet.SET_NONO_FLAG_1194,this.onData);
         finish();
      }
      
      private function onData(param1:MessageEvent) : void
      {
         var _loc3_:Actor = null;
         var _loc2_:IDataInput = param1.message.getRawDataCopy();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         _loc3_ = ActorManager.getActorById(_loc4_);
         if(_loc3_ != null)
         {
            _loc3_.getInfo().updateNonoInfo(_loc2_);
         }
      }
   }
}

