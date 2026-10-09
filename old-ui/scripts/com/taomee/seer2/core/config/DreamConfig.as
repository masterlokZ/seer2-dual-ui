package com.taomee.seer2.core.config
{
   import org.taomee.ds.HashMap;
   
   public class DreamConfig
   {
      
      private static var _xml:XML;
      
      private static var _familyInfoVec:Vector.<FamilyInfo>;
      
      private static var _xmlClass:Class = DreamConfig__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      private static var _dreamMap:HashMap = new HashMap();
      
      private static var _isDreamMap:HashMap = new HashMap();
      
      setup();
      
      public function DreamConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc7_:DreamInfo = null;
         var _loc9_:uint = 0;
         var _loc8_:XMLList = null;
         var _loc3_:FamilyInfo = null;
         var _loc2_:Vector.<DreamInfo> = null;
         var _loc5_:XML = null;
         var _loc4_:XML = null;
         var _loc1_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc10_:Vector.<DreamItemInfo> = null;
         var _loc11_:Vector.<DreamPetInfo> = null;
         var _loc14_:Vector.<DreamPetInfo> = null;
         _xml = XML(new _xmlClass());
         var _loc6_:XMLList = _xml.descendants("family");
         _familyInfoVec = Vector.<FamilyInfo>([]);
         for each(_loc5_ in _loc6_)
         {
            _loc3_ = new FamilyInfo();
            _loc9_ = uint(_loc5_.attribute("id"));
            _loc8_ = _loc5_.descendants("map");
            _loc3_.isSwapPet = int(_loc5_.attribute("isSwapPet"));
            _loc3_.petType = int(_loc5_.attribute("petType"));
            _loc3_.itemIdList = String(_loc5_.attribute("itemIdList")).split(",");
            _loc3_.totalItemCountList = String(_loc5_.attribute("totalItemCountList")).split(",");
            _loc3_.clickMapIdList = String(_loc5_.attribute("clickMapIdList")).split(",");
            _loc3_.familyId = _loc9_;
            _familyInfoVec.push(_loc3_);
            _loc2_ = Vector.<DreamInfo>([]);
            for each(_loc4_ in _loc8_)
            {
               _loc7_ = new DreamInfo();
               _loc7_.familyId = _loc9_;
               _loc1_ = uint(_loc4_.attribute("id"));
               _loc12_ = uint(_loc4_.attribute("prevMapId"));
               _loc13_ = uint(_loc4_.attribute("fightIndex"));
               _loc7_.fightIndex = _loc13_;
               _loc7_.id = _loc1_;
               _loc7_.mapId = uint(_loc4_.attribute("mapId"));
               _loc7_.name = String(_loc4_.attribute("name"));
               _loc7_.isWelfare = uint(_loc4_.attribute("isWelfare"));
               _loc7_.prevMapId = _loc12_;
               _loc7_.monster = uint(_loc4_.attribute("monsterId"));
               _loc7_.monsterCount = uint(_loc4_.attribute("monsterCount"));
               _loc7_.present = String(_loc4_.attribute("present"));
               _loc7_.threeStar = String(_loc4_.attribute("threeStar"));
               _loc7_.nextIdList = String(_loc4_.attribute("nextId")).split(",");
               _loc10_ = Vector.<DreamItemInfo>([]);
               _loc11_ = Vector.<DreamPetInfo>([]);
               _loc14_ = Vector.<DreamPetInfo>([]);
               _loc7_.itemList = getItemList(_loc4_.descendants("item"),_loc10_);
               _loc7_.petList = getPetList(_loc4_.descendants("pet"),_loc11_,false);
               _loc7_.bossList = getPetList(_loc4_.descendants("boss"),_loc14_,true);
               _isDreamMap.add(_loc12_,_loc1_);
               _loc2_.push(_loc7_);
               _loc3_.mapInfoList = _loc2_;
               _map.add(_loc7_.mapId,_loc7_);
               _dreamMap.add(_loc7_.id,_loc7_);
            }
         }
      }
      
      private static function getItemList(param1:XMLList, param2:Vector.<DreamItemInfo>) : Vector.<DreamItemInfo>
      {
         var _loc4_:XML = null;
         var _loc3_:DreamItemInfo = null;
         for each(_loc4_ in param1)
         {
            _loc3_ = new DreamItemInfo();
            _loc3_.id = uint(_loc4_.attribute("id"));
            _loc3_.count = uint(_loc4_.attribute("count"));
            param2.push(_loc3_);
         }
         return param2;
      }
      
      private static function getPetList(param1:XMLList, param2:Vector.<DreamPetInfo>, param3:Boolean) : Vector.<DreamPetInfo>
      {
         var _loc5_:XML = null;
         var _loc4_:DreamPetInfo = null;
         for each(_loc5_ in param1)
         {
            _loc4_ = new DreamPetInfo();
            _loc4_.id = uint(_loc5_.attribute("id"));
            _loc4_.level = uint(_loc5_.attribute("level"));
            _loc4_.isBoss = param3;
            _loc4_.pointX = Number(_loc5_.attribute("pointX"));
            _loc4_.pointY = Number(_loc5_.attribute("pointY"));
            param2.push(_loc4_);
         }
         return param2;
      }
      
      public static function getFamily(param1:int) : FamilyInfo
      {
         var _loc2_:FamilyInfo = null;
         for each(_loc2_ in _familyInfoVec)
         {
            if(_loc2_.familyId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getFamilyMax() : int
      {
         return _familyInfoVec.length;
      }
      
      public static function getInfo(param1:uint) : DreamInfo
      {
         if(!_map.containsKey(param1))
         {
            return null;
         }
         return _map.getValue(param1);
      }
      
      public static function getMapInfo(param1:uint) : DreamInfo
      {
         if(!_dreamMap.containsKey(param1))
         {
            return null;
         }
         return _dreamMap.getValue(param1);
      }
      
      public static function isDream(param1:uint) : Boolean
      {
         if(_map.containsKey(param1))
         {
            return true;
         }
         return false;
      }
      
      public static function getDreamInfo(param1:uint) : DreamInfo
      {
         if(_isDreamMap.containsKey(param1))
         {
            return getInfo(_isDreamMap.getValue(param1));
         }
         return null;
      }
   }
}

