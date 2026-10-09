package com.taomee.seer2.app.config
{
   import org.taomee.ds.HashMap;
   
   public class TitleConfig
   {
      
      private static var _configXML:XML;
      
      private static var _map:HashMap;
      
      private static var _xmlClass:Class = TitleConfig__xmlClass;
      
      initialize();
      
      public function TitleConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _map = new HashMap();
         setup();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         _configXML = XML(new _xmlClass());
         var _loc2_:XMLList = _configXML.descendants("type");
         for each(_loc1_ in _loc2_)
         {
            _map.add(int(_loc1_.@id),_loc1_);
         }
      }
      
      public static function getList(param1:int) : Array
      {
         var _loc2_:XML = null;
         var _loc3_:XML = _map.getValue(param1);
         var _loc5_:XMLList = _loc3_.descendants("title");
         var _loc4_:Array = [];
         for each(_loc2_ in _loc5_)
         {
            _loc4_.push([_loc2_.@titleId,_loc2_.@titleName,_loc2_.@des]);
         }
         return _loc4_;
      }
   }
}

