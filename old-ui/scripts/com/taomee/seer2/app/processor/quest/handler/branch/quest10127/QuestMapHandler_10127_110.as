package com.taomee.seer2.app.processor.quest.handler.branch.quest10127
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.NpcUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestMapHandler_10127_110 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10127_110(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStart);
         }
         if(QuestManager.isStepComplete(_quest.id,1) && QuestManager.isStepComplete(_quest.id,2) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onSecond);
         }
      }
      
      private function onStart(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         if((evt.content as DialogPanelEventData).params == "10127_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStart);
            NpcDialog.show(NpcUtil.getSeerNpcId(),"我",[[0,"阿宝它要去骰子星寻宝啦！我想邀请您去幽静浅滩为它饯行，壮壮胆！您知道它可从来没有出过远门呢。"]],[" 您愿意吗？"],[function():void
            {
               NpcDialog.show(16,"神目酋长",[[0,"哦，可以啊。咳——如果现在来一杯药酒，我这老腿可能会更麻利些，去水仙溪口找维拉，她的手艺我最放心。"]],["好！这就去！"],[function():void
               {
                  QuestManager.addEventListener("accept",onAcceptHandler);
                  QuestManager.accept(_quest.id);
               }]);
            }]);
         }
      }
      
      private function onSecond(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "10127_2")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onSecond);
            QuestManager.addEventListener("complete",this.onCompleteHandler);
            QuestManager.completeStep(_quest.id,2);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         SceneManager.changeScene(1,151);
      }
      
      private function onCompleteHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onCompleteHandler);
         ModuleManager.toggleModule(URLUtil.getAppModule("SayGood_byeToAboPanel"),"正在打开面板...");
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         DialogPanel.removeEventListener("customReplyClick",this.onStart);
         DialogPanel.removeEventListener("customReplyClick",this.onSecond);
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
      }
   }
}

