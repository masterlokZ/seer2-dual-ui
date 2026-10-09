package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class MapProcessor_80123 extends MapProcessor
   {
      
      private const fight_id:uint = 791;
      
      private const pet_id:uint = 169;
      
      public function MapProcessor_80123(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         var currentDate:Date;
         var isA:Boolean;
         var isB:Boolean;
         StatisticsManager.sendNovice("0x1003406D");
         currentDate = new Date(TimeManager.getPrecisionServerTime() * 1000);
         isA = currentDate.fullYear == 2014 && currentDate.month == 0 && currentDate.date == 18 && currentDate.hours == 14 && currentDate.minutes < 11;
         isB = currentDate.fullYear == 2014 && currentDate.month == 0 && currentDate.date == 19 && currentDate.hours == 14 && currentDate.minutes < 11;
         if(isA || isB)
         {
            this.createPet();
         }
         else
         {
            AlertManager.showAlert("活动时间已经结束了,去传送室看看其他活动吧!",function():void
            {
               SceneManager.changeScene(1,70);
            });
         }
      }
      
      private function createPet() : void
      {
         var _loc1_:SpawnedPet = null;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = new SpawnedPet(169,791,0);
            MobileManager.addMobile(_loc1_,"spawnedPet");
            _loc2_++;
         }
      }
   }
}

