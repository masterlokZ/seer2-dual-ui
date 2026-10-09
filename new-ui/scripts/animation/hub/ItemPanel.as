package animation.hub
{
   import animation.event.OperateEvent;
   import data.pet.ItemData;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import ui.hub.UI_FightPage;
   
   internal class ItemPanel extends Sprite
   {
      
      private static const ITEM_NUM_PAGE:int = 9;
      
      private var _pageIndex:int;
      
      private var _maxPageIndex:int;
      
      private var _petItemVec:Vector.<ItemData>;
      
      private var _itemDisplayVec:Vector.<ItemDisplay>;
      
      private var _nextBtn:SimpleButton;
      
      private var _prevBtn:SimpleButton;
      
      private var _tip:ItemTip;
      
      private var _capsule:Boolean;
      
      public function ItemPanel(param1:Boolean)
      {
         var offsetX:int;
         var offsetY:int;
         var itemWidth:int;
         var i:int;
         var onOver:Function;
         var onOut:Function;
         var onNextPage:Function;
         var onPrevPage:Function;
         var itemDisplay:ItemDisplay;
         var capsule:Boolean = param1;
         this._capsule = capsule;
         i = 0;
         onOver = null;
         onOut = null;
         onNextPage = null;
         onPrevPage = null;
         itemDisplay = null;
         super();
         onOver = function(param1:MouseEvent):void
         {
            var _loc2_:ItemDisplay = param1.currentTarget as ItemDisplay;
            _tip.initData(_loc2_.item());
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
            showPage(_pageIndex + 1);
         };
         onPrevPage = function(param1:MouseEvent):void
         {
            showPage(_pageIndex - 1);
         };
         this.mouseEnabled = false;
         offsetX = 28;
         offsetY = 7;
         itemWidth = 73;
         this._itemDisplayVec = new Vector.<ItemDisplay>();
         i = 0;
         while(i < 9)
         {
            itemDisplay = new ItemDisplay();
            itemDisplay.x = offsetX + i * itemWidth;
            itemDisplay.y = offsetY + i % 2 * 20;
            itemDisplay.addEventListener("click",this.onClick);
            itemDisplay.addEventListener("mouseOver",onOver);
            itemDisplay.addEventListener("mouseOut",onOut);
            this._itemDisplayVec.push(itemDisplay);
            addChild(itemDisplay);
            i = i + 1;
         }
         this._prevBtn = new UI_FightPage();
         this._prevBtn.x = 3;
         this._prevBtn.y = 60;
         addChild(this._prevBtn);
         this._nextBtn = new UI_FightPage();
         this._nextBtn.x = 693;
         this._nextBtn.y = 47;
         this._nextBtn.scaleX = -1;
         addChild(this._nextBtn);
         this.disableBtn(this._prevBtn);
         this.disableBtn(this._nextBtn);
         this._tip = new ItemTip();
         this._nextBtn.addEventListener("click",onNextPage);
         this._prevBtn.addEventListener("click",onPrevPage);
      }
      
      public function initData(param1:Vector.<ItemData>) : void
      {
         this._petItemVec = param1;
         this._pageIndex = 0;
         this._maxPageIndex = Math.max(0,Math.floor((this._petItemVec.length - 1) / 9));
         this.showPage(this._pageIndex);
      }
      
      private function showPage(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc2_:ItemDisplay = null;
         if(param1 < 0 || param1 > _maxPageIndex)
         {
            return;
         }
         this._pageIndex = param1;
         var _loc3_:int = param1 * 9;
         var _loc6_:Number = Math.min((param1 + 1) * 9,_petItemVec.length);
         var _loc7_:Vector.<ItemData> = new Vector.<ItemData>();
         _loc5_ = _loc3_;
         while(_loc5_ < _loc6_)
         {
            _loc7_.push(_petItemVec[_loc5_]);
            _loc5_++;
         }
         var _loc4_:Number = Math.min(_loc7_.length,9);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._itemDisplayVec[_loc5_];
            _loc2_.initData(_loc7_[_loc5_]);
            _loc5_++;
         }
         _loc5_ = _loc4_;
         while(_loc5_ < 9)
         {
            _loc2_ = this._itemDisplayVec[_loc5_];
            _loc2_.initData(null);
            _loc5_++;
         }
         if(param1 > 0)
         {
            this.enableBtn(this._prevBtn);
         }
         else
         {
            this.disableBtn(this._prevBtn);
         }
         if(param1 < this._maxPageIndex)
         {
            this.enableBtn(this._nextBtn);
         }
         else
         {
            this.disableBtn(this._nextBtn);
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
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:ItemDisplay = param1.currentTarget as ItemDisplay;
         if(_capsule)
         {
            dispatchEvent(OperateEvent.capsule(_loc2_.item().id));
         }
         else
         {
            dispatchEvent(OperateEvent.item(_loc2_.item().id));
         }
      }
   }
}

