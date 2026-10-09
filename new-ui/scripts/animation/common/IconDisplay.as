package animation.common
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import ui.IconFallback;
   import utils.CacheUtils;
   import utils.an.DisplayObjectUtil;
   
   public class IconDisplay extends Sprite
   {
      
      protected var _url:String;
      
      protected var _icon:DisplayObject;
      
      protected var _maxWidth:Number;
      
      protected var _maxHeight:Number;
      
      protected var _scaleX:Number;
      
      protected var _scaleY:Number;
      
      private var _useScale:Boolean = false;
      
      public function IconDisplay()
      {
         super();
         mouseChildren = false;
      }
      
      private static function mayWrapIcon(param1:String, param2:DisplayObject) : DisplayObject
      {
         if(param2 is IconFallback)
         {
            return param2;
         }
         if(param1.indexOf("res/pet/icon/") !== -1)
         {
            return new CroppedMovieClip(param2 as MovieClip,54,54);
         }
         if(param1.indexOf("res/skill/sideEffect/") !== -1)
         {
            return new CroppedMovieClip(param2 as MovieClip,30,30);
         }
         return param2;
      }
      
      public function initData(param1:String) : void
      {
         var url:String = param1;
         if(url === _url)
         {
            return;
         }
         if(!url)
         {
            DisplayObjectUtil.removeFromParent(_icon);
            _url = url;
            _icon = null;
            return;
         }
         _url = url;
         CacheUtils.loadItem(url,function(param1:DisplayObject):void
         {
            if(_url === url)
            {
               DisplayObjectUtil.removeFromParent(_icon);
               _icon = mayWrapIcon(url,param1);
               if(_useScale)
               {
                  if(!isNaN(_scaleX))
                  {
                     _icon.scaleX = _scaleX;
                     _icon.scaleY = _scaleY;
                  }
               }
               else if(!isNaN(_maxWidth))
               {
                  DisplayObjectUtil.setSize(_icon,_maxWidth,_maxHeight);
               }
               addChild(_icon);
            }
         });
      }
      
      public function setSize(param1:Number) : void
      {
         setBoundary(param1,param1);
      }
      
      public function setBoundary(param1:Number, param2:Number) : void
      {
         this._useScale = false;
         this._maxWidth = param1;
         this._maxHeight = param2;
         if(_icon)
         {
            DisplayObjectUtil.setSize(_icon,_maxWidth,_maxHeight);
         }
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         this._useScale = true;
         if(param1)
         {
            this._scaleX = param1;
         }
         if(param1)
         {
            this._scaleY = param2;
         }
         if(_icon)
         {
            _icon.scaleX = param1;
            _icon.scaleY = param2;
         }
      }
   }
}

