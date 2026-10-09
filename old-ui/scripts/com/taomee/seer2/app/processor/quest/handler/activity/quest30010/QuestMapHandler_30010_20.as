package com.taomee.seer2.app.processor.quest.handler.activity.quest30010
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_30010_20 extends QuestMapHandler
   {
      
      public function QuestMapHandler_30010_20(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(!QuestManager.isAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onAccept);
         }
      }
      
      private function onAccept(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "accept")
         {
            QuestManager.addEventListener("accept",this.acceptHanlder);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function acceptHanlder(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("accept",this.acceptHanlder);
            SceneManager.changeScene(3,ActorManager.actorInfo.id,600,400);
         }
      }
      
      override public function processMapDispose() : void
      {
         DialogPanel.removeEventListener("customReplyClick",this.onAccept);
         super.processMapDispose();
      }
   }
}

