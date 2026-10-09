package com.taomee.seer2.core.animation.frame
{
   import com.taomee.seer2.core.log.Logger;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class FrameSheet
   {
      
      private var _unitWidth:uint;
      
      private var _unitHeight:uint;
      
      private var _sheetBitmapData:BitmapData;
      
      private var _frameNum:uint;
      
      private var _frameInfoVec:Vector.<FrameInfo>;
      
      private var _logger:Logger;
      
      private var _isReady:Boolean = false;
      
      private var _frameNumX:uint;
      
      private var _frameNumY:uint;
      
      private var _initializedFrameCount:uint;
      
      private var _loader:Loader;
      
      public function FrameSheet(param1:ByteArray)
      {
         super();
         this._logger = Logger.getLogger("FrameSheet");
         this.parseFrameInfo(param1);
         this.parseSheet(param1);
      }
      
      private function parseFrameInfo(param1:ByteArray) : void
      {
         var _loc2_:FrameInfo = null;
         var _loc3_:ByteArray = new ByteArray();
         var _loc5_:int = param1.readShort();
         param1.readBytes(_loc3_,0,_loc5_);
         this._unitWidth = _loc3_.readShort();
         this._unitHeight = _loc3_.readShort();
         this._frameNum = _loc3_.readShort();
         this._frameInfoVec = new Vector.<FrameInfo>();
         var _loc4_:int = 0;
         while(_loc4_ < this._frameNum)
         {
            _loc2_ = new FrameInfo();
            _loc2_.keyNum = _loc3_.readShort();
            _loc2_.offsetX = _loc3_.readShort();
            _loc2_.offsetY = _loc3_.readShort();
            _loc2_.contentWidth = _loc3_.readShort();
            _loc2_.contentHeight = _loc3_.readShort();
            _loc2_.sheetIndex = _loc3_.readShort();
            this._frameInfoVec.push(_loc2_);
            _loc4_++;
         }
      }
      
      private function parseSheet(param1:ByteArray) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         param1.readBytes(_loc2_);
         _loc2_.position = 0;
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener("complete",this.onImageLoaded);
         this._loader.contentLoaderInfo.addEventListener("ioError",this.onError);
         var _loc3_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         _loc3_.allowCodeImport = true;
         this._loader.loadBytes(_loc2_,_loc3_);
      }
      
      private function removeImageLoaderEventListener() : void
      {
         if(this._loader)
         {
            this._loader.contentLoaderInfo.removeEventListener("complete",this.onImageLoaded);
            this._loader.contentLoaderInfo.removeEventListener("ioError",this.onError);
         }
      }
      
      private function onImageLoaded(param1:Event) : void
      {
         this.removeImageLoaderEventListener();
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         this._sheetBitmapData = (_loc2_.content as Bitmap).bitmapData;
         this._frameNumX = this._sheetBitmapData.width / this._unitWidth;
         this._frameNumY = this._sheetBitmapData.height / this._unitHeight;
         this._isReady = true;
         this._loader.unloadAndStop();
         this._loader = null;
      }
      
      private function onError(param1:Event) : void
      {
         this._logger.error("文件解析失败");
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
      
      public function getFrameInfo(param1:int) : FrameInfo
      {
         var _loc2_:uint = this.findFrameInfoIndex(param1);
         var _loc3_:FrameInfo = this._frameInfoVec[_loc2_];
         if(_loc3_.bitmapData == null)
         {
            this.createFrameData(_loc3_,_loc3_.sheetIndex);
         }
         return _loc3_;
      }
      
      private function findFrameInfoIndex(param1:uint) : uint
      {
         var _loc3_:FrameInfo = null;
         var _loc2_:int = int(this._frameInfoVec.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._frameInfoVec[_loc4_];
            if(param1 == _loc3_.keyNum)
            {
               return _loc4_;
            }
            if(param1 < _loc3_.keyNum)
            {
               return _loc4_ - 1;
            }
            _loc4_++;
         }
         return _loc2_ - 1;
      }
      
      private function createFrameData(param1:FrameInfo, param2:int) : void
      {
         var _loc5_:BitmapData = null;
         var _loc8_:int = param2 % this._frameNumX;
         var _loc7_:int = param2 / this._frameNumX;
         var _loc4_:int = _loc8_ * this._unitWidth;
         var _loc3_:int = _loc7_ * this._unitHeight;
         var _loc6_:Rectangle = new Rectangle(_loc4_,_loc3_,param1.contentWidth,param1.contentHeight);
         _loc5_ = new BitmapData(param1.contentWidth,param1.contentHeight,true,16724991);
         _loc5_.copyPixels(this._sheetBitmapData,_loc6_,new Point(0,0));
         param1.bitmapData = _loc5_;
         ++this._initializedFrameCount;
         if(this._initializedFrameCount >= this._frameNum)
         {
            this.disposeSheetImage();
         }
      }
      
      private function disposeSheetImage() : void
      {
         if(this._sheetBitmapData)
         {
            this._sheetBitmapData.dispose();
            this._sheetBitmapData = null;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:FrameInfo = null;
         this.removeImageLoaderEventListener();
         for each(_loc1_ in this._frameInfoVec)
         {
            if(_loc1_.bitmapData)
            {
               _loc1_.bitmapData.dispose();
            }
            _loc1_ = null;
         }
         this._frameInfoVec = null;
         this.disposeSheetImage();
      }
   }
}

