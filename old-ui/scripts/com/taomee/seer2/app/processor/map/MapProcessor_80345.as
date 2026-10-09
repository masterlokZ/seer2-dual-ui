package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import org.taomee.utils.Tick;
   
   public class MapProcessor_80345 extends MapProcessor
   {
      
      private static var _isFight:Boolean = false;
      
      private var _res:MovieClip;
      
      private const FIGHT_ID:uint = 1366;
      
      public function MapProcessor_80345(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         if(_isFight)
         {
            this.onComplete();
         }
         else
         {
            QueueLoader.load(URLUtil.getActivityAnimation("cindysMemory/Cindy2"),"swf",this.onLoad);
            ActorManager.getActor().hide();
            ActorManager.getActor().blockNoNo = true;
         }
      }
      
      private function onLoad(param1:ContentInfo) : void
      {
         var info:ContentInfo = param1;
         this._res = info.content;
         this._res.x = 0;
         this._res.y = 0;
         _map.front.addChild(this._res);
         ServerBufferManager.getServerBuffer(288,function(param1:ServerBuffer):void
         {
            var sb:ServerBuffer = param1;
            var curStep:int = sb.readDataAtPostion(1);
            if(curStep == 1)
            {
               MovieClipUtil.playMc(_res,1,_res.totalFrames,function():void
               {
                  _map.front.removeChild(_res);
                  FightManager.startFightWithBoss(1366,function():void
                  {
                     _isFight = true;
                  });
               });
            }
            else
            {
               ActorManager.getActor().show();
               ActorManager.getActor().blockNoNo = false;
            }
         });
      }
      
      private function onComplete() : void
      {
         if(SceneManager.prevSceneType == 2 && 1366 == FightManager.currentFightRecord.initData.positionIndex)
         {
            _isFight = false;
            if(FightManager.isWinWar())
            {
               ServerBufferManager.updateServerBuffer(288,1,2);
               Tick.instance.addTimeout(1200,function():void
               {
                  SceneManager.changeScene(9,80346);
               });
            }
            else
            {
               NpcDialog.show(830,"雷霆",[[0,"英雄怎么可以战败？"]],["等一下再来","再战！"],[function():void
               {
                  SceneManager.addEventListener("switchComplete",(function():*
                  {
                     var switchOver:Function;
                     return switchOver = function():void
                     {
                        SceneManager.removeEventListener("switchComplete",switchOver);
                        ModuleManager.showAppModule("CindysMemoryPanel");
                     };
                  })());
                  ActsHelperUtil.goHandle(70);
               },function():void
               {
                  FightManager.startFightWithBoss(1366,function():void
                  {
                     _isFight = true;
                  });
               }]);
            }
         }
      }
   }
}

