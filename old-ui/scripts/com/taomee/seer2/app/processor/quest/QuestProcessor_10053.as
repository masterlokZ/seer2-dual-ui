package com.taomee.seer2.app.processor.quest
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class QuestProcessor_10053 extends QuestProcessor
   {
      
      public var count:int = 0;
      
      public function QuestProcessor_10053(param1:Quest)
      {
         super(param1);
         SceneManager.addEventListener("switchComplete",this.onSwictchComplete);
      }
      
      private function onSwictchComplete(param1:SceneEvent) : void
      {
         var _loc2_:Boolean = false;
         if(SceneManager.active.mapID == 100 || SceneManager.active.mapID == 101)
         {
            _loc2_ = true;
         }
         if(_loc2_ && QuestManager.isAccepted(_quest.id) && SceneManager.prevSceneType == 2)
         {
            if(FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.bossId == 1)
            {
               ++this.count;
            }
         }
      }
      
      override public function dispose() : void
      {
         SceneManager.removeEventListener("switchComplete",this.onSwictchComplete);
         super.dispose();
      }
   }
}

