package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MapProcessor_1030 extends DiceMapProcessor
   {
      
      private var diceMc:MovieClip;
      
      private var telpoint0:MovieClip;
      
      private var isGuid:int;
      
      private var helpBtn:SimpleButton;
      
      public function MapProcessor_1030(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         ServerBufferManager.getServerBuffer(46,this.getBuff);
         this.telpoint0 = _map.content["telpoint0"];
         this.helpBtn = _map.content["helpBtn"];
         this.telpoint0.addEventListener("click",this.to70);
         this.helpBtn.addEventListener("click",this.openHelp);
         this.telpoint0.buttonMode = true;
         TooltipManager.addCommonTip(this.telpoint0,"幽静浅滩");
      }
      
      private function openHelp(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("DiceStarHelpPanel"));
      }
      
      private function to70(param1:MouseEvent) : void
      {
         SceneManager.changeScene(1,220);
      }
      
      private function getBuff(param1:ServerBuffer) : void
      {
         var buff:ServerBuffer = param1;
         this.isGuid = buff.readDataAtPostion(19);
         if(this.isGuid != 1)
         {
            MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("debarkDice"),function():void
            {
               ModuleManager.toggleModule(URLUtil.getAppModule("DiceStarHelpPanel"));
               ModuleManager.addEventListener("DiceStarHelpPanel","dispose",disposeHelp);
            });
         }
      }
      
      private function disposeHelp(param1:ModuleEvent) : void
      {
         if(this.isGuid != 1)
         {
            this.setupGuid();
         }
      }
      
      private function setupGuid() : void
      {
         var _loc1_:Rectangle = new Rectangle(0,0,135,120);
         GuideManager.instance.addTarget(_loc1_,3);
         GuideManager.instance.addGuide2Target(_loc1_,0,3,new Point(967,45),false,false,9);
         GuideManager.instance.startGuide(3);
         this.diceMc = _map.content["dice"];
         this.diceMc.addEventListener("click",this.overGuid);
      }
      
      private function overGuid(param1:MouseEvent) : void
      {
         this.diceMc.removeEventListener("click",this.overGuid);
         GuideManager.instance.pause();
         ServerBufferManager.updateServerBuffer(46,19,1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.telpoint0.removeEventListener("click",this.to70);
         if(this.diceMc)
         {
            this.diceMc.removeEventListener("click",this.overGuid);
         }
         this.helpBtn.removeEventListener("click",this.openHelp);
         TooltipManager.remove(this.telpoint0);
         ModuleManager.removeEventListener("DiceStarHelpPanel","dispose",this.disposeHelp);
      }
   }
}

