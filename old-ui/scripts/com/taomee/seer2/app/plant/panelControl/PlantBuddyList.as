package com.taomee.seer2.app.plant.panelControl
{
   import com.taomee.seer2.app.home.panel.buddy.HomeBuddyItem;
   import com.taomee.seer2.app.home.panel.data.HomeBuddyDataService;
   import com.taomee.seer2.app.home.panel.data.HomeBuddyDataUnit;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.ui.WaitIndicator;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class PlantBuddyList extends Sprite
   {
      
      private static const MAX_NUM:int = 6;
      
      private var _container:MovieClip;
      
      private var _prePageBtn:SimpleButton;
      
      private var _nextPageBtn:SimpleButton;
      
      private var _refreshBtn:SimpleButton;
      
      private var _itemVec:Vector.<HomeBuddyItem>;
      
      private var _waitIndicator:WaitIndicator;
      
      private var _dataService:HomeBuddyDataService;
      
      private var _dataUnitVec:Vector.<HomeBuddyDataUnit>;
      
      private var _currentDataUnit:HomeBuddyDataUnit;
      
      private var _dataUnitIndex:int;
      
      private var _pageIndex:int;
      
      private var _emptyDataUnit:HomeBuddyDataUnit;
      
      private var _hasOrder:Boolean;
      
      private var _isIncreaseOrder:Boolean;
      
      public function PlantBuddyList()
      {
         super();
         this.createChildren();
         this.createDataService();
         this.initEventListener();
         this._hasOrder = false;
      }
      
      private function createChildren() : void
      {
         this.x = 234;
         this.y = 13;
         this._container = UIManager.getMovieClip("UI_PlantBuddyList");
         addChild(this._container);
         this._prePageBtn = this._container["prePage"];
         this._nextPageBtn = this._container["nextPage"];
         this._refreshBtn = this._container["refresh"];
         this.addToolTips();
         this.createItemVec();
         this._waitIndicator = new WaitIndicator();
         this._waitIndicator.x = 300;
         this._waitIndicator.y = 30;
      }
      
      private function createItemVec() : void
      {
         var _loc5_:int = 0;
         var _loc1_:HomeBuddyItem = null;
         this._itemVec = new Vector.<HomeBuddyItem>();
         var _loc3_:int = -2;
         var _loc2_:int = -62;
         _loc5_ = 120;
         var _loc4_:int = 0;
         while(_loc4_ < 6)
         {
            _loc1_ = new HomeBuddyItem(8);
            _loc1_.y = _loc3_;
            _loc1_.x = _loc2_ + _loc5_ * _loc4_;
            addChild(_loc1_);
            this._itemVec.push(_loc1_);
            _loc4_++;
         }
      }
      
      private function createDataService() : void
      {
         this._dataService = new HomeBuddyDataService();
         this._dataUnitVec = this._dataService.dataUnitVec;
         this._emptyDataUnit = new HomeBuddyDataUnit();
         this._emptyDataUnit.status = "empty";
         this._dataUnitIndex = 0;
      }
      
      private function initEventListener() : void
      {
         this._prePageBtn.addEventListener("click",this.onPreAllBtnClick);
         this._nextPageBtn.addEventListener("click",this.onNextAllBtnClick);
         this._refreshBtn.addEventListener("click",this.onRefreshBtnClick);
         this._dataService.addEventListener("buddyDataChange",this.onBuddyDataChange);
      }
      
      private function disposeEventListener() : void
      {
         this._prePageBtn.removeEventListener("click",this.onPreAllBtnClick);
         this._nextPageBtn.removeEventListener("click",this.onNextAllBtnClick);
         this._refreshBtn.removeEventListener("click",this.onRefreshBtnClick);
         this._dataService.removeEventListener("buddyDataChange",this.onBuddyDataChange);
      }
      
      private function onPreAllBtnClick(param1:MouseEvent) : void
      {
         DisplayObjectUtil.disableButton(this._prePageBtn);
         this.updateBuddyItem(-6);
      }
      
      private function onNextAllBtnClick(param1:MouseEvent) : void
      {
         DisplayObjectUtil.disableButton(this._nextPageBtn);
         this.updateBuddyItem(6);
      }
      
      private function onBuddyDataChange(param1:Event) : void
      {
         this._dataUnitVec = this._dataService.dataUnitVec;
         if(this._hasOrder)
         {
            this.sortAllDataUnit();
         }
         this.updateDisplay();
      }
      
      private function onRefreshBtnClick(param1:MouseEvent) : void
      {
         if(this._hasOrder == true)
         {
            this._isIncreaseOrder = !this._isIncreaseOrder;
         }
         else
         {
            this._isIncreaseOrder = false;
         }
         TooltipManager.remove(this._refreshBtn);
         var _loc2_:String = this._isIncreaseOrder ? "按木屋等级降序排序" : "按木屋等级升序排序";
         TooltipManager.addCommonTip(this._refreshBtn,_loc2_);
         DisplayObjectUtil.disableButton(this._refreshBtn);
         this.disableBuddyList();
         this.setAllDataUnitBusy();
         this.updateAllDataUnit();
      }
      
      private function updateBuddyItem(param1:int) : void
      {
         this.updateDataUnitIndex(param1);
         this.updateDisplay();
      }
      
      private function updateDataUnitIndex(param1:int) : void
      {
         this._dataUnitIndex += param1;
         if(this._dataUnitIndex < 0)
         {
            this._dataUnitIndex = 0;
         }
         if(this._dataUnitIndex + 6 > this._dataUnitVec.length)
         {
            this._dataUnitIndex = this._dataUnitVec.length - 6;
         }
      }
      
      private function updateDisplay() : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(this._dataUnitVec.length);
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc3_ = this._dataUnitIndex + _loc1_;
            if(_loc3_ < _loc2_)
            {
               this._itemVec[_loc1_].setData(this._dataUnitVec[_loc3_]);
            }
            else
            {
               this._itemVec[_loc1_].setData(this._emptyDataUnit);
            }
            _loc1_++;
         }
         this.updateBtnStatus();
         this.updateDataUnit();
      }
      
      private function updateBtnStatus() : void
      {
         this.enableBuddyList();
         if(this._dataUnitIndex == 0)
         {
            DisplayObjectUtil.disableButton(this._prePageBtn);
         }
         if(this._dataUnitIndex + 6 >= this._dataUnitVec.length)
         {
            DisplayObjectUtil.disableButton(this._nextPageBtn);
         }
      }
      
      private function updateDataUnit() : void
      {
         var _loc4_:int = 0;
         var _loc1_:HomeBuddyDataUnit = null;
         var _loc3_:int = int(this._dataUnitVec.length);
         var _loc2_:uint = 0;
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            _loc4_ = this._dataUnitIndex + _loc5_;
            if(_loc4_ < _loc3_)
            {
               _loc1_ = this._dataUnitVec[_loc4_];
               if(_loc1_.status == "busy")
               {
                  this.currentDataUnit = _loc1_;
                  this._currentDataUnit.addEventListener("update",this.onDataUnitUpdate);
                  this._currentDataUnit.update();
                  break;
               }
               _loc2_++;
               if(_loc2_ >= _loc3_ || _loc2_ >= 6)
               {
                  PlantPanelControl.isOpenBuddyMouse(true);
               }
            }
            _loc5_++;
         }
      }
      
      private function updatePage() : void
      {
      }
      
      private function onDataUnitUpdate(param1:Event) : void
      {
         this._currentDataUnit.removeEventListener("update",this.onDataUnitUpdate);
         this._currentDataUnit = null;
         this.updateDisplay();
      }
      
      private function setAllDataUnitBusy() : void
      {
         var _loc1_:HomeBuddyDataUnit = null;
         for each(_loc1_ in this._dataUnitVec)
         {
            _loc1_.status = "busy";
         }
         addChild(this._waitIndicator);
      }
      
      private function updateAllDataUnit() : void
      {
         var _loc3_:HomeBuddyDataUnit = null;
         var _loc2_:Boolean = false;
         var _loc1_:int = int(this._dataUnitVec.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this._dataUnitVec[_loc4_];
            if(_loc3_.status == "busy")
            {
               this.currentDataUnit = _loc3_;
               this._currentDataUnit.addEventListener("update",this.onDataUnitUpdateFinished);
               this._currentDataUnit.update();
               _loc2_ = true;
               break;
            }
            _loc4_++;
         }
         if(_loc2_ == false)
         {
            DisplayUtil.removeForParent(this._waitIndicator);
            this.sortAllDataUnit();
            this.enableBuddyList();
            DisplayObjectUtil.enableButton(this._prePageBtn);
            this._dataUnitIndex = 0;
            this.updateDisplay();
            this._hasOrder = true;
         }
      }
      
      private function sortAllDataUnit() : void
      {
         if(this._isIncreaseOrder == true)
         {
            this._dataUnitVec.sort(this.increaseByTrainerLevel);
         }
         else
         {
            this._dataUnitVec.sort(this.decreaseByTrainerLevel);
         }
         var _loc2_:int = int(this._dataUnitVec.length);
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            this._dataUnitVec[_loc1_].order = _loc1_ + 1;
            _loc1_++;
         }
      }
      
      private function decreaseByTrainerLevel(param1:HomeBuddyDataUnit, param2:HomeBuddyDataUnit) : int
      {
         var _loc4_:int = int(param1.userInfo.plantLevel);
         var _loc3_:int = int(param2.userInfo.plantLevel);
         if(_loc4_ < _loc3_)
         {
            return 1;
         }
         if(_loc4_ > _loc3_)
         {
            return -1;
         }
         return 0;
      }
      
      private function increaseByTrainerLevel(param1:HomeBuddyDataUnit, param2:HomeBuddyDataUnit) : int
      {
         var _loc4_:int = int(param1.userInfo.plantLevel);
         var _loc3_:int = int(param2.userInfo.plantLevel);
         if(_loc4_ < _loc3_)
         {
            return -1;
         }
         if(_loc4_ > _loc3_)
         {
            return 1;
         }
         return 0;
      }
      
      private function onDataUnitUpdateFinished(param1:Event) : void
      {
         this._currentDataUnit.removeEventListener("update",this.onDataUnitUpdateFinished);
         this._currentDataUnit = null;
         this.updateAllDataUnit();
      }
      
      private function set currentDataUnit(param1:HomeBuddyDataUnit) : void
      {
         if(this._currentDataUnit != null)
         {
            this._currentDataUnit.removeEventListener("update",this.onDataUnitUpdate);
            this._currentDataUnit.removeEventListener("update",this.onDataUnitUpdateFinished);
         }
         this._currentDataUnit = param1;
      }
      
      private function addToolTips() : void
      {
         TooltipManager.addCommonTip(this._prePageBtn,"上五个");
         TooltipManager.addCommonTip(this._nextPageBtn,"下五个");
         TooltipManager.addCommonTip(this._refreshBtn,"按木屋等级排序");
      }
      
      private function removeToolTips() : void
      {
         TooltipManager.remove(this._prePageBtn);
         TooltipManager.remove(this._nextPageBtn);
         TooltipManager.remove(this._refreshBtn);
      }
      
      private function disableBuddyList() : void
      {
         DisplayObjectUtil.disableButton(this._refreshBtn);
         DisplayObjectUtil.disableButton(this._prePageBtn);
         DisplayObjectUtil.disableButton(this._nextPageBtn);
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      private function enableBuddyList() : void
      {
         DisplayObjectUtil.enableButton(this._refreshBtn);
         DisplayObjectUtil.enableButton(this._prePageBtn);
         DisplayObjectUtil.enableButton(this._nextPageBtn);
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      public function setData() : void
      {
         this.updateDisplay();
      }
      
      public function dispose() : void
      {
         var _loc1_:HomeBuddyItem = null;
         this.removeToolTips();
         this._waitIndicator.dispose();
         for each(_loc1_ in this._itemVec)
         {
            _loc1_.dispose();
         }
         this._dataService.dispose();
         this.disposeEventListener();
         this.currentDataUnit = null;
      }
   }
}

