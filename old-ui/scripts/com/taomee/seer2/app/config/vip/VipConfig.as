package com.taomee.seer2.app.config.vip
{
   public class VipConfig
   {
      
      private static var _data:Vector.<UnitInfo>;
      
      private static var _xmlClass:Class = VipConfig__xmlClass;
      
      setup();
      
      public function VipConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:UnitInfo = null;
         var _loc3_:XML = null;
         _data = new Vector.<UnitInfo>();
         var _loc2_:XML = XML(new _xmlClass());
         var _loc4_:XMLList = _loc2_.descendants("item");
         for each(_loc3_ in _loc4_)
         {
            _loc1_ = new UnitInfo();
            _loc1_.sort = int(_loc3_.@Sort);
            _loc1_.resId = int(_loc3_.@ResId);
            _loc1_.clickType = String(_loc3_.@ClickType);
            _loc1_.effect = String(_loc3_.@Effect);
            if(String(_loc3_.@Tip) != "")
            {
               _loc1_.tip = String(_loc3_.@Tip);
            }
            _data.push(_loc1_);
         }
      }
      
      public static function get data() : Vector.<UnitInfo>
      {
         return _data;
      }
      
      public static function getDataBySort(param1:int) : Vector.<UnitInfo>
      {
         var _loc3_:UnitInfo = null;
         var _loc2_:Vector.<UnitInfo> = new Vector.<UnitInfo>();
         for each(_loc3_ in _data)
         {
            if(_loc3_.sort == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

