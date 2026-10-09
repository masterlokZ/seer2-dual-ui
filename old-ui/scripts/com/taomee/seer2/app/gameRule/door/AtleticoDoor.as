package com.taomee.seer2.app.gameRule.door
{
   import com.taomee.seer2.app.gameRule.door.atletico.Atletico50V50DoorSupport;
   import com.taomee.seer2.app.gameRule.door.atletico.AtleticoDoorSupport;
   import com.taomee.seer2.app.gameRule.door.core.vo.DoorLevelInfomation;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class AtleticoDoor extends BaseDoor
   {
      
      public function AtleticoDoor(param1:SimpleButton, param2:uint)
      {
         super(param1,param2,3);
         _doorName = "竞技之门";
         _doorInformation = new DoorLevelInfomation();
         _doorNormalId = 67;
         _door50V50Id = 68;
         _lastDoorRule = 2;
      }
      
      override protected function onDoorEntryClickHandler(param1:MouseEvent) : void
      {
         if(_doorType == 0)
         {
            _doorSupport = AtleticoDoorSupport.getInstance();
         }
         else if(_doorType == 1)
         {
            _doorSupport = Atletico50V50DoorSupport.getInstance();
         }
         super.onDoorEntryClickHandler(param1);
      }
   }
}

