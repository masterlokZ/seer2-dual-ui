package com.taomee.seer2.app.gameRule.spt.support
{
   public class SptConfigInfoManager
   {
      
      private static var _xml:XML;
      
      public static var bossInfoVec:Vector.<SptBossInfo>;
      
      private static var _xmlClass:Class = SptConfigInfoManager__xmlClass;
      
      setup();
      
      public function SptConfigInfoManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         var _loc3_:SptBossInfo = null;
         bossInfoVec = new Vector.<SptBossInfo>();
         _xml = XML(new _xmlClass());
         var _loc2_:XMLList = _xml.descendants("Boss");
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = new SptBossInfo();
            _loc3_.id = _loc1_.attribute("BossID");
            _loc3_.level = _loc1_.attribute("BossLV");
            bossInfoVec.push(_loc3_);
         }
      }
      
      public static function getSptBossLevel(param1:uint) : uint
      {
         var _loc3_:SptBossInfo = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in bossInfoVec)
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = _loc3_.level;
            }
         }
         return _loc2_;
      }
   }
}

