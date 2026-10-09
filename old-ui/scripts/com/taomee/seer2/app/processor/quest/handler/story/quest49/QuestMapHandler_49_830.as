package com.taomee.seer2.app.processor.quest.handler.story.quest49
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_49_830 extends QuestMapHandler
   {
      
      public function QuestMapHandler_49_830(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onFirstStepHandler);
         }
      }
      
      private function onFirstStepHandler(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "49_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onFirstStepHandler);
            QuestManager.addEventListener("accept",this.AcceptHandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function AcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.AcceptHandler);
         SceneManager.changeScene(1,840);
      }
      
      override public function processMapDispose() : void
      {
         DialogPanel.removeEventListener("customReplyClick",this.onFirstStepHandler);
         QuestManager.removeEventListener("accept",this.AcceptHandler);
      }
   }
}

