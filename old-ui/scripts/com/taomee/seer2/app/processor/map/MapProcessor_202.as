package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.map.MapModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MapProcessor_202 extends TitleMapProcessor
   {
      
      private static const FUNNYSTAR_REWARD_2:String = "funnyStarReward2";
      
      private var _funnyStarMC:MovieClip;
      
      public function MapProcessor_202(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initFunnyCrab();
         StatisticsManager.sendNovice("0x10033428");
      }
      
      private function initFunnyCrab() : void
      {
         this._funnyStarMC = _map.content["funnyStar"] as MovieClip;
         this._funnyStarMC.addEventListener("funnyStarReward2",this.onFunnyStarReward);
      }
      
      private function onFunnyStarReward(param1:Event) : void
      {
         this._funnyStarMC.removeEventListener("funnyStarReward2",this.onFunnyStarReward);
         if(SwapManager.isSwapNumberMax(9))
         {
            SwapManager.entrySwap(9);
         }
      }
      
      override public function dispose() : void
      {
         if(this._funnyStarMC.hasEventListener("funnyStarReward2"))
         {
            this._funnyStarMC.removeEventListener("funnyStarReward2",this.onFunnyStarReward);
         }
         this._funnyStarMC = null;
         super.dispose();
      }
   }
}

