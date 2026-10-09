package ui
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class PetFallback extends MovieClip
   {
      
      public static var Pet0:Class = §assets_swf$223d619de69321f89b5a1ebdf98f131d-626351976§;
      
      private var _origin:MovieClip;
      
      public function PetFallback()
      {
         super();
         _origin = new Pet0();
         addChild(_origin);
         addHitEvent(_origin);
         addChild(showPetFrames(_origin));
      }
      
      public static function addHitEvent(param1:MovieClip) : void
      {
         var origin:MovieClip = param1;
         origin.addEventListener("enterFrame",function(param1:Event):void
         {
            var _loc3_:MovieClip = param1.target as MovieClip;
            if(!_loc3_.numChildren)
            {
               return;
            }
            var _loc4_:MovieClip = _loc3_.getChildAt(0) as MovieClip;
            var _loc2_:Boolean = false;
            if(_loc4_)
            {
               if(_loc3_.currentFrame === 6 && _loc4_.currentFrame === 39)
               {
                  _loc2_ = true;
               }
               else if(_loc3_.currentFrame === 14 && _loc4_.currentFrame === 22)
               {
                  _loc2_ = true;
               }
               else if(_loc3_.currentFrame === 22 && _loc4_.currentFrame === 58)
               {
                  _loc2_ = true;
               }
               else if(_loc3_.currentFrame === 63 && _loc4_.currentFrame === 123)
               {
                  _loc2_ = true;
               }
            }
            if(_loc2_)
            {
               _loc3_.dispatchEvent(new Event("hit",true));
            }
         });
      }
      
      public static function showPetFrames(param1:MovieClip) : TextField
      {
         var origin:MovieClip = param1;
         var _text:TextField = new TextField();
         _text.y = 200;
         _text.textColor = 16711680;
         origin.addEventListener("enterFrame",function(param1:Event):void
         {
            var _loc2_:MovieClip = param1.target as MovieClip;
            var _loc3_:MovieClip = _loc2_.numChildren ? _loc2_.getChildAt(0) as MovieClip : null;
            _text.text = _loc2_.currentFrame + "/" + _loc2_.totalFrames + "," + (_loc3_ ? _loc3_.currentFrame + "/" + _loc3_.totalFrames : "");
         });
         return _text;
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

