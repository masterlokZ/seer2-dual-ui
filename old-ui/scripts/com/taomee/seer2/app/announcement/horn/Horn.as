package com.taomee.seer2.app.announcement.horn
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class Horn extends AbstractHorn
   {
      
      private var _hornMC:MovieClip;
      
      private var _groupMC:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      private var _contentTxt:TextField;
      
      private var _contentMC:MovieClip;
      
      private var _setTimeout:uint;
      
      public function Horn(param1:HornInfo)
      {
         super(param1);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         var _loc7_:Array = null;
         var _loc9_:String = null;
         var _loc8_:Object = null;
         var _loc4_:Array = null;
         var _loc3_:String = null;
         var _loc6_:Array = null;
         var _loc5_:uint = 0;
         var _loc2_:uint = 0;
         if(_info.mouseClickType == "module")
         {
            _loc7_ = _info.transport.split("|");
            if(_loc7_.length > 1)
            {
               _loc9_ = String(_loc7_[1]);
               _loc8_ = {};
               _loc4_ = _loc9_.split(",");
               for each(_loc3_ in _loc4_)
               {
                  _loc6_ = _loc3_.split(":");
                  _loc8_[_loc6_[0]] = _loc6_[1];
               }
               ModuleManager.showModule(URLUtil.getAppModule(_loc7_[0]),"正在打开面板...",_loc8_);
            }
            else
            {
               ModuleManager.showModule(URLUtil.getAppModule(_loc7_[0]),"正在打开面板...");
            }
         }
         else if(_info.mouseClickType == "gotoMap")
         {
            _loc5_ = 1;
            _loc2_ = uint(_info.transport);
            if(_loc2_ == 70000)
            {
               _loc5_ = 8;
               _loc2_ = ActorManager.actorInfo.id;
            }
            if(_loc2_ == 50000)
            {
               _loc5_ = 3;
               _loc2_ = ActorManager.actorInfo.id;
            }
            SceneManager.changeScene(_loc5_,_loc2_);
         }
         super.onClick(param1);
      }
      
      override public function show() : void
      {
         this.initTime();
         super.show();
      }
      
      private function initTime() : void
      {
         var totalMinmute:uint = 0;
         var date:Date = new Date(TimeManager.getServerTime() * 1000);
         var minmute:int = date.minutes + 1;
         if(minmute > _info.minute)
         {
            totalMinmute = minmute - _info.minute;
         }
         else
         {
            totalMinmute = 3;
         }
         this._setTimeout = setTimeout(function():void
         {
            HornControl._isShowHorn = false;
            onClose(null);
         },uint(totalMinmute * 60 * 1000));
      }
      
      private function removeTime() : void
      {
         clearTimeout(this._setTimeout);
      }
      
      override public function onClose(param1:MouseEvent) : void
      {
         this.removeTime();
         super.onClose(param1);
      }
   }
}

