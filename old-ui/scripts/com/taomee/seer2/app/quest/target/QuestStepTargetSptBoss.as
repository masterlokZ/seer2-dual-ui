package com.taomee.seer2.app.quest.target
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.data.TargetDefinition;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class QuestStepTargetSptBoss extends BaseQuestStepTarget
   {
      
      private var _bossId:int;
      
      public function QuestStepTargetSptBoss(param1:Quest, param2:TargetDefinition)
      {
         super(param1,param2);
         this._bossId = int(_params);
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
         if(SceneManager.prevSceneType == 2)
         {
            if(FightManager.currentFightRecord && FightManager.currentFightRecord.initData && Boolean(FightManager.currentFightRecord.initData.bossId) && Boolean(FightManager.currentFightRecord.initData.type) && FightManager.currentFightRecord.initData.type == "fightBoss")
            {
               if(FightManager.currentFightRecord.initData.bossId == this._bossId)
               {
                  execute();
               }
            }
         }
      }
   }
}

