package com.taomee.seer2.app.config
{
   import org.taomee.ds.HashMap;
   import seer2.next.entry.DynConfig;
   
   public class PetSkinDefineConfig
   {
      
      private static var _skinDefineMap:HashMap;
      
      private static var _skinNameMap:HashMap;
      
      private static var _xmlClass:Class = PetSkinDefineConfig__xmlClass;
      
      setup();
      
      public function PetSkinDefineConfig()
      {
         super();
      }
      
      public static function initialize() : void
      {
         setup();
      }
      
      private static function setup() : void
      {
         var tempArr:Array = null;
         var resId:* = 0;
         var skinId:* = 0;
         var tempMap:HashMap = null;
         var _xml:XML = null;
         var _skinXml:XML = DynConfig.petSkinDefineConfigXML || XML(new _xmlClass());
         var _skinList:XMLList = _skinXml.descendants("pet");
         _skinDefineMap = new HashMap();
         _skinNameMap = new HashMap();
         for each(_xml in _skinList)
         {
            tempArr = null;
            resId = uint(_xml.@resourceId);
            skinId = uint(_xml.@skinId);
            tempMap = null;
            if(_skinDefineMap.containsKey(resId))
            {
               tempArr = _skinDefineMap.remove(resId) as Array;
            }
            else
            {
               tempArr = [resId];
            }
            tempArr.push(skinId);
            _skinDefineMap.add(uint(_xml.@resourceId),tempArr);
            if(_skinNameMap.containsKey(resId))
            {
               tempMap = _skinNameMap.remove(resId) as HashMap;
            }
            else
            {
               tempMap = new HashMap();
            }
            tempMap.add(skinId,_xml.@skinname);
            _skinNameMap.add(resId,tempMap);
         }
      }
      
      public static function getPetSkinDefine(petId:uint) : Array
      {
         if(_skinDefineMap.containsKey(petId))
         {
            return _skinDefineMap.getValue(petId) as Array;
         }
         return [petId];
      }
      
      public static function getSkinName(petId:uint, skinId:uint) : String
      {
         var nameMap:HashMap = null;
         if(_skinNameMap.containsKey(petId))
         {
            nameMap = _skinNameMap.getValue(petId) as HashMap;
            if(nameMap && nameMap.containsKey(skinId))
            {
               return nameMap.getValue(skinId);
            }
            return "未定义该皮肤";
         }
         return "未知";
      }
   }
}

