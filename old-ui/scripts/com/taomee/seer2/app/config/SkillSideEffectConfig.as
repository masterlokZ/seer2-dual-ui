package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.skill.SkillSideEffectDefinition;
   import org.taomee.ds.HashMap;
   import seer2.next.entry.DynConfig;
   
   public class SkillSideEffectConfig
   {
      
      private static var _map:HashMap;
      
      private static var _buffConfigXML:XML;
      
      private static var _buffXmlClass:Class = SkillSideEffectConfig__buffXmlClass;
      
      initialize();
      
      public function SkillSideEffectConfig()
      {
         super();
      }
      
      public static function initialize() : void
      {
         var _loc1_:XML = null;
         _map = new HashMap();
         _buffConfigXML = DynConfig.buffConfigXML || XML(new _buffXmlClass());
         var _loc2_:XMLList = _buffConfigXML.descendants("buff");
         for each(_loc1_ in _loc2_)
         {
            addDefinition(uint(_loc1_.@Id),String(_loc1_.@name),String(_loc1_.@description),uint(_loc1_.@flag));
         }
      }
      
      private static function addDefinition(param1:uint, param2:String, param3:String, param4:uint) : void
      {
         var _loc5_:SkillSideEffectDefinition = new SkillSideEffectDefinition(param1,param2,param3,param4 == 1);
         _map.add(param1,_loc5_);
      }
      
      public static function contains(param1:uint) : Boolean
      {
         if(_map.containsKey(param1))
         {
            return true;
         }
         return false;
      }
      
      public static function getName(param1:uint) : String
      {
         var _loc2_:SkillSideEffectDefinition = null;
         if(contains(param1))
         {
            _loc2_ = _map.getValue(param1);
            return _loc2_.name;
         }
         return "";
      }
      
      public static function getDescription(param1:uint) : String
      {
         var _loc2_:SkillSideEffectDefinition = null;
         if(contains(param1))
         {
            _loc2_ = _map.getValue(param1);
            return _loc2_.description;
         }
         return "";
      }
      
      public static function getAllSideEffectDefinition() : Vector.<SkillSideEffectDefinition>
      {
         var _loc3_:SkillSideEffectDefinition = null;
         var _loc2_:Vector.<SkillSideEffectDefinition> = new Vector.<SkillSideEffectDefinition>();
         var _loc1_:Array = _map.getValues();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isShow == true)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getSideEffectIdArr(param1:uint) : Array
      {
         switch(int(param1) - 3)
         {
            case 0:
               return getBadEffectIdArr();
            case 1:
               return getAbnormalEffectIdArr();
            case 2:
               return getEnvironmentEffectIdArr();
            default:
               return null;
         }
      }
      
      private static function getBadEffectIdArr() : Array
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = [];
         var _loc1_:Array = _map.getKeys();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ < 2000 && _loc3_ >= 1000)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private static function getAbnormalEffectIdArr() : Array
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = [];
         var _loc1_:Array = _map.getKeys();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ < 1000 && _loc3_ >= 1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private static function getEnvironmentEffectIdArr() : Array
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = [];
         var _loc1_:Array = _map.getKeys();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ < 21000 && _loc3_ >= 20001)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function parseBuffConfigXml(param1:XML) : void
      {
         var _loc2_:XML = null;
         for each(_loc2_ in param1.descendants("buff"))
         {
            addDefinition(uint(_loc2_.@Id),String(_loc2_.@name),String(_loc2_.@description),uint(_loc2_.@flag));
         }
      }
   }
}

