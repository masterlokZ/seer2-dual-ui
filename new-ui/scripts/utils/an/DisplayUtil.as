package utils.an
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import utils.Delegate;
   
   public class DisplayUtil
   {
      
      private static const MOUSE_EVENT_LIST:Array = ["click","doubleClick","mouseDown","mouseMove","mouseOut","mouseOver","mouseUp","mouseWheel","rollOut","rollOver"];
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function FillColor(param1:DisplayObject, param2:uint) : void
      {
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
      
      public static function stopAllMovieClip(param1:DisplayObjectContainer, param2:uint = 0) : void
      {
         var _loc5_:int = 0;
         var _loc4_:DisplayObjectContainer = null;
         var _loc6_:MovieClip = param1 as MovieClip;
         if(_loc6_)
         {
            if(param2 > 0)
            {
               _loc6_.gotoAndStop(param2);
            }
            else
            {
               _loc6_.stop();
            }
            _loc6_ = null;
         }
         _loc5_ = param1.numChildren - 1;
         if(_loc5_ < 0)
         {
            return;
         }
         var _loc3_:int = _loc5_;
         while(_loc3_ >= 0)
         {
            _loc4_ = param1.getChildAt(_loc3_) as DisplayObjectContainer;
            if(_loc4_ != null)
            {
               stopAllMovieClip(_loc4_,param2);
            }
            _loc3_--;
         }
      }
      
      public static function hasParent(param1:DisplayObject) : Boolean
      {
         if(param1.parent == null)
         {
            return false;
         }
         return param1.parent.contains(param1);
      }
      
      public static function localToLocal(param1:DisplayObject, param2:DisplayObject, param3:Point = null) : Point
      {
         if(param3 == null)
         {
            param3 = new Point(0,0);
         }
         param3 = param1.localToGlobal(param3);
         return param2.globalToLocal(param3);
      }
      
      public static function copyDisplayAsBmp(param1:DisplayObject, param2:Boolean = true) : Bitmap
      {
         var _loc8_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc7_ = param1.scaleY;
         _loc8_ = param1.scaleX;
         var _loc4_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         var _loc3_:Rectangle = param1.getRect(param1);
         var _loc6_:Matrix = new Matrix();
         if(_loc8_ < 0)
         {
            param1.scaleX = -param1.scaleX;
         }
         if(_loc7_ < 0)
         {
            param1.scaleY = -param1.scaleY;
         }
         _loc6_.createBox(param1.scaleX,param1.scaleY,0,-_loc3_.x * param1.scaleX,-_loc3_.y * param1.scaleY);
         _loc4_.draw(param1,_loc6_);
         param1.scaleX = _loc8_;
         param1.scaleY = _loc7_;
         var _loc5_:Bitmap = new Bitmap(_loc4_,"auto",param2);
         if(_loc8_ < 0)
         {
            _loc5_.scaleX = -1;
         }
         if(_loc7_ < 0)
         {
            _loc5_.scaleY = -1;
         }
         _loc5_.x = _loc3_.x * param1.scaleX;
         _loc5_.y = _loc3_.y * param1.scaleY;
         return _loc5_;
      }
      
      public static function mouseEnabledAll(param1:InteractiveObject, param2:Boolean = false) : void
      {
         var container:DisplayObjectContainer;
         var i:int = 0;
         var child:InteractiveObject = null;
         var target:InteractiveObject = param1;
         var isAll:Boolean = param2;
         var b:Boolean = MOUSE_EVENT_LIST.some(function(param1:String, param2:int, param3:Array):Boolean
         {
            if(target.hasEventListener(param1))
            {
               return true;
            }
            return false;
         });
         if(!b)
         {
            if(target.name.indexOf("instance") != -1)
            {
               target.mouseEnabled = false;
            }
         }
         container = target as DisplayObjectContainer;
         if(container)
         {
            i = container.numChildren - 1;
            while(i >= 0)
            {
               child = container.getChildAt(i) as InteractiveObject;
               if(child)
               {
                  mouseEnabledAll(child);
               }
               i = i - 1;
            }
         }
      }
      
      public static function align(param1:DisplayObject, param2:int = 4, param3:Rectangle = null, param4:Point = null) : void
      {
         var _loc5_:Rectangle = null;
         if(param3 == null)
         {
            if(!param1.stage)
            {
               param1.addEventListener("addedToStage",Delegate.create(onAddStage,param2,param4),false,0,true);
               return;
            }
            _loc5_ = new Rectangle(0,0,param1.stage.stageWidth,param1.stage.stageHeight);
         }
         else
         {
            _loc5_ = param3.clone();
         }
         align2(param1,_loc5_,param2,param4);
      }
      
      public static function getColor(param1:DisplayObject, param2:uint = 0, param3:uint = 0, param4:Boolean = false) : uint
      {
         var _loc6_:BitmapData = null;
         _loc6_ = new BitmapData(param1.width,param1.height);
         _loc6_.draw(param1);
         var _loc5_:uint = !param4 ? _loc6_.getPixel(int(param2),int(param3)) : _loc6_.getPixel32(int(param2),int(param3));
         _loc6_.dispose();
         return _loc5_;
      }
      
      public static function removeForParent(param1:DisplayObject, param2:Boolean = true) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         if(param1 == null)
         {
            return;
         }
         if(param1.parent == null)
         {
            return;
         }
         if(param2)
         {
            _loc3_ = param1 as DisplayObjectContainer;
            if(_loc3_)
            {
               stopAllMovieClip(_loc3_);
               _loc3_ = null;
            }
         }
         param1.parent.removeChild(param1);
      }
      
      public static function playAllMovieClip(param1:DisplayObjectContainer) : void
      {
         var _loc4_:DisplayObjectContainer = null;
         var _loc3_:MovieClip = param1 as MovieClip;
         if(_loc3_ != null)
         {
            _loc3_.gotoAndPlay(1);
            _loc3_ = null;
         }
         var _loc5_:int = param1.numChildren - 1;
         if(_loc5_ < 0)
         {
            return;
         }
         var _loc2_:int = _loc5_;
         while(_loc2_ >= 0)
         {
            _loc4_ = param1.getChildAt(_loc2_) as DisplayObjectContainer;
            if(_loc4_ != null)
            {
               playAllMovieClip(_loc4_);
            }
            _loc2_--;
         }
      }
      
      private static function align2(param1:DisplayObject, param2:Rectangle, param3:int, param4:Point) : void
      {
         if(param4)
         {
            param2.offsetPoint(param4);
         }
         var _loc6_:Rectangle = param1.getRect(param1);
         var _loc5_:Number = param2.width - param1.width;
         var _loc7_:Number = param2.height - param1.height;
         switch(param3)
         {
            case 0:
               param1.x = param2.x;
               param1.y = param2.y;
               break;
            case 1:
               param1.x = param2.x + _loc5_ / 2 - _loc6_.x;
               param1.y = param2.y;
               break;
            case 2:
               param1.x = param2.x + _loc5_ - _loc6_.x;
               param1.y = param2.y;
               break;
            case 3:
               param1.x = param2.x;
               param1.y = param2.y + _loc7_ / 2 - _loc6_.x;
               break;
            case 4:
               param1.x = param2.x + _loc5_ / 2 - _loc6_.x;
               param1.y = param2.y + _loc7_ / 2 - _loc6_.y;
               break;
            case 5:
               param1.x = param2.x + _loc5_ - _loc6_.x;
               param1.y = param2.y + _loc7_ / 2 - _loc6_.y;
               break;
            case 6:
               param1.x = param2.x;
               param1.y = param2.y + _loc7_ - _loc6_.y;
               break;
            case 7:
               param1.x = param2.x + _loc5_ / 2 - _loc6_.x;
               param1.y = param2.y + _loc7_ - _loc6_.y;
               break;
            case 8:
               param1.x = param2.x + _loc5_ - _loc6_.x;
               param1.y = param2.y + _loc7_ - _loc6_.y;
         }
      }
      
      public static function uniformScale(param1:DisplayObject, param2:Number) : void
      {
         if(param1.width >= param1.height)
         {
            param1.width = param2;
            param1.scaleY = param1.scaleX;
         }
         else
         {
            param1.height = param2;
            param1.scaleX = param1.scaleY;
         }
      }
      
      private static function onAddStage(param1:Event, param2:int, param3:Point) : void
      {
         var _loc5_:DisplayObject = null;
         _loc5_ = param1.currentTarget as DisplayObject;
         _loc5_.removeEventListener("addedToStage",arguments.callee);
         align2(_loc5_,new Rectangle(0,0,_loc5_.stage.stageWidth,_loc5_.stage.stageHeight),param2,param3);
      }
      
      public static function removeAllChild(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         while(param1.numChildren > 0)
         {
            _loc2_ = param1.removeChildAt(0) as DisplayObjectContainer;
            if(_loc2_ != null)
            {
               stopAllMovieClip(_loc2_);
               _loc2_ = null;
            }
         }
      }
      
      public static function replaceChild(param1:*, param2:*) : *
      {
         var _loc3_:DisplayObjectContainer = param1.parent;
         var _loc4_:int = _loc3_.getChildIndex(param1);
         _loc3_.addChildAt(param2,_loc4_);
         _loc3_.removeChild(param1);
         return param2;
      }
      
      public static function setChildPosition(param1:DisplayObject, param2:int, param3:int) : void
      {
         param1.x = param2;
         param1.y = param3;
      }
   }
}

