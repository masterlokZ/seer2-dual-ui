package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.FreeUseItemInfo;
   
   public class FreeUseItemListConfig
   {
      
      private static var _xml:XML;
      
      private static var _infoVec:Vector.<FreeUseItemInfo>;
      
      private static var _timeStr:String;
      
      private static var _xmlClass:Class = FreeUseItemListConfig__xmlClass;
      
      setup();
      
      public function FreeUseItemListConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc4_:FreeUseItemInfo = null;
         var _loc6_:Array = null;
         var _loc5_:Array = null;
         var _loc2_:int = 0;
         var _loc1_:XML = null;
         _xml = XML(new _xmlClass());
         _infoVec = Vector.<FreeUseItemInfo>([]);
         var _loc3_:XMLList = _xml.descendants("item");
         for each(_loc1_ in _loc3_)
         {
            _loc4_ = new FreeUseItemInfo();
            _loc4_.idRuleList = [];
            _loc6_ = String(_loc1_.attribute("id")).split(";");
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length)
            {
               var _temp_4:* = (_loc6_[_loc2_] as String).split(",");
               _temp_4.push([uint((_loc5_ = _temp_4)[0]),int(_loc5_[1])]);
               _loc4_.idRuleList.push(_loc5_);
               _loc2_++;
            }
            _loc6_ = String(_loc1_.attribute("miBuyType")).split(",");
            _loc4_.miBuyType = [];
            _loc4_.miBuyType.push(int(_loc6_[0]),Boolean(int(_loc6_[1])),Boolean(int(_loc6_[2])));
            _loc4_.tip0 = String(_loc1_.attribute("tip0"));
            _loc4_.tip1 = String(_loc1_.attribute("tip1"));
            _loc4_.tip2 = String(_loc1_.attribute("tip2"));
            _infoVec.push(_loc4_);
         }
      }
      
      public static function getInfoVec() : Vector.<FreeUseItemInfo>
      {
         return _infoVec;
      }
   }
}

