package com.taomee.seer2.app.processor.quest.handler.activity.quest30044
{
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   
   public class QuestMapHandler_30044_10 extends QuestMapHandler
   {
      
      private var _npc:Mobile;
      
      public function QuestMapHandler_30044_10(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         if(QuestManager.isAccepted(_quest.id) && QuestManager.isStepComplete(_quest.id,1) == false)
         {
            this._npc = MobileManager.getMobile(1,"npc");
            this._npc.addEventListener("click",this.onNpc,false,1);
         }
      }
      
      private function onNpc(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this._npc.removeEventListener("click",this.onNpc);
         ServerBufferManager.getServerBuffer(68,this.onQuest);
      }
      
      private function onQuest(param1:ServerBuffer) : void
      {
         var server:ServerBuffer = param1;
         var count:uint = uint(server.readDataAtPostion(5));
         if(count < 1)
         {
            count++;
            ServerBufferManager.updateServerBuffer(68,5,count);
            NpcDialog.show(1,"船长",[[0,"新年快乐！我的星际赛尔！崭新的一年去创造新的辉煌吧！"]],["我会的！谢谢船长！"],[function():void
            {
               var data:* = {};
               data.index = 3;
               ModuleManager.toggleModule(URLUtil.getAppModule("OpenSchoolPanel"),"正在打开面板...",data);
               ServerMessager.addMessage("得到船长的祝福");
               if(server.readDataAtPostion(8) >= 1 && server.readDataAtPostion(6) >= 1 && server.readDataAtPostion(7) >= 1)
               {
                  QuestManager.completeStep(30044,1);
                  NpcDialog.show(113,"NONO",[[0,"船长、伊娃、克拉克和娜威拉都太给力啦！哈哈！我们回去看看传送仓装修成什么样子了吧！"]],["走！"],[function():void
                  {
                     SceneManager.changeScene(1,70);
                  }]);
               }
            }]);
         }
      }
   }
}

