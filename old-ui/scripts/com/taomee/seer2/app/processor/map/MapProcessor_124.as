package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actives.GadIssueAct;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.processor.activity.pandaMan.PandaManEntry;
   import com.taomee.seer2.core.map.MapModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MapProcessor_124 extends TitleMapProcessor
   {
      
      private var _glowAnimation:MovieClip;
      
      private var _leftGlowTriggerHit:MovieClip;
      
      private var _rightGlowTriggerHit:MovieClip;
      
      private var _glowClickCount:int = 0;
      
      private var _panda:PandaManEntry;
      
      public function MapProcessor_124(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initGlow();
         this.initPanda();
         super.init();
         StatisticsManager.sendNovice("0x10033414");
         GadIssueAct.getInstance().setup();
      }
      
      private function initGlow() : void
      {
         this._glowAnimation = _map.content["glowAnimation"];
         this._leftGlowTriggerHit = _map.content["leftGlowTriggerHit"];
         this._rightGlowTriggerHit = _map.content["rightGlowTriggerHit"];
         this._glowAnimation.gotoAndStop(1);
         initInteractor(this._leftGlowTriggerHit);
         initInteractor(this._rightGlowTriggerHit);
         this._leftGlowTriggerHit.addEventListener("click",this.onGlowClick);
         this._rightGlowTriggerHit.addEventListener("click",this.onGlowClick);
      }
      
      private function initPanda() : void
      {
         this._panda = new PandaManEntry();
         this._panda.setup();
      }
      
      private function onGlowClick(param1:MouseEvent) : void
      {
         if(this._glowClickCount == 0)
         {
            ++this._glowClickCount;
            this._glowAnimation.gotoAndStop(2);
         }
         else if(this._glowClickCount == 1)
         {
            --this._glowClickCount;
            this._glowAnimation.gotoAndStop(1);
         }
      }
      
      override public function dispose() : void
      {
         this._leftGlowTriggerHit.removeEventListener("click",this.onGlowClick);
         this._rightGlowTriggerHit.removeEventListener("click",this.onGlowClick);
         this._glowAnimation = null;
         this._leftGlowTriggerHit = null;
         this._rightGlowTriggerHit = null;
         this._panda.dispose();
         this._panda = null;
         super.dispose();
      }
   }
}

