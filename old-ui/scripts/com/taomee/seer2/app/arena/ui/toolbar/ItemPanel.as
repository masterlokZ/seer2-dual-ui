package com.taomee.seer2.app.arena.ui.toolbar
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.events.OperateEvent;
   import com.taomee.seer2.app.arena.resource.FightUIManager;
   import com.taomee.seer2.app.arena.ui.toolbar.sub.ItemDisplay;
   import com.taomee.seer2.app.arena.ui.toolbar.sub.ItemTip;
   import com.taomee.seer2.app.arena.util.FightMode;
   import com.taomee.seer2.app.config.FitConfig;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.item.PetItem;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ItemPanel extends Sprite
   {
      
      private static const ITEM_NUM_PATGE:int = 9;
      
      private static const MEDICINE_ITEM_TYPE_VECTOR:Vector.<int> = Vector.<int>([2,3,4,5,6,17]);
      
      private var _pageIndex:int;
      
      private var _maxPageIndex:int;
      
      private var _petItemVec:Vector.<PetItem>;
      
      private var _itemDisplayVec:Vector.<ItemDisplay>;
      
      private var _nextBtn:SimpleButton;
      
      private var _prevBtn:SimpleButton;
      
      private var _tip:ItemTip;
      
      private var _filterType:int;
      
      private var _fighter:Fighter;
      
      private var _oppositeFighter:Fighter;
      
      private var _usedItemReferenceId:uint;
      
      public function ItemPanel(param1:int)
      {
         var offsetX:int;
         var offsetY:int;
         var itemWidth:int;
         var i:int = 0;
         var onOver:Function = null;
         var onOut:Function = null;
         var onNextPage:Function = null;
         var onPrevPage:Function = null;
         var itemDisplay:ItemDisplay = null;
         var filterType:int = param1;
         super();
         onOver = function(param1:MouseEvent):void
         {
            var _loc2_:ItemDisplay = param1.currentTarget as ItemDisplay;
            _tip.setItemInfo(_loc2_.getItemInfo());
            _tip.x = _loc2_.x + 15;
            _tip.y = _loc2_.y;
            addChild(_tip);
         };
         onOut = function(param1:MouseEvent):void
         {
            if(Boolean(_tip) && contains(_tip))
            {
               removeChild(_tip);
            }
         };
         onNextPage = function(param1:MouseEvent):void
         {
            ++_pageIndex;
            showPage(_pageIndex);
         };
         onPrevPage = function(param1:MouseEvent):void
         {
            --_pageIndex;
            showPage(_pageIndex);
         };
         this._filterType = filterType;
         this.mouseEnabled = false;
         offsetX = 100;
         offsetY = 57;
         itemWidth = 73;
         this._itemDisplayVec = new Vector.<ItemDisplay>();
         for(i = 0; i < 9; )
         {
            itemDisplay = new ItemDisplay();
            itemDisplay.x = offsetX + i * itemWidth;
            itemDisplay.y = offsetY + i % 2 * 20;
            itemDisplay.addEventListener("click",this.onClick);
            itemDisplay.addEventListener("mouseOver",onOver);
            itemDisplay.addEventListener("mouseOut",onOut);
            this._itemDisplayVec.push(itemDisplay);
            addChild(itemDisplay);
            i++;
         }
         this._prevBtn = FightUIManager.getButton("UI_FightPage");
         this._prevBtn.x = 72;
         this._prevBtn.y = 92;
         addChild(this._prevBtn);
         this._nextBtn = FightUIManager.getButton("UI_FightPage");
         this._nextBtn.x = 772;
         this._nextBtn.y = 92;
         this._nextBtn.scaleX = -1;
         addChild(this._nextBtn);
         this.disableBtn(this._prevBtn);
         this.disableBtn(this._nextBtn);
         this._tip = new ItemTip();
         this._nextBtn.addEventListener("click",onNextPage);
         this._prevBtn.addEventListener("click",onPrevPage);
         if(SceneManager.currentSceneType == 6)
         {
            this.addGudie();
         }
      }
      
      public static function filterItems(_filterType:int) : Vector.<PetItem>
      {
         var filterByPetItemType:Function = function(param1:PetItem, param2:int, param3:Vector.<PetItem>):Boolean
         {
            var _loc6_:ArenaScene = null;
            var _loc5_:Boolean = false;
            var _loc4_:Fighter = null;
            if(_filterType == 1)
            {
               return param1.type == 1;
            }
            if(_filterType == 2)
            {
               _loc6_ = SceneManager.active as ArenaScene;
               if(param1.type == 17)
               {
                  _loc5_ = false;
                  for each(_loc4_ in _loc6_.arenaData.leftTeam.fighterVec)
                  {
                     if(FitConfig.isPetFit(_loc4_.fighterInfo.bunchId))
                     {
                        _loc5_ = true;
                     }
                  }
                  if(FightMode.isPVPMode(_loc6_.arenaData.fightMode) == false && _loc6_.arenaData.isDoubleMode == false && _loc5_ == false)
                  {
                     return true;
                  }
               }
               else
               {
                  if(param1.referenceId == 200018 || param1.referenceId == 200019)
                  {
                     if(FightMode.isPVPMode(_loc6_.arenaData.fightMode))
                     {
                        return false;
                     }
                     return true;
                  }
                  if(param1.referenceId == 201026 || param1.referenceId == 200233 || param1.referenceId == 201014 || param1.referenceId == 400132)
                  {
                     return false;
                  }
                  if(MEDICINE_ITEM_TYPE_VECTOR.indexOf(param1.type) != -1)
                  {
                     if(param1.type == 3)
                     {
                        if(FightMode.isPVPMode(_loc6_.arenaData.fightMode))
                        {
                           return false;
                        }
                        return true;
                     }
                     return true;
                  }
               }
            }
            return false;
         };
         return ItemManager.getPetRelateVec().filter(filterByPetItemType);
      }
      
      public static function filterItemsAllFight(_filterType:int) : Vector.<PetItem>
      {
         var filterByPetItemType:Function = function(param1:PetItem, param2:int, param3:Vector.<PetItem>):Boolean
         {
            if(_filterType == 1)
            {
               return param1.type == 1;
            }
            if(_filterType == 2)
            {
               if(MEDICINE_ITEM_TYPE_VECTOR.indexOf(param1.type) != -1)
               {
                  return true;
               }
            }
            return false;
         };
         return ItemManager.getPetRelateVec().filter(filterByPetItemType);
      }
      
      private function addGudie() : void
      {
         if(this._filterType == 2)
         {
            GuideManager.instance.addTarget(this._itemDisplayVec[0],2);
            GuideManager.instance.addGuide2Target(this._itemDisplayVec[0],0,2,new Point(100,470),true,false,9);
         }
         else if(this._filterType == 1)
         {
            GuideManager.instance.addTarget(this._itemDisplayVec[0],5);
            GuideManager.instance.addGuide2Target(this._itemDisplayVec[0],0,5,new Point(100,470),true,true,9);
         }
      }
      
      public function setControlledFighter(param1:Fighter) : void
      {
         this._fighter = param1;
      }
      
      public function setOppositeFighter(param1:Fighter) : void
      {
         this._oppositeFighter = param1;
      }
      
      public function reset() : void
      {
         var _loc1_:PetItem = null;
         if(SceneManager.currentSceneType == 6 && this._filterType == 2)
         {
            _loc1_ = new PetItem(200011,1,0);
            this._petItemVec = new Vector.<PetItem>();
            this._petItemVec.push(_loc1_);
            this._pageIndex = 0;
            this._maxPageIndex = Math.max(0,Math.floor((this._petItemVec.length - 1) / 9));
            this.showPage(this._pageIndex);
         }
         else if(SceneManager.currentSceneType == 6 && this._filterType == 1)
         {
            _loc1_ = new PetItem(200001,1,0);
            this._petItemVec = new Vector.<PetItem>();
            this._petItemVec.push(_loc1_);
            this._pageIndex = 0;
            this._maxPageIndex = Math.max(0,Math.floor((this._petItemVec.length - 1) / 9));
            this.showPage(this._pageIndex);
         }
         else
         {
            ItemManager.requestItemList(this.resetData);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:OperateEvent = null;
         var _loc2_:ItemDisplay = param1.currentTarget as ItemDisplay;
         var _loc4_:PetItem = _loc2_.getItemInfo();
         if(_loc4_.type == 2)
         {
            if(this._fighter.fighterInfo.hp >= this._fighter.fighterInfo.maxHp)
            {
               ServerMessager.addMessage("这只精灵处于满血状态");
               dispatchEvent(new OperateEvent(0,0,"error"));
               return;
            }
            this.useMedicineItem(_loc4_);
            _loc3_ = new OperateEvent(2,this._usedItemReferenceId,"operateEnd");
            _loc3_.fighterId = this._fighter.id;
         }
         else if(_loc4_.type == 3)
         {
            if(SceneManager.currentSceneType == 10 || SceneManager.currentSceneType == 14)
            {
               this.useMedicineItem(_loc4_);
               _loc3_ = new OperateEvent(2,this._usedItemReferenceId,"operateEnd");
               _loc3_.fighterId = this._fighter.id;
            }
            else
            {
               if(this._fighter.fighterInfo.fightAnger >= 100)
               {
                  ServerMessager.addMessage("这只精灵处于满怒气状态");
                  dispatchEvent(new OperateEvent(0,0,"error"));
                  return;
               }
               this.useMedicineItem(_loc4_);
               _loc3_ = new OperateEvent(2,this._usedItemReferenceId,"operateEnd");
               _loc3_.fighterId = this._fighter.id;
            }
         }
         else if(_loc4_.type == 1)
         {
            if(_loc4_.minLevel < this._oppositeFighter.fighterInfo.level)
            {
               ServerMessager.addMessage("只能捕捉" + _loc4_.minLevel + "级以下的精灵");
               return;
            }
            this.useCapsuleItem(_loc4_);
            _loc3_ = new OperateEvent(3,this._usedItemReferenceId,"operateEnd");
         }
         else if(_loc4_.type == 17)
         {
            this.useCapsuleItem(_loc4_);
            _loc3_ = new OperateEvent(6,this._usedItemReferenceId,"fightSelectItem");
         }
         if(_loc3_ == null)
         {
            _loc3_ = new OperateEvent(0,0,"operateEnd");
         }
         dispatchEvent(_loc3_);
      }
      
      private function useCapsuleItem(param1:PetItem) : void
      {
         this._usedItemReferenceId = param1.referenceId;
      }
      
      private function useMedicineItem(param1:PetItem) : void
      {
         this._usedItemReferenceId = param1.referenceId;
      }
      
      public function resetData() : void
      {
         this._petItemVec = filterItems(_filterType);
         this._pageIndex = 0;
         this._maxPageIndex = Math.max(0,Math.floor((this._petItemVec.length - 1) / 9));
         this.showPage(this._pageIndex);
      }
      
      private function showPage(param1:int) : void
      {
         var _loc4_:ItemDisplay = null;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         for each(_loc4_ in this._itemDisplayVec)
         {
            _loc4_.clear();
         }
         _loc6_ = this._pageIndex * 9;
         _loc5_ = (this._pageIndex + 1) * 9;
         _loc3_ = int(this._petItemVec.length);
         _loc5_ = Math.min(_loc5_,_loc3_);
         _loc2_ = _loc6_;
         while(_loc2_ < _loc5_)
         {
            this._itemDisplayVec[_loc2_ - _loc6_].setItemInfo(this._petItemVec[_loc2_]);
            _loc2_++;
         }
         this.disableBtn(this._nextBtn);
         this.disableBtn(this._prevBtn);
         if(this._pageIndex > 0)
         {
            this.enableBtn(this._prevBtn);
         }
         if(this._pageIndex < this._maxPageIndex)
         {
            this.enableBtn(this._nextBtn);
         }
      }
      
      private function enableBtn(param1:SimpleButton) : void
      {
         param1.enabled = true;
         param1.mouseEnabled = true;
      }
      
      private function disableBtn(param1:SimpleButton) : void
      {
         param1.enabled = false;
         param1.mouseEnabled = false;
      }
      
      public function dispose() : void
      {
         var _loc1_:ItemDisplay = null;
         DisplayObjectUtil.removeAllChildren(this);
         for each(_loc1_ in this._itemDisplayVec)
         {
            _loc1_.dispose();
         }
         this._itemDisplayVec = null;
         this._tip = null;
         this._oppositeFighter = null;
         this._fighter = null;
      }
      
      public function active() : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      public function deactive() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
   }
}

