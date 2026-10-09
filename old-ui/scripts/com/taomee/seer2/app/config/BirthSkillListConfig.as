package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.BirthSkillInfo;
   import org.taomee.ds.HashMap;
   
   public class BirthSkillListConfig
   {
      
      private static var _xmlClass:Class = BirthSkillListConfig__xmlClass;
      
      private static var _birthSkillList:HashMap = new HashMap();
      
      initlize();
      
      public function BirthSkillListConfig()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc6_:BirthSkillInfo = null;
         var _loc5_:XML = null;
         var _loc2_:XMLList = null;
         var _loc1_:XML = null;
         var _loc4_:XML = XML(new _xmlClass());
         var _loc3_:XMLList = _loc4_.child("Monster");
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = new BirthSkillInfo();
            _loc6_.id = uint(_loc5_.@ID);
            _loc2_ = _loc5_.descendants("Item");
            for each(_loc1_ in _loc2_)
            {
               _loc6_.skillList.push(uint(_loc1_.@skillid));
               if(_loc6_.id == 15)
               {
                  _loc6_.skillList[0] = 10068;
               }
            }
            _birthSkillList.add(_loc6_.id,_loc6_);
         }
      }
      
      public static function getInfo(param1:uint) : BirthSkillInfo
      {
         if(_birthSkillList.containsKey(param1))
         {
            return _birthSkillList.getValue(param1);
         }
         return null;
      }
      
      public static function getList() : Vector.<BirthSkillInfo>
      {
         return Vector.<BirthSkillInfo>(_birthSkillList.getValues());
      }
   }
}

