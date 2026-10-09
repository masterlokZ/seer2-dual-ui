package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MapProcessor_123 extends TitleMapProcessor
   {
      
      private var _MushroomAnimation:MovieClip;
      
      private var _board:Mobile;
      
      public function MapProcessor_123(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initMushroom();
         super.init();
         StatisticsManager.sendNovice("0x10033413");
      }
      
      private function initTreeHouseWar() : void
      {
         this._board = new Mobile();
         this._board.resourceUrl = URLUtil.getActivityMobile("TreeHouseWarBoard");
         this._board.x = 170;
         this._board.y = 370;
         this._board.mouseChildren = false;
         this._board.buttonMode = true;
         this._board.addEventListener("click",this.openTreePanel);
         MobileManager.addMobile(this._board,"npc");
      }
      
      protected function openTreePanel(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("TreeHouseWarPanel"));
      }
      
      private function initAttack() : void
      {
      }
      
      private function initMushroom() : void
      {
         this._MushroomAnimation = _map.content["MushroomAnimation"];
         initInteractor(this._MushroomAnimation);
         this._MushroomAnimation.addEventListener("click",this.onMushroomClick);
         this._MushroomAnimation.addEventListener("mouseOver",this.onMushroomOver);
         this._MushroomAnimation.addEventListener("mouseOut",this.offMushroomOver);
      }
      
      private function onMushroomOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.gotoAndStop(2);
      }
      
      private function offMushroomOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.gotoAndStop(1);
      }
      
      private function onMushroomClick(param1:MouseEvent) : void
      {
         this.reward();
      }
      
      private function reward() : void
      {
         if(SwapManager.isSwapNumberMax(15))
         {
            SwapManager.entrySwap(15);
         }
      }
      
      override public function dispose() : void
      {
         this._MushroomAnimation.removeEventListener("mouseOver",this.onMushroomOver);
         this._MushroomAnimation.removeEventListener("mouseOut",this.offMushroomOver);
         this._MushroomAnimation = null;
         super.dispose();
      }
   }
}

