package com.taomee.seer2.app.arena.vibration
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Expo;
   import com.taomee.seer2.core.scene.LayerManager;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class HorizontalDrifting
   {
      
      private static const MOVE_DISTANCE:int = 120;
      
      private var _target:DisplayObject;
      
      private var _targetBoundary:Rectangle;
      
      private var _direction:int = 0;
      
      public function HorizontalDrifting()
      {
         super();
      }
      
      public function drift(param1:int, param2:DisplayObject) : void
      {
         var _loc3_:int = 0;
         this._direction = param1;
         this._target = param2;
         this._targetBoundary = this._target.getBounds(this._target.parent);
         var _loc4_:int = 0;
         if(param1 == -1)
         {
            _loc4_ = this._targetBoundary.left - 120;
            _loc3_ = LayerManager.root.width - this._target.width;
            if(_loc4_ < _loc3_)
            {
               _loc4_ = _loc3_;
            }
         }
         else if(param1 == 1)
         {
            _loc4_ = this._targetBoundary.right + 120 - this._target.width;
            _loc4_ = int(_loc4_ > 0 ? 0 : _loc4_);
         }
         TweenLite.to(this._target,1.5,{
            "x":_loc4_,
            "ease":Expo.easeOut,
            "onUpdate":this.updatePosition,
            "onComplete":this.dispose
         });
      }
      
      private function updatePosition() : void
      {
         var _loc1_:int = 0;
         if(this._direction == -1)
         {
            _loc1_ = LayerManager.root.width - this._target.width;
            if(this._target.x < _loc1_)
            {
               this._target.x = _loc1_;
            }
         }
         else if(this._direction == 1)
         {
            this._target.x = this._target.x > 0 ? 0 : this._target.x;
         }
      }
      
      public function dispose() : void
      {
         TweenLite.killTweensOf(this);
         this._target = null;
         this._targetBoundary = null;
         this._direction = 0;
      }
   }
}

