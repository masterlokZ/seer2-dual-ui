package com.taomee.seer2.app.processor.activity.earthSearchAct
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.system.ApplicationDomain;
   
   public class EarthSearchTwoManager
   {
      
      private static var _self:EarthSearchTwoManager;
      
      public static var isPassMC:Boolean = false;
      
      private var _obj:EarthSearchTwoLayer;
      
      private var _resLib:ApplicationDomain;
      
      private const FOR_LIST:Array = [205337];
      
      private const DAY_LIST:Array = [1510,1511];
      
      private var _par:Parser_1142;
      
      private var _info:DayLimitListInfo;
      
      public var type:int;
      
      public function EarthSearchTwoManager()
      {
         super();
         this.type = -1;
         this.getURL();
      }
      
      public static function inistance() : EarthSearchTwoManager
      {
         if(null == _self)
         {
            _self = new EarthSearchTwoManager();
         }
         return _self;
      }
      
      private function getURL() : void
      {
         QueueLoader.load(URLUtil.getActivityAnimation("earthAct/earthAct"),"swf",function(param1:ContentInfo):void
         {
            _resLib = param1.domain;
            SceneManager.addEventListener("switchComplete",onComplete);
            stateHandle();
            _obj.resLib = _resLib;
         });
      }
      
      public function addObj(param1:EarthSearchTwoLayer) : void
      {
         this._obj = param1;
         this._obj.resLib = this._resLib;
      }
      
      public function stateHandle() : void
      {
         this.update();
      }
      
      private function onComplete(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType == 2)
         {
            this.update();
         }
         if(SceneManager.prevMapID == 80371 && SceneManager.active.type != 2)
         {
            this.dispose();
         }
      }
      
      private function dispose() : void
      {
         SceneManager.removeEventListener("switchComplete",this.onComplete);
         _self = null;
         this._obj = null;
         this.type = 0;
         this._resLib = null;
      }
      
      private function update() : void
      {
         ActiveCountManager.requestActiveCountList(this.FOR_LIST,function(param1:Parser_1142):void
         {
            var par:Parser_1142 = param1;
            DayLimitListManager.getDaylimitList(DAY_LIST,function(param1:DayLimitListInfo):void
            {
               _par = par;
               _info = param1;
               var _loc3_:int = [0,1,3,7].indexOf(par.infoVec[0]);
               var _loc5_:Number = param1.getCount(DAY_LIST[0]) - 180;
               var _loc4_:int = int(param1.getCount(DAY_LIST[1]));
               var _loc2_:Number = 180 - (TimeManager.getPrecisionServerTime() - _loc5_);
               if(type == -1)
               {
                  type = _loc3_;
                  if(_loc3_ == 3)
                  {
                     _obj.type = _loc3_;
                     _obj.showNpc();
                  }
                  else if(180 - (TimeManager.getPrecisionServerTime() - _loc5_) <= 0)
                  {
                     _obj.initSet([_loc3_,0,0]);
                     _obj.showNpc();
                     if(type == 0 && !isPassMC)
                     {
                        isPassMC = true;
                        _obj.curHandle.playSceneTalk("sceneTalk");
                     }
                  }
                  else
                  {
                     _obj.initSet([_loc3_,_loc5_,_loc4_]);
                     _obj.curHandle.stateUpdate();
                     _obj.hideNpc();
                  }
                  return;
               }
               if(_loc3_ == 3 && _loc3_ == type)
               {
                  _obj.type = _loc3_;
                  _obj.showNpc();
               }
               else if(_loc3_ > type)
               {
                  type = _loc3_;
                  _obj.initSet([_loc3_,_loc5_,_loc4_]);
                  _obj.curHandle.completeHandle();
               }
               else
               {
                  _obj.initSet([_loc3_,_loc5_,_loc4_]);
                  if(180 - (TimeManager.getPrecisionServerTime() - _loc5_) <= 0)
                  {
                     _obj.curHandle.failHandle();
                     _obj.initSet([_loc3_,0,0]);
                     _obj.showNpc();
                  }
                  else
                  {
                     _obj.curHandle.stateUpdate();
                     _obj.hideNpc();
                  }
               }
            });
         });
      }
   }
}

