package com.taomee.seer2.app.controls.widget
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.controls.ToolbarEvent;
   import com.taomee.seer2.app.controls.ToolbarEventDispatcher;
   import com.taomee.seer2.app.controls.widget.core.IWidgetable;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.core.effects.SoundEffects;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HomeInputFrameWidget extends Sprite implements IWidgetable
   {
      
      public static const HOME_INPUT:String = "HomeInput";
      
      private var _mainUI:MovieClip;
      
      private var _btn:SimpleButton;
      
      private var _page:MovieClip;
      
      private var _homeBag:SimpleButton;
      
      private var _plantBag:SimpleButton;
      
      private var _isShow:Boolean;
      
      public function HomeInputFrameWidget(param1:MovieClip)
      {
         super();
         this._mainUI = param1;
         addChild(this._mainUI);
         this.initMC();
         this.initEventListener();
      }
      
      private function initMC() : void
      {
         this._btn = this._mainUI["btn"];
         this._page = this._mainUI["page"];
         this._homeBag = this._page["homeBag"];
         this._plantBag = this._page["plantBag"];
         DisplayObjectUtil.removeFromParent(this._homeBag);
         DisplayObjectUtil.removeFromParent(this._btn);
         this._homeBag.x += this._mainUI.x;
         this._homeBag.y += this._mainUI.y;
         this._homeBag.scaleX = this._homeBag.scaleY = 0.86;
         this._homeBag.x -= 10;
         this._homeBag.y += 23;
         addChild(this._homeBag);
         this._isShow = false;
         this.updateNonoPage();
         this.updateTooltip();
      }
      
      private function updateTooltip() : void
      {
         TooltipManager.addCommonTip(this._btn,"家园");
      }
      
      private function initEventListener() : void
      {
         this._btn.addEventListener("rollOver",this.onNono);
         this._homeBag.addEventListener("click",this.onHome);
         this._plantBag.addEventListener("click",this.onPlant);
         ToolbarEventDispatcher.addEventListener("pageChange",this.onChange);
         ToolbarEventDispatcher.addEventListener("toolbarHide",this.onHide);
         this._mainUI.addEventListener("rollOut",this.onOut);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.onHide(null);
      }
      
      private function onHide(param1:ToolbarEvent) : void
      {
         this._isShow = false;
         this.updateNonoPage();
      }
      
      private function onChange(param1:ToolbarEvent) : void
      {
         if(param1.typeStr != "HomeInput" && param1.status)
         {
            this._isShow = false;
            this.updateNonoPage();
         }
      }
      
      private function updateNonoPage() : void
      {
         this._page.visible = this._isShow;
      }
      
      private function onNono(param1:MouseEvent) : void
      {
         this._isShow = !this._isShow;
         ToolbarEventDispatcher.dispatchEvent(new ToolbarEvent("pageChange",this._isShow,"HomeInput"));
         this.updateNonoPage();
         StatisticsManager.sendNovice("0x1003360D");
      }
      
      private function onHome(param1:MouseEvent) : void
      {
         StatisticsManager.sendNovice("0x10033620");
         ActorManager.getActor().stand();
         SceneManager.changeScene(3,ActorManager.actorInfo.id);
         SoundEffects.playSoundMouseClick();
      }
      
      private function onPlant(param1:MouseEvent) : void
      {
         SceneManager.changeScene(8,ActorManager.actorInfo.id);
         StatisticsManager.sendNovice("0x1003361F");
         SoundEffects.playSoundMouseClick();
      }
   }
}

