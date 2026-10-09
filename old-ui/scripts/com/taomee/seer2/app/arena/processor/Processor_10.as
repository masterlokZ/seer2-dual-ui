package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.animation.ArenaAnimationManager;
   import com.taomee.seer2.app.arena.data.ItemUseResultInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   
   public class Processor_10 extends ArenaProcessor
   {
      
      public function Processor_10(param1:ArenaScene)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         Connection.addCommandListener(CommandSet.FIGHT_USE_ITEM_NOTIFY_10,this.processor);
      }
      
      override public function processor(param1:MessageEvent) : void
      {
         var _loc3_:Fighter = null;
         var _loc2_:Object = null;
         var _loc4_:ItemUseResultInfo = new ItemUseResultInfo(param1.message.getRawData());
         var _loc6_:uint = _loc4_.userId;
         var _loc5_:uint = _loc4_.fighterId;
         _loc3_ = _secne.arenaData.getFighter(_loc6_,_loc5_);
         if(_loc3_ != null)
         {
            _loc2_ = {
               "fighter":_loc3_,
               "side":_loc3_.fighterSide,
               "itemUseResultInfo":_loc4_
            };
            ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.ItemUseAnimation",_loc2_,this.endAnimation);
            arenaUIController.showSkillPanel();
            arenaUIController.updateStatusPanel();
         }
      }
      
      private function endAnimation() : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Connection.removeCommandListener(CommandSet.FIGHT_USE_ITEM_NOTIFY_10,this.processor);
      }
   }
}

