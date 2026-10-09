package com.taomee.seer2.app.animationInteractive
{
   import com.taomee.seer2.core.scene.LayerManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PuzzlePictureAnimation extends BaseAniamationInteractive
   {
      
      private const BLOCK_NUM:int = 8;
      
      private var _container:MovieClip;
      
      private var _blockVec:Vector.<MovieClip>;
      
      private var _successCnt:int;
      
      private var _mouseBlock:MovieClip;
      
      private var _currentIndex:int;
      
      private const GRID_NUM:int = 8;
      
      private const GRID_SIZE:int = 17;
      
      private const GRID_START:Point = new Point(436,193);
      
      public function PuzzlePictureAnimation()
      {
         super();
      }
      
      override protected function paramAnimation() : void
      {
         var _loc1_:MovieClip = null;
         this._successCnt = 0;
         this._currentIndex = -1;
         this._container = _animation["container"];
         this._container.gotoAndStop(1);
         _animation.addEventListener("click",this.onContainerClick);
         this._mouseBlock = _animation["mouseBlock"];
         this._mouseBlock.addEventListener("enterFrame",this.onEnterBlock);
         this._mouseBlock.visible = false;
         this._mouseBlock.mouseEnabled = false;
         this._mouseBlock.mouseChildren = false;
         this._blockVec = new Vector.<MovieClip>();
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            _loc1_ = _animation["block_" + _loc2_];
            _loc1_.gotoAndStop(1);
            this._blockVec.push(_loc1_);
            _loc2_++;
         }
         this.openBlockListener();
      }
      
      private function openBlockListener() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            _loc1_ = this._blockVec[_loc2_];
            _loc1_.buttonMode = true;
            _loc1_.addEventListener("mouseDown",this.onBlockDown);
            _loc2_++;
         }
      }
      
      private function closeBlockListener() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            _loc1_ = this._blockVec[_loc2_];
            _loc1_.buttonMode = false;
            _loc1_.removeEventListener("mouseDown",this.onBlockDown);
            _loc2_++;
         }
      }
      
      private function onBlockDown(param1:MouseEvent) : void
      {
         if(this._currentIndex != -1)
         {
            return;
         }
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.visible = false;
         var _loc3_:String = _loc2_.name;
         this._currentIndex = int(_loc3_.substr(_loc3_.length - 1,1));
         this._mouseBlock.visible = true;
         this._mouseBlock.gotoAndStop(this._currentIndex + 1);
      }
      
      private function onContainerClick(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         if(this._currentIndex == -1)
         {
            return;
         }
         var _loc3_:MovieClip = this._blockVec[this._currentIndex];
         var _loc5_:Point = new Point(this._mouseBlock.x - this._mouseBlock.width / 2,this._mouseBlock.y - this._mouseBlock.height / 2);
         if(_loc5_.x > this.GRID_START.x + 17 * 8 + 17 || _loc5_.x < this.GRID_START.x - 17 || _loc5_.y > this.GRID_START.y + 17 * 8 + 17 || _loc5_.y < this.GRID_START.y - 17)
         {
            _loc3_.x = _loc5_.x;
            _loc3_.y = _loc5_.y;
         }
         else
         {
            _loc4_ = Math.round((_loc5_.x - this.GRID_START.x) / 17);
            _loc2_ = Math.round((_loc5_.y - this.GRID_START.y) / 17);
            _loc3_.x = this.GRID_START.x + _loc4_ * 17;
            _loc3_.y = this.GRID_START.y + _loc2_ * 17;
            this.isPuzzleOver();
         }
         _loc3_.visible = true;
         this._mouseBlock.visible = false;
         this._currentIndex = -1;
      }
      
      private function isPuzzleOver() : void
      {
         if(this._blockVec[0].y != this._blockVec[1].y || this._blockVec[1].y != this._blockVec[3].y || this._blockVec[0].y != this._blockVec[3].y)
         {
            return;
         }
         var _loc1_:int = this._blockVec[0].x + this._blockVec[3].x + this._blockVec[1].x;
         if(this._blockVec[3].x - this._blockVec[0].x != 34 || _loc1_ != 1427 && _loc1_ != 1444)
         {
            return;
         }
         if(this._blockVec[5].y != this._blockVec[6].y || this._blockVec[5].y != this._blockVec[2].y || this._blockVec[6].y != this._blockVec[2].y)
         {
            return;
         }
         if(this._blockVec[5].x != 436 || this._blockVec[6].x != 453 || this._blockVec[2].x != 504 || this._blockVec[4].x != 436 || this._blockVec[7].x != 436)
         {
            return;
         }
         if(this._blockVec[7].y - this._blockVec[4].y != 17 || this._blockVec[4].y - this._blockVec[5].y != 51)
         {
            return;
         }
         if(this._blockVec[2].y == 244 && this._blockVec[3].y != 193)
         {
            return;
         }
         if(this._blockVec[2].y == 193 && this._blockVec[3].y != 278)
         {
            return;
         }
         dispatchEvent(new Event("puzzlePicture"));
         this.dispose();
      }
      
      private function onEnterBlock(param1:Event) : void
      {
         this._mouseBlock.x = LayerManager.topLayer.mouseX;
         this._mouseBlock.y = LayerManager.topLayer.mouseY;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.closeEventListener();
      }
      
      private function closeEventListener() : void
      {
         this.closeBlockListener();
         this._mouseBlock.removeEventListener("enterFrame",this.onEnterBlock);
         _animation.removeEventListener("click",this.onContainerClick);
      }
   }
}

