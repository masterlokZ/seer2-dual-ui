package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.pet.PetFitDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import org.taomee.ds.HashMap;
   
   public class FitConfig
   {
      
      private static var _configXML:XML;
      
      private static var _idVec:Vector.<int>;
      
      private static var _skillIdMap:HashMap;
      
      private static var _petIdMap:HashMap;
      
      private static var _xmlClass:Class = FitConfig__xmlClass;
      
      initialize();
      
      public function FitConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _idVec = new Vector.<int>();
         _skillIdMap = new HashMap();
         _petIdMap = new HashMap();
         setup();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         _configXML = XML(new _xmlClass());
         initList(_configXML.attribute("list"));
         var _loc2_:XMLList = _configXML.descendants("fit");
         for each(_loc1_ in _loc2_)
         {
            initXML(_loc1_);
         }
      }
      
      private static function initList(param1:String) : void
      {
         var _loc2_:Array = param1.split("|");
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _idVec.push(_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      private static function initXML(param1:XML) : void
      {
         var _loc2_:PetFitDefinition = null;
         var _loc4_:uint = uint(param1.@skillId);
         var _loc3_:uint = uint(param1.@fatherId);
         if(_skillIdMap.containsKey(_loc4_) == false)
         {
            _loc2_ = new PetFitDefinition(param1.@id,param1.@fatherId,param1.@motherId,param1.@skillId,param1.@anger,param1.@type,param1.@content,param1.@special);
            _skillIdMap.add(_loc4_,_loc2_);
            _petIdMap.add(_loc3_,_loc2_);
         }
      }
      
      public static function isPetFit(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         if(_idVec.indexOf(param1) != -1)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public static function formPetIdGetPetFitDefinition(param1:uint) : PetFitDefinition
      {
         var _loc2_:PetFitDefinition = null;
         if(_petIdMap.containsKey(param1) == true)
         {
            _loc2_ = _petIdMap.getValue(param1);
         }
         return _loc2_;
      }
      
      public static function formSkillIdGetPetFitDefinition(param1:uint) : PetFitDefinition
      {
         var _loc2_:PetFitDefinition = null;
         if(_skillIdMap.containsKey(param1) == true)
         {
            _loc2_ = _skillIdMap.getValue(param1);
         }
         return _loc2_;
      }
      
      public static function checkPetType(param1:PetFitDefinition) : Boolean
      {
         if(param1.type != "void")
         {
            var _loc2_:String = param1.type;
            if("item" !== _loc2_)
            {
               return true;
            }
            return checkPetItem(param1.content);
         }
         return true;
      }
      
      private static function checkPetItem(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         if(ItemManager.getCollection(param1))
         {
            _loc2_ = ItemManager.getCollection(param1).quantity;
         }
         if(_loc2_ > 0)
         {
            return true;
         }
         return false;
      }
   }
}

