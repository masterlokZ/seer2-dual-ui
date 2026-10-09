package com.taomee.seer2.app.gameRule.fish
{
   import com.taomee.seer2.app.gameRule.core.ISupportable;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class FishRule_220 implements ISupportable
   {
      
      private var _fishingPoint:MovieClip = new MovieClip();
      
      public function FishRule_220()
      {
         super();
      }
      
      public function init(param1:MapModel) : void
      {
         this._fishingPoint = param1.content["fishingPP"];
         this._fishingPoint.buttonMode = true;
         this._fishingPoint.useHandCursor = true;
         TooltipManager.addCommonTip(this._fishingPoint,"幽静浅滩垂钓点");
         this._fishingPoint.addEventListener("click",this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         StatisticsManager.sendNovice("0x10033566");
         ModuleManager.showModule(URLUtil.getAppModule("FishToolPanel"),"正在打开选择鱼竿鱼饵面板!",{"sceneStyle":3});
      }
      
      public function dispose() : void
      {
         this._fishingPoint.removeEventListener("click",this.onClick);
         this._fishingPoint = null;
      }
   }
}

