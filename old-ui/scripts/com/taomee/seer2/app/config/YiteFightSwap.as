package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.YiteFightSwapInfo;
   
   public class YiteFightSwap
   {
      
      private static var _xml:XML;
      
      private static var _infoVec:Array;
      
      private static var _petInfoVec:Array;
      
      private static var _petGadVec:Array;
      
      private static var _xmlClass:Class = YiteFightSwap__xmlClass;
      
      setup();
      
      public function YiteFightSwap()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc7_:YiteFightSwapInfo = null;
         var _loc9_:XML = null;
         var _loc8_:uint = 0;
         var _loc3_:String = null;
         var _loc2_:uint = 0;
         var _loc5_:uint = 0;
         var _loc4_:uint = 0;
         var _loc1_:uint = 0;
         _xml = XML(new _xmlClass());
         _infoVec = [];
         _petInfoVec = [];
         _petGadVec = [];
         var _loc6_:XMLList = _xml.descendants("swap");
         for each(_loc9_ in _loc6_)
         {
            _loc7_ = new YiteFightSwapInfo();
            _loc8_ = uint(_loc9_.attribute("type"));
            _loc3_ = String(_loc9_.attribute("name"));
            _loc2_ = uint(_loc9_.attribute("swapCount"));
            _loc5_ = uint(_loc9_.attribute("id"));
            _loc4_ = uint(_loc9_.attribute("isPet"));
            _loc1_ = uint(_loc9_.attribute("swapID"));
            _loc7_.type = _loc8_;
            _loc7_.name = _loc3_;
            _loc7_.swapCount = _loc2_;
            _loc7_.id = _loc5_;
            _loc7_.isPet = _loc4_;
            _loc7_.swapId = _loc1_;
            if(_loc8_ == 2)
            {
               _infoVec.push(_loc7_);
            }
            else if(_loc8_ == 1)
            {
               _petInfoVec.push(_loc7_);
            }
            else if(_loc8_ == 3)
            {
               _petGadVec.push(_loc7_);
            }
         }
      }
      
      public static function getInfoVec(param1:uint) : Array
      {
         if(param1 == 1)
         {
            return _petInfoVec;
         }
         if(param1 == 2)
         {
            return _infoVec;
         }
         if(param1 == 3)
         {
            return _petGadVec;
         }
         return null;
      }
   }
}

