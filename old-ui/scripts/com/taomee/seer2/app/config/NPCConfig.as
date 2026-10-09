package com.taomee.seer2.app.config
{
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import org.taomee.ds.HashMap;
   
   public class NPCConfig
   {
      
      private static var _xml:XML;
      
      private static var _hashMap:HashMap;
      
      private static var _class:Class = NPCConfig__class;
      
      setup();
      
      public function NPCConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         var _loc3_:int = 0;
         _hashMap = new HashMap();
         _xml = XML(new _class());
         var _loc2_:XMLList = _xml.descendants("npc");
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = int(_loc1_.attribute("id"));
            _hashMap.add(_loc3_,_loc1_);
         }
      }
      
      public static function getNPCDefinition(param1:int) : NpcDefinition
      {
         var _loc2_:XML = null;
         var _loc3_:NpcDefinition = null;
         if(_hashMap.containsKey(param1))
         {
            _loc2_ = _hashMap.getValue(param1);
            return new NpcDefinition(_loc2_);
         }
         return null;
      }
   }
}

