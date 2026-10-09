package com.taomee.seer2.core.map.grids
{
   import com.taomee.seer2.core.entity.PathMobile;
   import com.taomee.seer2.core.scene.BaseMapLoader;
   import com.taomee.seer2.core.scene.LayerManager;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class GameMap extends BaseDisplayObject
   {
      
      public var playerList:Array = [];
      
      private var _player:HeptaFishCharacter;
      
      private var _mapWidth:Number;
      
      private var _mapHeight:Number;
      
      private var _cellWidth:Number;
      
      private var _cellHeight:Number;
      
      private var _itemArr:Array;
      
      private var _mapArr:Array;
      
      private var _mapDArr:Array;
      
      private var _mapXML:XML;
      
      private var _row:int;
      
      private var _col:int;
      
      private var _pathIndex:int;
      
      private var _mapLayer:MapLayer;
      
      private var _buildLayer:BuildingLayer;
      
      private var _gridLayer:GridLayer;
      
      private var _roadPointLayer:RoadPointLayer;
      
      private var _initPlayerPoint:Point;
      
      private var _roadSeeker:RoadSeeker;
      
      private var _roadArr:Array;
      
      private var _roadMap:HashMap = new HashMap();
      
      private var _app:Sprite;
      
      private var _bitmapData:BitmapData;
      
      private var _targetPoint:Point;
      
      private var _curtPoint:Point;
      
      public function GameMap(param1:BaseMapLoader, param2:Point = null)
      {
         super();
         this._app = LayerManager.root;
         this._mapXML = param1.dataXml;
         this._bitmapData = param1.mapBitmapData;
         this.name = this._mapXML.@name;
         this._initPlayerPoint = param2 || new Point(30,80);
         this._mapWidth = this._mapXML.@mapwidth;
         this._mapHeight = this._mapXML.@mapheight;
         this._cellWidth = this._mapXML.floor.@tileWidth;
         this._cellHeight = this._mapXML.floor.@tileHeight;
         this._mapArr = GameMapUtils.getArrByStr(this._mapXML.floor,this._mapXML.floor.@col,this._mapXML.floor.@row);
         this._row = this._mapArr.length;
         this._col = this._mapArr[0].length;
         this._mapDArr = GameMapUtils.getDArrayByArr(this._mapArr,this._row,this._col,this._roadMap);
         this._roadSeeker = new RoadSeeker(this._mapDArr,this._cellWidth,this._cellHeight * 2);
      }
      
      public function initMap() : void
      {
         this._mapLayer = new MapLayer(this);
         this._buildLayer = new BuildingLayer(this);
         this._buildLayer.mouseEnabled = false;
         this._buildLayer.mouseChildren = false;
         this._mapLayer.initMapLayer(this._bitmapData);
         this._buildLayer.drawByXml(this._mapXML);
         this.sortBuild();
      }
      
      private function sortBuild() : void
      {
         var _loc1_:GameMapItem = null;
         var _loc4_:int = 0;
         var _loc3_:GameMapItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._buildLayer.buildingArray.length)
         {
            _loc1_ = this._buildLayer.buildingArray[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < this._buildLayer.buildingArray.length)
            {
               _loc3_ = this._buildLayer.buildingArray[_loc4_];
               if(_loc1_.y > _loc3_.y)
               {
                  if(this._buildLayer.getChildIndex(_loc1_ as DisplayObject) < this._buildLayer.getChildIndex(_loc3_ as DisplayObject))
                  {
                     this._buildLayer.swapChildren(_loc1_,_loc3_);
                  }
               }
               else if(this._buildLayer.getChildIndex(_loc1_ as DisplayObject) > this._buildLayer.getChildIndex(_loc3_ as DisplayObject))
               {
                  this._buildLayer.swapChildren(_loc1_,_loc3_);
               }
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      public function setControlPlayer(param1:int = 0) : void
      {
         if(this.playerList.length > 0)
         {
            this._player = this.playerList[param1];
            this._player.mapEle = this;
            this._player.x = this._initPlayerPoint.x;
            this._player.y = this._initPlayerPoint.y;
         }
      }
      
      public function addPlayer(param1:HeptaFishCharacter) : void
      {
         this.playerList.push(param1);
         param1.mapEle = this;
         param1.x = this._initPlayerPoint.x;
         param1.y = this._initPlayerPoint.y;
         this._buildLayer.addChild(param1 as DisplayObject);
      }
      
      private function mapLayerLoaded(param1:Event) : void
      {
      }
      
      public function walk(param1:PathMobile, param2:Point, param3:Point) : void
      {
         var _loc9_:Point = null;
         var _loc8_:Point = null;
         var _loc12_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc16_:Point = null;
         var _loc17_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         this._curtPoint = param2;
         this._targetPoint = param3;
         _loc9_ = GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param3.x,param3.y,this._row);
         var _loc6_:int = _loc9_.x;
         var _loc5_:int = _loc9_.y;
         _loc8_ = GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x,param1.y - this._cellHeight,this._row);
         var _loc7_:int = _loc8_.x;
         var _loc4_:int = _loc8_.y;
         var _loc13_:Point = GameMapUtils.getMaxDirectPoint(this._row,this._col);
         if(_loc6_ >= 0 && _loc6_ < _loc13_.x && _loc5_ >= 0 && _loc5_ < _loc13_.y && this._roadSeeker.value(_loc6_,_loc5_) == 0)
         {
            this._roadArr = this._roadSeeker.path8(new Point(_loc7_,_loc4_),new Point(_loc6_,_loc5_));
            _loc12_ = int(this._roadSeeker.path.length);
            if(_loc12_ > 0)
            {
               param1.runInBigMapToLocation(this.roadArrToPointArr(this._roadArr),param3.x,param3.y);
            }
            else if(_loc12_ == 0)
            {
               _loc10_ = [GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x - this._cellWidth,param1.y - this._cellHeight,this._row),GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x - this._cellWidth / 2,param1.y - this._cellHeight - this._cellHeight / 2,this._row),GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x,param1.y,this._row),GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x + this._cellWidth / 2,param1.y - this._cellHeight - this._cellHeight / 2,this._row),GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x + this._cellWidth,param1.y - this._cellHeight,this._row),GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x + this._cellWidth / 2,param1.y - this._cellHeight + this._cellHeight / 2,this._row),GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x,param1.y - this._cellHeight + this._cellHeight / 2,this._row),GameMapUtils
               .getDirectPointByPixel(this._cellWidth,this._cellHeight,param1.x - this._cellWidth / 2,param1.y - this._cellHeight + this._cellHeight / 2,this._row)];
               _loc11_ = 0;
               while(_loc11_ < _loc10_.length)
               {
                  _loc17_ = int(_loc10_[_loc11_].x);
                  _loc14_ = int(_loc10_[_loc11_].y);
                  _loc15_ = this._roadSeeker.path8(new Point(_loc17_,_loc14_),new Point(_loc6_,_loc5_));
                  if(_loc15_.length > 0)
                  {
                     param1.runInBigMapToLocation(this.roadArrToPointArr(this._roadArr),param3.x,param3.y);
                     break;
                  }
                  _loc11_++;
               }
               _loc16_ = new Point();
            }
         }
      }
      
      private function roadArrToPointArr(param1:Array) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:Point = null;
         var _loc4_:Array = [];
         var _loc6_:int = 1;
         while(_loc6_ < param1.length - 1)
         {
            _loc5_ = int(this._roadMap.getValue(this._roadSeeker.path[_loc6_].y + "-" + this._roadSeeker.path[_loc6_].x).px);
            _loc3_ = int(this._roadMap.getValue(this._roadSeeker.path[_loc6_].y + "-" + this._roadSeeker.path[_loc6_].x).py);
            _loc2_ = GameMapUtils.getPixelPoint(this._cellWidth,this._cellHeight,_loc5_,_loc3_);
            _loc4_.push(new Point(_loc2_.x,_loc2_.y + this._cellHeight));
            _loc6_++;
         }
         _loc4_.unshift(this._curtPoint);
         _loc4_.push(this._targetPoint);
         return _loc4_;
      }
      
      private function checkDiff(param1:int, param2:int) : int
      {
         return int((param1 - param2) * Math.tan(0.5233333333333333));
      }
      
      public function canWalk(param1:int, param2:int) : Boolean
      {
         var _loc5_:Point = GameMapUtils.getDirectPointByPixel(this._cellWidth,this._cellHeight,param1,param2,this._row);
         var _loc4_:int = _loc5_.x;
         var _loc3_:int = _loc5_.y;
         return this._roadSeeker.value(_loc4_,_loc3_) == 0 ? true : false;
      }
      
      public function sortDepth(param1:Array) : void
      {
         var _loc3_:Point = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc4_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:Number = 0;
         var _loc11_:Number = 0;
         var _loc5_:Number = 0;
         var _loc9_:Boolean = false;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc6_ = param1[_loc2_];
            if(this._buildLayer.hitTestObject(_loc6_ as DisplayObject))
            {
               for each(_loc7_ in this._buildLayer.buildingArray)
               {
                  if(_loc7_ is GameMapItem && Boolean(_loc7_.bitMap))
                  {
                     if(_loc7_.bitMap.hitTestObject(_loc6_ as DisplayObject))
                     {
                        if(_loc7_.configXml.walkable.@left_k != null && _loc7_.configXml.walkable.@right_k != null && _loc7_.configXml.walkable.@origin_x != null && Boolean(_loc7_.configXml.walkable.@origin_y))
                        {
                           _loc11_ = Number(_loc7_.configXml.walkable.@left_k);
                           _loc5_ = Number(_loc7_.configXml.walkable.@right_k);
                           _loc3_ = new Point(Number(_loc7_.configXml.walkable.@origin_x) + _loc7_.x,Number(_loc7_.configXml.walkable.@origin_y) + _loc7_.y);
                           _loc12_ = -(_loc3_.y - _loc6_.y) / (_loc3_.x - _loc6_.x);
                           _loc9_ = true;
                        }
                        else
                        {
                           _loc9_ = false;
                        }
                        _loc8_ = this._buildLayer.getChildIndex(_loc6_ as DisplayObject);
                        _loc4_ = this._buildLayer.getChildIndex(_loc7_);
                        if(_loc6_.y < _loc7_.y + _loc7_.bitMap.height)
                        {
                           if(_loc9_)
                           {
                              if(_loc12_ < 0 && _loc12_ < _loc11_ || _loc12_ > 0 && _loc12_ > _loc5_)
                              {
                                 if(_loc8_ > _loc4_)
                                 {
                                    this._buildLayer.addChildAt(_loc6_,_loc4_);
                                 }
                              }
                              else if(_loc8_ < _loc4_)
                              {
                                 this._buildLayer.addChildAt(_loc6_,_loc4_ + 1);
                              }
                           }
                           else if(_loc8_ > _loc4_)
                           {
                              this._buildLayer.addChildAt(_loc6_,_loc4_);
                           }
                        }
                        else if(_loc8_ < _loc4_)
                        {
                           this._buildLayer.addChildAt(_loc6_,_loc4_ + 1);
                        }
                     }
                  }
               }
            }
            _loc2_++;
         }
         param1.length = 0;
         param1 = null;
      }
      
      public function dispose() : void
      {
         this._itemArr.length = 0;
         this._itemArr = null;
         this._mapArr.length = 0;
         this._mapArr = null;
         this._mapDArr.length = 0;
         this._mapDArr = null;
         this._mapLayer.dispose();
         this._buildLayer.dispose();
         this._bitmapData.dispose();
         this._bitmapData = null;
         this._mapXML = null;
      }
      
      public function get cellWidth() : Number
      {
         return this._cellWidth;
      }
      
      public function get cellHeight() : Number
      {
         return this._cellHeight;
      }
      
      public function get mapWidth() : Number
      {
         return this._mapWidth;
      }
      
      public function get mapHeight() : Number
      {
         return this._mapHeight;
      }
      
      public function get mapXML() : XML
      {
         return this._mapXML;
      }
      
      public function get mapLayer() : MapLayer
      {
         return this._mapLayer;
      }
      
      public function get initPlayerPoint() : Point
      {
         return this._initPlayerPoint;
      }
      
      public function get app() : Sprite
      {
         return this._app;
      }
      
      public function get buildLayer() : BuildingLayer
      {
         return this._buildLayer;
      }
   }
}

