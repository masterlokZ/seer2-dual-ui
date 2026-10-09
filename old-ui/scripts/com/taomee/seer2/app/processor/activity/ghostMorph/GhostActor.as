package com.taomee.seer2.app.processor.activity.ghostMorph
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class GhostActor extends Sprite
   {
      
      public var mc:MovieClip;
      
      public var index:int;
      
      public function GhostActor()
      {
         super();
      }
      
      public function addMC() : void
      {
         addChild(this.mc);
      }
      
      public function update() : void
      {
         var _loc2_:uint = Math.random() * 30;
         if(_loc2_ < 10)
         {
            _loc2_ = 1;
         }
         else if(_loc2_ < 20)
         {
            _loc2_ = 2;
         }
         else if(_loc2_ < 30)
         {
            _loc2_ = 3;
         }
         var _loc1_:String = "";
         switch(int(_loc2_))
         {
            case 0:
               _loc1_ = "冒泡1";
               break;
            case 1:
               _loc1_ = "冒泡1";
               break;
            case 2:
               _loc1_ = "冒泡2";
               break;
            case 3:
               _loc1_ = "冒泡3";
         }
         this.mc.gotoAndStop(_loc1_);
      }
      
      public function end() : void
      {
         this.mc.gotoAndStop("消失");
      }
   }
}

