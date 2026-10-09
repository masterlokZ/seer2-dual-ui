package com.taomee.seer2.app.entity.handler
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dream.DreamManager;
   import com.taomee.seer2.app.pet.FollowingPet;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import flash.events.Event;
   
   public class HandlerDreamNpcClick extends HandlerEntityClick
   {
      
      private static const DREAM_FEATUREID:uint = 1004;
      
      private var _dreamNpc:Mobile;
      
      public function HandlerDreamNpcClick()
      {
         super();
      }
      
      override public function initData(param1:XML) : void
      {
      }
      
      override protected function action() : void
      {
         this._dreamNpc = MobileManager.getMobile(_entityDefinition.id,"npc");
         if(this._dreamNpc.action == "sleeping" || DreamManager.isDreamingAvalueable() == false)
         {
            this.StartFightFail();
         }
         else if(this.hasDreamFollowingPet())
         {
            DreamManager.currentDreamNpcID = _entityDefinition.id;
            DreamManager.dispatchDreamEvent("enterDream");
         }
         else
         {
            DialogPanel.showForNpc(_entityDefinition as NpcDefinition);
         }
      }
      
      private function StartFightFail() : void
      {
         if(this._dreamNpc.action == "sleeping")
         {
            this._dreamNpc.action = "onClick";
            this._dreamNpc.mouseEnabled = false;
            this._dreamNpc.mouseChildren = false;
            this._dreamNpc.addActionEventListener("finished",this.onActionFinished);
         }
         else if(DreamManager.isDreamingAvalueable() == false)
         {
            AlertManager.showAlert("嘘，让它做个好梦吧！今天就别打扰喽！");
         }
      }
      
      private function onActionFinished(param1:Event) : void
      {
         this._dreamNpc.removeActionEventListener("finished",this.onActionFinished);
         this._dreamNpc.action = "sleeping";
         this._dreamNpc.mouseEnabled = true;
      }
      
      private function hasDreamFollowingPet() : Boolean
      {
         var _loc2_:Actor = ActorManager.getActor();
         var _loc1_:FollowingPet = _loc2_.getFollowingPet();
         if(_loc1_ == null)
         {
            return false;
         }
         var _loc3_:uint = _loc1_.getInfo().getPetDefinition().featureId;
         if(_loc3_ == 1004)
         {
            return true;
         }
         return false;
      }
   }
}

