package com.taomee.seer2.app.processor.quest.handler.main.quest116
{
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class QuestMapHandler_116_80588 extends QuestMapHandler
   {
      
      public function QuestMapHandler_116_80588(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         if(QuestManager.isComplete(_quest.id))
         {
            return;
         }
         SceneManager.active.mapModel.content["badi"].addEventListener("click",this.onBaDiClick);
      }
      
      private function onBaDiClick(param1:* = null) : void
      {
         var e:* = param1;
         NpcDialog.showDialogsByText("quest/dialog/116/1.json",function():void
         {
            if(!QuestManager.isAccepted(_quest.id))
            {
               QuestManager.accept(_quest.id);
            }
            SceneManager.changeScene(9,80589);
         },null);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

