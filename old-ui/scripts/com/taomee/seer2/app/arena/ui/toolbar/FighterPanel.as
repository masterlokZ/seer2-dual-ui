package com.taomee.seer2.app.arena.ui.toolbar
{
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.data.FighterInfo;
   import com.taomee.seer2.app.arena.data.FighterTeam;
   import com.taomee.seer2.app.arena.events.OperateEvent;
   import com.taomee.seer2.app.arena.ui.toolbar.sub.FighterDisplay;
   import com.taomee.seer2.app.arena.ui.toolbar.sub.FighterTip;
   import com.taomee.seer2.app.popup.ServerMessager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FighterPanel extends Sprite
   {
      
      private static const MAX_NUM_FINGHTER:int = 6;
      
      private var _fighterTeam:FighterTeam;
      
      private var _fighterDisplayVec:Vector.<FighterDisplay>;
      
      private var _tip:FighterTip;
      
      private var _itemId:uint = 0;
      
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
            var _loc3_:FighterInfo = null;
            var _loc2_:FighterDisplay = param1.currentTarget as FighterDisplay;
            _loc3_ = _loc2_.getFighter().fighterInfo;
            _tip.x = _loc2_.x + 15;
            _tip.y = _loc2_.y;
            _tip.setFighterInfo(_loc3_);
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
         offsetX = 90;
         offsetY = 52;
         itemWidth = 116;
         this._fighterDisplayVec = new Vector.<FighterDisplay>();
         for(i = 0; i < 6; )
         {
            fighterDisplay = new FighterDisplay();
            fighterDisplay.x = offsetX + itemWidth * i;
            fighterDisplay.y = offsetY;
            fighterDisplay.addEventListener("click",this.onMouseClick);
            fighterDisplay.addEventListener("mouseOver",onMouseOver);
            fighterDisplay.addEventListener("mouseOut",onMouseOut);
            this._fighterDisplayVec.push(fighterDisplay);
            addChild(fighterDisplay);
            i++;
         }
         this._tip = new FighterTip();
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:OperateEvent = null;
         var _loc3_:FighterDisplay = param1.currentTarget as FighterDisplay;
         var _loc5_:FighterInfo = _loc3_.getFighter().fighterInfo;
         if(_loc5_.position != 0)
         {
            return;
         }
         var _loc4_:uint = _loc5_.catchTime;
         if(this._itemId == 0)
         {
            dispatchEvent(new OperateEvent(4,_loc4_,"operateEnd"));
         }
         else if(_loc5_.hp <= 0)
         {
            _loc2_ = new OperateEvent(6,this._itemId,"operateEnd");
            _loc2_.fighterId = _loc4_;
            dispatchEvent(_loc2_);
            this.updatePet(_loc5_);
            dispatchEvent(new OperateEvent(6,_loc4_,"fightSelectSkill"));
         }
         else
         {
            ServerMessager.addMessage("这只精灵不需要复活");
         }
      }
      
      private function updatePet(param1:FighterInfo) : void
      {
         if(this._itemId == 200064 || this._itemId == 201021)
         {
            param1.changeHp(param1.maxHp);
         }
         else
         {
            param1.changeHp(uint(param1.maxHp / 2));
         }
         this._itemId = 0;
         ServerMessager.addMessage("成功的复活了" + param1.name);
      }
      
      public function setFighterTeam(param1:FighterTeam, param2:uint = 0) : void
      {
         var _loc5_:Fighter = null;
         this._itemId = param2;
         this._fighterTeam = param1;
         this.disposeFighterDisplay();
         var _loc7_:Vector.<Fighter> = this._fighterTeam.fighterVec;
         var _loc6_:int = int(_loc7_.length);
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc5_ = _loc7_[_loc3_];
            if(_loc5_.isFit == false)
            {
               this._fighterDisplayVec[_loc4_].setFighter(_loc5_);
               if(this._itemId != 0)
               {
                  this._fighterDisplayVec[_loc4_].isCloseMouse(false);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function updatePetPress(param1:uint) : void
      {
         var _loc2_:Fighter = null;
         var _loc4_:Vector.<Fighter> = this._fighterTeam.fighterVec;
         var _loc6_:int = int(_loc4_.length);
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc2_ = _loc4_[_loc3_];
            if(_loc2_.isFit == false)
            {
               this._fighterDisplayVec[_loc5_].updatePressStatus(param1);
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      public function update() : void
      {
         var _loc1_:FighterDisplay = null;
         for each(_loc1_ in this._fighterDisplayVec)
         {
            _loc1_.update();
         }
      }
      
      private function disposeFighterDisplay() : void
      {
         var _loc1_:FighterDisplay = null;
         for each(_loc1_ in this._fighterDisplayVec)
         {
            _loc1_.clear();
         }
      }
      
      public function dispose() : void
      {
         this.disposeFighterDisplay();
         this._fighterTeam = null;
         this._fighterDisplayVec = null;
         this._tip = null;
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

