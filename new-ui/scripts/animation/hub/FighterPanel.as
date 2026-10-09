package animation.hub
{
   import animation.event.OperateEvent;
   import data.pet.PetData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.an.DisplayObjectUtil;
   
   internal class FighterPanel extends Sprite
   {
      
      private static const MAX_NUM_FIGHTER:int = 6;
      
      private var _fighterDisplayVec:Vector.<FighterDisplay>;
      
      private var _tip:FighterTip;
      
      public function FighterPanel()
      {
         var offsetX:int;
         var itemWidth:int;
         var i:int;
         var offsetY:int = 0;
         var onMouseOver:Function = null;
         var onMouseOut:Function = null;
         var fighterDisplay:FighterDisplay = null;
         onMouseOver = function(param1:MouseEvent):void
         {
            var _loc3_:PetData = null;
            var _loc2_:FighterDisplay = param1.currentTarget as FighterDisplay;
            _loc3_ = _loc2_.pet();
            _tip.x = _loc2_.x + 15;
            _tip.y = _loc2_.y;
            _tip.initData(_loc3_.skills);
            addChild(_tip);
         };
         onMouseOut = function(param1:MouseEvent):void
         {
            var _loc2_:FighterDisplay = param1.target as FighterDisplay;
            if(Boolean(_tip) && contains(_tip))
            {
               removeChild(_tip);
            }
         };
         super();
         this.mouseEnabled = false;
         offsetX = 11;
         offsetY = 3;
         itemWidth = 118;
         this._fighterDisplayVec = new Vector.<FighterDisplay>();
         i = 0;
         while(i < 6)
         {
            fighterDisplay = new FighterDisplay();
            fighterDisplay.x = offsetX + itemWidth * i;
            fighterDisplay.y = offsetY;
            fighterDisplay.addEventListener("click",this.onMouseClick);
            fighterDisplay.addEventListener("mouseOver",onMouseOver);
            fighterDisplay.addEventListener("mouseOut",onMouseOut);
            this._fighterDisplayVec.push(fighterDisplay);
            addChild(fighterDisplay);
            i = i + 1;
         }
         this._tip = new FighterTip();
      }
      
      public function initData(param1:Vector.<PetData>) : void
      {
         var _loc4_:int = 0;
         var _loc2_:FighterDisplay = null;
         var _loc3_:Number = Math.min(param1.length,6);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this._fighterDisplayVec[_loc4_];
            _loc2_.initData(param1[_loc4_]);
            if(!_loc2_.parent)
            {
               addChild(_loc2_);
            }
            _loc4_++;
         }
         _loc4_ = _loc3_;
         while(_loc4_ < 6)
         {
            _loc2_ = this._fighterDisplayVec[_loc4_];
            DisplayObjectUtil.removeFromParent(_loc2_);
            _loc4_++;
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:FighterDisplay = param1.currentTarget as FighterDisplay;
         dispatchEvent(OperateEvent.pet(_loc2_.pet().pid));
      }
   }
}

