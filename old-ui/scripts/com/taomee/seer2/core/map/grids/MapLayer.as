package com.taomee.seer2.core.map.grids
{
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class MapLayer extends BaseDisplayObject
   {
      
      private var _imageLoader:ImageLoader;
      
      private var _image:Bitmap;
      
      private var _imageMap:HashMap;
      
      private var _simage:Bitmap;
      
      private var _map:GameMap;
      
      private var _loadType:int;
      
      private var _visualWidth:Number;
      
      private var _visualHeight:Number;
      
      private var _sliceWidth:Number;
      
      private var _sliceHeight:Number;
      
      private var _preloadX:Number;
      
      private var _preloadY:Number;
      
      private var _loadingMap:HashMap;
      
      private var _waitLoadingArr:Array;
      
      private var _loadingNo:int = 1;
      
      private var _screenImageRow:int;
      
      private var _screenImageCol:int;
      
      private var _row:int;
      
      private var _col:int;
      
      private var _nowPlayerPoint:Point;
      
      public function MapLayer(param1:GameMap)
      {
         super();
         this._map = param1;
         this._loadType = parseInt(this._map.mapXML.@loadType);
      }
      
      private function loadBigSuccess(param1:Event) : void
      {
         var _loc2_:ImageLoader = ImageLoader(param1.target);
         var _loc3_:Bitmap = new Bitmap(_loc2_._data);
         addChild(_loc3_);
         if(this._simage != null && this._simage.parent == this)
         {
            removeChild(this._simage);
            this._simage = null;
         }
         this.width = _loc3_.width;
         this.height = _loc3_.height;
         _loc2_.removeEventListener("complete",this.loadBigSuccess);
         _loc2_.removeEventListener("progress",loadingHandler);
         _loc2_.removeEventListener("ioError",ioErrorHandler);
         _loc2_ = null;
         dispatchEvent(param1);
         HeptaFishGC.gc();
      }
      
      public function initMapLayer(param1:BitmapData) : void
      {
         var _loc4_:String = null;
         var _loc3_:ImageLoader = null;
         var _loc2_:Bitmap = new Bitmap(param1);
         _loc2_.width *= 10;
         _loc2_.height *= 10;
         _loc2_.cacheAsBitmap = true;
         addChild(_loc2_);
         HeptaFishGC.gc();
         switch(this._loadType)
         {
            case 0:
               _loc4_ = URLUtil.getMapImage(this._map.name + "/map");
               _loc3_ = new ImageLoader();
               _loc3_.load(_loc4_);
               _loc3_.addEventListener("complete",this.loadBigSuccess);
               _loc3_.addEventListener("progress",loadingHandler);
               _loc3_.addEventListener("ioError",ioErrorHandler);
               break;
            case 1:
               this._loadingMap = new HashMap();
               this._imageMap = new HashMap();
               this._waitLoadingArr = [];
               this._visualWidth = this._map.app.width;
               this._visualHeight = this._map.app.height;
               this._sliceWidth = parseFloat(this._map.mapXML.@sliceWidth);
               this._sliceHeight = parseFloat(this._map.mapXML.@sliceHeight);
               this._preloadX = parseFloat(this._map.mapXML.@preloadX);
               this._preloadY = parseFloat(this._map.mapXML.@preloadY);
               this._screenImageRow = Math.round(this._visualWidth / this._sliceWidth);
               this._screenImageCol = Math.round(this._visualHeight / this._sliceHeight);
               this._row = Math.ceil(this._map.mapWidth / this._sliceWidth);
               this._col = Math.ceil(this._map.mapHeight / this._sliceHeight);
               this.loadSliceImage(this._map.initPlayerPoint);
         }
      }
      
      private function loadSliceImage(param1:Point) : void
      {
         var _loc7_:int = 0;
         var _loc9_:int = param1.x / this._sliceWidth;
         var _loc11_:int = param1.y / this._sliceHeight;
         var _loc10_:int = _loc9_ / this._screenImageRow;
         var _loc4_:int = _loc11_ / this._screenImageCol;
         this._nowPlayerPoint = new Point(_loc10_,_loc4_);
         this.loadScreenImage(_loc10_,_loc4_);
         var _loc3_:int = int(_loc10_ - this._preloadX < 0 ? 0 : int(_loc10_ - this._preloadX));
         var _loc8_:int = int(_loc4_ - this._preloadY < 0 ? 0 : int(_loc4_ - this._preloadY));
         var _loc5_:int = _loc10_ + this._preloadX > this._row ? this._row : int(_loc10_ + this._preloadX);
         var _loc2_:int = _loc4_ + this._preloadY > this._col ? this._col : int(_loc4_ + this._preloadY);
         var _loc6_:int = _loc3_;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc8_;
            while(_loc7_ < _loc2_)
            {
               if(!(_loc6_ == _loc10_ && _loc7_ == _loc4_))
               {
                  this.loadScreenImage(_loc6_,_loc7_);
               }
               _loc7_++;
            }
            _loc6_++;
         }
      }
      
      private function loadScreenImage(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc3_:String = null;
         var _loc9_:int = this._screenImageRow * param1 <= 0 ? 0 : this._screenImageRow * param1;
         var _loc8_:int = this._screenImageCol * param2 <= 0 ? 0 : this._screenImageCol * param2;
         var _loc5_:int = this._screenImageRow * (param1 + 1) >= this._row - 1 ? this._row - 1 : this._screenImageRow * (param1 + 1);
         var _loc4_:int = this._screenImageCol * (param2 + 1) >= this._col - 1 ? this._col - 1 : this._screenImageCol * (param2 + 1);
         var _loc7_:int = _loc8_;
         while(_loc7_ <= _loc4_)
         {
            _loc6_ = _loc9_;
            while(_loc6_ <= _loc5_)
            {
               _loc3_ = _loc7_ + "_" + _loc6_;
               if(!this._loadingMap.containsValue(_loc3_) && !this._imageMap.containsKey(_loc3_))
               {
                  this._waitLoadingArr.push(_loc3_);
               }
               _loc6_++;
            }
            this._waitLoadingArr.reverse();
            this.loadImage();
            _loc7_++;
         }
      }
      
      private function loadImage() : void
      {
         var _loc2_:int = 0;
         var _loc1_:String = null;
         var _loc4_:ImageLoader = null;
         var _loc3_:String = null;
         if(this._waitLoadingArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._loadingNo - this._loadingMap.size())
            {
               _loc1_ = this._waitLoadingArr.pop();
               _loc4_ = new ImageLoader();
               _loc3_ = URLUtil.getMapImage(this._map.name + "/" + _loc1_);
               this._loadingMap.put(_loc4_,_loc1_);
               _loc4_.addEventListener("complete",this.loadScreenImageSuccess);
               _loc4_.addEventListener("progress",loadingHandler);
               _loc4_.addEventListener("ioError",ioErrorHandler);
               _loc4_.load(_loc3_);
               _loc2_++;
            }
         }
      }
      
      private function loadScreenImageSuccess(param1:Event) : void
      {
         var _loc6_:Array = null;
         var _loc4_:Bitmap = null;
         var _loc5_:ImageLoader = ImageLoader(param1.target);
         var _loc7_:String = String(this._loadingMap.getValue(_loc5_));
         _loc6_ = _loc7_.split("_");
         var _loc3_:int = int(_loc6_[0]);
         var _loc2_:int = int(_loc6_[1]);
         this._loadingMap.remove(_loc5_);
         _loc4_ = new Bitmap(_loc5_._data);
         _loc4_.x = this._sliceWidth * _loc2_;
         _loc4_.y = this._sliceHeight * _loc3_;
         this.addChild(_loc4_);
         this._imageMap.put(_loc3_ + "_" + _loc2_,_loc4_);
         _loc5_.removeEventListener("complete",this.loadScreenImageSuccess);
         _loc5_.removeEventListener("progress",loadingHandler);
         _loc5_.removeEventListener("ioError",ioErrorHandler);
         _loc5_ = null;
         this.loadImage();
      }
      
      private function removeScreenImage(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Bitmap = null;
         var _loc9_:int = int(param1 - this._preloadX < 0 ? 0 : int(param1 - this._preloadX));
         var _loc8_:int = int(param2 - this._preloadY < 0 ? 0 : int(param2 - this._preloadY));
         var _loc5_:int = param1 + this._preloadX > this._row ? this._row : int(param1 + this._preloadX);
         var _loc4_:int = param2 + this._preloadY > this._col ? this._col : int(param2 + this._preloadY);
         var _loc7_:Array = this._imageMap.keys();
         var _loc6_:int = 0;
         while(_loc6_ < _loc7_.length)
         {
            _loc3_ = _loc7_ as String;
            _loc12_ = _loc3_.split("_");
            _loc13_ = int(_loc12_[0]);
            _loc10_ = int(_loc12_[1]);
            if(_loc10_ < _loc9_ * this._screenImageRow || _loc10_ > _loc5_ * this._screenImageRow || _loc13_ < _loc8_ * this._screenImageCol || _loc13_ > _loc4_ * this._screenImageCol)
            {
               _loc11_ = Bitmap(this._imageMap.getValue(_loc3_));
               this.removeChild(_loc11_);
               _loc11_ = null;
               this._imageMap.remove(_loc3_);
            }
            _loc6_++;
         }
         HeptaFishGC.gc();
      }
      
      public function checkLoad(param1:Point) : void
      {
         var _loc3_:int = Math.floor(param1.x / this._sliceWidth);
         var _loc5_:int = Math.floor(param1.y / this._sliceHeight);
         var _loc4_:int = Math.floor(_loc3_ / this._screenImageRow);
         var _loc2_:int = Math.floor(_loc5_ / this._screenImageCol);
         if(_loc4_ != this._nowPlayerPoint.x || _loc2_ != this._nowPlayerPoint.y)
         {
            this.loadSliceImage(param1);
         }
      }
      
      public function dispose() : void
      {
         this._imageMap.clear();
         this._loadingMap.clear();
         this._waitLoadingArr.length = 0;
         this._waitLoadingArr = null;
      }
   }
}

