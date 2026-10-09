package com.taomee.seer2.app.config
{
   import org.taomee.ds.HashMap;
   
   public class PartyNotisiConfig
   {
      
      private static var _xml:XML;
      
      private static var _hashMap:HashMap;
      
      private static var _xmlClass:Class = PartyNotisiConfig__xmlClass;
      
      initlize();
      
      public function PartyNotisiConfig()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc5_:uint = 0;
         var _loc4_:String = null;
         var _loc1_:XML = null;
         var _loc3_:XML = XML(new _xmlClass());
         var _loc2_:XMLList = _loc3_.descendants("con");
         _hashMap = new HashMap();
         for each(_loc1_ in _loc2_)
         {
            _loc5_ = uint(_loc1_.attribute("id"));
            _loc4_ = String(_loc1_.attribute("content"));
            _hashMap.add(_loc5_,_loc4_);
         }
      }
      
      public static function getStr(param1:uint) : String
      {
         return _hashMap.getValue(param1);
      }
   }
}

