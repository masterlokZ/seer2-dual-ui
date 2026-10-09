package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.dream.DreamManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.scene.LayerManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcessor_222 extends DreamMapProcessor
   {
      
      private var _totalContent:MovieClip;
      
      private var _selectPoint:Point;
      
      private var _puzzle:MovieClip;
      
      private var _puzzleList:Vector.<MovieClip>;
      
      private var _selectList:Vector.<MovieClip>;
      
      public function MapProcessor_222(param1:MapModel)
      {
         _taskId = 2;
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this._totalContent = _map.content["totalContent"];
         this._puzzleList = Vector.<MovieClip>([]);
         this._selectList = Vector.<MovieClip>([]);
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._puzzleList.push(this._totalContent["puzzle" + _loc1_]);
            this._selectList.push(this._totalContent["select" + _loc1_]);
            _loc1_++;
         }
         this.initEventListener();
      }
      
      private function initEventListener() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._puzzleList)
         {
            _loc1_.buttonMode = true;
            _loc1_.mouseChildren = true;
            _loc1_.mouseEnabled = true;
            _loc1_.addEventListener("click",this.onPuzzle);
         }
      }
      
      private function removeEventListener() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._puzzleList)
         {
            _loc1_.buttonMode = false;
            _loc1_.removeEventListener("click",this.onPuzzle);
         }
      }
      
      private function initSelectEventListener() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._selectList)
         {
            _loc1_.buttonMode = true;
            _loc1_.mouseChildren = true;
            _loc1_.mouseEnabled = true;
            _loc1_.addEventListener("click",this.onSelect);
         }
      }
      
      private function removeSelectEventListener() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._selectList)
         {
            _loc1_.buttonMode = false;
            _loc1_.removeEventListener("click",this.onSelect);
         }
      }
      
      private function onPuzzle(param1:MouseEvent) : void
      {
         this.removeEventListener();
         this.initSelectEventListener();
         this._puzzle = param1.currentTarget as MovieClip;
         this._puzzle.mouseChildren = false;
         this._puzzle.mouseEnabled = false;
         this._selectPoint = new Point(this._puzzle.x,this._puzzle.y);
         this._puzzle.x = LayerManager.stage.mouseX;
         this._puzzle.y = LayerManager.stage.mouseY;
         this._puzzle.addEventListener("enterFrame",this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this._puzzle.x = LayerManager.stage.mouseX - 508;
         this._puzzle.y = LayerManager.stage.mouseY - 346;
      }
      
      private function onSelect(param1:MouseEvent) : void
      {
         this.removeSelectEventListener();
         this._puzzle.removeEventListener("enterFrame",this.onEnterFrame);
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc4_:int = this._selectList.indexOf(_loc2_);
         var _loc3_:int = this._puzzleList.indexOf(this._puzzle);
         if(_loc4_ == _loc3_)
         {
            this._puzzle.x = _loc2_.x + this._puzzle.width / 2 - 3;
            this._puzzle.y = _loc2_.y + this._puzzle.height / 2 - 3;
            this._puzzleList.splice(_loc3_,1);
            this._selectList.splice(_loc4_,1);
         }
         else
         {
            this._puzzle.x = this._selectPoint.x;
            this._puzzle.y = this._selectPoint.y;
         }
         this._puzzle = null;
         this._selectPoint = null;
         this.initEventListener();
         if(this._puzzleList.length <= 0)
         {
            this.win();
         }
      }
      
      private function win() : void
      {
         DreamManager.currentTaskId = _taskId;
         this._totalContent.gotoAndStop(2);
         indicateLeaveDream();
      }
      
      override public function dispose() : void
      {
         this._selectPoint = null;
         if(this._puzzle)
         {
            this._puzzle.removeEventListener("enterFrame",this.onEnterFrame);
            this._puzzle = null;
         }
         this.removeEventListener();
         this._puzzleList = null;
         this.removeSelectEventListener();
         this._selectList = null;
         this._totalContent = null;
         super.dispose();
      }
   }
}

