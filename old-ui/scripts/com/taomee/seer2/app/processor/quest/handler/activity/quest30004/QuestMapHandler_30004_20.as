package com.taomee.seer2.app.processor.quest.handler.activity.quest30004
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
   
   public class QuestMapHandler_30004_20 extends QuestMapHandler
   {
      
      public function QuestMapHandler_30004_20(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            DialogPanel.addEventListener("questUnitClick",this.onQuestClick);
         }
         if(QuestManager.isStepComplete(_quest.id,4) && QuestManager.isStepComplete(_quest.id,5) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep);
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         if((event.content as DialogPanelEventData).params == "30004_1")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("30004_4"),function():void
            {
               QuestManager.completeStep(_quest.id,5);
            },true,false,2);
         }
      }
      
      private function onQuestClick(param1:DialogPanelEvent) : void
      {
         if(param1.content.questId == _quest.id && QuestManager.isCanAccepted(_quest.id))
         {
            DialogPanel.removeEventListener("questUnitClick",this.onQuestClick);
            QuestManager.addEventListener("accept",this.onAccept);
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("30004_0"),null,true,false,2);
         }
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAccept);
         if(param1.questId == _quest.id)
         {
            SceneManager.changeScene(1,133);
         }
      }
      
      override public function processMapDispose() : void
      {
         DialogPanel.removeEventListener("customReplyClick",this.onStep);
         DialogPanel.removeEventListener("questUnitClick",this.onQuestClick);
         QuestManager.removeEventListener("accept",this.onAccept);
         super.processMapDispose();
      }
   }
}

