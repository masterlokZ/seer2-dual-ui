package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import flash.events.MouseEvent;
   
   public class MapProcessor_3855 extends TitleMapProcessor
   {
      
      public function MapProcessor_3855(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initNpcSet();
      }
      
      private function initNpcSet() : void
      {
         var _loc1_:Mobile = null;
         for each(_loc1_ in MobileManager.getMobileVec("npc"))
         {
            _loc1_.addEventListener("rollOver",this.onNpcOver);
            _loc1_.addEventListener("rollOut",this.onNpcOut);
            _loc1_.animation.gotoAndStop(1);
         }
      }
      
      private function onNpcOver(param1:MouseEvent) : void
      {
         var _loc2_:Mobile = param1.currentTarget as Mobile;
         _loc2_.animation.gotoAndPlay(2);
      }
      
      private function onNpcOut(param1:MouseEvent) : void
      {
         var _loc2_:Mobile = param1.currentTarget as Mobile;
         if(_loc2_)
         {
            _loc2_.animation.gotoAndStop(1);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:Mobile = null;
         for each(_loc1_ in MobileManager.getMobileVec("npc"))
         {
            _loc1_.removeEventListener("rollOver",this.onNpcOver);
            _loc1_.removeEventListener("rollOut",this.onNpcOut);
         }
         super.dispose();
      }
   }
}

