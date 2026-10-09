package com.taomee.seer2.app.processor.quest.handler.story.quest74
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.quest.mark.AcceptableMark;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_74_1240 extends QuestMapHandler
   {
      
      public static var haveBattle:Boolean = true;
      
      private var _mc1:MovieClip;
      
      private var _mack:AcceptableMark;
      
      public function QuestMapHandler_74_1240(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         if(!haveBattle)
         {
            return;
         }
         super.processMapComplete();
         if(!QuestManager.isAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep);
         }
         if(QuestManager.isAccepted(_quest.id) && !QuestManager.isStepComplete(_quest.id,1))
         {
            _map.content.visible = false;
            this.initStep1();
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "74_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            QuestManager.addEventListener("accept",this.onAcceptHandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         this.initStep1();
      }
      
      private function initStep1() : void
      {
         QuestManager.addEventListener("stepComplete",this.onStepComplete);
         QuestManager.completeStep(74,1);
      }
      
      private function onStepComplete(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStepComplete);
         SceneManager.changeScene(1,1210);
      }
      
      override public function processMapDispose() : void
      {
         MobileManager.showMoileVec("npc");
         ActorManager.showRemoteActor = true;
         ActorManager.getActor().isShow = true;
         ActorManager.getActor().blockNoNo = false;
         QuestManager.removeEventListener("complete",this.onStepComplete);
         DisplayUtil.removeForParent(this._mc1);
         DisplayUtil.removeForParent(this._mack);
      }
   }
}

