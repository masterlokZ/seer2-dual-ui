package com.taomee.seer2.app.processor.quest.handler.branch.quest10165
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_10165_1090 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10165_1090(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isAccepted(_quest.id) && QuestManager.isStepComplete(_quest.id,1) == false)
         {
            if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1)
            {
               this.doWin();
            }
            DialogPanel.addEventListener("questUnitClick",this.onQuestUnit);
         }
         else if(QuestManager.isCanAccepted(_quest.id))
         {
            QuestManager.addEventListener("accept",this.onAccept);
         }
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("accept",this.onAccept);
            DialogPanel.addEventListener("questUnitClick",this.onQuestUnit);
         }
      }
      
      private function onQuestUnit(param1:DialogPanelEvent) : void
      {
         if(param1.content.questId == _quest.id && param1.content.stepId == 1)
         {
            ServerBufferManager.getServerBuffer(66,this.onDialog);
            DialogPanel.hide();
         }
      }
      
      private function onDialog(param1:ServerBuffer) : void
      {
         var _loc2_:uint = uint(param1.readDataAtPostion(0));
         NpcDialog.show(193,"熊猫酒仙",[[0,"你还需要打败" + (10 - _loc2_) + "个玩耍的乔飞！去，完成挑战再来找我！"]],["呼呼，很累啊！"]);
      }
      
      private function doWin() : void
      {
         ServerBufferManager.getServerBuffer(66,this.onServer);
      }
      
      private function onServer(param1:ServerBuffer) : void
      {
         var _loc2_:uint = uint(param1.readDataAtPostion(0));
         ServerBufferManager.updateServerBuffer(66,0,_loc2_ + 1);
         if(_loc2_ + 1 >= 10)
         {
            this.completeQuest();
         }
         else
         {
            ServerMessager.addMessage("还需要击败" + (10 - (_loc2_ + 1)) + "位熊猫人对手！");
         }
      }
      
      private function completeQuest() : void
      {
         QuestManager.completeStep(_quest.id,1);
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         DialogPanel.removeEventListener("questUnitClick",this.onQuestUnit);
      }
   }
}

