package com.taomee.seer2.app.processor.quest.handler.main.quest79
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.quest.mark.AcceptableMark;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class QuestMapHandler_79_3828 extends QuestMapHandler
   {
      
      private var _npc:Mobile;
      
      public function QuestMapHandler_79_3828(param1:QuestProcessor)
      {
         super(param1);
         QuestManager.removeEventListener("complete",this.onComplete);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(questID))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStep);
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         if((param1.content as DialogPanelEventData).params == "79_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            QuestManager.addEventListener("accept",this.onAcceptHandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         SceneManager.changeScene(1,3830);
      }
      
      private function onAccepted(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAccepted);
         if(QuestManager.isAccepted(questID) && !QuestManager.isStepComplete(questID,1))
         {
            this.createNpc();
         }
         if(QuestManager.isStepComplete(questID,1) && !QuestManager.isComplete(questID))
         {
            this.onComplete(null);
         }
      }
      
      private function onComplete(param1:QuestEvent) : void
      {
         MobileManager.showMoileVec("npc");
         QuestManager.removeEventListener("stepComplete",this.onComplete);
         SceneManager.changeScene(1,3830);
      }
      
      private function createNpc() : void
      {
         var _loc1_:AcceptableMark = null;
         if(!this._npc)
         {
            this._npc = new Mobile();
            this._npc.setPostion(new Point(650,550));
            this._npc.resourceUrl = URLUtil.getNpcSwf(1016);
            this._npc.buttonMode = true;
            MobileManager.addMobile(this._npc,"npc");
            _loc1_ = new AcceptableMark();
            this._npc.addChild(_loc1_);
            _loc1_.y = -150;
            this._npc.addEventListener("click",this.initStep1);
         }
      }
      
      private function initStep1(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         NpcDialog.show(1016,"里格",[[0,"小赛尔， 剩下的能量碎片极有可能在超能广场和军工厂。从这条路过去就是广场了。你们一定要注意安全。"]],["（前往超能广场）"],[function():void
         {
            QuestManager.completeStep(questID,1);
            QuestManager.addEventListener("stepComplete",onComplete);
         }]);
      }
      
      override public function processMapDispose() : void
      {
         MobileManager.removeMobile(this._npc,"npc");
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         DialogPanel.removeEventListener("customReplyClick",this.onStep);
         super.processMapDispose();
         if(this._npc)
         {
            this._npc.removeEventListener("click",this.initStep1);
         }
         this._npc = null;
      }
   }
}

