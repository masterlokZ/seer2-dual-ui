package com.taomee.seer2.core.map.grids
{
   import flash.display.Shape;
   import flash.geom.Point;
   
   public class RoadPointLayer extends BaseDisplayObject
   {
      
      private var _cellWidth:Number;
      
      private var _cellHeight:Number;
      
      private var _childMap:HashMap;
      
      private var _map:GameMap;
      
      public function RoadPointLayer(param1:GameMap)
      {
         super();
         this._map = param1;
         this._cellWidth = param1.cellWidth;
         this._cellHeight = param1.cellHeight;
         this._childMap = new HashMap();
      }
      
      public function drawCell(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Shape = null;
         var _loc7_:Number = NaN;
         if(param3 == 1)
         {
            _loc7_ = 3407667;
         }
         else
         {
            if(param3 != 2)
            {
               throw new Error("未知单元格类型！");
            }
            _loc7_ = 16711731;
         }
         var _loc5_:Point = GameMapUtils.getPixelPoint(this._cellWidth,this._cellHeight,param1,param2);
         this.resetCell(param1,param2);
         _loc4_ = new Shape();
         _loc4_.graphics.beginFill(_loc7_,0.5);
         _loc4_.graphics.drawCircle(0,0,this._cellHeight / 4);
         _loc4_.graphics.endFill();
         _loc4_.x = _loc5_.x;
         _loc4_.y = _loc5_.y;
         addChild(_loc4_);
         var _loc6_:String = param1 + "," + param2;
         this._childMap.put(_loc6_,_loc4_);
      }
      
      public function resetCell(param1:int, param2:int) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:String = param1 + "," + param2;
         _loc3_ = this._childMap.getValue(_loc4_);
         if(_loc3_ != null && _loc3_.parent == this)
         {
            removeChild(_loc3_);
         }
      }
      
      public function drawWalkableBuilding(param1:GameMapItem, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc13_:int = 0;
         var _loc10_:int = 0;
         var _loc14_:Point = null;
         var _loc15_:* = undefined;
         _loc7_ = param1.configXml.walkable;
         _loc6_ = _loc7_.split(",");
         if(_loc6_ == null || _loc6_.length < 2)
         {
            return;
         }
         var _loc9_:Number = this._map.cellWidth;
         var _loc8_:Number = this._map.cellHeight;
         var _loc5_:int = this._map.mapHeight / _loc8_;
         var _loc12_:int = this._map.mapWidth / _loc9_;
         var _loc11_:int = 0;
         while(_loc11_ < _loc6_.length)
         {
            _loc10_ = param3 + int(_loc6_[_loc11_ + 1]);
            _loc13_ = param2 + int(_loc6_[_loc11_]);
            _loc14_ = GameMapUtils.getCellPoint(_loc9_,_loc8_,_loc13_,_loc10_);
            _loc15_ = this._childMap.getValue(_loc14_.x + "," + _loc14_.y);
            if(param4 == false)
            {
               if(_loc15_ == null)
               {
                  this.drawCell(_loc14_.x,_loc14_.y,2);
               }
            }
            else if(_loc15_ != null)
            {
               removeChild(_loc15_);
            }
            _loc11_ += 2;
         }
      }
      
      public function drawArr(param1:Array, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1[0].length)
            {
               _loc3_ = int(param1[_loc5_][_loc4_]);
               if(param2 == 1)
               {
                  if(_loc3_ == 0)
                  {
                     this.drawCell(_loc4_,_loc5_,1);
                  }
               }
               else if(param2 == 0)
               {
                  if(_loc3_ == 1)
                  {
                     this.drawCell(_loc4_,_loc5_,2);
                  }
               }
               _loc4_++;
            }
            _loc5_++;
         }
      }
      
      public function set cellWidth(param1:Number) : void
      {
         this._cellWidth = param1;
      }
      
      public function get cellWidth() : Number
      {
         return this._cellWidth;
      }
      
      public function set cellHeight(param1:Number) : void
      {
         this._cellHeight = param1;
      }
      
      public function get cellHeight() : Number
      {
         return this._cellHeight;
      }
   }
}

