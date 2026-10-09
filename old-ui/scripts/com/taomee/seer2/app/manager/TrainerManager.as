package com.taomee.seer2.app.manager
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class TrainerManager
   {
      
      public static const TASK_COMPLETE:String = "taskComplete";
      
      public static var typeId:uint;
      
      public static var taskId:uint;
      
      public static var progress:uint;
      
      public static var isComplete:Boolean;
      
      private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
      
      public function TrainerManager()
      {
         super();
      }
      
      public static function dispatcheEvent(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         typeId = param1;
         taskId = param2;
         progress = param3;
         isComplete = param4 == 1;
         _eventDispatcher.dispatchEvent(new Event("taskComplete"));
      }
      
      public static function addEventListener(param1:Function) : void
      {
         _eventDispatcher.addEventListener("taskComplete",param1);
      }
      
      public static function removeEventListener(param1:Function) : void
      {
         _eventDispatcher.removeEventListener("taskComplete",param1);
      }
   }
}

