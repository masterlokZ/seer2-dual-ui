package com.taomee.seer2.app.processor.quest.handler.branch.quest10238
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   
   public class QuestMapHandler_10238_80246 extends QuestMapHandler
   {
      
      private static var haveFight:int = 0;
      
      private var _mc1:MovieClip;
      
      private var _mc2:MovieClip;
      
      public function QuestMapHandler_10238_80246(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         ActorManager.hideActor();
         MobileManager.hideMoileVec("npc");
         if(haveFight == 1)
         {
            haveFight = 0;
            return;
         }
         if(QuestManager.isAccepted(questID) && !QuestManager.isStepComplete(questID,1))
         {
            this.initStep1();
         }
         if(QuestManager.isStepComplete(questID,1) && !QuestManager.isStepComplete(questID,2) && !QuestManager.isComplete(questID))
         {
            this.onStepComplete(null);
         }
         if(QuestManager.isStepComplete(questID,1) && QuestManager.isStepComplete(questID,2) && !QuestManager.isStepComplete(questID,3))
         {
            this.initLastStep();
         }
      }
      
      private function onStepComplete(param1:QuestEvent) : void
      {
         this._mc1 = null;
         MobileManager.showMoileVec("npc");
         QuestManager.removeEventListener("stepComplete",this.onStepComplete);
         SceneManager.changeScene(9,80247);
      }
      
      private function onComplete(param1:QuestEvent) : void
      {
         this._mc2 = null;
         MobileManager.showMoileVec("npc");
         QuestManager.removeEventListener("complete",this.onComplete);
         SceneManager.changeScene(1,70);
      }
      
      private function initStep1() : void
      {
         this._mc1 = _processor.resLib.getMovieClip("Mc10238_0");
         _map.content.addChild(this._mc1);
         this._mc1.gotoAndStop(1);
         MovieClipUtil.playMc(this._mc1,1,this._mc1.totalFrames,function():void
         {
            NpcDialog.show(591,"约瑟",[[0,"糟糕，中计了。超梦！小赛尔！你们快走！他们应该已经开始袭击氏族了！"]],["约瑟你怎么办？"],[function():void
            {
               NpcDialog.show(774,"超梦",[[0,"                可是这样！就没人帮助你了！"]],["先救约瑟吧"],[function():void
               {
                  NpcDialog.show(591,"约瑟",[[0,"凭你们现在的力量在这里也无法救出我，快去提醒各大氏族！不然阿卡迪亚真的要末日了……"]],["末日…… "],[function():void
                  {
                     NpcDialog.show(774,"超梦",[[0,"\t\t         好的，约瑟……我们一定会回来救你的。"]],["一定！"],[function():void
                     {
                        DisplayObjectUtil.removeFromParent(_mc1);
                        initContinue();
                     }]);
                  }]);
               }]);
            }]);
         },true);
      }
      
      private function initContinue() : void
      {
         this._mc2 = _processor.resLib.getMovieClip("Mc10238_1");
         _map.content.addChild(this._mc2);
         this._mc2.gotoAndStop(1);
         MovieClipUtil.playMc(this._mc2,1,this._mc2.totalFrames,function():void
         {
            DisplayObjectUtil.removeFromParent(_mc2);
            QuestManager.addEventListener("stepComplete",onStepComplete);
            QuestManager.completeStep(questID,1);
         },true);
      }
      
      private function initLastStep() : void
      {
         this._mc2 = _processor.resLib.getMovieClip("Mc10238_1");
         _map.content.addChild(this._mc2);
         this._mc2.gotoAndStop(1);
         MovieClipUtil.playMc(this._mc2,this._mc2.totalFrames,this._mc2.totalFrames,function():void
         {
            NpcDialog.show(591,"约瑟",[[0,"看来战神联盟已经出动了……"]],["保护阿卡迪亚"],[function():void
            {
               NpcDialog.show(764,"万劫魔尊",[[0,"约瑟，你已经自身难保了。"]],["约瑟危险！"],[function():void
               {
                  NpcDialog.show(591,"约瑟",[[0,"魔域军团，你们以为500年前能使阿卡迪亚彻底崩溃的力量就只有这些吗？"]],["难道？！ "],[function():void
                  {
                     NpcDialog.show(591,"约瑟",[[0,"让你们看下，被称为精灵王的力量！"]],["精灵王！！"],[function():void
                     {
                        DisplayObjectUtil.removeFromParent(_mc2);
                        MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10238_1"),function():void
                        {
                           QuestManager.addEventListener("complete",onComplete);
                           QuestManager.completeStep(questID,3);
                        });
                     }]);
                  }]);
               }]);
            }]);
         },true);
      }
   }
}

