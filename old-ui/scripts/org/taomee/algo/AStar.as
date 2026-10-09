package org.taomee.algo
{
   import flash.geom.Point;
   
   public class AStar
   {
      
      private static const COST_STRAIGHT:int = 10;
      
      private static var _instance:AStar;
      
      private static const COST_DIAGONAL:int = 14;
      
      public static const arounds:Array = [new Point(1,0),new Point(0,1),new Point(-1,0),new Point(0,-1),new Point(1,1),new Point(-1,1),new Point(-1,-1),new Point(1,-1)];
      
      private var _fatherList:Array;
      
      private const NOTE_OPEN:int = 1;
      
      private const NOTE_ID:int = 0;
      
      private var _noteMap:Array;
      
      private var _mapModel:IMapModel;
      
      private var _isOptimize:Boolean = true;
      
      private const NOTE_CLOSED:int = 2;
      
      private var _openId:int;
      
      private var _nodeList:Array;
      
      private var _openCount:int;
      
      private var _openList:Array;
      
      private var _pathScoreList:Array;
      
      public var maxTry:int = 1000;
      
      private var _movementCostList:Array;
      
      public function AStar()
      {
         super();
      }
      
      public static function get instance() : AStar
      {
         if(_instance == null)
         {
            _instance = new AStar();
         }
         return _instance;
      }
      
      public function find(param1:Point, param2:Point, param3:Boolean = true) : Array
      {
         var _loc8_:int = 0;
         var _loc7_:Point = null;
         var _loc4_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Point = null;
         if(_mapModel == null)
         {
            return null;
         }
         var _loc9_:Point = transPoint(param1.clone());
         var _loc6_:Point = transPoint(param2.clone());
         if(!isArrive(_loc6_))
         {
            return null;
         }
         _isOptimize = param3;
         initLists();
         _openCount = 0;
         _openId = -1;
         openNote(_loc9_,0,0,0);
         for(var _loc5_:int = 0; _openCount > 0; )
         {
            if(++_loc5_ > maxTry)
            {
               destroyLists();
               return null;
            }
            _loc8_ = int(_openList[0]);
            closeNote(_loc8_);
            _loc7_ = _nodeList[_loc8_];
            if(_loc6_.equals(_loc7_))
            {
               return getPath(_loc9_,_loc8_);
            }
            _loc10_ = getArounds(_loc7_);
            for each(_loc11_ in _loc10_)
            {
               _loc12_ = _movementCostList[_loc8_] + (_loc11_.x == _loc7_.x || _loc11_.y == _loc7_.y ? 10 : 14);
               _loc13_ = _loc12_ + (Math.abs(_loc6_.x - _loc11_.x) + Math.abs(_loc6_.y - _loc11_.y)) * 10;
               if(isOpen(_loc11_))
               {
                  _loc4_ = int(_noteMap[_loc11_.y][_loc11_.x][0]);
                  if(_loc12_ < _movementCostList[_loc4_])
                  {
                     _movementCostList[_loc4_] = _loc12_;
                     _pathScoreList[_loc4_] = _loc13_;
                     _fatherList[_loc4_] = _loc8_;
                     aheadNote(_openList.indexOf(_loc4_) + 1);
                  }
               }
               else
               {
                  openNote(_loc11_,_loc13_,_loc12_,_loc8_);
               }
            }
         }
         destroyLists();
         return null;
      }
      
      private function isOpen(param1:Point) : Boolean
      {
         if(_noteMap[param1.y] == null)
         {
            return false;
         }
         if(_noteMap[param1.y][param1.x] == null)
         {
            return false;
         }
         return _noteMap[param1.y][param1.x][1];
      }
      
      public function init(param1:IMapModel) : void
      {
         _mapModel = param1;
      }
      
      private function aheadNote(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(param1 > 1)
         {
            _loc2_ = param1 / 2;
            if(getScore(param1) >= getScore(_loc2_))
            {
               break;
            }
            _loc3_ = int(_openList[param1 - 1]);
            _openList[param1 - 1] = _openList[_loc2_ - 1];
            _openList[_loc2_ - 1] = _loc3_;
            param1 = _loc2_;
         }
      }
      
      private function openNote(param1:Point, param2:int, param3:int, param4:int) : void
      {
         ++_openCount;
         ++_openId;
         if(_noteMap[param1.y] == null)
         {
            _noteMap[param1.y] = [];
         }
         _noteMap[param1.y][param1.x] = [];
         _noteMap[param1.y][param1.x][1] = true;
         _noteMap[param1.y][param1.x][0] = _openId;
         _nodeList.push(param1);
         _pathScoreList.push(param2);
         _movementCostList.push(param3);
         _fatherList.push(param4);
         _openList.push(_openId);
         aheadNote(_openCount);
      }
      
      private function optimize(param1:Array, param2:int = 0) : void
      {
         var _loc6_:Point = null;
         var _loc4_:int = 0;
         var _loc9_:Number = NaN;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         var _loc5_:Point = null;
         if(param1 == null)
         {
            return;
         }
         var _loc12_:int = param1.length - 1;
         if(_loc12_ < 2)
         {
            return;
         }
         var _loc11_:Point = param1[param2];
         var _loc8_:Array = [];
         var _loc3_:int = _loc12_;
         while(_loc3_ > param2)
         {
            _loc6_ = param1[_loc3_];
            _loc4_ = Point.distance(_loc11_,_loc6_);
            _loc9_ = Math.atan2(_loc6_.y - _loc11_.y,_loc6_.x - _loc11_.x);
            _loc7_ = 1;
            while(_loc7_ < _loc4_)
            {
               var _temp_2:* = _loc11_.add(Point.polar(_loc7_,_loc9_));
               _temp_2.x = int((_loc5_ = _temp_2).x);
               _loc5_.y = int(_loc5_.y);
               if(!_mapModel.data[_loc5_.x][_loc5_.y])
               {
                  _loc8_.length = 0;
                  break;
               }
               _loc8_.push(_loc5_);
               _loc7_++;
            }
            _loc10_ = int(_loc8_.length);
            if(_loc10_ > 0)
            {
               param1.splice(param2 + 1,_loc3_ - param2 - 1);
               param2 += _loc10_ - 1;
               break;
            }
            _loc3_--;
         }
         if(param2 < _loc12_)
         {
            optimize(param1,++param2);
         }
      }
      
      private function transPoint(param1:Point) : Point
      {
         param1.x /= _mapModel.gridSize;
         param1.y /= _mapModel.gridSize;
         return param1;
      }
      
      private function isArrive(param1:Point) : Boolean
      {
         if(param1.x < 0 || param1.x >= _mapModel.gridX || param1.y < 0 || param1.y >= _mapModel.gridY)
         {
            return false;
         }
         return _mapModel.data[param1.x][param1.y];
      }
      
      private function closeNote(param1:int) : void
      {
         --_openCount;
         var _loc2_:Point = _nodeList[param1];
         _noteMap[_loc2_.y][_loc2_.x][1] = false;
         _noteMap[_loc2_.y][_loc2_.x][2] = true;
         if(_openCount <= 0)
         {
            _openCount = 0;
            _openList.length = 0;
            return;
         }
         _openList[0] = _openList.pop();
         backNote();
      }
      
      private function getScore(param1:int) : int
      {
         return _pathScoreList[_openList[param1 - 1]];
      }
      
      private function getArounds(param1:Point) : Array
      {
         var _loc3_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc9_:Point = null;
         var _loc8_:Boolean = false;
         var _loc7_:Array = [];
         var _loc4_:int = 0;
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc3_ = isArrive(_loc9_);
         if(_loc3_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc6_ = isArrive(_loc9_);
         if(_loc6_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc5_ = isArrive(_loc9_);
         if(_loc5_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc2_ = isArrive(_loc9_);
         if(_loc2_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc8_ = isArrive(_loc9_);
         if(_loc8_ && _loc3_ && _loc6_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc8_ = isArrive(_loc9_);
         if(_loc8_ && _loc5_ && _loc6_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc8_ = isArrive(_loc9_);
         if(_loc8_ && _loc5_ && _loc2_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         _loc9_ = param1.add(arounds[_loc4_]);
         _loc4_++;
         _loc8_ = isArrive(_loc9_);
         if(_loc8_ && _loc3_ && _loc2_ && !isClosed(_loc9_))
         {
            _loc7_.push(_loc9_);
         }
         return _loc7_;
      }
      
      private function getPath(param1:Point, param2:int) : Array
      {
         var _loc4_:Array = [];
         var _loc3_:Point = _nodeList[param2];
         while(!param1.equals(_loc3_))
         {
            _loc4_.push(_loc3_);
            param2 = int(_fatherList[param2]);
            _loc3_ = _nodeList[param2];
         }
         _loc4_.push(param1);
         destroyLists();
         _loc4_.reverse();
         if(_isOptimize)
         {
            optimize(_loc4_);
         }
         _loc4_.forEach(eachArray);
         return _loc4_;
      }
      
      private function eachArray(param1:Point, param2:int, param3:Array) : void
      {
         param1.x *= _mapModel.gridSize;
         param1.y *= _mapModel.gridSize;
      }
      
      private function initLists() : void
      {
         _openList = [];
         _nodeList = [];
         _pathScoreList = [];
         _movementCostList = [];
         _fatherList = [];
         _noteMap = [];
      }
      
      private function isClosed(param1:Point) : Boolean
      {
         if(_noteMap[param1.y] == null)
         {
            return false;
         }
         if(_noteMap[param1.y][param1.x] == null)
         {
            return false;
         }
         return _noteMap[param1.y][param1.x][2];
      }
      
      private function destroyLists() : void
      {
         _openList = null;
         _nodeList = null;
         _pathScoreList = null;
         _movementCostList = null;
         _fatherList = null;
         _noteMap = null;
      }
      
      private function backNote() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:int = 1;
         while(true)
         {
            _loc1_ = _loc2_;
            if(2 * _loc1_ <= _openCount)
            {
               if(getScore(_loc2_) > getScore(2 * _loc1_))
               {
                  _loc2_ = 2 * _loc1_;
               }
               if(2 * _loc1_ + 1 <= _openCount)
               {
                  if(getScore(_loc2_) > getScore(2 * _loc1_ + 1))
                  {
                     _loc2_ = 2 * _loc1_ + 1;
                  }
               }
            }
            if(_loc1_ == _loc2_)
            {
               break;
            }
            _loc3_ = int(_openList[_loc1_ - 1]);
            _openList[_loc1_ - 1] = _openList[_loc2_ - 1];
            _openList[_loc2_ - 1] = _loc3_;
         }
      }
   }
}

