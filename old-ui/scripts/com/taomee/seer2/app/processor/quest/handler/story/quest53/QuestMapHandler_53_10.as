package com.taomee.seer2.app.processor.quest.handler.story.quest53
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.controls.ToolbarEvent;
   import com.taomee.seer2.app.controls.ToolbarEventDispatcher;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class QuestMapHandler_53_10 extends QuestMapHandler
   {
      
      private var _npc1:Mobile;
      
      public function QuestMapHandler_53_10(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
      }
      
      private function checkPreTask() : Boolean
      {
         var _loc1_:Boolean = false;
         if(QuestManager.isAccepted(31) || QuestManager.isComplete(31))
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function init() : void
      {
         ActorManager.showRemoteActor = false;
         this._npc1 = MobileManager.getMobile(1,"npc");
         DialogPanel.addEventListener("dialogShow",this.onDialogShow);
         DialogPanel.addEventListener("questUnitClick",this.onUnitClick);
         ModuleManager.addEventListener("ItemBagPanel","open",this.hideGudie);
         ModuleManager.addEventListener("QuestPanel","open",this.hideGudie);
         ModuleManager.addEventListener("QuestPanel","setup",this.onShowQuest);
      }
      
      private function hideGudie(param1:ModuleEvent) : void
      {
         if(QuestManager.isAccepted(_quest.id))
         {
            GuideManager.instance.pause();
         }
      }
      
      private function onShowQuest(param1:ModuleEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(QuestManager.isAccepted(_quest.id) && QuestManager.isStepComplete(_quest.id,1) == true && QuestManager.isStepComplete(_quest.id,2) == false)
         {
            _loc2_ = new Rectangle(0,0,66,25);
            GuideManager.instance.addTarget(_loc2_,7);
            GuideManager.instance.addGuide2Target(_loc2_,0,7,new Point(455,190),false,false,9);
            GuideManager.instance.startGuide(7);
         }
      }
      
      private function onHideGudie(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("QuestPanel","hide",this.onHideGudie);
         if(QuestManager.isAccepted(_quest.id) && QuestManager.isStepComplete(_quest.id,1) == true && QuestManager.isStepComplete(_quest.id,2) == false)
         {
            GuideManager.instance.pause();
         }
      }
      
      private function onDialogShow(param1:DialogPanelEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(param1.content == 1 && QuestManager.isCanAccepted(_quest.id))
         {
            if(this.checkPreTask() == false)
            {
               _loc2_ = new Rectangle(0,0,140,30);
               GuideManager.instance.addTarget(_loc2_,1);
               GuideManager.instance.addGuide2Target(_loc2_,0,1,new Point(284,480),false,false,9);
               GuideManager.instance.startGuide(1);
            }
            else
            {
               DialogPanel.functionalityBox.removeQuestUnit(53);
            }
         }
      }
      
      private function onUnitClick(param1:DialogPanelEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(param1.content.questId == 53 && param1.content.stepId == 0)
         {
            _loc2_ = new Rectangle(0,0,160,30);
            GuideManager.instance.addTarget(_loc2_,2);
            GuideManager.instance.addGuide2Target(_loc2_,0,2,new Point(628,519),false,false,9);
            GuideManager.instance.startGuide(2);
            QuestManager.addEventListener("accept",this.AcceptHandler);
         }
      }
      
      private function AcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.AcceptHandler);
         GuideManager.instance.pause();
         this.gudieEquip();
      }
      
      private function gudieEquip() : void
      {
         var _loc1_:Rectangle = new Rectangle(0,0,54,56);
         GuideManager.instance.addTarget(_loc1_,3);
         GuideManager.instance.addGuide2Target(_loc1_,0,3,new Point(404,502),false,false,9);
         GuideManager.instance.startGuide(3);
         ToolbarEventDispatcher.addEventListener("pageChange",this.pageChange);
      }
      
      private function pageChange(param1:ToolbarEvent) : void
      {
         var _loc2_:Rectangle = null;
         ToolbarEventDispatcher.removeEventListener("pageChange",this.pageChange);
         if(param1.status)
         {
            _loc2_ = new Rectangle(0,0,44,44);
            GuideManager.instance.addTarget(_loc2_,4);
            GuideManager.instance.addGuide2Target(_loc2_,0,4,new Point(404,456),false,false,9);
            GuideManager.instance.startGuide(4);
            ModuleManager.addEventListener("ItemBagPanel","hide",this.onEquipChange);
         }
      }
      
      private function onEquipChange(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("ItemBagPanel","hide",this.onEquipChange);
         QuestManager.addEventListener("stepComplete",this.StepHandler);
         QuestManager.completeStep(_quest.id,1);
      }
      
      private function StepHandler(param1:QuestEvent) : void
      {
         var evt:QuestEvent = param1;
         if(evt.questId == _quest.id && evt.stepId == 1)
         {
            GuideManager.instance.pause();
            QuestManager.removeEventListener("stepComplete",this.StepHandler);
            NpcDialog.show(1,"辛迪船长",[[0,"真帅气，在展开冒险前还需要为你的精灵准备一些物资哦，去<font color=\'#ff0000\'>实验室</font>找<font color=\'#ff0000\'>伊娃博士购买道具</font>吧。"]],["实验室在哪里？ "],[function():void
            {
               useTaskPanel();
            }]);
         }
         StatisticsManager.sendNovice("0x1003323A");
      }
      
      private function useTaskPanel() : void
      {
         NpcDialog.show(1,"辛迪船长",[[0,"<font color=\'#ff0000\'>任务面板</font>的空间<font color=\'#ff0000\'>传送</font>功能非常强大，可以让你迅速到达进行任务的指定场景。"]],["恩，我这就看看！"],[function():void
         {
            var _loc1_:Rectangle = new Rectangle(0,0,52,45);
            GuideManager.instance.addTarget(_loc1_,6);
            GuideManager.instance.addGuide2Target(_loc1_,0,6,new Point(685,15),false,false,9);
            GuideManager.instance.startGuide(6);
            ModuleManager.addEventListener("QuestPanel","hide",onHideGudie);
         }]);
      }
      
      override public function processMapDispose() : void
      {
         this._npc1 = null;
         DialogPanel.removeEventListener("dialogShow",this.onDialogShow);
         DialogPanel.removeEventListener("questUnitClick",this.onUnitClick);
         ModuleManager.removeEventListener("ItemBagPanel","open",this.hideGudie);
         ModuleManager.removeEventListener("QuestPanel","open",this.hideGudie);
         ModuleManager.removeEventListener("QuestPanel","setup",this.onShowQuest);
      }
   }
}

