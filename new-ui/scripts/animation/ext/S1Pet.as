package animation.ext
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import ui.PetFallback;
   
   public class S1Pet extends MovieClip
   {
      
      private var _origin:MovieClip;
      
      public function S1Pet(param1:MovieClip)
      {
         super();
         this._origin = param1;
         _origin.x = 180;
         _origin.y = 250;
         addChild(_origin);
         gotoAndStop("待机");
         addChild(PetFallback.showPetFrames(_origin));
      }
      
      override public function get currentLabels() : Array
      {
         return [{"name":"物理攻击"},{"name":"特殊攻击"},{"name":"属性攻击"},{"name":"被打"},{"name":"待机"}];
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         return _origin.getChildAt(param1);
      }
      
      override public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         var label:String;
         var frame:Object = param1;
         var scene:String = param2;
         var handleEnterFrame:* = function(param1:Event):void
         {
            var handleEnterFrame1:*;
            var event:Event = param1;
            var child0:MovieClip = _origin.getChildAt(0) as MovieClip;
            if(child0)
            {
               _origin.removeEventListener("enterFrame",handleEnterFrame);
               if(frame === "待机")
               {
                  child0.gotoAndStop(0);
               }
               else
               {
                  handleEnterFrame1 = function(param1:Event):void
                  {
                     if(child0.hit)
                     {
                        child0.hit = false;
                        dispatchEvent(new Event("hit"));
                     }
                     if(child0.currentFrame == child0.totalFrames)
                     {
                        child0.removeEventListener("enterFrame",handleEnterFrame1);
                        child0.gotoAndStop(0);
                     }
                  };
                  child0.gotoAndPlay(1);
                  child0.addEventListener("enterFrame",handleEnterFrame1);
               }
            }
         };
         if(frame === "物理攻击")
         {
            label = "attack";
         }
         else if(frame === "特殊攻击")
         {
            label = "sa";
         }
         else if(frame === "属性攻击")
         {
            label = "cp";
         }
         else if(frame === "被打")
         {
            label = "hited";
         }
         else
         {
            label = "attack";
         }
         _origin.gotoAndStop(label);
         _origin.addEventListener("enterFrame",handleEnterFrame);
      }
   }
}

