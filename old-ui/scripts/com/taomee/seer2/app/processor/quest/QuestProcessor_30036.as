package com.taomee.seer2.app.processor.quest
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestProcessor_30036 extends QuestProcessor
   {
      
      public function QuestProcessor_30036(param1:Quest)
      {
         super(param1);
         SceneManager.addEventListener("switchComplete",this.onMapComplete);
      }
      
      private function onMapComplete(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && QuestManager.isAccepted(_quest.id) && QuestManager.isStepComplete(_quest.id,1) == false)
         {
            if(SceneManager.active.type == 3 && SceneManager.active.mapID != ActorManager.actorInfo.id)
            {
               QuestManager.addEventListener("stepComplete",this.onStepComplete);
               QuestManager.completeStep(_quest.id,1);
            }
         }
      }
      
      private function onStepComplete(param1:QuestEvent) : void
      {
         var event:QuestEvent = param1;
         QuestManager.removeEventListener("stepComplete",this.onStepComplete);
         MovieClipUtil.playFullScreen(URLUtil.getActivityAnimation("xegg/xegg5"),function():void
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("XeggPanel"),"正在打开面板...");
         },true,true,2);
      }
   }
}

