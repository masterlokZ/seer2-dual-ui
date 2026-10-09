package com.taomee.seer2.app.gameRule.door
{
   import com.taomee.seer2.app.gameRule.door.core.vo.DoorLevelInfomation;
   import com.taomee.seer2.app.gameRule.door.warrior.Warrior50V50DoorSuport;
   import com.taomee.seer2.app.gameRule.door.warrior.WarriorDoorSuport;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class WarriorDoor extends BaseDoor
   {
      
      public function WarriorDoor(param1:SimpleButton, param2:uint)
      {
         super(param1,param2,2);
         _doorName = "勇士之门";
         _doorInformation = new DoorLevelInfomation();
         _doorNormalId = 50;
         _door50V50Id = 51;
         _lastDoorRule = 1;
      }
      
      override protected function onDoorEntryClickHandler(param1:MouseEvent) : void
      {
         if(_doorType == 0)
         {
            _doorSupport = WarriorDoorSuport.getInstance();
         }
         else if(_doorType == 1)
         {
            _doorSupport = Warrior50V50DoorSuport.getInstance();
         }
         super.onDoorEntryClickHandler(param1);
      }
   }
}

