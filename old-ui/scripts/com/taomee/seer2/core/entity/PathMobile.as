package com.taomee.seer2.core.entity
{
   import com.taomee.seer2.core.entity.events.MoveEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import flash.geom.Point;
   import org.taomee.algo.AStar;
   import org.taomee.utils.GeomUtil;
   
   public class PathMobile extends Mobile
   {
      
      public static const CLOSE_DISTANCE:uint = 20;
      
      public var walkSpeed:uint = 5;
      
      public var runSpeed:uint = 7;
      
      private var _speed:int;
      
      private var _path:Vector.<Point>;
      
      private var _isMoving:Boolean;
      
      private var _targetPos:Point;
      
      private var _currentPos:Point;
      
      private var _stepStartPos:Point;
      
      private var _stepEndPos:Point;
      
      private var _stepIndex:uint;
      
      private var _stepDisX:Number;
      
      private var _stepDisY:Number;
      
      private var _isBigMap:Boolean = false;
      
      public function PathMobile()
      {
         super();
         this._speed = this.walkSpeed;
      }
      
      public function set speed(param1:int) : void
      {
         this._speed = param1;
      }
      
      public function get speed() : int
      {
         return this._speed;
      }
      
      public function setPath(param1:Vector.<Point>) : void
      {
         this._path = param1;
         this.polishPath();
      }
      
      private function polishPath() : void
      {
         var _loc5_:Point = null;
         var _loc2_:Point = null;
         var _loc1_:Number = NaN;
         var _loc4_:int = this._speed * this._speed;
         var _loc3_:int = int(this._path.length);
         var _loc6_:int = 1;
         while(_loc6_ < _loc3_ - 1)
         {
            _loc5_ = this._path[_loc6_];
            _loc2_ = this._path[_loc6_ - 1];
            _loc1_ = Point.distance(_loc2_,_loc5_);
            if(_loc1_ < _loc4_)
            {
               this._path.splice(_loc6_,1);
               _loc6_--;
               _loc3_--;
            }
            _loc6_++;
         }
      }
      
      public function getPath() : Vector.<Point>
      {
         return this._path;
      }
      
      public function stand() : void
      {
         this._isMoving = false;
         this.updateMoveStyle("stand");
      }
      
      public function walkToLocation(param1:Number, param2:Number) : void
      {
         this.speed = this.walkSpeed;
         if(this.calculatePath(param1,param2) == true)
         {
            this._targetPos = new Point(param1,param2);
            this.startMove("walk");
         }
      }
      
      public function runToLocation(param1:Number, param2:Number) : void
      {
         this.speed = this.runSpeed;
         if(this.calculatePath(param1,param2) == true)
         {
            this._targetPos = new Point(param1,param2);
            this.startMove("run");
         }
      }
      
      public function runInBigMapToLocation(param1:Array, param2:Number, param3:Number) : void
      {
         this._isBigMap = true;
         this.speed = this.runSpeed;
         this._path = Vector.<Point>(param1);
         this._targetPos = new Point(param2,param3);
         this.startMove("run");
      }
      
      protected function calculatePath(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Array = null;
         var _loc5_:Point = new Point(this.x,this.y);
         var _loc4_:Point = new Point(param1,param2);
         _loc3_ = AStar.instance.find(_loc5_,_loc4_);
         if(_loc3_ != null)
         {
            this._path = Vector.<Point>(_loc3_);
            this.polishPath();
            return true;
         }
         return false;
      }
      
      public function getTargetPoint() : Point
      {
         return this._targetPos;
      }
      
      protected function startMove(param1:String) : void
      {
         if(this.isPathExist() == true)
         {
            this._stepIndex = 0;
            this._stepStartPos = this._path[this._stepIndex];
            this._currentPos = this._stepStartPos.clone();
            this._stepEndPos = this._path[++this._stepIndex];
            this.updateDirection();
            this.updateMoveStyle(param1);
            this._isMoving = true;
            this.dispathMoveEvent("start");
         }
      }
      
      protected function isPathExist() : Boolean
      {
         return Boolean(this._path) && this._path.length > 1;
      }
      
      private function dispathMoveEvent(param1:String) : void
      {
         if(hasEventListener(param1) == true)
         {
            dispatchEvent(new MoveEvent(param1));
         }
      }
      
      override public function update() : void
      {
         this.updatePostion();
         super.update();
      }
      
      protected function updatePostion() : void
      {
         var _loc2_:Point = null;
         var _loc1_:MoveEvent = null;
         if(this._isMoving)
         {
            if(Point.distance(this._currentPos,this._stepEndPos) < this._speed)
            {
               this._stepStartPos = this._stepEndPos;
               this._currentPos.x = this._stepStartPos.x;
               this._currentPos.y = this._stepStartPos.y;
               this.getNextEndPos();
            }
            else
            {
               _loc2_ = GeomUtil.angleSpeed(this._stepStartPos,this._stepEndPos);
               this._stepDisX = _loc2_.x * this._speed;
               this._stepDisY = _loc2_.y * this._speed;
               this._currentPos.x -= this._stepDisX;
               this._currentPos.y -= this._stepDisY;
            }
            this.x = this._currentPos.x;
            this.y = this._currentPos.y;
            _loc1_ = new MoveEvent("move");
            _loc1_.param = _loc2_;
            if(hasEventListener("move") == true)
            {
               dispatchEvent(_loc1_);
            }
            LayerManager.layout();
         }
      }
      
      protected function updateDirection() : void
      {
         this.updateHorizontalDirection();
         this.updateVerticalDirection();
      }
      
      protected function updateHorizontalDirection() : void
      {
         if(this._stepStartPos.x <= this._stepEndPos.x)
         {
            this.direction |= 1;
         }
         else
         {
            this.direction &= 2;
         }
      }
      
      protected function updateVerticalDirection() : void
      {
         var _loc1_:uint = uint(this.direction);
         if(this._stepStartPos.y > this._stepEndPos.y)
         {
            this.direction |= 2;
         }
         else
         {
            this.direction &= 1;
         }
      }
      
      protected function updateMoveStyle(param1:String) : void
      {
         this.moveStyle = param1;
      }
      
      protected function getNextEndPos() : void
      {
         if(this._stepIndex >= this._path.length - 1)
         {
            this.x = this._targetPos.x;
            this.y = this._targetPos.y;
            this.stopMove();
         }
         else
         {
            this._stepEndPos = this._path[++this._stepIndex];
            this.updateDirection();
         }
      }
      
      protected function stopMove() : void
      {
         this._isMoving = false;
         this._isBigMap = false;
         this.updateMoveStyle("stand");
         this.dispathMoveEvent("finished");
      }
      
      public function isArrivedPosition(param1:Point) : Boolean
      {
         var _loc2_:int = Math.abs(this.x - param1.x);
         var _loc3_:int = Math.abs(this.y - param1.y);
         return _loc2_ < 20 && _loc3_ < 20;
      }
   }
}

