package com.taomee.seer2.app.config
{
   import org.taomee.ds.HashMap;
   
   public class ServerNameConfig
   {
      
      private static var _serverXML:XML;
      
      private static var _serverMap:HashMap;
      
      private static var _xmlClass:Class = ServerNameConfig__xmlClass;
      
      setup();
      
      public function ServerNameConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         var _loc4_:int = 0;
         var _loc3_:String = null;
         _serverMap = new HashMap();
         _serverXML = XML(new _xmlClass());
         var _loc2_:XMLList = _serverXML.descendants("node");
         for each(_loc1_ in _loc2_)
         {
            _loc4_ = int(_loc1_.attribute("id"));
            _loc3_ = _loc1_.attribute("name");
            _serverMap.add(_loc4_,_loc3_);
         }
      }
      
      public static function getServerName(param1:int) : String
      {
         if(_serverMap.containsKey(param1))
         {
            return _serverMap.getValue(param1);
         }
         return "未知号";
      }
   }
}

