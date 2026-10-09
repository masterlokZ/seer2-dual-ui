package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
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
   import flash.utils.IDataInput;
   
   public class MapProcessor_80346 extends MapProcessor
   {
      
      private static var _isFight:Boolean = false;
      
      private var _res:MovieClip;
      
      private const FIGHT_ID:uint = 1365;
      
      private const SWAP_TASK:uint = 3451;
      
      public function MapProcessor_80346(param1:MapModel)
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
            QueueLoader.load(URLUtil.getActivityAnimation("cindysMemory/Cindy3"),"swf",this.onLoad);
            ActorManager.getActor().hide();
            ActorManager.getActor().blockNoNo = true;
         }
      }
      
      private function onComplete() : void
      {
         if(SceneManager.prevSceneType == 2 && 1365 == FightManager.currentFightRecord.initData.positionIndex)
         {
            _isFight = false;
            if(FightManager.isWinWar())
            {
               NpcDialog.show(830,"雷霆",[[0,"邪恶的精灵不可能战胜我，永远不能！"]],["雷霆好帅！"],[function():void
               {
                  SwapManager.swapItem(3451,1,function(param1:IDataInput):void
                  {
                     ServerBufferManager.updateServerBuffer(288,1,0);
                     new SwapInfo(param1);
                     gameOver();
                  });
               }]);
            }
            else
            {
               NpcDialog.show(830,"雷霆",[[0,"英雄怎么可以战败？"]],["等一下再来","再战！"],[function():void
               {
                  gameOver();
               },function():void
               {
                  FightManager.startFightWithBoss(1365,function():void
                  {
                     _isFight = true;
                  });
               }]);
            }
         }
      }
      
      private function gameOver() : void
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
      }
      
      private function onLoad(param1:ContentInfo) : void
      {
         var info:ContentInfo = param1;
         this._res = info.content;
         this._res.x = 0;
         this._res.y = 0;
         ServerBufferManager.getServerBuffer(288,function(param1:ServerBuffer):void
         {
            var sb:ServerBuffer = param1;
            var curStep:int = sb.readDataAtPostion(1);
            if(curStep == 2)
            {
               _map.content.addChild(_res);
               MovieClipUtil.playMc(_res,1,_res.totalFrames,function():void
               {
                  _map.content.removeChild(_res);
                  FightManager.startFightWithBoss(1365,function():void
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
   }
}

