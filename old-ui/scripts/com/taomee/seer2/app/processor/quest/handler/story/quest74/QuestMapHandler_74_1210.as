package com.taomee.seer2.app.processor.quest.handler.story.quest74
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.quest.mark.AcceptableMark;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_74_1210 extends QuestMapHandler
   {
      
      public static var haveBattle:Boolean = true;
      
      private var _mc1:MovieClip;
      
      private var _mack:AcceptableMark;
      
      public function QuestMapHandler_74_1210(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         if(!haveBattle)
         {
            return;
         }
         super.processMapComplete();
         if(QuestManager.isAccepted(_quest.id) && !QuestManager.isStepComplete(_quest.id,2))
         {
            _map.content.visible = false;
            this.initStep1();
         }
      }
      
      private function onStep(param1:DialogPanelEvent) : void
      {
         var e:DialogPanelEvent = param1;
         if((e.content as DialogPanelEventData).params == "74_0")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStep);
            MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("74_0"),function():void
            {
               QuestManager.addEventListener("accept",onAcceptHandler);
               QuestManager.accept(_quest.id);
            },true,false,2);
         }
      }
      
      private function onAcceptHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAcceptHandler);
         this.initStep1();
      }
      
      private function initStep1() : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("74_0"),function():void
         {
            initStep2();
         },true,true);
      }
      
      private function initStep2() : void
      {
         ActorManager.showRemoteActor = false;
         MobileManager.hideMoileVec("npc");
         ActorManager.getActor().isShow = false;
         ActorManager.getActor().blockNoNo = true;
         this._mc1 = _processor.resLib.getMovieClip("mc1");
         this._mc1["snowP"].visible = false;
         _map.front.addChild(this._mc1);
         MovieClipUtil.playMc(this._mc1,2,this._mc1.totalFrames,function():void
         {
            _mack = new AcceptableMark();
            _mack.x = _mc1["snowP"].x;
            _mack.y = _mc1["snowP"].y;
            _mc1.addChild(_mack);
            _mc1["snowP"].visible = true;
            _mc1["snowP"].buttonMode = true;
            _mc1["snowP"].addEventListener("click",onClick);
         },true);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         this._mc1["snowP"].removeEventListener("click",this.onClick);
         NpcDialog.show(324,"白雪公主",[[0,"谢谢你们，第七小队，帮助我们摆脱了黑桃皇后的统治。"]],["女王大人，这是应该做的"],[function():void
         {
            NpcDialog.show(324,"白雪公主",[[0,"不用那么拘谨，叫我白雪就好。"]],["是的，女王大人！"],[function():void
            {
               NpcDialog.show(324,"白雪公主",[[0,"额……言归正传，为了报答你们拯救了整个氏族，我们要告诉你们一个秘密！ "]],[" 秘密？"],[function():void
               {
                  NpcDialog.show(324,"白雪公主",[[0,"恩，帮助你们到超能氏族的秘密。"]],[" 超能氏族！？"],[function():void
                  {
                     NpcDialog.show(324,"白雪公主",[[0,"跟我来吧。"]],[" 是的，女王大人！ "],[function():void
                     {
                        DisplayUtil.removeForParent(_mack);
                        DisplayUtil.removeForParent(_mc1);
                        QuestManager.addEventListener("stepComplete",onStepComplete);
                        QuestManager.completeStep(74,2);
                     }]);
                  }]);
               }]);
            }]);
         }]);
      }
      
      private function onStepComplete(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStepComplete);
         SceneManager.changeScene(1,1220);
      }
      
      override public function processMapDispose() : void
      {
         MobileManager.showMoileVec("npc");
         ActorManager.showRemoteActor = true;
         ActorManager.getActor().isShow = true;
         ActorManager.getActor().blockNoNo = false;
         _map.content.visible = true;
         QuestManager.removeEventListener("complete",this.onStepComplete);
         DisplayUtil.removeForParent(this._mc1);
         DisplayUtil.removeForParent(this._mack);
      }
   }
}

