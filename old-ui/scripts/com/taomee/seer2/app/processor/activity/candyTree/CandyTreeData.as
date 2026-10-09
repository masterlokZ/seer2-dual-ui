package com.taomee.seer2.app.processor.activity.candyTree
{
   import com.taomee.seer2.core.manager.TimeManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class CandyTreeData
   {
      
      public static var isCanWater:uint;
      
      public static var upCount:uint;
      
      public static var startTime:uint;
      
      public static var timeMC:MovieClip;
      
      public static var currStatus:uint;
      
      private static var timeList:Vector.<uint> = Vector.<uint>([1,60,240,900,1800,1800,1800,1800,1800,1800]);
      
      public function CandyTreeData()
      {
         super();
      }
      
      public static function getOverTime(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = TimeManager.getPrecisionServerTime() - param2;
         if(_loc4_ >= timeList[param1])
         {
            _loc3_ = 10000;
         }
         else
         {
            _loc3_ = timeList[param1] - _loc4_;
         }
         return _loc3_;
      }
      
      public static function updateTime(param1:uint, param2:uint) : void
      {
         var _loc7_:TextField = timeMC["txt"];
         var _loc6_:MovieClip = timeMC["content"];
         var _loc4_:TextField = timeMC["txt2"];
         var _loc3_:uint = timeList[param1];
         var _loc5_:String = "";
         _loc5_ = String(uint(param2 / 60));
         _loc5_ = _loc5_ + ":";
         _loc5_ = _loc5_ + String(param2 % 60);
         _loc7_.text = _loc5_;
         _loc4_.text = "离成熟还有0小时" + (uint(param2 / 60) + 1) + "分";
         _loc6_.scaleX = param2 / _loc3_;
      }
   }
}

