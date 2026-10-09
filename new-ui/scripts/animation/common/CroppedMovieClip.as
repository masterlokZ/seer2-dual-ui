package animation.common
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class CroppedMovieClip extends Sprite
   {
      
      private var _content:MovieClip;
      
      private var _cropRect:Rectangle;
      
      public function CroppedMovieClip(param1:MovieClip, param2:Number, param3:Number)
      {
         super();
         _content = param1;
         addChild(_content);
         _cropRect = new Rectangle(0,0,param2,param3);
         _content.scrollRect = _cropRect;
      }
      
      override public function get width() : Number
      {
         return _cropRect.width;
      }
      
      override public function set width(param1:Number) : void
      {
         _cropRect.width = param1;
         _content.scrollRect = _cropRect;
      }
      
      override public function get height() : Number
      {
         return _cropRect.height;
      }
      
      override public function set height(param1:Number) : void
      {
         _cropRect.height = param1;
         _content.scrollRect = _cropRect;
      }
      
      public function setCropPosition(param1:Number, param2:Number) : void
      {
         _cropRect.x = param1;
         _cropRect.y = param2;
         _content.scrollRect = _cropRect;
      }
      
      public function get content() : MovieClip
      {
         return _content;
      }
   }
}

