package com.taomee.seer2.app.processor.quest.handler.activity.quest30023
{
   import com.taomee.seer2.app.actor.attach.PetKingTeamAttach;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.dialog.functionality.BaseUnit;
   import com.taomee.seer2.app.dialog.functionality.CustomUnit;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_30023_50 extends QuestMapHandler
   {
      
      public static const SIGN:String = "i_am_commissary_30023_50";
      
      public static const TEAM_INDEX:int = 3;
      
      public static var isPlayTalkMc:Boolean = false;
      
      private var _decorateMc:MovieClip;
      
      private var _progressbar:MovieClip;
      
      private var _unit:BaseUnit;
      
      public function QuestMapHandler_30023_50(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isAccepted(_quest.id) && !QuestManager.isStepComplete(_quest.id,1))
         {
            DialogPanel.addEventListener("customUnitClick",this.startTalkWithDuoluo);
         }
         SceneManager.addEventListener("switchStart",this.destory);
         DialogPanel.addEventListener("dialogShow",this.onDialogShow);
      }
      
      private function onDialogShow(param1:Event) : void
      {
         var _loc2_:BaseUnit = new CustomUnit("quest","我是宣传委员","i_am_commissary_30023_50");
         if(QuestManager.isAccepted(_quest.id) && !QuestManager.isStepComplete(_quest.id,1))
         {
            DialogPanel.functionalityBox.addUnit(_loc2_);
         }
      }
      
      private function startTalkWithDuoluo(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         if(event.content.params == "i_am_commissary_30023_50")
         {
            if(PetKingTeamAttach.myTeamIndex == 3)
            {
               NpcDialog.show(11,"多罗",[[1,"我正为队伍的宣传犯愁呢！比赛已经接近高潮了！我们需要加一把劲！咦？背包里的是船长给的装饰品吗？"]],["恩恩！正是呢！"],[function():void
               {
                  NpcDialog.show(11,"多罗",[[1,"（快点击右下角两个正在搭建装饰物的赛尔吧）快把装饰品给他们，我们一起打造独一无二的丛林战场吧！"]],["（点击队员）"],[function():void
                  {
                     _decorateMc = _processor.resLib.getMovieClip("daban3");
                     LayerManager.topLayer.addChild(_decorateMc);
                     LayerManager.focusOnTopLayer();
                     _progressbar = _decorateMc["progressbar"]["bar"] as MovieClip;
                     _processor.showMouseHintAt(608.05,280);
                     _decorateMc.addEventListener("click",clickHandler);
                  }]);
               }]);
            }
            else
            {
               NpcDialog.show(11,"多罗",[[1,"你现在不是丛林队的哦！"]],["（知道了）"],[function():void
               {
               }]);
            }
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         _processor.hideMouseClickHint();
         this._progressbar.play();
         this._progressbar.addFrameScript(this._progressbar.totalFrames - 1,function():void
         {
            _progressbar.stop();
            _decorateMc.gotoAndStop(2);
            NpcDialog.show(11,"多罗",[[1,"哇哦！棒！装饰完毕，接下来的工作就是拉取队员，宣扬我队口号啦！你快去幻影崖那里看看吧。"]],["（我这就前往幻影崖）"],[function():void
            {
               LayerManager.resetOperation();
               isPlayTalkMc = true;
               var _loc1_:Timer = new Timer(2000,1);
               _loc1_.addEventListener("timer",getOut);
               _loc1_.start();
            }]);
         });
      }
      
      private function getOut(param1:Event = null) : void
      {
         SceneManager.changeScene(1,141);
         var _loc2_:Timer = param1.currentTarget as Timer;
         _loc2_.reset();
         _loc2_.removeEventListener("timer",this.getOut);
      }
      
      private function destory(param1:Event) : void
      {
         _processor.hideMouseClickHint();
         DialogPanel.removeEventListener("dialogShow",this.onDialogShow);
         SceneManager.removeEventListener("switchStart",this.destory);
         DialogPanel.removeEventListener("customUnitClick",this.startTalkWithDuoluo);
         DisplayUtil.removeForParent(this._decorateMc);
         DisplayUtil.removeForParent(this._progressbar);
      }
   }
}

