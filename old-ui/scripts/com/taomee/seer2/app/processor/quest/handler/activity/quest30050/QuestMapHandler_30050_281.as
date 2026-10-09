package com.taomee.seer2.app.processor.quest.handler.activity.quest30050
{
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_30050_281 extends QuestMapHandler
   {
      
      private var _npc:MovieClip;
      
      public function QuestMapHandler_30050_281(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isCanAccepted(30050))
         {
            this.openNpc();
         }
      }
      
      private function openNpc() : void
      {
         this._npc = _processor.resLib.getMovieClip("npc");
         _map.content.addChild(this._npc);
         this._npc.buttonMode = true;
         this._npc.addEventListener("click",this.onNpc);
      }
      
      private function onNpc(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         this._npc.removeEventListener("click",this.onNpc);
         MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("30050_1"),function():void
         {
            QuestManager.addEventListener("accept",onAccept);
            QuestManager.accept(30050);
         },true,false,2);
      }
      
      private function onAccept(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.onAccept);
         SceneManager.changeScene(1,142);
      }
      
      override public function processMapDispose() : void
      {
         QuestManager.removeEventListener("accept",this.onAccept);
         DisplayUtil.removeForParent(this._npc);
         super.processMapDispose();
      }
   }
}

