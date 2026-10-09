package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.controls.ToolBar;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.rightToolbar.RightToolbarConter;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcessor_80491 extends MapProcessor
   {
      
      private var _captain:Mobile;
      
      private var _npc:MovieClip;
      
      public function MapProcessor_80491(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this._captain = MobileManager.getMobile(80351,"npc");
         if(this._captain)
         {
            this._captain.gotoAndStop(1);
            this._captain.addEventListener("mouseOver",this.onCaptainOver);
            this._captain.addEventListener("mouseOut",this.onCaptainOut);
         }
         this._npc = _map.content["npc"];
         this._npc.buttonMode = true;
         if(QuestManager.isComplete(99))
         {
            AlertManager.showAlert("新手任务已完成");
            RightToolbarConter.instance.newPlayerShowFilter();
            this._npc.addEventListener("click",this.onNpc);
            ToolBar.getBtn("NonoInput").visible = true;
         }
      }
      
      private function onNpc(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("NewPlayerProcessWayPanel");
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
         if(this._captain)
         {
            this._captain.removeEventListener("enterFrame",this.onCaptainPlay);
            this._captain.gotoAndStop(1);
         }
      }
      
      override public function dispose() : void
      {
         this._npc.removeEventListener("click",this.onNpc);
         if(this._captain)
         {
            this._captain.removeEventListener("mouseOver",this.onCaptainOver);
            this._captain.removeEventListener("mouseOut",this.onCaptainOut);
         }
         super.dispose();
      }
   }
}

