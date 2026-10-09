package com.taomee.seer2.app.quest.target
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.data.TargetDefinition;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class QuestStepTargetCatchWild extends BaseQuestStepTarget
   {
      
      public function QuestStepTargetCatchWild(param1:Quest, param2:TargetDefinition)
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
            if(FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.positionIndex && FightManager.currentFightRecord.initData.type && FightManager.currentFightRecord.initData.type == "fightWild" && FightManager.endReason == 7)
            {
               _loc2_ = int(FightManager.currentFightRecord.initData.positionIndex);
               if(SceneManager.active.mapID == uint(_params) && _loc2_ >= 0 && _loc2_ <= 9)
               {
                  execute();
               }
            }
         }
      }
   }
}

