package com.taomee.seer2.app.home.panel.buddy
{
   import com.taomee.seer2.app.home.panel.events.HomePanelEvent;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HomeBuddyEmptyItem extends Sprite
   {
      
      private var _container:MovieClip;
      
      private var _type:uint;
      
      public function HomeBuddyEmptyItem(param1:uint = 3)
      {
         super();
         buttonMode = true;
         mouseChildren = false;
         if(param1 == 3)
         {
            this._container = UIManager.getMovieClip("UI_HomeBuddyEmptyItem");
         }
         else if(param1 == 8)
         {
            this._container = UIManager.getMovieClip("UI_PlantBuddyEmptyItem");
         }
         this._container.gotoAndStop(1);
         addChild(this._container);
         addEventListener("rollOver",this.onMouseOver);
         addEventListener("rollOut",this.onMouseOut);
         addEventListener("click",this.onMouseClick);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this._container.gotoAndStop(2);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this._container.gotoAndStop(1);
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new HomePanelEvent("requestAddBuddy",true));
      }
      
      public function dispose() : void
      {
         removeEventListener("rollOver",this.onMouseOver);
         removeEventListener("rollOut",this.onMouseOut);
         removeEventListener("click",this.onMouseClick);
      }
   }
}

