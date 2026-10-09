package com.taomee.seer2.app.processor.quest.handler.story.quest56
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_56_10 extends QuestMapHandler
   {
      
      public function QuestMapHandler_56_10(param1:QuestProcessor)
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
         if(QuestManager.isStepComplete(_quest.id,6) && QuestManager.isStepComplete(_quest.id,7) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onStepSevenHandler);
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "56_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            QuestManager.addEventListener("accept",this.onAcceptHandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         SceneManager.changeScene(1,110);
      }
      
      private function onStepSevenHandler(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "56_7")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStepSevenHandler);
            QuestManager.addEventListener("stepComplete",this.onStepCompleteHandler);
            QuestManager.completeStep(_quest.id,7);
         }
      }
      
      private function onStepCompleteHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStepCompleteHandler);
         SceneManager.changeScene(1,890);
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         QuestManager.removeEventListener("stepComplete",this.onStepCompleteHandler);
      }
   }
}

