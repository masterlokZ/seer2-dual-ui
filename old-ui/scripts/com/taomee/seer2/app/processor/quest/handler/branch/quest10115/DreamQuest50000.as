package com.taomee.seer2.app.processor.quest.handler.branch.quest10115
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class DreamQuest50000 extends QuestMapHandler
   {
      
      protected var seer:MovieClip;
      
      protected var toSceneId:int;
      
      protected var isInTime:Boolean = false;
      
      private var overDay:int;
      
      public function DreamQuest50000(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapDispose() : void
      {
         if(this.seer)
         {
            this.seer.removeEventListener("click",this.clickSeer);
         }
         QuestManager.removeEventListener("accept",this.onAccept);
         super.processMapDispose();
      }
      
      override public function processMapComplete() : void
      {
         var _loc3_:int = 0;
         super.processMapComplete();
         this.seer = _processor.resLib.getMovieClip("SleepSeer");
         this.isInTime = false;
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc1_:int = _quest.id;
         this.overDay = _loc2_.date - 10;
         if(this.overDay <= 0)
         {
            return;
         }
         var _loc4_:int = 1;
         while(_loc4_ < 6)
         {
            _loc3_ = 10114 + _loc4_;
            if(this.overDay == _loc4_ && _loc1_ > _loc3_)
            {
               return;
            }
            _loc4_++;
         }
         this.isInTime = true;
         this.seer.buttonMode = true;
         _map.content.addChild(this.seer);
         this.seer.addEventListener("click",this.clickSeer);
         ActorManager.hideActor();
      }
      
      protected function clickSeer(param1:MouseEvent) : void
      {
         this.seer.removeEventListener("click",this.clickSeer);
         if(!QuestManager.isAccepted(_quest.id) && QuestManager.isCanAccepted(_quest.id))
         {
            QuestManager.addEventListener("accept",this.onAccept);
            QuestManager.accept(_quest.id);
            return;
         }
         if(!QuestManager.isComplete(_quest.id))
         {
            SceneManager.changeScene(1,this.toSceneId);
         }
      }
      
      protected function onAccept(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("accept",this.onAccept);
            SceneManager.changeScene(1,this.toSceneId);
         }
      }
   }
}

