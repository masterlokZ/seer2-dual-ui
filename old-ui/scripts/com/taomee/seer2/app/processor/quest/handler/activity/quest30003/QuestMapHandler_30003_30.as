package com.taomee.seer2.app.processor.quest.handler.activity.quest30003
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.NpcUtil;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_30003_30 extends QuestMapHandler
   {
      
      private var _mc_0:MovieClip;
      
      private var _mc_1:MovieClip;
      
      public function QuestMapHandler_30003_30(param1:QuestProcessor)
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
         if(QuestManager.isStepComplete(_quest.id,3) && QuestManager.isStepComplete(_quest.id,4) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep4);
         }
         if(QuestManager.isStepComplete(_quest.id,6) && QuestManager.isStepComplete(_quest.id,7) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onEnd);
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "41_0")
         {
            QuestManager.addEventListener("accept",this.onAccept);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAccept);
         SceneManager.changeScene(1,124);
      }
      
      private function onStep4(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         if((event.content as DialogPanelEventData).params == "41_1")
         {
            NpcDialog.show(NpcUtil.getSeerNpcId(),"我",[[0,"信奉广场！信奉广场！我听酋长说过，这里是他们举行任何仪式的地方，这里可以集合天地之灵气！！！"]],["（赶往信奉广场）"],[function():void
            {
               QuestManager.addEventListener("stepComplete",onStep4Handler);
               QuestManager.completeStep(_quest.id,4);
            }]);
         }
      }
      
      private function onStep4Handler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStep4Handler);
         SceneManager.changeScene(1,20000);
      }
      
      private function onEnd(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "41_2")
         {
            QuestManager.addEventListener("complete",this.onComplete);
            QuestManager.completeStep(_quest.id,7);
         }
      }
      
      private function onComplete(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onComplete);
         if(param1.questId == 40)
         {
            if(this._mc_0)
            {
               DisplayUtil.removeForParent(this._mc_0);
            }
            if(this._mc_1)
            {
               DisplayUtil.removeForParent(this._mc_1);
            }
         }
      }
      
      override public function processMapDispose() : void
      {
         DialogPanel.removeEventListener("customReplyClick",this.onStep);
         QuestManager.removeEventListener("accept",this.onAccept);
      }
   }
}

