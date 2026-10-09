package com.taomee.seer2.app.processor.quest.handler.branch.quest10162
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.IDataInput;
   
   public class QuestMapHandler_10162_610 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10162_610(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isStepComplete(_quest.id,1) && QuestManager.isStepComplete(_quest.id,2) == false && SceneManager.prevSceneType == 2)
         {
            if(FightManager.fightWinnerSide == 1)
            {
               this.doWin();
            }
         }
      }
      
      private function doWin() : void
      {
         SwapManager.swapItem(923,1,this.onSwap);
      }
      
      private function onSwap(param1:IDataInput) : void
      {
         var _loc2_:SwapInfo = new SwapInfo(param1,false);
         ServerBufferManager.updateServerBuffer(37,14,1);
         QuestManager.addEventListener("stepComplete",this.onStepHandler);
         QuestManager.completeStep(_quest.id,2);
      }
      
      private function onStepHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStepHandler);
         SceneManager.changeScene(1,50);
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStepHandler);
      }
   }
}

