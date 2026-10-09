package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.activity.data.ActivityDefinition;
   import com.taomee.seer2.app.activity.data.ActivityPetDefinition;
   import org.taomee.ds.HashMap;
   
   public class ActivityConfig
   {
      
      private static var _configXML:XML;
      
      private static var _timeActivityMap:HashMap;
      
      private static var _timelessActivityMap:HashMap;
      
      private static var _activityPetMap:HashMap;
      
      private static var _activityProcessorMap:HashMap;
      
      private static var _xmlClass:Class = ActivityConfig__xmlClass;
      
      initialize();
      
      public function ActivityConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _timeActivityMap = new HashMap();
         _timelessActivityMap = new HashMap();
         _activityPetMap = new HashMap();
         _activityProcessorMap = new HashMap();
         setup();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         _configXML = XML(new _xmlClass());
         var _loc2_:XMLList = _configXML.descendants("activity");
         for each(_loc1_ in _loc2_)
         {
            initActivityPet(_loc1_);
            initActivityDefinition(_loc1_);
         }
      }
      
      private static function initActivityPet(param1:XML) : void
      {
         var _loc7_:XML = null;
         var _loc6_:uint = 0;
         var _loc3_:String = null;
         var _loc2_:Array = null;
         var _loc4_:XML = null;
         var _loc5_:XMLList = param1.descendants("activityPet");
         for each(_loc7_ in _loc5_)
         {
            _loc6_ = uint(_loc7_.@id);
            _loc3_ = _loc7_.@name;
            _loc2_ = [];
            for each(_loc4_ in _loc7_.descendants("slogan"))
            {
               _loc2_.push(String(_loc4_.@value));
            }
            addActivityPetDefinition(_loc6_,_loc3_,_loc2_);
         }
      }
      
      private static function initActivityDefinition(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = uint(param1.@ID);
         var _loc5_:String = param1.@processor;
         addActivityProcessor(_loc3_,_loc5_);
         var _loc4_:String = param1.@name;
         _loc2_ = int(param1.@circleType);
         if(_loc2_ == -1)
         {
            addTimelessActivity(_loc3_,_loc4_,_loc2_);
         }
         else
         {
            addTimeActivity(_loc3_,_loc4_,_loc2_,param1);
         }
      }
      
      private static function addTimelessActivity(param1:uint, param2:String, param3:int) : void
      {
         _timelessActivityMap.add(param1,new ActivityDefinition(param1,param2,param3,null,null,null));
      }
      
      private static function addTimeActivity(param1:uint, param2:String, param3:int, param4:XML) : void
      {
         var _loc7_:String = null;
         var _loc12_:XML = null;
         var _loc13_:String = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc14_:String = null;
         _loc7_ = param4.@circleDate;
         _loc7_ = _loc7_.replace(/ /g,"");
         var _loc6_:Array = _loc7_.split(",");
         var _loc9_:Array = [];
         var _loc8_:Array = [];
         var _loc5_:XMLList = param4.descendants("phase");
         for each(_loc12_ in _loc5_)
         {
            _loc10_ = String(_loc12_.@value);
            _loc10_ = _loc10_.replace(/ /g,"");
            _loc11_ = _loc10_.split(",");
            for each(_loc13_ in _loc11_)
            {
               _loc9_.push(_loc13_);
            }
            _loc14_ = _loc12_.@detail;
            _loc14_ = _loc14_.replace(/ /g,"");
            _loc11_ = _loc14_.split(",");
            for each(_loc13_ in _loc11_)
            {
               _loc8_.push(_loc13_);
            }
         }
         addTimeActivityDefinition(param1,param2,param3,_loc6_,_loc8_,_loc9_);
      }
      
      private static function addActivityProcessor(param1:uint, param2:String) : void
      {
         _activityProcessorMap.add(param1,param2);
      }
      
      private static function addTimeActivityDefinition(param1:uint, param2:String, param3:int, param4:Array, param5:Array, param6:Array) : void
      {
         _timeActivityMap.add(param1,new ActivityDefinition(param1,param2,param3,param4,param5,param6));
      }
      
      public static function getInprogressActivityVec() : Vector.<ActivityDefinition>
      {
         var _loc3_:ActivityDefinition = null;
         var _loc2_:Vector.<ActivityDefinition> = new Vector.<ActivityDefinition>();
         var _loc1_:Vector.<ActivityDefinition> = Vector.<ActivityDefinition>(_timeActivityMap.getValues());
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isEnterable())
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getTimelessActivityVec() : Vector.<ActivityDefinition>
      {
         return Vector.<ActivityDefinition>(_timelessActivityMap.getValues());
      }
      
      public static function getActivityProcessorName(param1:uint) : String
      {
         if(_activityProcessorMap.containsKey(param1))
         {
            return _activityProcessorMap.getValue(param1);
         }
         return null;
      }
      
      public static function getActivityById(param1:uint) : ActivityDefinition
      {
         if(_timeActivityMap.containsKey(param1))
         {
            return _timeActivityMap.getValue(param1);
         }
         return null;
      }
      
      private static function addActivityPetDefinition(param1:uint, param2:String, param3:Array) : void
      {
         _activityPetMap.add(param1,new ActivityPetDefinition(param1,param2,param3));
      }
      
      public static function getActivityPetDefinition(param1:int) : ActivityPetDefinition
      {
         if(_activityPetMap.containsKey(param1))
         {
            return _activityPetMap.getValue(param1) as ActivityPetDefinition;
         }
         return null;
      }
   }
}

