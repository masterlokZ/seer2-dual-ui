package com.taomee.seer2.app.processor.quest.handler.branch.quest10127
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.IDataInput;
   
   public class QuestMapHandler_10127_151 extends QuestMapHandler
   {
      
      public function QuestMapHandler_10127_151(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isAccepted(_quest.id))
         {
            DialogPanel.addEventListener("customReplyClick",this.onStart);
         }
      }
      
      private function onStart(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         if((evt.content as DialogPanelEventData).params == "10127_1")
         {
            DialogPanel.removeEventListener("customReplyClick",this.onStart);
            ItemManager.requestItemList(function():void
            {
               if(ItemManager.getItemByReferenceId(400008))
               {
                  SwapManager.swapItem(586,1,function(param1:IDataInput):void
                  {
                     var data:IDataInput = param1;
                     NpcDialog.show(19,"维拉",[[0,"哦——成功了！蘑蘑壮骨酒——我们维尔家族的秘制药酒！谢谢你哦，来，拿去吧，我知道你就是冲着这酒来的啦~"]],[" 嘿嘿，谢谢维拉。"],[function():void
                     {
                        QuestManager.addEventListener("stepComplete",onStep1CompleteHandler);
                        QuestManager.completeStep(_quest.id,1);
                     }]);
                  });
               }
               else
               {
                  NpcDialog.show(19,"维拉",[[0,"小赛尔，你可一个蘑菇果实都没有哦。没有蘑菇，我的蘑蘑壮骨酒可是做不出来呢。"]],["去幻影崖采蘑菇"]);
               }
            });
         }
      }
      
      private function onStep1CompleteHandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStep1CompleteHandler);
         SceneManager.changeScene(1,110);
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         DialogPanel.removeEventListener("customReplyClick",this.onStart);
         QuestManager.removeEventListener("stepComplete",this.onStep1CompleteHandler);
      }
   }
}

