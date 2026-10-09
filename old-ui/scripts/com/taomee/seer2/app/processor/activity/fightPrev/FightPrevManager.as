package com.taomee.seer2.app.processor.activity.fightPrev
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class FightPrevManager
   {
      
      private static const MAP_LIST:Vector.<uint> = Vector.<uint>([80112,80113,80114,80115,80116,80117,80118,80119,80120,80121]);
      
      private static const MON_LIST:Vector.<uint> = Vector.<uint>([148,170,150,153,155,378,433,442,450,453]);
      
      private static const FIGHT_LIST:Vector.<uint> = Vector.<uint>([778,779,780,781,782,783,784,785,786,787]);
      
      public function FightPrevManager()
      {
         super();
      }
      
      public static function startFightPrev() : void
      {
         SceneManager.addEventListener("switchComplete",onComplete);
      }
      
      private static function onComplete(param1:SceneEvent) : void
      {
         var e:SceneEvent = param1;
         var index:int = MAP_LIST.indexOf(SceneManager.active.mapID);
         if(index != -1)
         {
            SpawnedManager.addSpawned([[MON_LIST[index],FIGHT_LIST[index],0]]);
            if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1)
            {
               ActiveCountManager.requestActiveCount(203638,function(param1:uint, param2:uint):void
               {
                  var _loc5_:Array = [];
                  _loc5_[0] = (param2 & 1) == 1;
                  _loc5_[1] = (param2 & 2) == 2;
                  _loc5_[2] = (param2 & 4) == 4;
                  _loc5_[3] = (param2 & 8) == 8;
                  _loc5_[4] = (param2 & 0x10) == 16;
                  _loc5_[5] = (param2 & 0x20) == 32;
                  _loc5_[6] = (param2 & 0x40) == 64;
                  _loc5_[7] = (param2 & 0x80) == 128;
                  _loc5_[8] = (param2 & 0x0100) == 256;
                  _loc5_[9] = (param2 & 0x0200) == 512;
                  var _loc4_:uint = 0;
                  var _loc3_:int = 0;
                  while(_loc3_ < _loc5_.length)
                  {
                     if(_loc5_[_loc3_])
                     {
                        _loc4_++;
                     }
                     _loc3_++;
                  }
                  if(_loc4_ >= 10)
                  {
                     ModuleManager.toggleModule(URLUtil.getAppModule("FightPrevReadyPanel"),"正在打开...");
                  }
                  else
                  {
                     ModuleManager.toggleModule(URLUtil.getAppModule("FightPrevReadyMonPanel"),"正在打开...");
                  }
               });
            }
         }
      }
   }
}

