package com.taomee.analytics
{
   internal class RecordSocketHistory
   {
      
      public static const TAG_SYSTEM_BUSY:String = "SystemBusy";
      
      public static const TAG_DB_TIMEOUT:String = "DBTimeOut";
      
      private static var oldTimer:Number = 0;
      
      public static const ACTION_WRITE:String = "write";
      
      public static var recordCount:int = 40;
      
      public static const ACTION_READ:String = "read";
      
      public static var actionHistory:Array = [];
      
      public function RecordSocketHistory()
      {
         super();
      }
      
      public static function pushInActionHistory(param1:int, param2:String) : void
      {
         var _loc4_:Number = new Date().time;
         var _loc3_:int = _loc4_ - (oldTimer == 0 ? _loc4_ : oldTimer);
         actionHistory.push(param1 + ":" + String(_loc3_) + "/" + param2);
         if(actionHistory.length > recordCount)
         {
            actionHistory.shift();
         }
         oldTimer = _loc4_;
      }
      
      public static function pushInTagHistory(param1:int, param2:String) : void
      {
         var _loc4_:Number = new Date().time;
         var _loc3_:int = _loc4_ - (oldTimer == 0 ? _loc4_ : oldTimer);
         actionHistory.push(param1 + ":" + param2 + "-" + String(_loc3_) + "/Tag");
         if(actionHistory.length > recordCount)
         {
            actionHistory.shift();
         }
         oldTimer = _loc4_;
      }
   }
}

