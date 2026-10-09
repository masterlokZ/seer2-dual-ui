package com.taomee.seer2.core.module
{
   import flash.utils.getDefinitionByName;
   import org.taomee.ds.HashMap;
   
   public class ModulesToRemoveXMLInfo
   {
      
      private static var _modulesToReomve:HashMap;
      
      private static var xmlClass:Class = ModulesToRemoveXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function ModulesToRemoveXMLInfo()
      {
         super();
      }
      
      private static function init() : void
      {
         var _loc5_:XML = null;
         var _loc4_:String = null;
         var _loc1_:String = null;
         _modulesToReomve = new HashMap();
         var _loc3_:XMLList = xml.item;
         var _loc2_:int = 0;
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = _loc5_.@moduleName;
            _loc1_ = _loc5_.@tip;
            _modulesToReomve.add(_loc4_,_loc1_);
         }
      }
      
      public static function checkIsModuleToRemove(param1:String) : Boolean
      {
         var _loc2_:String = null;
         if(_modulesToReomve == null)
         {
            init();
         }
         if(_modulesToReomve.getValue(param1) != null)
         {
            _loc2_ = String(_modulesToReomve.getValue(param1));
            getDefinitionByName("com.taomee.seer2.app.popup.AlertManager").showAlert(_loc2_);
            return true;
         }
         return false;
      }
   }
}

