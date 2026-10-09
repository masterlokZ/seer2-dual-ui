package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.announcement.horn.HornInfo;
   
   public class HornConfig
   {
      
      private static var _xml:XML;
      
      private static var _hornInfoVec:Vector.<HornInfo>;
      
      private static var _xmlClass:Class = HornConfig__xmlClass;
      
      setup();
      
      public function HornConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc7_:HornInfo = null;
         var _loc9_:XML = null;
         var _loc8_:uint = 0;
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         var _loc5_:String = null;
         var _loc4_:String = null;
         var _loc1_:String = null;
         _xml = XML(new _xmlClass());
         _hornInfoVec = Vector.<HornInfo>([]);
         var _loc6_:XMLList = _xml.descendants("horns");
         for each(_loc9_ in _loc6_)
         {
            _loc7_ = new HornInfo();
            _loc8_ = uint(_loc9_.attribute("Week"));
            _loc3_ = uint(_loc9_.attribute("Time"));
            _loc2_ = uint(_loc9_.attribute("Minute"));
            _loc5_ = String(_loc9_.attribute("MouseClickType"));
            _loc4_ = String(_loc9_.attribute("Transport"));
            _loc1_ = String(_loc9_.attribute("Content"));
            _loc7_.week = _loc8_;
            _loc7_.time = _loc3_;
            _loc7_.minute = _loc2_;
            _loc7_.mouseClickType = _loc5_;
            _loc7_.transport = _loc4_;
            _loc7_.content = _loc1_;
            _hornInfoVec.push(_loc7_);
         }
      }
      
      public static function getHornInfoVec() : Vector.<HornInfo>
      {
         if(_hornInfoVec.length < 1)
         {
            return null;
         }
         return _hornInfoVec;
      }
   }
}

