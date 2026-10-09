package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.EquipElementInfo;
   import org.taomee.ds.HashMap;
   
   public class EquipElementConfig
   {
      
      private static var _xml:XML;
      
      private static var _xmlClass:Class = EquipElementConfig__xmlClass;
      
      private static var _mapList:Vector.<HashMap> = Vector.<HashMap>([]);
      
      private static var _itemMapList:Vector.<HashMap> = Vector.<HashMap>([]);
      
      setup();
      
      public function EquipElementConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc7_:EquipElementInfo = null;
         var _loc10_:XML = null;
         var _loc9_:String = null;
         var _loc4_:Array = null;
         var _loc3_:Array = null;
         var _loc6_:int = 0;
         var _loc5_:String = null;
         var _loc1_:String = null;
         var _loc15_:uint = 0;
         var _loc17_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:String = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc11_:HashMap = null;
         var _loc12_:int = 0;
         var _loc2_:HashMap = null;
         var _loc16_:int = 0;
         _xml = XML(new _xmlClass());
         var _loc8_:XMLList = _xml.descendants("equip");
         for each(_loc10_ in _loc8_)
         {
            _loc7_ = new EquipElementInfo();
            _loc9_ = String(_loc10_.attribute("idList"));
            _loc4_ = _loc9_.split(",");
            _loc3_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc3_.push(uint(_loc4_[_loc6_]));
               _loc6_++;
            }
            _loc5_ = String(_loc10_.attribute("elementType"));
            _loc1_ = String(_loc10_.attribute("elementCount"));
            _loc15_ = uint(_loc10_.attribute("equipIcon"));
            _loc17_ = String(_loc10_.attribute("itemIdList"));
            _loc13_ = uint(_loc10_.attribute("levelMax"));
            _loc14_ = String(_loc10_.attribute("nextObj"));
            _loc20_ = _loc17_.split(",");
            _loc21_ = [];
            _loc18_ = 0;
            while(_loc18_ < _loc20_.length)
            {
               _loc21_.push(uint(_loc20_[_loc18_]));
               _loc18_++;
            }
            _loc19_ = String(_loc10_.attribute("obj"));
            _loc7_.idVec = Vector.<uint>(_loc3_);
            _loc7_.elementCount = updateCount(_loc1_);
            _loc7_.equipIcon = _loc15_;
            _loc7_.elementType = updateType(_loc5_);
            _loc7_.itemVec = Vector.<uint>(_loc21_);
            _loc7_.nextObj = _loc14_;
            _loc7_.levelMax = _loc13_;
            _loc7_.obj = _loc19_;
            _loc11_ = new HashMap();
            _loc12_ = 0;
            while(_loc12_ < _loc7_.idVec.length)
            {
               _loc11_.add(_loc7_.idVec[_loc12_],_loc7_);
               _loc12_++;
            }
            _mapList.push(_loc11_);
            _loc2_ = new HashMap();
            _loc16_ = 0;
            while(_loc16_ < _loc7_.itemVec.length)
            {
               _loc2_.add(_loc7_.itemVec[_loc16_],_loc7_);
               _loc16_++;
            }
            _itemMapList.push(_loc2_);
         }
      }
      
      private static function updateCount(param1:String) : Array
      {
         var _loc7_:Array = null;
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = param1.split("|");
         var _loc6_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc7_ = String(_loc5_[_loc3_]).split(",");
            _loc2_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc7_.length)
            {
               _loc2_.push(Number(_loc7_[_loc4_]));
               _loc4_++;
            }
            _loc6_.push(_loc2_);
            _loc3_++;
         }
         return _loc6_;
      }
      
      private static function updateType(param1:String) : Array
      {
         var _loc7_:Array = null;
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = param1.split("|");
         var _loc6_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc7_ = String(_loc5_[_loc3_]).split(",");
            _loc2_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc7_.length)
            {
               _loc2_.push(uint(_loc7_[_loc4_]));
               _loc4_++;
            }
            _loc6_.push(_loc2_);
            _loc3_++;
         }
         return _loc6_;
      }
      
      public static function getInfo(param1:uint) : EquipElementInfo
      {
         var _loc2_:HashMap = null;
         for each(_loc2_ in _mapList)
         {
            if(_loc2_.containsKey(param1))
            {
               return _loc2_.getValue(param1);
            }
         }
         return null;
      }
      
      public static function getItemInfo(param1:uint) : EquipElementInfo
      {
         var _loc2_:HashMap = null;
         for each(_loc2_ in _itemMapList)
         {
            if(_loc2_.containsKey(param1))
            {
               return _loc2_.getValue(param1);
            }
         }
         return null;
      }
   }
}

