package com.taomee.seer2.app.component
{
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.core.cache.CacheManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class IconDisplayer extends Sprite
   {
      
      public static const NORMAL:String = "normal";
      
      public static const CENTER:String = "center";
      
      private static const DEFAULT_PET_ICON_SIZE:Number = 53.3333333333333;
      
      private var _iconUrl:String;
      
      private var _icon:DisplayObject;
      
      private var _onComplete:Function;
      
      private var _param:Array;
      
      private var _maxWidth:Number;
      
      private var _maxHeight:Number;
      
      private var _displayType:String;
      
      private var _petIconFallback:Boolean;
      
      private var _requestSerial:uint;
      
      private var _activeUrl:String;
      
      private var _activeCompleteHandler:Function;
      
      private var _activeErrorHandler:Function;
      
      public function IconDisplayer()
      {
         super();
         mouseChildren = false;
         this._displayType = "normal";
      }
      
      public function setIconUrl(param1:String, param2:Function = null, param3:Array = null) : void
      {
         this.removeIcon();
         this._iconUrl = param1;
         this._onComplete = param2;
         this._petIconFallback = false;
         this._param = null;
         if(param3)
         {
            this._param = param3;
         }
         this.loadIcon();
      }
      
      public function set displayType(param1:String) : void
      {
         this._displayType = param1;
         this.setIconMove();
      }
      
      public function setBoundary(param1:Number, param2:Number) : void
      {
         this._maxWidth = param1;
         this._maxHeight = param2;
      }
      
      public function showIconByReferenceId(param1:uint) : void
      {
         this.setIconUrl(ItemConfig.getItemIconUrl(param1));
      }
      
      public function get icon() : DisplayObject
      {
         return this._icon;
      }
      
      public function removeIcon() : void
      {
         ++this._requestSerial;
         this.cancelActiveLoad();
         DisplayObjectUtil.removeFromParent(this._icon);
         this._icon = null;
      }
      
      public function dispose() : void
      {
         this.removeIcon();
         this._onComplete = null;
         this._param = null;
      }
      
      private function setIconMove() : void
      {
         if(this._icon)
         {
            switch(this._displayType)
            {
               case "normal":
                  this._icon.x = 0;
                  this._icon.y = 0;
                  break;
               case "center":
                  this._icon.x = -this._icon.width / 2;
                  this._icon.y = -this._icon.height / 2;
            }
         }
      }
      
      private function loadIcon() : void
      {
         var serial:uint = this._requestSerial;
         var expectedUrl:String = this._iconUrl;
         this._activeUrl = expectedUrl;
         this._activeCompleteHandler = function(param1:ContentInfo):void
         {
            onIconLoaded(param1,serial,expectedUrl);
         };
         this._activeErrorHandler = function(param1:ContentInfo):void
         {
            onIconLoadError(param1,serial,expectedUrl);
         };
         CacheManager.getContent(expectedUrl,"phasor",this._activeCompleteHandler,this._activeErrorHandler);
      }
      
      private function cancelActiveLoad() : void
      {
         if(this._activeUrl && this._activeCompleteHandler != null)
         {
            CacheManager.cancel(this._activeUrl,"phasor",this._activeCompleteHandler);
            CacheManager.cancel(this._activeUrl,"pet",this._activeCompleteHandler);
         }
         this._activeUrl = null;
         this._activeCompleteHandler = null;
         this._activeErrorHandler = null;
      }
      
      private function isPetIconUrl(param1:String) : Boolean
      {
         var _loc2_:Array = null;
         if(param1 == null)
         {
            return false;
         }
         _loc2_ = param1.match(/\/res\/pet\/icon\/(\d+)\.swf(?:\?.*)?$/i);
         if(_loc2_ == null || _loc2_.length < 2)
         {
            return false;
         }
         return true;
      }
      
      private function isCurrentRequest(param1:uint, param2:String, param3:ContentInfo) : Boolean
      {
         return param1 == this._requestSerial && param2 == this._iconUrl && param2 == this._activeUrl && (param3 == null || param3.url == param2);
      }
      
      private function loadPetFallback(param1:uint, param2:String) : void
      {
         if(param1 != this._requestSerial || param2 != this._iconUrl || this._petIconFallback)
         {
            return;
         }
         this._petIconFallback = true;
         CacheManager.getContent(param2,"pet",this._activeCompleteHandler,this._activeErrorHandler);
      }
      
      private function onIconLoadError(param1:ContentInfo, param2:uint, param3:String) : void
      {
         if(!this.isCurrentRequest(param2,param3,param1))
         {
            return;
         }
         if(!this._petIconFallback && this.isPetIconUrl(param3))
         {
            this.loadPetFallback(param2,param3);
            return;
         }
         this.finishRequest();
      }
      
      private function onIconLoaded(param1:ContentInfo, param2:uint, param3:String) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         if(!this.isCurrentRequest(param2,param3,param1))
         {
            return;
         }
         if(param1.content == null && !this._petIconFallback && this.isPetIconUrl(param3))
         {
            this.loadPetFallback(param2,param3);
            return;
         }
         if(this._petIconFallback)
         {
            _loc4_ = param1.content as MovieClip;
            if(_loc4_ != null)
            {
               this.freezeFirstFrame(_loc4_);
               _loc5_ = new Sprite();
               _loc5_.addChild(_loc4_);
               _loc6_ = _loc4_.getBounds(_loc4_);
               _loc7_ = isNaN(this._maxWidth) ? DEFAULT_PET_ICON_SIZE : this._maxWidth;
               _loc8_ = isNaN(this._maxHeight) ? DEFAULT_PET_ICON_SIZE : this._maxHeight;
               if(_loc6_.width > 0 && _loc6_.height > 0)
               {
                  _loc9_ = Math.min(_loc7_ / _loc6_.width,_loc8_ / _loc6_.height);
                  _loc4_.scaleX = _loc4_.scaleY = _loc9_;
                  _loc4_.x = -_loc6_.x * _loc9_ + (_loc7_ - _loc6_.width * _loc9_) / 2;
                  _loc4_.y = -_loc6_.y * _loc9_ + (_loc8_ - _loc6_.height * _loc9_) / 2;
               }
               this._icon = _loc5_;
            }
         }
         else
         {
            this._icon = param1.content as DisplayObject;
         }
         if(this.icon != null)
         {
            if(!this._petIconFallback && !isNaN(this._maxWidth))
            {
               DisplayObjectUtil.setSize(this._icon,this._maxWidth,this._maxHeight);
            }
            addChild(this._icon);
            this.setIconMove();
         }
         this.finishRequest();
      }
      
      private function freezeFirstFrame(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = param1 as MovieClip;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         if(_loc2_ != null)
         {
            _loc2_.gotoAndStop(1);
         }
         _loc3_ = param1 as DisplayObjectContainer;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.numChildren - 1;
            while(_loc4_ >= 0)
            {
               this.freezeFirstFrame(_loc3_.getChildAt(_loc4_));
               _loc4_--;
            }
         }
      }
      
      private function finishRequest() : void
      {
         var _loc1_:Function = this._onComplete;
         var _loc2_:Array = this._param;
         this._activeUrl = null;
         this._activeCompleteHandler = null;
         this._activeErrorHandler = null;
         this._onComplete = null;
         this._param = null;
         if(_loc1_ != null)
         {
            if(_loc2_)
            {
               _loc1_(_loc2_);
            }
            else
            {
               _loc1_();
            }
         }
      }
   }
}

