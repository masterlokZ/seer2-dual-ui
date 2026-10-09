package com.taomee.seer2.app.processor.quest
{
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   
   public class QuestProcessor_1 extends QuestProcessor
   {
      
      public function QuestProcessor_1(param1:Quest)
      {
         QuestManager.addEventListener("complete",this.onQuestComplete);
         _isLoadResLib = true;
         super(param1);
      }
      
      private function onQuestComplete(param1:QuestEvent) : void
      {
         if(param1.questId == 1)
         {
            QuestManager.removeEventListener("complete",this.onQuestComplete);
            StatisticsManager.sendNovice("0x10030601");
         }
      }
   }
}

