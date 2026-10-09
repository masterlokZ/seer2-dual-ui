package com.taomee.seer2.app.processor.quest.handler.branch.quest10199
{
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_10199_660 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10199_660(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         if(QuestManager.isStepComplete(10199,1) == false)
         {
            QuestManager.addEventListener("stepComplete",this.onStep);
         }
      }
      
      private function onStep(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id && param1.stepId == 1)
         {
            QuestManager.removeEventListener("stepComplete",this.onStep);
            SceneManager.changeScene(1,302);
         }
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStep);
         super.processMapDispose();
      }
   }
}

