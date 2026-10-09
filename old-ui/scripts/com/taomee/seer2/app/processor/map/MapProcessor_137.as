package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.dream.DreamManager;
   import com.taomee.seer2.core.map.MapModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcessor_137 extends DreamMapProcessor
   {
      
      private static const BOTTLE_COUNT:uint = 5;
      
      private var _drinkCount:uint;
      
      private var _bottleVec:Vector.<MovieClip>;
      
      private var _moveBottle:MovieClip;
      
      public function MapProcessor_137(param1:MapModel)
      {
         _taskId = 2;
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this._drinkCount = 0;
         this.initBottleVed();
      }
      
      override protected function onDreamerMouseOver(param1:MouseEvent) : void
      {
         if(_dreamer.currentFrameLabel == "enterMapEnd")
         {
            _dreamer.gotoAndPlay("enterMap");
         }
         else if(_dreamer.currentFrameLabel == "drinkEnd")
         {
            _dreamer.gotoAndPlay("drinking");
         }
         else if(_dreamer.currentFrameLabel == "drinkEnoughEnd")
         {
            _dreamer.gotoAndPlay("drinkEnough");
         }
      }
      
      private function initBottleVed() : void
      {
         var _loc1_:String = null;
         var _loc3_:MovieClip = null;
         this._bottleVec = new Vector.<MovieClip>();
         this._moveBottle = _map.content["moveBottle"];
         this._moveBottle.gotoAndStop(1);
         this._moveBottle.visible = false;
         closeInteractor(this._moveBottle);
         var _loc2_:uint = 1;
         while(_loc2_ <= 5)
         {
            _loc1_ = "bottle" + _loc2_.toString();
            _loc3_ = _map.content[_loc1_];
            this._bottleVec.push(_loc3_);
            _loc3_.addEventListener("click",this.onBottleClick);
            _loc2_++;
         }
         this.openAllBottle();
      }
      
      private function onBottleClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.visible = false;
         ++this._drinkCount;
         this._moveBottle.visible = true;
         this._moveBottle.gotoAndPlay(1);
         this._moveBottle.addEventListener("enterFrame",this.onMoveBottleEnterFrame);
         this.closeAllBottle();
      }
      
      private function onMoveBottleEnterFrame(param1:Event) : void
      {
         if(this._moveBottle.currentFrame == this._moveBottle.totalFrames)
         {
            this._moveBottle.removeEventListener("enterFrame",this.onMoveBottleEnterFrame);
            this._moveBottle.gotoAndStop(1);
            this._moveBottle.visible = false;
            if(this._drinkCount == 5)
            {
               DreamManager.currentTaskId = _taskId;
               _dreamer.gotoAndPlay("drinkEnough");
               indicateLeaveDream();
            }
            else
            {
               _dreamer.gotoAndPlay("drinking");
            }
            this.openAllBottle();
         }
      }
      
      private function closeAllBottle() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._bottleVec.length)
         {
            closeInteractor(this._bottleVec[_loc1_]);
            _loc1_++;
         }
      }
      
      private function openAllBottle() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._bottleVec.length)
         {
            initInteractor(this._bottleVec[_loc1_]);
            _loc1_++;
         }
      }
      
      private function clearEventListener() : void
      {
         this._moveBottle.removeEventListener("enterFrame",this.onMoveBottleEnterFrame);
         var _loc1_:int = 0;
         while(_loc1_ < this._bottleVec.length)
         {
            this._bottleVec[_loc1_].removeEventListener("click",this.onBottleClick);
            this._bottleVec[_loc1_] = null;
            _loc1_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.clearEventListener();
         this._bottleVec = null;
      }
   }
}

