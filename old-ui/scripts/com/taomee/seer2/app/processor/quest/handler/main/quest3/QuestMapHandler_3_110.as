package com.taomee.seer2.app.processor.quest.handler.main.quest3
{
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestMapHandler_3_110 extends QuestMapHandler
   {
      
      private var _resultInfo:FightResultInfo;
      
      public function QuestMapHandler_3_110(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(_quest.status == 0)
         {
            QuestManager.addEventListener("accept",this.onQuestAccept);
         }
         else if(_quest.status == 1)
         {
            if(!_quest.isStepCompete(1))
            {
               this.processStep1();
            }
            else if(!_quest.isStepCompete(2))
            {
               this.processStep2();
            }
            else if(!_quest.isStepCompete(10))
            {
               DialogPanel.addEventListener("customReplyClick",this.onStep);
               PetInfoManager.addEventListener("petLevelUp",this.onPetLevelUp);
            }
         }
      }
      
      private function onQuestAccept(param1:QuestEvent) : void
      {
         if(_quest.id == param1.questId)
         {
            QuestManager.removeEventListener("accept",this.onQuestAccept);
            DialogPanel.showForCommon(_quest.getStep(1).dialog);
            this.processStep1();
         }
      }
      
      private function processStep1() : void
      {
         DialogPanel.addEventListener("customReplyClick",this.onCustomReply);
      }
      
      private function onCustomReply(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         if(DialogPanelEventData(evt.content).params == "3_1")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onCustomReply);
            MovieClipUtil.playNpcTalkNew(URLUtil.getQuestAnimation("3/quest3Animation1"),10,[[1,0],[7,1]],function():void
            {
               QuestManager.addEventListener("stepComplete",onCompleteStep1);
               QuestManager.completeStep(_quest.id,1);
            });
         }
      }
      
      private function onCompleteStep1(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep1);
            this.processStep2();
         }
      }
      
      private function processStep2() : void
      {
         _processor.showMouseHintAt(-34,500);
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "3_10")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            QuestManager.addEventListener("complete",this.onQuestComplete);
            QuestManager.completeStep(_quest.id,10);
         }
      }
      
      private function onQuestComplete(param1:QuestEvent) : void
      {
         ModuleManager.addEventListener("FightResultPanel","hide",this.teacherPlayerHandler);
         QuestManager.removeEventListener("complete",this.onQuestComplete);
      }
      
      private function onPetLevelUp(param1:PetInfoEvent) : void
      {
         this._resultInfo = param1.content.resultInfo;
      }
      
      private function teacherPlayerHandler(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("FightResultPanel","hide",this.teacherPlayerHandler);
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("accept",this.onQuestAccept);
         DialogPanel.removeEventListener("customReplyClick",this.onCustomReply);
         QuestManager.removeEventListener("stepComplete",this.onCompleteStep1);
         QuestManager.removeEventListener("complete",this.onQuestComplete);
         PetInfoManager.removeEventListener("petLevelUp",this.onPetLevelUp);
         ModuleManager.removeEventListener("FightResultPanel","hide",this.teacherPlayerHandler);
         super.processMapDispose();
      }
   }
}

