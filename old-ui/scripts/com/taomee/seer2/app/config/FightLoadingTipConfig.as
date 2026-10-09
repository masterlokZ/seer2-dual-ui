package com.taomee.seer2.app.config
{
   public class FightLoadingTipConfig
   {
      
      private static var _configXML:XML;
      
      private static var arr:Array;
      
      private static var _xmlClass:Class = FightLoadingTipConfig__xmlClass;
      
      initialize();
      
      public function FightLoadingTipConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         arr = [];
         setup();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         _configXML = XML(new _xmlClass());
         var _loc2_:XMLList = _configXML.descendants("tip");
         for each(_loc1_ in _loc2_)
         {
            arr.push(_loc1_.@txt);
         }
      }
      
      public static function getTipList() : Array
      {
         return arr;
      }
   }
}

