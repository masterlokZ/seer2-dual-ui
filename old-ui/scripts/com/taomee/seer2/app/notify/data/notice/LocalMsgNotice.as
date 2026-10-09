package com.taomee.seer2.app.notify.data.notice
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class LocalMsgNotice extends Notice
   {
      
      private var _obj:Object;
      
      public function LocalMsgNotice(param1:Object)
      {
         this._obj = param1;
         super("localMsg",ActorManager.actorInfo.id);
      }
      
      override public function process() : void
      {
         var _loc1_:* = this._obj.type;
         if("module" === _loc1_)
         {
            ModuleManager.toggleModule(URLUtil.getAppModule(this._obj.param1),"正在面板...",this._obj.param2);
         }
         ServerBufferManager.updateServerBuffer(21,this._obj.index,this._obj.value);
      }
   }
}

