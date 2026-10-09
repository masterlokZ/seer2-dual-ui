package com.taomee.seer2.app.processor.quest.handler.branch.quest10150
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_10150_123 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10150_123(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isAccepted(_quest.id) && SceneManager.prevSceneType == 2 && (FightManager.currentFightRecord.initData.positionIndex == 1 || FightManager.currentFightRecord.initData.positionIndex == 4 || FightManager.currentFightRecord.initData.positionIndex == 7))
         {
            if(FightManager.fightWinnerSide == 1)
            {
               this.doWin();
            }
         }
      }
      
      private function doWin() : void
      {
         DayLimitManager.getDoCount(587,function(param1:int):void
         {
            if(param1 + 1 == 10)
            {
               QuestManager.addEventListener("complete",onQuestComplete);
               QuestManager.completeStep(_quest.id,1);
            }
            else
            {
               ServerMessager.addMessage("你已经击败" + (param1 + 1) + "/10只浣浣！");
            }
         });
         SwapManager.swapItem(904);
      }
      
      private function onQuestComplete(param1:QuestEvent) : void
      {
         var evt:QuestEvent = param1;
         QuestManager.removeEventListener("complete",this.onQuestComplete);
         StatisticsManager.sendNovice("0x1003359C");
         ServerMessager.addMessage("你获得1枚金币！");
         NpcDialog.show(113,"NONO",[[0,"主人！你已经完成了当前的悬赏令！快去找赏金猎人-金那里领取下一个任务吧！"]],["现在就去！","稍后再去。"],[function():void
         {
            SceneManager.changeScene(1,60);
         }]);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         QuestManager.removeEventListener("complete",this.onQuestComplete);
      }
   }
}

