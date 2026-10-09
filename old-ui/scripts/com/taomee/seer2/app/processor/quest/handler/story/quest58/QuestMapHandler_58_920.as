package com.taomee.seer2.app.processor.quest.handler.story.quest58
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
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.events.MouseEvent;
   
   public class QuestMapHandler_58_920 extends QuestMapHandler
   {
      
      private var _npcDefinition:NpcDefinition;
      
      private var _npc:Mobile;
      
      public function QuestMapHandler_58_920(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         QuestManager.removeEventListener("accept",this.onAccept);
         DialogPanel.removeEventListener("customUnitClick",this.showAcceptDia);
         if(this._npc)
         {
            this._npc.removeEventListener("click",this.showDia);
         }
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(_quest.id))
         {
            this.initAcceptProcess();
         }
      }
      
      private function initAcceptProcess() : void
      {
         var _loc1_:AcceptableMark = null;
         var _loc2_:XML = <npc id="137" resId="137" name="席德" dir="1" width="25" height="90" pos="790,414"
                              actorPos="821,288" path="">
            <dialog npcId="137" npcName="席德" transport="1,300,400">
                <branch id="default">
                    <node emotion="0"><![CDATA[赛尔……【希望之光】……%￥%……&*……]]></node>
                    <reply action="close"><![CDATA[不知道他在说什么]]></reply>
                </branch>
            </dialog>
            <functionality>
                <node type="accept" name="（主线）工房迷雾杀手" params="58_920_0"/>
            </functionality>
        </npc>;
         this._npcDefinition = new NpcDefinition(_loc2_);
         this._npc = MobileManager.createNpc(this._npcDefinition);
         this._npc.buttonMode = true;
         _loc1_ = new AcceptableMark();
         _loc1_.setPostion(this._npc.pos);
         _loc1_.y -= this._npc.height;
         _map.content.addChild(_loc1_);
         this._npc.addEventListener("click",this.showDia);
      }
      
      private function showDia(param1:MouseEvent) : void
      {
         DialogPanel.showForNpc(this._npcDefinition);
         DialogPanel.addEventListener("customUnitClick",this.showAcceptDia);
      }
      
      private function showAcceptDia(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         var params:String = (evt.content as DialogPanelEventData).params;
         if(params == "58_920_0")
         {
            NpcDialog.show(137,"席德",[[0,"上次的暗杀者来袭没吓坏你吧？这次我会全程保护你的，我来继续向你介绍风刃氏族的其他地方吧。"]],["好呀！那我们继续吧！"],[function():void
            {
               NpcDialog.show(137,"席德",[[0,"我们今天要去的地方叫做御风中枢！之所以风刃氏族能够在风涡中发展，全靠这个御风中枢来稳定这座城市。"]],["酷！走吧！"],[function():void
               {
                  QuestManager.addEventListener("accept",onAccept);
                  QuestManager.accept(_quest.id);
               }]);
            }]);
         }
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            SceneManager.changeScene(1,930);
         }
      }
   }
}

