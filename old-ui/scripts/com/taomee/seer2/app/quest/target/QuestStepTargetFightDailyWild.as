package com.taomee.seer2.app.quest.target
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.data.TargetDefinition;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestStepTargetFightDailyWild extends BaseQuestStepTarget
   {
      
      public function QuestStepTargetFightDailyWild(param1:Quest, param2:TargetDefinition)
      {
         super(param1,param2);
      }
      
      override public function start() : void
      {
         super.start();
         SceneManager.addEventListener("switchComplete",this.onSwitchComplete);
      }
      
      override public function finish() : void
      {
         SceneManager.removeEventListener("switchComplete",this.onSwitchComplete);
         super.finish();
      }
      
      private function onSwitchComplete(param1:SceneEvent) : void
      {
         var _loc2_:int = 0;
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1)
         {
            if(FightManager.currentFightRecord && FightManager.currentFightRecord.initData && Boolean(FightManager.currentFightRecord.initData.positionIndex) && Boolean(FightManager.currentFightRecord.initData.type) && FightManager.currentFightRecord.initData.type == "fightWild")
            {
               _loc2_ = int(FightManager.currentFightRecord.initData.positionIndex);
               if(SceneManager.active.mapID == uint(_params) && _loc2_ >= 0 && _loc2_ <= 9)
               {
                  this.execute();
               }
            }
         }
      }
      
      override protected function execute() : void
      {
         super.execute();
         if(isFinish == true && _quest.status == 1)
         {
            this.finish();
            QuestManager.addEventListener("stepComplete",onCompleteStep);
            QuestManager.addEventListener("complete",onCompleteStep);
            QuestManager.completeStep(_quest.id,_quest.getCurrentOrNextStep().id);
         }
      }
      
      override protected function completeStep() : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PetKingIngPanel"),"正在打开面板...");
      }
   }
}

