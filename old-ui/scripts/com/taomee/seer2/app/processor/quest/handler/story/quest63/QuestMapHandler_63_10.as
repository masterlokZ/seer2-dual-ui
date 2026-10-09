package com.taomee.seer2.app.processor.quest.handler.story.quest63
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_63_10 extends QuestMapHandler
   {
      
      public function QuestMapHandler_63_10(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep);
         }
         if(QuestManager.isStepComplete(_quest.id,4) && QuestManager.isStepComplete(_quest.id,5) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep1);
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "63_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            QuestManager.addEventListener("accept",this.onAcceptHandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         SceneManager.changeScene(1,20);
      }
      
      private function onStep1(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "63_3")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep1);
            QuestManager.addEventListener("complete",this.onCompleteHandler);
            QuestManager.completeStep(_quest.id,5);
         }
      }
      
      private function onCompleteHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onCompleteHandler);
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         QuestManager.removeEventListener("complete",this.onCompleteHandler);
      }
   }
}

