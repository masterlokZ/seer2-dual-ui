package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actives.GadIssueAct;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.map.MapModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MapProcessor_212 extends TitleMapProcessor
   {
      
      private static const FUNNY_FACE_REWARD_2:String = "funnyFaceReward2";
      
      private var _funnyFace:MovieClip;
      
      public function MapProcessor_212(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initFunnyCrab();
         StatisticsManager.sendNovice("0x10033420");
         GadIssueAct.getInstance().setup();
      }
      
      private function initFunnyCrab() : void
      {
         this._funnyFace = _map.content["funnyFace"] as MovieClip;
         this._funnyFace.addEventListener("funnyFaceReward2",this.onFunnyReward);
      }
      
      private function onFunnyReward(param1:Event) : void
      {
         this._funnyFace.removeEventListener("funnyFaceReward2",this.onFunnyReward);
         if(SwapManager.isSwapNumberMax(11))
         {
            SwapManager.entrySwap(11);
         }
      }
      
      override public function dispose() : void
      {
         if(this._funnyFace.hasEventListener("funnyFaceReward2"))
         {
            this._funnyFace.removeEventListener("funnyFaceReward2",this.onFunnyReward);
         }
         this._funnyFace = null;
         super.dispose();
      }
   }
}

