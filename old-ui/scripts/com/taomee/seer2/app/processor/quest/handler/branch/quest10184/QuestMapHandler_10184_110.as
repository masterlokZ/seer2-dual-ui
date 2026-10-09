package com.taomee.seer2.app.processor.quest.handler.branch.quest10184
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class QuestMapHandler_10184_110 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10184_110(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep);
            DialogPanel.addEventListener("customReplyClick",this.onStepOne);
         }
         if(QuestManager.isAccepted(_quest.id) && QuestManager.isStepComplete(_quest.id,1) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onStepOne);
         }
         if(QuestManager.isStepComplete(_quest.id,1) && QuestManager.isStepComplete(_quest.id,2) == false)
         {
            DialogPanel.addEventListener("customReplyClick",this.onStepTwo);
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         if((event.content as DialogPanelEventData).params == "10184_0")
         {
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10184_0"),function():void
            {
               QuestManager.addEventListener("accept",onAcceptHandler);
               QuestManager.accept(_quest.id);
            },true,false,2);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         ModuleManager.addEventListener("ChameleonDancePanel","DanceGameOneSuccess",this.onSucessDancePanel);
         ModuleManager.toggleModule(URLUtil.getAppModule("ChameleonDancePanel"),"正在打开面板...");
      }
      
      private function onStepOne(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "10184_1" && QuestManager.isAccepted(_quest.id))
         {
            ModuleManager.addEventListener("ChameleonDancePanel","DanceGameOneSuccess",this.onSucessDancePanel);
            ModuleManager.toggleModule(URLUtil.getAppModule("ChameleonDancePanel"),"正在打开面板...");
         }
      }
      
      private function onSucessDancePanel(param1:ModuleEvent) : void
      {
         var evr:ModuleEvent = param1;
         ModuleManager.removeEventListener("ChameleonDancePanel","DanceGameOneSuccess",this.onSucessDancePanel);
         MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10184_1"),function():void
         {
            QuestManager.addEventListener("stepComplete",onCompleteOneHandler);
            QuestManager.completeStep(_quest.id,1);
         },true,false,2);
      }
      
      private function onCompleteOneHandler(param1:QuestEvent) : void
      {
         var event:QuestEvent = param1;
         QuestManager.removeEventListener("stepComplete",this.onCompleteOneHandler);
         NpcDialog.show(16,"神目酋长",[[0,"可恶的萨伦帝国又在肆无忌惮的破坏我们的家园了。不行，我们必须依靠自己的力量强大起来，对抗萨伦。"]],["强大起来！"],[function():void
         {
            chameleonTalk();
         }]);
      }
      
      private function onStepTwo(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "10184_2" && QuestManager.isStepComplete(_quest.id,1) && QuestManager.isStepComplete(_quest.id,2) == false)
         {
            this.chameleonTalk();
         }
      }
      
      private function chameleonTalk() : void
      {
         NpcDialog.show(576,"变色蜥",[[0,"是的，我们必须将我们的精灵训练有素，同萨伦做抵抗。但是……但是……"]],["噗……"],[function():void
         {
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10184_2"),function():void
            {
               NpcDialog.show(16,"神目酋长",[[0,"抵抗萨伦帝国是我们的责任，我们一起来参加前所未有的精灵训练营，训练强大的精灵吧。"]],["参加精灵训练营咯"],[function():void
               {
                  QuestManager.addEventListener("complete",onCompleteHandler);
                  QuestManager.completeStep(_quest.id,2);
               }]);
            },true,false,2);
         }]);
      }
      
      private function onCompleteHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onCompleteHandler);
         ModuleManager.toggleModule(URLUtil.getAppModule("PetTrainTogetherPanel"),"正在打开面板...");
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         DialogPanel.removeEventListener("customReplyClick",this.onStep);
         DialogPanel.removeEventListener("customReplyClick",this.onStepOne);
         DialogPanel.removeEventListener("customReplyClick",this.onStepTwo);
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         QuestManager.removeEventListener("stepComplete",this.onCompleteOneHandler);
         QuestManager.removeEventListener("complete",this.onCompleteHandler);
      }
   }
}

