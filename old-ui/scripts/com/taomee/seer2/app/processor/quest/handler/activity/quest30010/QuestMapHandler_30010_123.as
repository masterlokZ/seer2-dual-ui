package com.taomee.seer2.app.processor.quest.handler.activity.quest30010
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.component.MouseClickHintSprite;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.quest.mark.InProgressMark;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.app.utils.NpcUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_30010_123 extends QuestMapHandler
   {
      
      private var mikaMc3:MovieClip;
      
      private var currentNpc:Mobile;
      
      private var mark:InProgressMark;
      
      private var diaMc:MovieClip;
      
      private var battleNum:int;
      
      public function QuestMapHandler_30010_123(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isStepComplete(_quest.id,2) && !QuestManager.isStepComplete(_quest.id,3))
         {
            this.check();
         }
      }
      
      private function check() : void
      {
         this.battleNum = _quest.getStepData(_quest.getCurrentOrNextStep().id,0);
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && this.battleNum < 3)
         {
            ++this.battleNum;
            _quest.setStepData(_quest.getCurrentOrNextStep().id,0,this.battleNum);
            QuestManager.addEventListener("stepUpdateBuffer",this.onStepUpdateBuffer);
            QuestManager.setStepBufferServer(_quest.id,_quest.getCurrentOrNextStep().id);
         }
         else
         {
            this.checkQuest();
         }
      }
      
      private function onStepUpdateBuffer(param1:QuestEvent) : void
      {
         var event:QuestEvent = param1;
         if(event.questId == _quest.id)
         {
            this.battleNum = _quest.getStepData(_quest.getCurrentOrNextStep().id,0);
            QuestManager.removeEventListener("stepUpdateBuffer",this.onStepUpdateBuffer);
            if(this.battleNum < 3)
            {
               ServerMessager.addMessage("已经拿回" + this.battleNum + "份礼物,还需要打" + (5 - this.battleNum).toString() + "只浣浣.");
               this.checkQuest();
            }
            else if(this.battleNum > 3)
            {
               this.diaMc = _processor.resLib.getMovieClip("Dia30010_2");
               LayerManager.topLayer.addChild(this.diaMc);
               MovieClipUtil.playMc(this.diaMc,1,this.diaMc.totalFrames,function():void
               {
                  LayerManager.topLayer.removeChild(diaMc);
                  NpcDialog.show(NpcUtil.getSeerNpcId(),"我",[[0,"糟糕！这回真的出事了！！！！可恶！！！咦……刚才……（你有看到米咔吗？）"]],["（快赶往赤炼山脉）"],[function():void
                  {
                     QuestManager.addEventListener("stepComplete",completeStep3);
                     QuestManager.completeStep(_quest.id,3);
                  }]);
               },true);
            }
            else if(this.battleNum == 3)
            {
               this.checkQuest();
            }
         }
      }
      
      private function checkQuest() : void
      {
         if(this.battleNum == 0)
         {
            this.currentNpc = MobileManager.getMobile(20,"npc");
            this.currentNpc.removeOverHeadMark();
            this.mark = new InProgressMark();
            this.mark.y = -92;
            this.currentNpc.addChild(this.mark);
            DialogPanel.addEventListener("questUnitClick",this.showNpcTalk);
         }
         else if(this.battleNum < 3)
         {
            this.showMonsterTips();
         }
         else
         {
            this.showMika();
         }
      }
      
      override public function processMapDispose() : void
      {
         DialogPanel.removeEventListener("questUnitClick",this.showNpcTalk);
         QuestManager.removeEventListener("stepComplete",this.completeStep3);
         if(this.mark)
         {
            DisplayUtil.removeForParent(this.mark);
         }
         if(Boolean(this.diaMc) && LayerManager.topLayer.contains(this.diaMc))
         {
            LayerManager.topLayer.removeChild(this.diaMc);
         }
         Connection.removeCommandListener(CommandSet.PET_SPAWN_1103,this.showMonsterTips);
         super.processMapDispose();
      }
      
      private function showMika() : void
      {
         this.mikaMc3 = _processor.resLib.getMovieClip("mikaMc3");
         _map.content.addChild(this.mikaMc3);
         MovieClipUtil.playMc(this.mikaMc3,1,this.mikaMc3.totalFrames,function():void
         {
            _map.content.removeChild(mikaMc3);
            _quest.setStepData(_quest.getCurrentOrNextStep().id,0,5);
            QuestManager.addEventListener("stepUpdateBuffer",onStepUpdateBuffer);
            QuestManager.setStepBufferServer(_quest.id,_quest.getCurrentOrNextStep().id);
         },true);
      }
      
      private function completeStep3(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.completeStep3);
            SceneManager.changeScene(1,261);
         }
      }
      
      private function showNpcTalk(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         DialogPanel.hide();
         MovieClipUtil.playNpcTalkNew(URLUtil.getQuestNpcTalkAnimation("30010_0"),2,[[1,0]],function():void
         {
            NpcDialog.show(NpcUtil.getSeerNpcId(),"我",[[0,"别急别急！包在我身上！你一定会有礼物送给其他小朋友的！"]],["打五个浣浣，拿回礼物"],[function():void
            {
               currentNpc.removeChild(mark);
               showMonsterTips();
            }]);
         });
      }
      
      private function showMonsterTips(param1:MessageEvent = null) : void
      {
         var _loc2_:MouseClickHintSprite = null;
         var _loc3_:Vector.<Mobile> = MobileManager.getMobileVec("spawnedPet");
         if(!_loc3_)
         {
            Connection.addCommandListener(CommandSet.PET_SPAWN_1103,this.showMonsterTips);
            return;
         }
         Connection.removeCommandListener(CommandSet.PET_SPAWN_1103,this.showMonsterTips);
         var _loc5_:int = int(_loc3_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = new MouseClickHintSprite();
            _loc3_[_loc4_].addOverHeadMark(_loc2_);
            _loc2_.y = -50;
            _loc4_++;
         }
      }
   }
}

