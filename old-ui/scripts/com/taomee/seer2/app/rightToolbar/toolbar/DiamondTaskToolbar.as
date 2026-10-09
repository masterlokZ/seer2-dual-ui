package com.taomee.seer2.app.rightToolbar.toolbar
{
   import com.taomee.seer2.app.rightToolbar.RightToolbar;
   import com.taomee.seer2.app.rightToolbar.config.RightToolbarInfo;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.manager.EventManager;
   
   public class DiamondTaskToolbar extends RightToolbar
   {
      
      public var _aniWenZiMc:MovieClip;
      
      private var curTaskInfo:Array = [];
      
      public function DiamondTaskToolbar()
      {
         super();
      }
      
      override public function init(param1:RightToolbarInfo) : void
      {
         super.init(param1);
         EventManager.addEventListener("DiamondTaskEvent",this.playAnimation);
      }
      
      private function playAnimation(param1:Event) : void
      {
         this.show();
      }
      
      override protected function onResLoaded(param1:ContentInfo) : void
      {
         super.onResLoaded(param1);
         this._aniWenZiMc = (param1.content as MovieClip)["wenziMc"];
         this.updateBarStatus();
      }
      
      override protected function show() : void
      {
         if(Boolean(this._aniWenZiMc) && Boolean(this._aniWenZiMc.parent))
         {
            this._aniWenZiMc.parent.removeChild(this._aniWenZiMc);
         }
         super.show();
         this.updateBarStatus();
      }
      
      public function updateBarStatus() : void
      {
         ServerBufferManager.getServerBuffer(100014,function(param1:ServerBuffer):void
         {
            var _loc2_:Object = null;
            param1.printDataInfo();
            var _loc4_:int = 6;
            var _loc6_:Array = [];
            var _loc5_:int = 0;
            while(_loc5_ < 6)
            {
               _loc2_ = {};
               _loc2_["task_id"] = param1.readDataAtPostion(_loc4_);
               _loc2_["step_id"] = param1.readDataAtPostion(++_loc4_);
               _loc2_["task_status"] = param1.readDataAtPostion(++_loc4_);
               _loc6_.push(_loc2_);
               _loc4_++;
               _loc5_++;
            }
            curTaskInfo = [];
            var _loc3_:int = 0;
            while(_loc3_ < _loc6_.length)
            {
               if(_loc6_[_loc3_].task_id != 0)
               {
                  curTaskInfo.push(_loc6_[_loc3_]);
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < curTaskInfo.length)
            {
               if(curTaskInfo[_loc3_].task_status == 1)
               {
                  addChild(_aniWenZiMc);
                  break;
               }
               _loc3_++;
            }
         },false);
      }
      
      override public function remove() : void
      {
         super.remove();
         if(Boolean(this._aniWenZiMc) && Boolean(this._aniWenZiMc.parent))
         {
            this._aniWenZiMc.parent.removeChild(this._aniWenZiMc);
         }
      }
   }
}

