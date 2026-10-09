package com.taomee.seer2.app.processor.quest
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestProcessor_10048 extends QuestProcessor
   {
      
      private static const MAP_ID:Array = [152,193,270];
      
      public function QuestProcessor_10048(param1:Quest)
      {
         super(param1);
         if(QuestManager.isAccepted(10048))
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
         if(param1.questId == 10048)
         {
            QuestManager.removeEventListener("accept",this.onQuestAccepted);
            this.updateQuestStatus();
         }
      }
      
      private function updateQuestStatus() : void
      {
         if(QuestManager.isStepComplete(10048,1) == false && _quest.getStepData(1,0) >= 1 && _quest.getStepData(1,1) >= 1 && _quest.getStepData(1,2) >= 1)
         {
            QuestManager.addEventListener("stepComplete",this.onCompleteStep1);
            QuestManager.completeStep(_quest.id,1);
         }
         else if(QuestManager.isStepComplete(10048,1) == false)
         {
            SceneManager.addEventListener("switchComplete",this.onMapComplete);
         }
      }
      
      private function onMapComplete(param1:SceneEvent) : void
      {
         if(MAP_ID.indexOf(SceneManager.active.mapID) != -1 && _quest.isStepCompletable(1))
         {
            this.processStep1();
         }
      }
      
      private function processStep1() : void
      {
         var _loc2_:int = 0;
         var _loc1_:uint = 0;
         if(_quest.getStepData(1,0) >= 1 && _quest.getStepData(1,1) >= 1 && _quest.getStepData(1,2) >= 1)
         {
            SceneManager.removeEventListener("switchComplete",this.onMapComplete);
            QuestManager.addEventListener("stepComplete",this.onCompleteStep1);
            QuestManager.completeStep(_quest.id,1);
         }
         else if(SceneManager.prevSceneType == 2)
         {
            _loc2_ = MAP_ID.indexOf(SceneManager.active.mapResourceID);
            if(FightManager.fightWinnerSide == 1 && (SceneManager.active.mapResourceID == 152 && FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.bossId && FightManager.currentFightRecord.initData.bossId == 57 || SceneManager.active.mapResourceID == 193 && FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.bossId && FightManager.currentFightRecord.initData.bossId == 31 || SceneManager.active.mapResourceID == 270 && FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.bossId && FightManager.currentFightRecord.initData.bossId == 38))
            {
               _loc1_ = uint(_quest.getStepData(1,_loc2_));
               if(_loc1_ == 0)
               {
                  _quest.setStepData(1,_loc2_,1);
                  QuestManager.setStepBufferServer(_quest.id,1);
                  if(_quest.getStepData(1,0) >= 1 && _quest.getStepData(1,1) >= 1 && _quest.getStepData(1,2) >= 1)
                  {
                     SceneManager.removeEventListener("switchComplete",this.onMapComplete);
                     QuestManager.addEventListener("stepComplete",this.onCompleteStep1);
                     QuestManager.completeStep(_quest.id,1);
                  }
                  else
                  {
                     ModuleManager.showModule(URLUtil.getAppModule("DecorateQuestPanel"),"正在打开装修图纸……");
                  }
               }
            }
         }
      }
      
      private function onCompleteStep1(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id && param1.stepId == 1)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep1);
            if(Boolean(SceneManager.active) && SceneManager.active.type == 1)
            {
               ServerMessager.addMessage("战胜三大系族BOSS啦，快回 <font color=\'#ffcc00\'>小屋</font> 看看装修进度吧");
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

