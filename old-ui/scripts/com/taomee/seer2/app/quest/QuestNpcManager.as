package com.taomee.seer2.app.quest
{
   import com.taomee.seer2.app.quest.mark.AcceptableMark;
   import com.taomee.seer2.app.quest.mark.InProgressMark;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.QuestStep;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class QuestNpcManager
   {
      
      public function QuestNpcManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         QuestManager.addEventListener("init",onQuestInit);
      }
      
      private static function onQuestInit(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("init",onQuestInit);
         QuestManager.addEventListener("accept",onQuestChange);
         QuestManager.addEventListener("abort",onQuestChange);
         QuestManager.addEventListener("complete",onQuestChange);
         QuestManager.addEventListener("stepComplete",onQuestChange);
         SceneManager.addEventListener("switchComplete",onMapComplete);
         updateQuestMark();
      }
      
      private static function onQuestChange(param1:QuestEvent) : void
      {
         updateQuestMark();
      }
      
      private static function onMapComplete(param1:SceneEvent) : void
      {
         updateQuestMark();
      }
      
      public static function updateQuestMark() : void
      {
         if(SceneManager.currentSceneType != 0 && SceneManager.currentSceneType !== 2)
         {
            clearQuestMark();
            checkAcceptable();
            checkInProgress();
         }
      }
      
      private static function clearQuestMark() : void
      {
         var _loc1_:Mobile = null;
         for each(_loc1_ in MobileManager.getMobileVec("npc"))
         {
            _loc1_.removeOverHeadMark();
         }
      }
      
      private static function checkAcceptable() : void
      {
         var _loc2_:Quest = null;
         var _loc1_:int = 0;
         var _loc4_:Mobile = null;
         var _loc3_:AcceptableMark = null;
         for each(_loc2_ in QuestManager.getQuestListByStatus(0))
         {
            if(_loc2_.needAcceptMark)
            {
               if(_loc2_.acceptDialog)
               {
                  _loc1_ = _loc2_.acceptDialog.npcId;
                  _loc4_ = MobileManager.getMobile(_loc1_,"npc");
                  if(_loc4_)
                  {
                     _loc3_ = new AcceptableMark();
                     _loc4_.addOverHeadMark(_loc3_);
                  }
               }
            }
         }
      }
      
      private static function checkInProgress() : void
      {
         var _loc3_:Quest = null;
         var _loc2_:QuestStep = null;
         var _loc5_:int = 0;
         var _loc4_:Mobile = null;
         var _loc1_:InProgressMark = null;
         for each(_loc3_ in QuestManager.getQuestListByStatus(1))
         {
            if(_loc3_.needAcceptMark)
            {
               for each(_loc2_ in _loc3_.getStepVec())
               {
                  if(_loc3_.isStepCompletable(_loc2_.id) && Boolean(_loc2_.dialog))
                  {
                     _loc5_ = _loc2_.dialog.npcId;
                     _loc4_ = MobileManager.getMobile(_loc5_,"npc");
                     if(_loc4_)
                     {
                        _loc1_ = new InProgressMark();
                        _loc4_.addOverHeadMark(_loc1_);
                     }
                  }
               }
            }
         }
      }
   }
}

