package com.taomee.seer2.app.processor.quest.handler.activity.quest30012
{
   import com.taomee.seer2.app.component.MouseClickHintSprite;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.quest.mark.AcceptableMark;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class QuestMapHandler_30012_770 extends QuestMapHandler
   {
      
      private var airshipMc:MovieClip;
      
      private var airshipAniamation:MovieClip;
      
      private var mark:AcceptableMark;
      
      private var npc:Mobile;
      
      private var _npcDefinition:NpcDefinition;
      
      private var fakeMap:MovieClip;
      
      private var markMc:MouseClickHintSprite;
      
      public function QuestMapHandler_30012_770(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         var _loc1_:XML = null;
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            _loc1_ = <npc id="120" resId="120" name="老婆婆" dir="0" width="70" height="110" pos="350,350"
                          actorPos="445,312" path="">
                <dialog npcId="120" transport="1,300,400">
                    <branch id="default">
                        <node emotion="0"><![CDATA[哎呦呦……谁来救救我这个柔弱的女子……哎哟哟……]]></node>
                        <reply action="close"><![CDATA[我一会儿来帮你]]></reply>
                    </branch>
                    <eventHandler>
                        <mouseOver>
                            <HandlerShowNpcSlogan><![CDATA[浓缩就是精华！你懂不懂啊！]]></HandlerShowNpcSlogan>
                        </mouseOver>
                        <click>
                            <HandlerOpenDialogPanel/>
                        </click>
                    </eventHandler>
                </dialog>
            </npc>;
            this._npcDefinition = new NpcDefinition(_loc1_);
            this.npc = MobileManager.createNpc(this._npcDefinition);
            this.mark = new AcceptableMark();
            this.mark.y = -120;
            this.npc.addChild(this.mark);
            this.npc.buttonMode = true;
            this.npc.addEventListener("click",this.showDia);
         }
         if(QuestManager.isAccepted(_quest.id) && !QuestManager.isStepComplete(_quest.id,1))
         {
            this.initStep1();
         }
         if(QuestManager.isStepComplete(_quest.id,1) && !QuestManager.isStepComplete(_quest.id,2))
         {
            this.initStep2();
         }
      }
      
      protected function showDia(param1:MouseEvent) : void
      {
         DialogPanel.showForNpc(this._npcDefinition);
         DialogPanel.addEventListener("questUnitClick",this.initAccept);
      }
      
      private function initAccept(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         DialogPanel.hide();
         DisplayObjectUtil.removeFromParent(this.mark);
         DialogPanel.removeEventListener("questUnitClick",this.initAccept);
         MovieClipUtil.playNpcTalkNew(URLUtil.getQuestNpcTalkAnimation("30012_0"),2,[[1,0]],function():void
         {
            QuestManager.addEventListener("accept",acceptQuest);
            QuestManager.accept(_quest.id);
         });
      }
      
      private function acceptQuest(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            MobileManager.removeMobile(this.npc,"npc");
            QuestManager.removeEventListener("accept",this.acceptQuest);
            QuestManager.addEventListener("stepComplete",this.stepComplete);
            QuestManager.completeStep(_quest.id,1);
         }
      }
      
      private function initStep1() : void
      {
         QuestManager.addEventListener("stepComplete",this.stepComplete);
         QuestManager.completeStep(_quest.id,1);
      }
      
      private function toAirship(param1:MouseEvent) : void
      {
         SceneManager.changeScene(1,870);
      }
      
      private function stepComplete(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id && param1.stepId == 1)
         {
            QuestManager.removeEventListener("stepComplete",this.stepComplete);
            this.initStep2();
         }
      }
      
      private function initStep2() : void
      {
         this.airshipMc = _processor.resLib.getMovieClip("airshipMc");
         _map.content.addChild(this.airshipMc);
         MovieClipUtil.playMc(this.airshipMc,1,this.airshipMc.totalFrames,function():void
         {
            markMc = new MouseClickHintSprite();
            markMc.y = 85;
            markMc.x = 220;
            airshipMc.addChild(markMc);
            airshipMc.buttonMode = true;
            airshipMc.addEventListener("click",toAirship);
         });
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("stepComplete",this.stepComplete);
         QuestManager.removeEventListener("accept",this.acceptQuest);
         DialogPanel.removeEventListener("questUnitClick",this.initAccept);
         if(this.airshipMc)
         {
            this.airshipMc.removeEventListener("click",this.toAirship);
         }
         if(this.npc)
         {
            MobileManager.removeMobile(this.npc,"npc");
         }
         super.processMapDispose();
      }
   }
}

