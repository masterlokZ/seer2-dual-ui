package com.taomee.seer2.app.processor.quest.handler.branch.quest10186
{
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestMapHandler_10186_4704 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10186_4704(param1:QuestProcessor)
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
         if(!QuestManager.isComplete(10186))
         {
            QuestManager.addEventListener("complete",this.onComplete);
         }
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("accept",this.onAccept);
         QuestManager.removeEventListener("stepComplete",this.onStepComplete);
         QuestManager.removeEventListener("complete",this.onComplete);
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         if(param1.questId == 10186)
         {
            QuestManager.removeEventListener("accept",this.onAccept);
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10186_0"),null,true,true);
         }
      }
      
      private function onStepComplete(param1:QuestEvent) : void
      {
         if(param1.questId == 10186 && param1.stepId == 1)
         {
            QuestManager.removeEventListener("stepComplete",this.onStepComplete);
            ModuleManager.toggleModule(URLUtil.getAppModule("YueBeastPanel"),"","1");
         }
      }
      
      private function onComplete(param1:QuestEvent) : void
      {
         if(param1.questId == 10186)
         {
            QuestManager.removeEventListener("complete",this.onComplete);
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10186_1"),null,true,true);
         }
      }
   }
}

