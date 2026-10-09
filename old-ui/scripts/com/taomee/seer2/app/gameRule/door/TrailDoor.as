package com.taomee.seer2.app.gameRule.door
{
   import com.taomee.seer2.app.gameRule.door.core.vo.DoorLevelInfomation;
   import com.taomee.seer2.app.gameRule.door.trails.Trail50V50DoorSupport;
   import com.taomee.seer2.app.gameRule.door.trails.TrailDoorSupport;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class TrailDoor extends BaseDoor
   {
      
      public function TrailDoor(param1:SimpleButton, param2:uint)
      {
         super(param1,param2,1);
         _doorName = "试炼之门";
         _doorInformation = new DoorLevelInfomation();
         _doorNormalId = 33;
         _door50V50Id = 34;
         _lastDoorRule = -1;
      }
      
      override protected function onDoorEntryClickHandler(param1:MouseEvent) : void
      {
         if(_doorType == 0)
         {
            _doorSupport = TrailDoorSupport.getInstance();
         }
         else if(_doorType == 1)
         {
            _doorSupport = Trail50V50DoorSupport.getInstance();
         }
         super.onDoorEntryClickHandler(param1);
      }
   }
}

