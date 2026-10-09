package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.core.map.MapModel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcessor_133 extends TitleMapProcessor
   {
      
      private var _bottlesCartoon:MovieClip;
      
      public function MapProcessor_133(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initBottlesCartoon();
         this.initLeiyiFight();
         StatisticsManager.sendNovice("0x10033416");
      }
      
      private function initLeiyiFight() : void
      {
      }
      
      private function initBottlesCartoon() : void
      {
         var _loc1_:MovieClip = _map.content["bottles"];
         this._bottlesCartoon = _loc1_.getChildByName("bottlesCartoon") as MovieClip;
         this._bottlesCartoon.addEventListener("frameConstructed",this.onCartoonFrameConstructed);
         this._bottlesCartoon.addEventListener("click",this.onClick);
         initInteractor(this._bottlesCartoon);
         this._bottlesCartoon.gotoAndStop(1);
      }
      
      private function onCartoonFrameConstructed(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.gotoAndStop(1);
            initInteractor(_loc2_);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         closeInteractor(_loc2_);
         _loc2_.gotoAndPlay(1);
         param1.stopPropagation();
      }
      
      private function clearEventListener(param1:Sprite) : void
      {
         param1.removeEventListener("frameConstructed",this.onCartoonFrameConstructed);
         param1.removeEventListener("click",this.onClick);
      }
      
      override public function dispose() : void
      {
         this.clearEventListener(this._bottlesCartoon);
         this._bottlesCartoon = null;
         super.dispose();
      }
   }
}

