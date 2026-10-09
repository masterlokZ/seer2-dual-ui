package com.taomee.seer2.app.processor.quest.handler.branch.quest10164
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestMapHandler_10164_160 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10164_160(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         DialogPanel.removeEventListener("customReplyClick",this.onReply);
         QuestManager.removeEventListener("stepComplete",this.onStepComplete);
         QuestManager.removeEventListener("complete",this.onComplete);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(isNeedCompleteStep(1))
         {
            DialogPanel.addEventListener("customReplyClick",this.onReply);
         }
         if(isNeedCompleteStep(2))
         {
            QuestManager.addEventListener("stepComplete",this.onStepComplete);
         }
         if(isNeedCompleteStep(6))
         {
            QuestManager.addEventListener("complete",this.onComplete);
         }
      }
      
      private function onComplete(param1:QuestEvent) : void
      {
         if(param1.questId == 10164)
         {
            QuestManager.removeEventListener("complete",this.onComplete);
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10164_0"));
         }
      }
      
      private function onReply(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         if((event.content as DialogPanelEventData).params == "playNpcTalk")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onReply);
            MovieClipUtil.playNpcTalkNew(URLUtil.getQuestNpcTalkAnimation("10164_0"),4,[[1,0]],function():void
            {
               QuestManager.addEventListener("stepComplete",onStepComplete);
               QuestManager.completeStep(questID,1);
            });
         }
      }
      
      private function onStepComplete(param1:QuestEvent) : void
      {
         if(questID == param1.questId)
         {
            if(param1.stepId == 2)
            {
               SceneManager.changeScene(1,840);
            }
         }
      }
   }
}

