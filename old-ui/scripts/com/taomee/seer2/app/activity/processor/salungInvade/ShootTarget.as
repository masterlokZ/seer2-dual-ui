package com.taomee.seer2.app.activity.processor.salungInvade
{
   import com.taomee.seer2.core.loader.ContentInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ShootTarget extends MovieClip
   {
      
      private static const ANGLE_VEC:Vector.<Number> = Vector.<Number>([-2.356194490192345,-1.5707963267948966,-0.7853981633974483]);
      
      protected var _mc:MovieClip;
      
      protected var _angle:Number;
      
      protected var _type:uint;
      
      private var STEP:uint = 5;
      
      private var _info:ContentInfo;
      
      private var _engine:SalungShootEngine;
      
      public function ShootTarget(param1:uint, param2:SalungShootEngine)
      {
         super();
         this._info = param2.contentInfo;
         this._engine = param2;
         this._type = param1;
         this.initUI();
         this.initPisition();
         addEventListener("click",this.clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         this._engine.updateProgressBar(this._type == 3);
         this.playMc(3);
      }
      
      public function resetUI() : void
      {
         var _loc1_:uint = Math.random() * 10000 % ANGLE_VEC.length;
         this._angle = ANGLE_VEC[_loc1_];
         this.initPisition();
      }
      
      private function initUI() : void
      {
         this._mc = this.getMovie();
         var _loc1_:uint = Math.random() * 10000 % ANGLE_VEC.length;
         this._angle = ANGLE_VEC[_loc1_];
         addChild(this._mc);
         this._mc.scaleX = 0.5;
         this._mc.scaleY = 0.5;
         this.playMc(2);
      }
      
      private function initPisition() : void
      {
         var _loc1_:Number = Math.random() * 960;
         x = _loc1_;
         y = 560;
      }
      
      private function getMovie() : MovieClip
      {
         var _loc1_:MovieClip = null;
         return new (this._info.domain.getDefinition("st" + this._type))();
      }
      
      private function playMc(param1:uint) : void
      {
         var i:int;
         var index:uint = param1;
         for(i = 1; i <= 3; )
         {
            this._mc["mc" + i].visible = false;
            this._mc["mc" + i].stop();
            i++;
         }
         this._mc["mc" + index].visible = true;
         this._mc["mc" + index].play();
         if(index == 3)
         {
            this._mc["mc" + index].gotoAndPlay(1);
            this._mc["mc" + index].addFrameScript(this._mc["mc" + index].totalFrames - 1,function():void
            {
               playMc(2);
            });
         }
      }
      
      public function move() : void
      {
         x += Math.cos(this._angle) * this.STEP;
         y += Math.sin(this._angle) * this.STEP;
      }
   }
}

