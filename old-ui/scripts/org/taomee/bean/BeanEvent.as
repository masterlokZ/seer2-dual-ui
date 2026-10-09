package org.taomee.bean
{
   import flash.events.Event;
   
   public class BeanEvent extends Event
   {
      
      public static const OPEN:String = "open";
      
      public static const COMPLETE:String = "complete";
      
      public static const PROGRESS:String = "progress";
      
      private var _id:String;
      
      public function BeanEvent(param1:String, param2:String)
      {
         super(param1);
         this._id = param2;
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}

