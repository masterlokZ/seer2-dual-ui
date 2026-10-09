package animation.ext
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import ui.PetFallback;
   import utils.an.DisplayObjectUtil;
   
   public class ImgPet extends MovieClip
   {
      
      public static var Pet0:Class = assets_swf$223d619de69321f89b5a1ebdf98f131d220261325;
      
      public var _img:Bitmap;
      
      public var _origin:MovieClip;
      
      public function ImgPet(param1:Bitmap)
      {
         super();
         _img = param1;
         DisplayObjectUtil.setSize(_img,240,240);
         _img.x = 70;
         _img.y = 110;
         addChild(_img);
         _origin = new Pet0();
         addChild(_origin);
         PetFallback.addHitEvent(_origin);
         addChild(PetFallback.showPetFrames(_origin));
      }
      
      override public function get currentLabels() : Array
      {
         return _origin.currentLabels;
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         return _origin.getChildAt(param1);
      }
      
      override public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         _origin.gotoAndStop(param1,param2);
      }
   }
}

