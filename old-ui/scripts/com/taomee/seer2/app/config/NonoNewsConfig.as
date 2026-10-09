package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.activity.onlineReward.NonoNewsInfo;
   
   public class NonoNewsConfig
   {
      
      private static var _xml:XML;
      
      private static var _nonoNewsInfoVec:Vector.<NonoNewsInfo>;
      
      private static var _xmlClass:Class = NonoNewsConfig__xmlClass;
      
      setup();
      
      public function NonoNewsConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc4_:NonoNewsInfo = null;
         var _loc6_:XML = null;
         var _loc5_:String = null;
         var _loc2_:String = null;
         var _loc1_:String = null;
         _xml = XML(new _xmlClass());
         _nonoNewsInfoVec = Vector.<NonoNewsInfo>([]);
         var _loc3_:XMLList = _xml.descendants("nono");
         for each(_loc6_ in _loc3_)
         {
            _loc4_ = new NonoNewsInfo();
            _loc5_ = String(_loc6_.attribute("content"));
            _loc2_ = String(_loc6_.attribute("type"));
            _loc1_ = String(_loc6_.attribute("transport"));
            _loc4_.content = _loc5_;
            _loc4_.type = _loc2_;
            _loc4_.transport = _loc1_;
            _nonoNewsInfoVec.push(_loc4_);
         }
      }
      
      public static function getNonoNewsInfoVec() : Vector.<NonoNewsInfo>
      {
         if(_nonoNewsInfoVec.length < 1)
         {
            return null;
         }
         return _nonoNewsInfoVec;
      }
   }
}

