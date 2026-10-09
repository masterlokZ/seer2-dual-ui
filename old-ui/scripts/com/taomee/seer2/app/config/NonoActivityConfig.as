package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.NonoActivityInfo;
   import seer2.next.entry.DynConfig;
   
   public class NonoActivityConfig
   {
      
      private static var _xml:XML;
      
      private static var _nonoInfoVec:Vector.<NonoActivityInfo>;
      
      private static var _xmlClass:Class = NonoActivityConfig__xmlClass;
      
      setup();
      
      public function NonoActivityConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         loadConfig(DynConfig.nonoActivityConfigXML || XML(new _xmlClass()));
      }
      
      public static function loadConfig(xml:XML) : void
      {
         var _loc6_:NonoActivityInfo = null;
         var _loc8_:XML = null;
         var _loc7_:String = null;
         var _loc3_:uint = 0;
         var _loc2_:String = null;
         var _loc4_:String = null;
         _xml = xml;
         _nonoInfoVec = Vector.<NonoActivityInfo>([]);
         var _loc5_:XMLList = _xml.descendants("activity");
         for each(_loc8_ in _loc5_)
         {
            _loc6_ = new NonoActivityInfo();
            _loc7_ = String(_loc8_.attribute("content"));
            _loc3_ = uint(_loc8_.attribute("isShowGo"));
            _loc2_ = String(_loc8_.attribute("goType"));
            _loc4_ = String(_loc8_.attribute("goContent"));
            _loc6_.content = _loc7_;
            _loc6_.isShowGo = _loc3_;
            _loc6_.goType = _loc2_;
            _loc6_.goContent = _loc4_;
            _nonoInfoVec.push(_loc6_);
         }
      }
      
      public static function getNonoInfoVec() : Vector.<NonoActivityInfo>
      {
         if(_nonoInfoVec.length < 1)
         {
            return null;
         }
         return _nonoInfoVec;
      }
   }
}

