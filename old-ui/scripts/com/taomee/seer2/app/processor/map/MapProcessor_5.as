package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcessor_5 extends TitleMapProcessor
   {
      
      private static const MOVESKYCONST:int = 1;
      
      private static const MOVESKYMAX:int = 0;
      
      private static const MOVESKYMIN:int = -500;
      
      private var _starrySky:MovieClip;
      
      private var _moveSkyType:int;
      
      private var _skyInterval:int;
      
      private var _captain:Mobile;
      
      public function MapProcessor_5(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initCaptain();
         this.initStarrySky();
      }
      
      private function initCaptain() : void
      {
         this._captain = MobileManager.getMobile(1,"npc");
         this._captain.gotoAndStop(1);
         this._captain.addEventListener("mouseOver",this.onCaptainOver);
         this._captain.addEventListener("mouseOut",this.onCaptainOut);
      }
      
      private function onCaptainOver(param1:MouseEvent) : void
      {
         this._captain.addEventListener("enterFrame",this.onCaptainPlay);
         this._captain.play();
      }
      
      private function onCaptainPlay(param1:Event) : void
      {
         if(this._captain.currentFrameIndex == 3)
         {
            this._captain.removeEventListener("enterFrame",this.onCaptainPlay);
            this._captain.gotoAndStop(3);
         }
      }
      
      private function onCaptainOut(param1:MouseEvent) : void
      {
         this._captain.removeEventListener("enterFrame",this.onCaptainPlay);
         this._captain.gotoAndStop(1);
      }
      
      private function initStarrySky() : void
      {
         this._skyInterval = 0;
         this._starrySky = _map.far["starrySky"];
         this._starrySky.addEventListener("enterFrame",this.moveSky);
      }
      
      private function moveSky(param1:Event) : void
      {
         ++this._skyInterval;
         if(this._skyInterval == 2)
         {
            this._skyInterval = 0;
            if(this._starrySky.x == 0)
            {
               this._moveSkyType = 1;
            }
            if(this._starrySky.x == -500)
            {
               this._moveSkyType = 0;
            }
            if(this._moveSkyType == 1)
            {
               this._starrySky.x -= 1;
            }
            else
            {
               this._starrySky.x += 1;
            }
            return;
         }
      }
      
      override public function dispose() : void
      {
         this._starrySky.removeEventListener("enterFrame",this.moveSky);
         this._starrySky = null;
         super.dispose();
      }
   }
}

