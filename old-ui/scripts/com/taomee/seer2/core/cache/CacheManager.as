package com.taomee.seer2.core.cache
{
   import org.taomee.ds.HashMap;
   
   public class CacheManager
   {
      
      private static var _cacheMap:HashMap = new HashMap();
      
      public function CacheManager()
      {
         super();
      }
      
      public static function getContent(param1:String, param2:String, param3:Function, param4:Function = null, param5:* = null, param6:int = 2, param7:Function = null, param8:Function = null) : void
      {
         getCacheImpl(param2).getContent(param1,getLoadType(param2),param3,param4,param5,param6,param7,param8);
      }
      
      public static function cancel(param1:String, param2:String, param3:Function) : void
      {
         getCacheImpl(param2).cancel(param1,param3);
      }
      
      public static function clear(param1:String) : void
      {
         getCacheImpl(param1).clear();
      }
      
      private static function getCacheImpl(param1:String) : CacheImpl
      {
         var _loc2_:CacheImpl = _cacheMap.getValue(param1);
         if(_loc2_ == null)
         {
            switch(param1)
            {
               case "phasor":
                  _loc2_ = new PhasorParse();
                  _loc2_.name = "item";
                  break;
               case "effect":
                  _loc2_ = new PhasorParse();
                  _loc2_.name = "effect";
                  break;
               case "pet":
                  _loc2_ = new PhasorParse();
                  _loc2_.name = "pet";
                  break;
               default:
                  _loc2_ = new CacheImpl();
            }
            _loc2_.maxCount = getMaxCount(param1);
            _cacheMap.add(param1,_loc2_);
         }
         return _loc2_;
      }
      
      private static function getLoadType(param1:String) : String
      {
         switch(param1)
         {
            case "equip":
               return "binary";
            case "phasor":
            case "effect":
            case "pet":
               break;
            case "sound":
               return "sound";
            default:
               return "";
         }
         return "domain";
      }
      
      private static function getMaxCount(param1:String) : int
      {
         switch(param1)
         {
            case "effect":
               return 100;
            case "equip":
               return 100;
            case "pet":
               return 50;
            case "phasor":
               return 100;
            case "sound":
               return 100;
            default:
               return 50;
         }
      }
   }
}

