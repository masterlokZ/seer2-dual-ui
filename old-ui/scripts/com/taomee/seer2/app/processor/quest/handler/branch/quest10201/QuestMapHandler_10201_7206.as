package com.taomee.seer2.app.processor.quest.handler.branch.quest10201
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   
   public class QuestMapHandler_10201_7206 extends QuestMapHandler
   {
      
      private static const LIMIT_ID:int = 203002;
      
      private static const FIGHT_LIST:Array = [532,533,534,535,536];
      
      private var npc:Mobile;
      
      private var currentIndex:int = -1;
      
      public function QuestMapHandler_10201_7206(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         var _loc1_:int = 0;
         if(QuestManager.isStepComplete(10201,3) == false)
         {
            QuestManager.addEventListener("stepComplete",this.onStep);
         }
         if(QuestManager.isStepComplete(10201,3) == true && QuestManager.isStepComplete(10201,4) == false)
         {
            this.onStep();
            return;
         }
         if(SceneManager.prevSceneType == 2)
         {
            _loc1_ = int(FightManager.currentFightRecord.initData.positionIndex);
            if(FIGHT_LIST.indexOf(_loc1_) != -1 && FightManager.fightWinnerSide == 1 && _loc1_ != FIGHT_LIST[4])
            {
            }
         }
         ActiveCountManager.requestActiveCount(203002,this.getData);
      }
      
      private function getData(param1:uint, param2:uint) : void
      {
         var type:uint = param1;
         var count:uint = param2;
         if(type == 203002)
         {
            if(count >= 5)
            {
               if(QuestManager.isStepComplete(10201,3) == false)
               {
                  AlertManager.showAlert("真厉害，你已经收集齐全部的碎片咯！",function():void
                  {
                     QuestManager.completeStep(10201,3);
                  });
               }
            }
            else
            {
               this.currentIndex = count;
               this.createNpc();
            }
         }
      }
      
      private function onStep(param1:QuestEvent = null) : void
      {
         var e:QuestEvent = param1;
         MovieClipUtil.playFullScreen(URLUtil.getQuestFullScreenAnimation("10201_2"),function():void
         {
            QuestManager.completeStep(10201,4);
         });
      }
      
      private function createNpc() : void
      {
         if(this.npc == null)
         {
            this.npc = new Mobile();
            this.npc.resourceUrl = URLUtil.getNpcSwf(335);
            this.npc.x = 190;
            this.npc.y = 345;
            this.npc.buttonMode = true;
            MobileManager.addMobile(this.npc,"npc");
            this.npc.addEventListener("click",this.onClick);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(FIGHT_LIST[this.currentIndex])
         {
            FightManager.startFightWithWild(FIGHT_LIST[this.currentIndex]);
         }
      }
      
      override public function processMapDispose() : void
      {
         if(this.npc)
         {
            this.npc.removeEventListener("click",this.onClick);
            MobileManager.removeMobile(this.npc,"npc");
            this.npc = null;
         }
         QuestManager.removeEventListener("stepComplete",this.onStep);
      }
   }
}

