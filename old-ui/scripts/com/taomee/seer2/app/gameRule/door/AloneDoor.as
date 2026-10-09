package com.taomee.seer2.app.gameRule.door
{
   import com.taomee.seer2.app.gameRule.door.alone.Alone50V50DoorSupport;
   import com.taomee.seer2.app.gameRule.door.alone.AloneDoorSupport;
   import com.taomee.seer2.app.gameRule.door.core.vo.DoorLevelInfomation;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class AloneDoor extends BaseDoor
   {
      
      public function AloneDoor(param1:SimpleButton, param2:uint)
      {
         super(param1,param2,7);
         _doorName = "孤独之门";
         _doorInformation = new DoorLevelInfomation();
         _doorNormalId = 273;
         _door50V50Id = 274;
         _lastDoorRule = 3;
         _doorTotalLevel = 4;
         _hasContinueButton = false;
      }
      
      override protected function onDoorEntryClickHandler(param1:MouseEvent) : void
      {
         if(_doorType == 0)
         {
            _doorSupport = AloneDoorSupport.getInstance();
         }
         else if(_doorType == 1)
         {
            _doorSupport = Alone50V50DoorSupport.getInstance();
         }
         super.onDoorEntryClickHandler(param1);
      }
      
      override protected function requestDailyLimit() : void
      {
         super.requestDailyLimit();
         _currentLevelHistory = 1;
      }
   }
}

