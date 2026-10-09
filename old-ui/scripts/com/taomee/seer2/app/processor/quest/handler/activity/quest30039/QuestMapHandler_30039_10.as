package com.taomee.seer2.app.processor.quest.handler.activity.quest30039
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_30039_10 extends QuestMapHandler
   {
      
      public function QuestMapHandler_30039_10(param1:QuestProcessor)
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
      }
      
      private function onStart(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "30038_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStart);
            QuestManager.addEventListener("accept",this.onAcceptHandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         SceneManager.changeScene(1,124);
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         DialogPanel.removeEventListener("customReplyClick",this.onStart);
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
      }
   }
}

