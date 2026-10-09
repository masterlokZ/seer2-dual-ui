package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.pet.StarSpawnedPet;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.entity.events.MoveEvent;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class WenZhangMapController
   {
      
      private static const limitCount:uint = 10;
      
      private static var myClass:WenZhangMapController;
      
      private static const mapIDs:Array = [121,141,133,131,203,191,204,180,291,261,281,302];
      
      private static const monsterIDs:Array = [10,18,200,13,72,25,140,41,32,39,49,35];
      
      private static const chanceIDs:Array = [5,20,5,15,15,15,5,10,25,25,20,15];
      
      private static const limitIDs:Array = [657,658,659,660,661,662,663,664,665,666,667,668];
      
      private static const fightIDs:Array = [390,391,392,393,394,395,396,397,398,399,400,401];
      
      private var _map:MapModel;
      
      private var _currentMapId:uint = 0;
      
      private var timeout:uint;
      
      private var spawnedPet:StarSpawnedPet;
      
      public function WenZhangMapController()
      {
         super();
         if(WenZhangMapController.myClass !== null)
         {
            throw new Error("WenZhangMapController是单例类");
         }
      }
      
      public static function getInstance() : WenZhangMapController
      {
         if(myClass == null)
         {
            myClass = new WenZhangMapController();
         }
         return myClass;
      }
      
      public function setup(param1:MapModel) : void
      {
         if(this.checkTime())
         {
            this._map = param1;
            this._currentMapId = this._map.id;
            this.onUpdate();
         }
      }
      
      private function onUpdate(param1:MoveEvent = null) : void
      {
         this.randomMonster();
      }
      
      private function checkTime() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         if(_loc2_.fullYear == 2013)
         {
            _loc1_ = _loc2_.month == 3 && _loc2_.date >= 28;
            _loc4_ = _loc2_.month == 4 && _loc2_.date <= 2;
            _loc3_ = _loc2_.hours == 13 || _loc2_.hours == 14;
            if((_loc1_ || _loc4_) && _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function randomMonster() : void
      {
         var index:int = 0;
         index = mapIDs.indexOf(this._currentMapId);
         DayLimitManager.getDoCount(limitIDs[index],function(param1:uint):void
         {
            var _loc2_:Number = NaN;
            if(param1 < 10)
            {
               _loc2_ = Math.random() * 100;
               if(_loc2_ < chanceIDs[index])
               {
                  createMonster();
               }
            }
         });
      }
      
      private function createMonster() : void
      {
         var _loc1_:int = mapIDs.indexOf(this._currentMapId);
         if(SceneManager.active && SceneManager.active.mapModel && SceneManager.active.mapModel.id == this._currentMapId)
         {
            this.spawnedPet = new StarSpawnedPet(monsterIDs[_loc1_],fightIDs[_loc1_],0);
            this.timeout = setTimeout(this.addPet,3000);
         }
      }
      
      private function addPet() : void
      {
         if(this.spawnedPet)
         {
            MobileManager.addMobile(this.spawnedPet,"spawnedPet");
         }
      }
      
      public function dispose() : void
      {
         if(this._map)
         {
            this._map = null;
         }
         this._currentMapId = 0;
         if(this.spawnedPet)
         {
            this.spawnedPet = null;
         }
         clearTimeout(this.timeout);
      }
   }
}

