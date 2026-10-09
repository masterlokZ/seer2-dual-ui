package com.taomee.seer2.app.component
{
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class Scroller extends Sprite
   {
      
      public static const START:String = "start";
      
      public static const MOVE:String = "move";
      
      public static const END:String = "end";
      
      private var _upArrow:SimpleButton;
      
      private var _downArrow:SimpleButton;
      
      private var _thumb:Sprite;
      
      private var _track:Sprite;
      
      private var _scrollRec:Rectangle;
      
      private var _pageSize:int;
      
      private var _stepSize:int;
      
      private var _maxScrollPosition:int;
      
      private var _scrollPosition:int;
      
      private var _continuousScrollDirection:int;
      
      private var _enabled:Boolean;
      
      private var _wheelObject:InteractiveObject;
      
      public function Scroller(param1:MovieClip)
      {
         super();
         this.extractAssets(param1);
         this.initialize();
      }
      
      private function extractAssets(param1:MovieClip) : void
      {
         this._track = param1["track"];
         addChild(this._track);
         this._upArrow = param1["arrowUp"];
         this.disableButton(this._upArrow);
         addChild(this._upArrow);
         this._downArrow = param1["arrowDown"];
         this.disableButton(this._downArrow);
         addChild(this._downArrow);
         this._thumb = param1["thumb"];
         this._thumb.visible = false;
         addChild(this._thumb);
      }
      
      private function disableButton(param1:SimpleButton) : void
      {
         param1.mouseEnabled = false;
         param1.enabled = false;
      }
      
      private function enableButton(param1:SimpleButton) : void
      {
         param1.mouseEnabled = true;
         param1.enabled = true;
      }
      
      private function initialize() : void
      {
         this.mouseEnabled = false;
         this._stepSize = 1;
         var _loc2_:int = this._upArrow.x;
         var _loc1_:int = this._upArrow.height;
         var _loc4_:int = this._track.width;
         var _loc3_:int = this._track.height - this._upArrow.height - this._downArrow.height - this._thumb.height;
         this._scrollRec = new Rectangle(_loc2_,_loc1_,0,_loc3_);
      }
      
      public function set maxScrollPosition(param1:int) : void
      {
         this._maxScrollPosition = param1;
         if(this._maxScrollPosition > this._pageSize)
         {
            if(this._enabled == false)
            {
               this.enableThumb();
               this.enableArrow();
               this.enableTrack();
               this._enabled = true;
            }
         }
         else if(this._enabled == true)
         {
            this.disableThumb();
            this.disableArrow();
            this.disableTrack();
            this._enabled = false;
         }
      }
      
      private function enableTrack() : void
      {
         this._track.addEventListener("mouseDown",this.onTrackDown);
      }
      
      private function disableTrack() : void
      {
         this._track.removeEventListener("mouseDown",this.onTrackDown);
      }
      
      private function onTrackDown(param1:MouseEvent) : void
      {
         this._track.stage.addEventListener("mouseUp",this.onTrackStageUp);
         if(this._track.mouseY > this._thumb.y)
         {
            this.startContinuousScroll(this._stepSize);
         }
         else
         {
            this.startContinuousScroll(-this._stepSize);
         }
         addEventListener("enterFrame",this.onCheckThumbPostion);
      }
      
      private function onCheckThumbPostion(param1:Event) : void
      {
         var _loc2_:Rectangle = this._thumb.getBounds(this);
         if(_loc2_.contains(this._track.mouseX,this._track.mouseY))
         {
            removeEventListener("enterFrame",this.onCheckThumbPostion);
            this._track.stage.removeEventListener("mouseUp",this.onTrackStageUp);
            this.endContinuousScroll();
         }
      }
      
      private function onTrackStageUp(param1:MouseEvent) : void
      {
         this._track.stage.removeEventListener("mouseUp",this.onTrackStageUp);
         this.endContinuousScroll();
      }
      
      private function enableThumb() : void
      {
         this._thumb.visible = true;
         this._thumb.y = this._scrollRec.y;
         this._thumb.addEventListener("mouseDown",this.onThumbMouseDown);
      }
      
      private function disableThumb() : void
      {
         this._thumb.visible = false;
         this._thumb.removeEventListener("mouseDown",this.onThumbMouseDown);
      }
      
      private function onThumbMouseDown(param1:MouseEvent) : void
      {
         this._thumb.startDrag(false,this._scrollRec);
         this.addThumbStageEventListener();
         this.dispatchScrollEvent("start");
      }
      
      private function addThumbStageEventListener() : void
      {
         this._thumb.stage.addEventListener("mouseMove",this.onThumbStageMouseMove);
         this._thumb.stage.addEventListener("mouseUp",this.onThumbStageMouseUp);
      }
      
      private function removeThumbStageEventListener() : void
      {
         this._thumb.stage.removeEventListener("mouseMove",this.onThumbStageMouseMove);
         this._thumb.stage.removeEventListener("mouseUp",this.onThumbStageMouseUp);
      }
      
      private function onThumbStageMouseMove(param1:MouseEvent) : void
      {
         this.updateScrollPostionToThumb();
      }
      
      private function updateScrollPostionToThumb() : void
      {
         var _loc2_:Number = (this._thumb.y - this._scrollRec.y) / this._scrollRec.height;
         var _loc1_:int = (this._maxScrollPosition - this._pageSize) * _loc2_;
         if(_loc1_ != this._scrollPosition)
         {
            this._scrollPosition = _loc1_;
            this.dispatchScrollEvent("move");
         }
      }
      
      private function onThumbStageMouseUp(param1:MouseEvent) : void
      {
         this._thumb.stopDrag();
         this.removeThumbStageEventListener();
         this.dispatchScrollEvent("end");
      }
      
      private function enableArrow() : void
      {
         this.enableButton(this._upArrow);
         this.enableButton(this._downArrow);
         this._upArrow.addEventListener("mouseDown",this.onUpArrowDown);
         this._downArrow.addEventListener("mouseDown",this.onDownArrowDown);
      }
      
      private function disableArrow() : void
      {
         this.disableButton(this._upArrow);
         this.disableButton(this._downArrow);
         this._upArrow.removeEventListener("mouseDown",this.onUpArrowDown);
         this._downArrow.removeEventListener("mouseDown",this.onDownArrowDown);
      }
      
      private function onUpArrowDown(param1:MouseEvent) : void
      {
         this._upArrow.stage.addEventListener("mouseUp",this.onUpArrowUp);
         this.startContinuousScroll(-this._stepSize);
      }
      
      private function onUpArrowUp(param1:MouseEvent) : void
      {
         this._upArrow.stage.removeEventListener("mouseUp",this.onUpArrowUp);
         this.endContinuousScroll();
      }
      
      private function onDownArrowDown(param1:MouseEvent) : void
      {
         this._downArrow.stage.addEventListener("mouseUp",this.onDownArrowUp);
         this.startContinuousScroll(this._stepSize);
      }
      
      private function onDownArrowUp(param1:MouseEvent) : void
      {
         this._downArrow.stage.removeEventListener("mouseUp",this.onDownArrowUp);
         this.endContinuousScroll();
      }
      
      private function startContinuousScroll(param1:int) : void
      {
         this.dispatchScrollEvent("start");
         this._continuousScrollDirection = param1;
         addEventListener("enterFrame",this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = this._scrollPosition + this._continuousScrollDirection;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this._maxScrollPosition - this._pageSize)
         {
            _loc2_ = this._maxScrollPosition - this._pageSize;
         }
         if(_loc2_ != this._scrollPosition)
         {
            this._scrollPosition = _loc2_;
            this.dispatchScrollEvent("move");
         }
         this.updateThumbPosition(this._scrollPosition);
      }
      
      private function endContinuousScroll() : void
      {
         removeEventListener("enterFrame",this.onEnterFrame);
         this.dispatchScrollEvent("end");
      }
      
      private function updateThumbPosition(param1:int) : void
      {
         var _loc2_:Number = param1 / (this._maxScrollPosition - this._pageSize);
         this._thumb.y = this._scrollRec.height * _loc2_ + this._scrollRec.y;
         if(this._thumb.y < this._scrollRec.y)
         {
            this._thumb.y = this._scrollRec.y;
         }
         if(this._thumb.y > this._scrollRec.bottom)
         {
            this._thumb.y = this._scrollRec.bottom;
         }
      }
      
      public function get maxScrollPosition() : int
      {
         return this._maxScrollPosition;
      }
      
      public function set scrollPosition(param1:int) : void
      {
         this._scrollPosition = param1;
         this.updateThumbPosition(this._scrollPosition);
      }
      
      public function get scrollPosition() : int
      {
         return this._scrollPosition;
      }
      
      public function set pageSize(param1:int) : void
      {
         this._pageSize = param1;
      }
      
      public function get pageSize() : int
      {
         return this._pageSize;
      }
      
      public function set stepSize(param1:int) : void
      {
         this._stepSize = param1;
      }
      
      public function get stepSize() : int
      {
         return this._stepSize;
      }
      
      public function set wheelObject(param1:InteractiveObject) : void
      {
         this._wheelObject = param1;
         if(this._wheelObject.mouseEnabled == true)
         {
            this._wheelObject.addEventListener("mouseWheel",this.onMouseWheel);
         }
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Number = this._thumb.y;
         _loc2_ -= param1.delta;
         if(_loc2_ <= this._scrollRec.y)
         {
            this._thumb.y = this._scrollRec.y;
         }
         else if(_loc2_ >= this._scrollRec.bottom)
         {
            this._thumb.y = this._scrollRec.bottom;
         }
         else
         {
            this._thumb.y = _loc2_;
         }
         this.dispatchScrollEvent("start");
         this.updateScrollPostionToThumb();
         this.dispatchScrollEvent("end");
      }
      
      public function get wheelObject() : InteractiveObject
      {
         return this._wheelObject;
      }
      
      private function dispatchScrollEvent(param1:String) : void
      {
         if(hasEventListener(param1))
         {
            dispatchEvent(new Event(param1));
         }
      }
      
      public function dispose() : void
      {
         if(this._wheelObject)
         {
            this._wheelObject.removeEventListener("mouseWheel",this.onMouseWheel);
            this._wheelObject = null;
         }
      }
   }
}

