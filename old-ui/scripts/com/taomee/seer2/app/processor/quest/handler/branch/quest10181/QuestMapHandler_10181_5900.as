package com.taomee.seer2.app.processor.quest.handler.branch.quest10181
{
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestMapHandler_10181_5900 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10181_5900(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(isNeedToAccept())
         {
            QuestManager.addEventListener("accept",this.onAccept);
            QuestManager.addEventListener("stepComplete",this.onStepComplete);
         }
         if(isNeedCompleteStep(1))
         {
            QuestManager.addEventListener("stepComplete",this.onStepComplete);
         }
         if(QuestManager.isStepComplete(questID,2) && !QuestManager.isComplete(questID))
         {
            QuestManager.addEventListener("complete",this.onComplete);
            QuestManager.completeStep(questID,3);
         }
      }
      
      private function onComplete(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onComplete);
         if(param1.questId == 10181)
         {
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10181_1"),null,true,true);
         }
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         if(param1.questId == 10181)
         {
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10181_0"),null,true,true);
         }
      }
      
      private function onStepComplete(param1:QuestEvent) : void
      {
         if(param1.questId == 10181)
         {
            if(param1.stepId == 1)
            {
               ModuleManager.toggleModule(URLUtil.getAppModule("QinBeastPanel"),"","3");
            }
         }
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         QuestManager.removeEventListener("stepComplete",this.onStepComplete);
         QuestManager.removeEventListener("accept",this.onAccept);
      }
   }
}

