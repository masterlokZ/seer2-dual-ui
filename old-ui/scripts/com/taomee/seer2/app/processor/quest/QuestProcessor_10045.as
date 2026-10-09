package com.taomee.seer2.app.processor.quest
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class QuestProcessor_10045 extends QuestProcessor
   {
      
      public function QuestProcessor_10045(param1:Quest)
      {
         super(param1);
         if(QuestManager.isAccepted(10045))
         {
            this.updateQuestStatus();
         }
         else
         {
            QuestManager.addEventListener("accept",this.onQuestAccepted);
         }
      }
      
      private function onQuestAccepted(param1:QuestEvent) : void
      {
         if(param1.questId == 10045)
         {
            QuestManager.removeEventListener("accept",this.onQuestAccepted);
            this.updateQuestStatus();
         }
      }
      
      private function updateQuestStatus() : void
      {
         var _loc1_:uint = uint(_quest.getStepData(1,0));
         if(QuestManager.isStepComplete(10045,1) == false && _loc1_ >= 10)
         {
            QuestManager.addEventListener("stepComplete",this.onCompleteStep1);
            QuestManager.completeStep(_quest.id,1);
         }
         else if(QuestManager.isStepComplete(10045,1) == false)
         {
            SceneManager.addEventListener("switchComplete",this.onMapComplete);
         }
      }
      
      private function onMapComplete(param1:SceneEvent) : void
      {
         if(SceneManager.active.mapID == 141 && _quest.isStepCompletable(1))
         {
            this.processStep1();
         }
      }
      
      private function processStep1() : void
      {
         var _loc1_:uint = 0;
         if(_quest.getStepData(1,0) >= 10)
         {
            SceneManager.removeEventListener("switchComplete",this.onMapComplete);
            QuestManager.addEventListener("stepComplete",this.onCompleteStep1);
            QuestManager.completeStep(_quest.id,1);
         }
         else if(SceneManager.prevSceneType == 2)
         {
            if(FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.positionIndex && FightManager.currentFightRecord.initData.positionIndex < 10 && FightManager.fightWinnerSide == 1)
            {
               _loc1_ = uint(_quest.getStepData(1,0));
               _quest.setStepData(1,0,_loc1_ + 1);
               QuestManager.setStepBufferServer(_quest.id,1);
            }
            if(_quest.getStepData(1,0) >= 10)
            {
               QuestManager.addEventListener("stepComplete",this.onCompleteStep1);
               QuestManager.completeStep(_quest.id,1);
            }
            else
            {
               ServerMessager.addMessage("还需要获得 <font color=\'#ffcc00\'>" + (10 - _quest.getStepData(1,0)) + " </font> 罐 <font color=\'#ffcc00\'>地蜡</font>");
            }
         }
      }
      
      private function onCompleteStep1(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id && param1.stepId == 1)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep1);
            if(SceneManager.active && SceneManager.active.type == 1 && SceneManager.prevSceneType == 2)
            {
               ServerMessager.addMessage("收集到足够的地蜡了，快回 <font color=\'#ffcc00\'>小屋</font> 看看装修进度吧");
            }
         }
      }
      
      override public function dispose() : void
      {
         QuestManager.removeEventListener("accept",this.onQuestAccepted);
         QuestManager.removeEventListener("stepComplete",this.onCompleteStep1);
         SceneManager.removeEventListener("switchComplete",this.onMapComplete);
         super.dispose();
      }
   }
}

