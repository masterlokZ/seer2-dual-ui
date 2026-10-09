package com.taomee.seer2.app.processor.quest.handler.main.quest5
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.QuestProcessor_5;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class QuestMapHandler_5_110 extends QuestMapHandler
   {
      
      private var _npc16:Mobile;
      
      private var _npc17:Mobile;
      
      private var _magicQiuZh110:MovieClip;
      
      private var _resultInfo:FightResultInfo;
      
      public function QuestMapHandler_5_110(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         this._npc16 = MobileManager.getMobile(16,"npc");
         this._npc17 = MobileManager.getMobile(17,"npc");
         this._npc17.visible = false;
         if(QuestManager.isCanAccepted(_quest.id))
         {
            QuestManager.addEventListener("accept",this.onAccept);
            QuestManager.accept(_quest.id);
         }
         if(!_quest.isStepCompete(1))
         {
            this.processStep1();
         }
         else if(!_quest.isStepCompete(2))
         {
            this.processStep2();
         }
         else if(!_quest.isStepCompete(3))
         {
            this.processStep3();
         }
         else if(_quest.isStepCompete(4))
         {
            this._npc17.visible = true;
         }
         if(!_quest.isStepCompete(5))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep);
            PetInfoManager.addEventListener("petLevelUp",this.onPetLevelUp);
         }
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAccept);
         this.processStep1();
      }
      
      private function processStep1() : void
      {
         DialogPanel.addEventListener("customReplyClick",this.onCustomReply);
      }
      
      private function onCustomReply(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         if(DialogPanelEventData(evt.content).params == "5_1")
         {
            MovieClipUtil.playHahaTalk(URLUtil.getQuestAnimation("5/quest5Animation1"),3,[800,460],function():void
            {
               QuestManager.addEventListener("stepComplete",onStepComplete1);
               QuestManager.completeStep(_quest.id,1);
            });
         }
      }
      
      private function onStepComplete1(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.onStepComplete1);
            this.processStep2();
         }
      }
      
      private function processStep2() : void
      {
         DialogPanel.showForSimple(16,"神目酋长",[[0,"也只好如此了。我现在就帮你变身，你一定要加倍小心啊！"]],"放心吧，我不会有事的……",function():void
         {
            _npc16.visible = false;
            showMagicQiuZh();
         });
      }
      
      private function showMagicQiuZh() : void
      {
         ActorManager.getActor().runToLocation(413,500);
         this._magicQiuZh110 = _map.libManager.getMovieClip("magicQiuZhMC");
         this._magicQiuZh110.x = 543;
         this._magicQiuZh110.y = 408;
         _map.front.addChild(this._magicQiuZh110);
         LayerManager.focusOnTopLayer();
         this._magicQiuZh110.play();
         this._magicQiuZh110.addEventListener("enterFrame",this.onMagicEnd);
      }
      
      private function onMagicEnd(param1:Event) : void
      {
         if(this._magicQiuZh110.currentFrame == this._magicQiuZh110.totalFrames)
         {
            LayerManager.resetOperation();
            this._magicQiuZh110.removeEventListener("enterFrame",this.onMagicEnd);
            DisplayObjectUtil.removeFromParent(this._magicQiuZh110);
            this._npc16.visible = true;
            QuestManager.addEventListener("stepComplete",this.onStepComplete2);
            QuestManager.completeStep(_quest.id,2);
         }
      }
      
      private function onStepComplete2(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestProcessor_5(_processor).setSubstitute();
            QuestManager.removeEventListener("stepComplete",this.onStepComplete2);
            this.processStep3();
         }
      }
      
      private function processStep3() : void
      {
         _processor.showMouseHintAt(-30,450);
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "5_5")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            QuestManager.addEventListener("complete",this.onQuestComplete);
            QuestManager.completeStep(_quest.id,5);
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
         PetInfoManager.removeEventListener("petLevelUp",this.onPetLevelUp);
         ModuleManager.removeEventListener("closePanel","hide",this.teacherPlayerHandler);
         QuestManager.removeEventListener("complete",this.onQuestComplete);
         QuestManager.removeEventListener("accept",this.onAccept);
      }
   }
}

