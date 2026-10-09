package com.taomee.seer2.app.config
{
   import org.taomee.ds.HashMap;
   
   public class StarTaskConfig
   {
      
      private static var _xmlClass:Class = StarTaskConfig__xmlClass;
      
      private static var stepMap:HashMap = new HashMap();
      
      initlize();
      
      public function StarTaskConfig()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc4_:XML = null;
         var _loc3_:StarTaskInfo = null;
         var _loc2_:XML = XML(new _xmlClass());
         var _loc1_:XMLList = _loc2_.descendants("step");
         for each(_loc4_ in _loc1_)
         {
            if(uint(_loc4_.@id) >= 9)
            {
               _loc3_ = new StarTaskInfo();
               _loc3_.module = String(_loc4_.@module);
               _loc3_.tip = String(_loc4_.@tip);
               stepMap.add(uint(_loc4_.@id),_loc3_);
            }
         }
      }
      
      public static function getStarTaskInfo(param1:uint) : StarTaskInfo
      {
         if(stepMap.containsKey(param1))
         {
            return stepMap.getValue(param1);
         }
         return null;
      }
   }
}

