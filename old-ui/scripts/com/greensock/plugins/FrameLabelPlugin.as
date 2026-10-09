package com.greensock.plugins
{
   import com.greensock.*;
   import flash.display.*;
   
   public class FrameLabelPlugin extends FramePlugin
   {
      
      public static const API:Number = 1;
      
      public function FrameLabelPlugin()
      {
         super();
         this.propName = "frameLabel";
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!param3.target is MovieClip)
         {
            return false;
         }
         _target = param1 as MovieClip;
         this.frame = _target.currentFrame;
         var _loc7_:Array = _target.currentLabels;
         var _loc5_:String = param2;
         var _loc4_:int = _target.currentFrame;
         var _loc6_:int = int(_loc7_.length);
         while(_loc6_--)
         {
            if(_loc7_[_loc6_].name == _loc5_)
            {
               _loc4_ = int(_loc7_[_loc6_].frame);
               break;
            }
         }
         if(this.frame != _loc4_)
         {
            addTween(this,"frame",this.frame,_loc4_,"frame");
         }
         return true;
      }
   }
}

