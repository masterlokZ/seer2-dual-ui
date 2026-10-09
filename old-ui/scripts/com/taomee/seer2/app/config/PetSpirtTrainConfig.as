package com.taomee.seer2.app.config
{
   import org.taomee.ds.HashMap;
   
   public class PetSpirtTrainConfig
   {
      
      private static var _configXML:XML;
      
      private static var _introdueInfo:Array;
      
      private static var _titleInfo:HashMap;
      
      private static var _xmlClass:Class = PetSpirtTrainConfig__xmlClass;
      
      setup();
      
      public function PetSpirtTrainConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc2_:Object = null;
         var _loc1_:XML = null;
         var _loc3_:XML = null;
         _configXML = XML(new _xmlClass());
         _introdueInfo = [];
         _titleInfo = new HashMap();
         for each(_loc1_ in _configXML["introduce"]["item"])
         {
            _loc2_ = {};
            _loc2_["id"] = int(_loc1_.@id);
            _loc2_["isNew"] = int(_loc1_.@isNew);
            _loc2_["isHot"] = int(_loc1_.@isHot);
            _loc2_["go"] = String(_loc1_.@go);
            _introdueInfo.push(_loc2_);
         }
         for each(_loc3_ in _configXML["title"]["item"])
         {
            _loc2_ = {};
            _loc2_["resId"] = int(_loc3_.@resId);
            _loc2_["skillInfo"] = String(_loc3_.@skillInfo);
            _loc2_["charactor"] = String(_loc3_.@charactor);
            _loc2_["getWay"] = String(_loc3_.@getWay);
            _loc2_["go"] = String(_loc3_.@go);
            _titleInfo.add(_loc2_["resId"],_loc2_);
         }
      }
      
      public static function get introdueInfo() : Array
      {
         return _introdueInfo;
      }
      
      public static function getTitleByResId(param1:int) : Object
      {
         return _titleInfo.getValue(param1);
      }
   }
}

