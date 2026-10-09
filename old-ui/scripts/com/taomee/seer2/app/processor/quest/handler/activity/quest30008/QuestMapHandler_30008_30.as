package com.taomee.seer2.app.processor.quest.handler.activity.quest30008
{
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_30008_30 extends QuestMapHandler
   {
      
      public function QuestMapHandler_30008_30(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            QuestManager.addEventListener("accept",this.onAccept);
         }
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("accept",this.onAccept);
            SceneManager.changeScene(1,110);
         }
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("accept",this.onAccept);
         super.processMapDispose();
      }
   }
}

