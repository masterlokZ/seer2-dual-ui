package com.taomee.seer2.app.rarePet
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.rarePet.config.RarePetConfig;
   import com.taomee.seer2.app.rarePet.event.RarePetEvent;
   import com.taomee.seer2.app.rarePet.info.RarePetInfo;
   import com.taomee.seer2.app.rarePet.info.RarePetTimeInfo;
   import com.taomee.seer2.app.rarePet.processor.BaseRarePetProcessor;
   import com.taomee.seer2.app.rarePet.processor.RarePetProcessor_437;
   import com.taomee.seer2.app.rarePet.processor.RarePetProcessor_438;
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.NumberUtil;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import org.taomee.utils.Tick;
   
   public class RarePetManager
   {
      
      private static var _dispatcher:EventDispatcher;
      
      private static var _rarePetVec:Vector.<int>;
      
      private static var _relatedMapVec:Vector.<int>;
      
      private static var _processorVec:Vector.<BaseRarePetProcessor>;
      
      public function RarePetManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _dispatcher = new EventDispatcher();
         _rarePetVec = RarePetConfig.getAllRarePetIds();
         _relatedMapVec = RarePetConfig.getAllRelatedMapIds();
         initProcessor();
         SceneManager.addEventListener("switchStart",onMapDispose);
         SceneManager.addEventListener("switchComplete",onMapComplete);
      }
      
      private static function initProcessor() : void
      {
         _processorVec = new Vector.<BaseRarePetProcessor>();
         _processorVec.push(new RarePetProcessor_437(437,380));
         _processorVec.push(new RarePetProcessor_438(438,340));
      }
      
      private static function onMapComplete(param1:SceneEvent) : void
      {
         var _loc2_:BaseRarePetProcessor = null;
         if(_relatedMapVec.indexOf(SceneManager.active.mapID) != -1)
         {
            Tick.instance.addRender(onTimer,1000);
         }
         for each(_loc2_ in _processorVec)
         {
            _loc2_.processMapComplete();
         }
      }
      
      private static function onMapDispose(param1:SceneEvent) : void
      {
         var _loc2_:BaseRarePetProcessor = null;
         Tick.instance.removeRender(onTimer);
         for each(_loc2_ in _processorVec)
         {
            if(SceneManager.active)
            {
               _loc2_.processMapDispose();
            }
         }
      }
      
      private static function onTimer(param1:int) : void
      {
         var _loc3_:RarePetInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < _rarePetVec.length)
         {
            _loc3_ = RarePetConfig.getRarePetInfo(_rarePetVec[_loc2_]);
            if(isInTimeRange(_loc3_) == 1)
            {
               disPatcherEvent(_loc3_.id,"startTimeUp");
            }
            else if(isInTimeRange(_loc3_) == 2)
            {
               disPatcherEvent(_loc3_.id,"endTimeUp");
            }
            _loc2_++;
         }
      }
      
      public static function getCookTime(param1:int) : uint
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("rarePet");
         var _loc3_:Object = _loc2_.data[param1];
         if(_loc3_ == null)
         {
            _loc3_ = {};
            _loc3_.time = 0;
            _loc2_.data[param1] = _loc3_;
            SharedObjectManager.flush(_loc2_);
         }
         return _loc3_.time;
      }
      
      public static function addCookTime(param1:int, param2:uint) : void
      {
         var _loc4_:SharedObject = SharedObjectManager.getUserSharedObject("rarePet");
         var _loc3_:Object = _loc4_.data[param1];
         param2 = TimeManager.getServerTime();
         _loc3_.time = param2;
         SharedObjectManager.flush(_loc4_);
      }
      
      public static function isInTimeRange(param1:RarePetInfo) : int
      {
         var _loc4_:uint = TimeManager.getServerTime();
         var _loc6_:Date = new Date(_loc4_ * 1000);
         var _loc5_:int = _loc6_.getDay();
         var _loc3_:Number = _loc6_.getHours() * 60 + _loc6_.getMinutes();
         if(!param1.timeInfoMap.containsKey(_loc5_))
         {
            return 0;
         }
         var _loc2_:RarePetTimeInfo = param1.timeInfoMap.getValue(_loc5_);
         if(NumberUtil.numInRange(_loc3_,_loc2_.startTime,_loc2_.startTime + 1) != 0)
         {
            return 1;
         }
         return NumberUtil.numInRange(_loc3_,_loc2_.startTime,_loc2_.endTime);
      }
      
      public static function startFight(param1:int) : void
      {
         var _loc2_:RarePetInfo = RarePetConfig.getRarePetInfo(param1);
         FightManager.startFightWithWild(_loc2_.index);
      }
      
      public static function disPatcherEvent(param1:int, param2:String) : void
      {
         if(_dispatcher)
         {
            _dispatcher.dispatchEvent(new RarePetEvent(param2,param1));
         }
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         if(_dispatcher)
         {
            _dispatcher.addEventListener(param1,param2);
         }
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         if(_dispatcher)
         {
            _dispatcher.removeEventListener(param1,param2);
         }
      }
   }
}

