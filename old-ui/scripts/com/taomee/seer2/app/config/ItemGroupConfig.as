package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.inventory.ItemDescription;
   import com.taomee.seer2.app.inventory.ItemGroup;
   import org.taomee.ds.HashMap;
   
   public class ItemGroupConfig
   {
      
      private static var _xml:XML;
      
      private static var _molecurlarPwdMap:HashMap;
      
      private static var _giftMap:HashMap;
      
      private static var _xmlClass:Class = ItemGroupConfig__xmlClass;
      
      initialize();
      
      public function ItemGroupConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _xml = XML(new _xmlClass());
         _molecurlarPwdMap = new HashMap();
         _giftMap = new HashMap();
         parseXml(_molecurlarPwdMap,"molecularPassword");
         parseXml(_giftMap,"dailyQuest");
      }
      
      private static function parseXml(param1:HashMap, param2:String) : void
      {
         var _loc9_:XML = null;
         var _loc8_:XML = null;
         var _loc5_:int = 0;
         var _loc4_:Vector.<ItemDescription> = null;
         var _loc7_:XML = null;
         var _loc6_:Boolean = false;
         var _loc3_:ItemDescription = null;
         for each(_loc9_ in _xml.children())
         {
            if(_loc9_.attribute("name").toString() == param2)
            {
               for each(_loc8_ in _loc9_.child("group"))
               {
                  _loc5_ = int(_loc8_.attribute("id"));
                  _loc4_ = new Vector.<ItemDescription>();
                  for each(_loc7_ in _loc8_.child("item"))
                  {
                     _loc6_ = Boolean(_loc7_.attribute("isPet")) && String(_loc7_.attribute("isPet")) == "true";
                     _loc3_ = new ItemDescription(int(_loc7_.attribute("id")),int(_loc7_.attribute("count")),0,_loc6_);
                     _loc4_.push(_loc3_);
                  }
                  param1.add(_loc5_,new ItemGroup(_loc5_,param2,_loc4_));
               }
               return;
            }
         }
      }
      
      private static function getMap(param1:String) : HashMap
      {
         var _loc2_:HashMap = null;
         switch(param1)
         {
            case "molecularPassword":
               _loc2_ = _molecurlarPwdMap;
               break;
            case "dailyQuest":
               _loc2_ = _giftMap;
         }
         return _loc2_;
      }
      
      public static function getItemGroupVec(param1:String) : Vector.<ItemGroup>
      {
         var _loc3_:ItemGroup = null;
         var _loc2_:HashMap = getMap(param1);
         var _loc4_:Vector.<ItemGroup> = new Vector.<ItemGroup>();
         for each(_loc3_ in _loc2_.getValues())
         {
            _loc4_.push(_loc3_);
         }
         return _loc4_;
      }
      
      public static function getGroup(param1:String, param2:Vector.<ItemDescription>) : ItemGroup
      {
         var _loc4_:int = 0;
         var _loc3_:ItemGroup = null;
         var _loc5_:HashMap = getMap(param1);
         for each(_loc4_ in _loc5_.getKeys())
         {
            _loc3_ = _loc5_.getValue(_loc4_);
            if(_loc3_.contains(param2))
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

