package com.taomee.seer2.app.utils
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class PetIntroUIHelper
   {
      
      private var _mcIntroUI:MovieClip;
      
      private var _closeIntroBtn:SimpleButton;
      
      public function PetIntroUIHelper(param1:MovieClip, param2:SimpleButton)
      {
         super();
         this._mcIntroUI = param1;
         this._mcIntroUI.visible = false;
         this._closeIntroBtn = param1["closeBtn"];
         param2.addEventListener("click",this.onShowIntro);
      }
      
      protected function onShowIntro(param1:MouseEvent) : void
      {
         this._mcIntroUI.visible = true;
         this._closeIntroBtn.addEventListener("click",this.onHideIntro);
      }
      
      protected function onHideIntro(param1:MouseEvent) : void
      {
         this._closeIntroBtn.removeEventListener("click",this.onHideIntro);
         this._mcIntroUI.visible = false;
      }
   }
}

