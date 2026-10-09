package com.taomee.seer2.app.processor.quest
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.geom.Point;
   import org.taomee.utils.BitUtil;
   
   public class QuestProcessor_7 extends QuestProcessor
   {
      
      private static const HAIMA_STEP_ID:int = 4;
      
      private static const HAIMA_STEP_INDEX:int = 0;
      
      private static const HAIMA_MAX_NUM:int = 5;
      
      private var _haimaPetVec:Vector.<Mobile>;
      
      public function QuestProcessor_7(param1:Quest)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this.initHaima();
      }
      
      private function initHaima() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(_quest.isStepCompete(3) && !_quest.isStepCompete(5))
         {
            this._haimaPetVec = new Vector.<Mobile>();
            _loc2_ = this.caculateHaimaCount();
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.addHaimaPet();
               _loc1_++;
            }
            if(_loc2_ > 0)
            {
               ActorManager.getActor().blockFollowingPet = true;
            }
         }
      }
      
      private function addHaimaPet() : void
      {
         var _loc1_:Mobile = new Mobile();
         _loc1_.resourceUrl = URLUtil.getPetSwf(41);
         this._haimaPetVec.push(_loc1_);
         ActorManager.getActor().addCarriedMobile(_loc1_,50 + 30 * (this._haimaPetVec.length - 1));
         _loc1_.setPostion(new Point(ActorManager.getActor().x + 30,ActorManager.getActor().y));
      }
      
      public function disposeHaima() : void
      {
         var _loc2_:int = int(this._haimaPetVec.length);
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            ActorManager.getActor().removeCarriedMobile(this._haimaPetVec[_loc1_]);
            this._haimaPetVec[_loc1_].dispose();
            _loc1_++;
         }
         ActorManager.getActor().blockFollowingPet = false;
      }
      
      public function isHaimaFound(param1:int) : Boolean
      {
         var _loc2_:int = _quest.getStepData(4,0);
         return BitUtil.getBit(_quest.getStepData(4,0),param1);
      }
      
      public function setHaimaFlagServer(param1:int) : void
      {
         var _loc2_:int = _quest.getStepData(4,0);
         _loc2_ = int(BitUtil.setBit(_loc2_,param1,true));
         _quest.setStepData(4,0,_loc2_);
         if(this.caculateHaimaCount() == 5)
         {
            QuestManager.addEventListener("stepComplete",this.onCompleteStep4);
            QuestManager.completeStep(_quest.id,4);
         }
         else
         {
            ServerMessager.addMessage("你还剩" + (5 - this.caculateHaimaCount()) + "只小海马没有找到");
            QuestManager.addEventListener("stepUpdateBuffer",this.onUpdateStepBuffer);
            QuestManager.setStepBufferServer(_quest.id,4);
         }
      }
      
      private function onCompleteStep4(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep4);
            this.addHaimaPet();
         }
      }
      
      private function onUpdateStepBuffer(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepUpdateBuffer",this.onUpdateStepBuffer);
            if(this._haimaPetVec == null)
            {
               this.initHaima();
            }
            else
            {
               this.addHaimaPet();
            }
         }
      }
      
      private function caculateHaimaCount() : int
      {
         var _loc2_:int = _quest.getStepData(4,0);
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            if(BitUtil.getBit(_loc2_,_loc3_))
            {
               _loc1_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

