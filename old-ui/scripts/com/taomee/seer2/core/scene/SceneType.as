package com.taomee.seer2.core.scene
{
   public class SceneType
   {
      
      public static const NULL:int = 0;
      
      public static const LOBBY:int = 1;
      
      public static const ARENA:int = 2;
      
      public static const HOME:int = 3;
      
      public static const TEAM:int = 4;
      
      public static const NOVICE:int = 5;
      
      public static const GUDIE_ARENA:int = 6;
      
      public static const GUDIE_ARENA2:int = 10;
      
      public static const GUDIE_ARENA3:int = 11;
      
      public static const GUDIE_ARENA4:int = 12;
      
      public static const GUDIE_ARENA5:int = 13;
      
      public static const GUIDE_NEW_ARENA1:int = 14;
      
      public static const GUIDE_NEW_ARENA2:int = 15;
      
      public static const GUIDE_NEW_ARENA3:int = 16;
      
      public static const BIG_LOBBY:int = 7;
      
      public static const PLANT:int = 8;
      
      public static const COPY:int = 9;
      
      public function SceneType()
      {
         super();
      }
      
      public static function getFromServerType(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = 1;
               break;
            case 1:
               _loc2_ = 3;
               break;
            case 2:
               _loc2_ = 4;
               break;
            case 3:
               _loc2_ = 8;
               break;
            case 4:
               _loc2_ = 9;
         }
         return _loc2_;
      }
      
      public static function getServerType(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1 - 1)
         {
            case 0:
               _loc2_ = 0;
               break;
            case 2:
               _loc2_ = 1;
               break;
            case 3:
               _loc2_ = 2;
               break;
            case 7:
               _loc2_ = 3;
               break;
            case 8:
               _loc2_ = 4;
         }
         return _loc2_;
      }
      
      public static function getTypeName(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1 - 1)
         {
            case 0:
               _loc2_ = "普通";
               break;
            case 1:
               _loc2_ = "对战地图";
               break;
            case 2:
               _loc2_ = "家园";
               break;
            case 3:
               _loc2_ = "组队";
               break;
            case 4:
               _loc2_ = "新手任务";
               break;
            case 5:
               _loc2_ = "新手教学对战";
               break;
            case 6:
               _loc2_ = "大地图";
               break;
            case 7:
               _loc2_ = "种植园";
               break;
            case 8:
               _loc2_ = "副本地图";
               break;
            case 9:
               _loc2_ = "新手教学对战2";
               break;
            case 10:
               _loc2_ = "新手教学对战3";
               break;
            case 11:
               _loc2_ = "新手教学对战4";
               break;
            case 12:
               _loc2_ = "新手教学对战5";
         }
         return _loc2_;
      }
      
      public static function hasPath(param1:int) : Boolean
      {
         return !(param1 == 2 || param1 == 6 || param1 == 10 || param1 == 11 || param1 == 12 || param1 == 13 || param1 == 14 || param1 == 15 || param1 == 16);
      }
      
      public static function getTypeFromMapID(param1:uint) : int
      {
         if(param1 > 0 && param1 < 10)
         {
            return 5;
         }
         if(param1 >= 10 && param1 < 10000)
         {
            return 1;
         }
         if(param1 >= 50000 && param1 < 60000)
         {
            return 3;
         }
         if(param1 >= 60000 && param1 < 70000)
         {
            return 4;
         }
         if(param1 >= 70000 && param1 < 80000)
         {
            return 8;
         }
         if(param1 >= 100000)
         {
            return 2;
         }
         return 0;
      }
   }
}

