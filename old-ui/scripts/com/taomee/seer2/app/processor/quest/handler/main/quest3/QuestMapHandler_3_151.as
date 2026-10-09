package com.taomee.seer2.app.processor.quest.handler.main.quest3
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.app.utils.NpcUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuestMapHandler_3_151 extends QuestMapHandler
   {
      
      private var _weilaNpc:Mobile;
      
      private var _badiNpc:Mobile;
      
      private var _duoluoNpc:Mobile;
      
      private var _stepAnimation:MovieClip;
      
      public function QuestMapHandler_3_151(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(_quest.isStepCompete(7))
         {
            if(!_quest.isStepCompete(8))
            {
               this.processStep8();
            }
            else if(!_quest.isStepCompete(9))
            {
               this.processStep9();
            }
         }
      }
      
      private function processStep8() : void
      {
         this._stepAnimation = _map.content["mainCartoon"] as MovieClip;
         DisplayObjectUtil.disableButtonMode(this._stepAnimation);
         this._weilaNpc = MobileManager.getMobile(19,"npc");
         this._badiNpc = MobileManager.createNpc(new NpcDefinition(<npc id="10" resId="10" name="巴蒂" dir="1" width="75"
                                                                       height="100" pos="425,290" actorPos="750,400"
                                                                       path=""></npc>));
         this._duoluoNpc = MobileManager.createNpc(new NpcDefinition(<npc id="11" resId="11" name="多罗" dir="1"
                                                                         width="75" height="100" pos="478,280"
                                                                         actorPos="750,400" path=""></npc>));
         this._badiNpc.addEventListener("click",this.onBadiClick);
         DisplayObjectUtil.enableButtonMode(this._badiNpc);
         _processor.showMouseHintAt(280,168);
      }
      
      private function onBadiClick(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._badiNpc.removeEventListener("click",this.onBadiClick);
         DisplayObjectUtil.disableButtonMode(this._badiNpc);
         _processor.hideMouseClickHint();
         NpcDialog.show(NpcUtil.getSeerNpcId(),"我",[[0,"你们这是怎么啦？让你们来找维拉的，怎么哭丧个脸？"]],["事情是这样的"],[function():void
         {
            MovieClipUtil.playFullScreen(URLUtil.getQuestAnimation("3/quest3Animation4"),function():void
            {
               _processor.showInProgressMarkOver(_weilaNpc);
               _weilaNpc.addEventListener("click",onWeilaNpcClick,false,2147483647);
            },false);
         }]);
      }
      
      private function onWeilaNpcClick(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         evt.stopImmediatePropagation();
         this._weilaNpc.removeEventListener("click",this.onWeilaNpcClick,false);
         _processor.hideInProgressMark();
         NpcDialog.show(19,"维拉",[[0,"我正为布洛果实烦恼呢……暂时就别打扰我了……"]],["我来帮你吧！（寻找布洛果实）"],[function():void
         {
            _processor.showMouseHintAt(430,405);
            DisplayObjectUtil.enableButtonMode(_stepAnimation);
            _stepAnimation.addEventListener("startPlay",onCartoonStartPlay);
         }]);
      }
      
      private function onCartoonStartPlay(param1:Event) : void
      {
         this._stepAnimation.removeEventListener("startPlay",this.onCartoonStartPlay);
         _processor.hideMouseClickHint();
         ServerMessager.addMessage("获得布洛果实");
         QuestManager.addEventListener("stepComplete",this.onCompleteStep8);
         QuestManager.completeStep(_quest.id,8);
      }
      
      private function onCompleteStep8(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep8);
            this.processStep9();
         }
      }
      
      private function processStep9() : void
      {
         DialogPanel.addEventListener("customReplyClick",this.onCustomReply);
      }
      
      private function onCustomReply(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         if(DialogPanelEventData(evt.content).params == "3_9")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onCustomReply);
            MovieClipUtil.playNpcTalkNew(URLUtil.getQuestAnimation("3/npctalk_0"),3,[[1,1]],function():void
            {
               MovieClipUtil.playFullScreen(URLUtil.getQuestAnimation("3/quest3Animation5"),function():void
               {
                  QuestManager.completeStep(_quest.id,9);
                  SceneManager.changeScene(1,110);
               },false);
            });
         }
      }
      
      override public function processMapDispose() : void
      {
         if(this._weilaNpc)
         {
            this._weilaNpc.removeEventListener("click",this.onWeilaNpcClick,false);
         }
         if(this._stepAnimation)
         {
            this._stepAnimation.removeEventListener("startPlay",this.onCartoonStartPlay);
         }
         if(this._badiNpc)
         {
            this._badiNpc.removeEventListener("click",this.onBadiClick);
         }
         QuestManager.removeEventListener("stepComplete",this.onCompleteStep8);
         DialogPanel.removeEventListener("customReplyClick",this.onCustomReply);
         super.processMapDispose();
      }
   }
}

