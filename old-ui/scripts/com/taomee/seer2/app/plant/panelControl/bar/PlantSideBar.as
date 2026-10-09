package com.taomee.seer2.app.plant.panelControl.bar
{
   import com.taomee.seer2.app.home.panel.bar.HomeBar;
   import com.taomee.seer2.app.home.panel.events.HomePanelEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.ds.HashMap;
   
   public class PlantSideBar extends HomeBar
   {
      
      public static const HOME_DAYILY_BTN:String = "homeDailyBtn";
      
      public static const HOME_NEWS_BTN:String = "buddyNewsBtn";
      
      public static const TRAINING_PET_BTN:String = "trainingPetBtn";
      
      public static const PET_STORAGE_BTN:String = "petStorageBtn";
      
      private var _warehouseBtn:SimpleButton;
      
      private var _trainingPetBtn:SimpleButton;
      
      private var _petStorageBtn:SimpleButton;
      
      private var _guardBtn:SimpleButton;
      
      private var _sideBtnMap:HashMap;
      
      public function PlantSideBar()
      {
         super();
         this.adjustPosition();
         _container = UIManager.getMovieClip("UI_PlantSideBar");
         addChild(_container);
         _buttonVec = new Vector.<SimpleButton>();
         this._sideBtnMap = new HashMap();
         this._warehouseBtn = _container["warehouse"];
         TooltipManager.addCommonTip(this._warehouseBtn,"仓库");
         this._warehouseBtn.addEventListener("click",this.onBuddyBtnClick);
         _buttonVec.push(this._warehouseBtn);
         this._sideBtnMap.add("buddyNewsBtn",this._warehouseBtn);
         this._trainingPetBtn = _container["mapBtn"];
         TooltipManager.addCommonTip(this._trainingPetBtn,"地图");
         this._trainingPetBtn.addEventListener("click",this.onTrainingBtnClick);
         _buttonVec.push(this._trainingPetBtn);
         this._sideBtnMap.add("trainingPetBtn",this._trainingPetBtn);
         this._petStorageBtn = _container["buddyBtn"];
         TooltipManager.addCommonTip(this._petStorageBtn,"好友");
         this._petStorageBtn.addEventListener("click",this.onPetStorageBtnClick);
         _buttonVec.push(this._petStorageBtn);
         this._sideBtnMap.add("petStorageBtn",this._petStorageBtn);
      }
      
      public function adjustPosition() : void
      {
         this.x = LayerManager.stage.stageWidth - 70;
         this.y = 139;
      }
      
      private function onBuddyBtnClick(param1:MouseEvent) : void
      {
         StatisticsManager.sendNovice("0x10033406");
         ModuleManager.toggleModule(URLUtil.getAppModule("PlantLibraryPanel"),"正在打开仓库...");
      }
      
      private function onTrainingBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = {};
         _loc2_["mapCategoryId"] = SceneManager.active.mapCategoryID;
         _loc2_["mapId"] = SceneManager.active.mapID;
         _loc2_["mapType"] = "star";
         ModuleManager.toggleModule(URLUtil.getAppModule("MapPanel"),"正在打开地图导航...",_loc2_);
      }
      
      public function get warehouse() : SimpleButton
      {
         return this._warehouseBtn;
      }
      
      private function onPetStorageBtnClick(param1:MouseEvent) : void
      {
         StatisticsManager.sendNovice("0x10033407");
         dispatchEvent(new HomePanelEvent("requestAddBuddy",true));
      }
      
      private function onGuardBtnClick(param1:MouseEvent) : void
      {
      }
      
      override protected function getShowButtonIndexVec(param1:Boolean) : Vector.<int>
      {
         if(param1)
         {
            return Vector.<int>([0,1,2,3]);
         }
         return Vector.<int>([]);
      }
      
      public function enableSomeBtn() : void
      {
         DisplayObjectUtil.enableButton(this.getBtnByName("homeDailyBtn"));
         DisplayObjectUtil.enableButton(this.getBtnByName("buddyNewsBtn"));
      }
      
      public function disEnableSomeBtn() : void
      {
         DisplayObjectUtil.disableButton(this.getBtnByName("homeDailyBtn"));
         DisplayObjectUtil.disableButton(this.getBtnByName("buddyNewsBtn"));
      }
      
      public function getBtnByName(param1:String) : SimpleButton
      {
         return this._sideBtnMap.getValue(param1);
      }
      
      override public function dispose() : void
      {
         TooltipManager.remove(this._warehouseBtn);
         TooltipManager.remove(this._trainingPetBtn);
         TooltipManager.remove(this._petStorageBtn);
         TooltipManager.remove(this._guardBtn);
         this._warehouseBtn.removeEventListener("click",this.onBuddyBtnClick);
         this._trainingPetBtn.removeEventListener("click",this.onTrainingBtnClick);
         this._petStorageBtn.removeEventListener("click",this.onPetStorageBtnClick);
         this._guardBtn.removeEventListener("click",this.onGuardBtnClick);
         this._sideBtnMap.clear();
         this._sideBtnMap = null;
      }
   }
}

