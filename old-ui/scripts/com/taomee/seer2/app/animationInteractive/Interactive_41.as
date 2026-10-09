package com.taomee.seer2.app.animationInteractive
{
   import com.taomee.seer2.core.scene.LayerManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Interactive_41 extends BaseAniamationInteractive
   {
      
      private var _panels:Array;
      
      public function Interactive_41()
      {
         super();
      }
      
      override protected function paramAnimation() : void
      {
         var _loc2_:MovieClip = null;
         LayerManager.showMap();
         LayerManager.focusOnTopLayer();
         this._panels = [];
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = _animation["mc" + _loc1_];
            _loc2_.buttonMode = true;
            _loc2_.addEventListener("click",this.onChoosePanel);
            this._panels.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function onChoosePanel(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:int = this._panels.indexOf(_loc2_);
         if(_loc3_ != 3)
         {
            _loc2_.gotoAndStop(2);
         }
         else
         {
            dispatchEvent(new Event("select"));
            super.dispose();
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            (this._panels[_loc1_] as MovieClip).removeEventListener("click",this.onChoosePanel);
            this._panels[_loc1_] = null;
            _loc1_++;
         }
         LayerManager.resetOperation();
         super.dispose();
      }
   }
}

