package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class MapProcessor_3704 extends MapProcessor
   {
      
      private const limitId:int = 202328;
      
      public function MapProcessor_3704(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         ActiveCountManager.requestActiveCount(202328,this.getCount);
      }
      
      private function getCount(param1:uint, param2:uint) : void
      {
         var spawnedPet:SpawnedPet = null;
         var type:uint = param1;
         var count:uint = param2;
         if(type == 202328)
         {
            if(count == 1)
            {
               spawnedPet = new SpawnedPet(82,476,0);
               MobileManager.addMobile(spawnedPet,"spawnedPet");
            }
            else
            {
               AlertManager.showAlert("你已经获得了红宝石，赶紧赶快去找汪总管吧",function():void
               {
                  QuestManager.addEventListener("stepComplete",onStep);
                  QuestManager.completeStep(10195,3);
               });
            }
         }
      }
      
      private function onStep(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStep);
         SceneManager.changeScene(1,330);
      }
      
      override public function dispose() : void
      {
         QuestManager.removeEventListener("stepComplete",this.onStep);
         super.dispose();
      }
   }
}

