package com.taomee.seer2.app.processor.quest.handler.activity.quest30009
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   
   public class QuestMapHandler_30009_70 extends QuestMapHandler
   {
      
      public function QuestMapHandler_30009_70(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStartHandler);
         }
      }
      
      private function onStartHandler(param1:DialogPanelEvent) : void
      {
         ActorManager.showRemoteActor = false;
         if((param1.content as DialogPanelEventData).params == "30009_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStartHandler);
            QuestManager.addEventListener("accept",this.onAcceptHandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
      }
      
      override public function processMapDispose() : void
      {
         DialogPanel.removeEventListener("customReplyClick",this.onStartHandler);
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
      }
   }
}

