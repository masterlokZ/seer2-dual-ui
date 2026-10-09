package com.taomee.seer2.app.processor.quest.handler.branch.quest10139
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   
   public class QuestMapHandler_10139_160 extends QuestMapHandler
   {
      
      private var _mc_0:MovieClip;
      
      public function QuestMapHandler_10139_160(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isStepComplete(_quest.id,6) && QuestManager.isStepComplete(_quest.id,7) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep);
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "10139_5")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            QuestManager.addEventListener("stepComplete",this.onStep7Handler);
            QuestManager.completeStep(_quest.id,7);
         }
      }
      
      private function onStep7Handler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStep7Handler);
         SceneManager.changeScene(1,220);
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStep7Handler);
      }
   }
}

