package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.team.NewTeamInfo;
   import org.taomee.ds.HashMap;
   
   public class NewTeamQuestConfig
   {
      
      private static var _xml:XML;
      
      private static var _xmlClass:Class = NewTeamQuestConfig__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      setup();
      
      public function NewTeamQuestConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc2_:NewTeamInfo = null;
         var _loc3_:XML = null;
         _xml = XML(new _xmlClass());
         var _loc1_:XMLList = _xml.descendants("quest");
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = new NewTeamInfo();
            _loc2_.type = uint(_loc3_.attribute("type"));
            _loc2_.questId = uint(_loc3_.attribute("questId"));
            _loc2_.titleType = String(_loc3_.attribute("titleType"));
            _loc2_.titleContent = String(_loc3_.attribute("titleContent"));
            _loc2_.target = String(_loc3_.attribute("target"));
            _loc2_.exp = uint(_loc3_.attribute("exp"));
            _loc2_.point = uint(_loc3_.attribute("point"));
            _loc2_.activity = uint(_loc3_.attribute("activity"));
            _loc2_.money = uint(_loc3_.attribute("money"));
            _map.add(_loc2_.questId,_loc2_);
         }
      }
      
      public static function getTeamQuestInfo(param1:uint) : NewTeamInfo
      {
         return _map.getValue(param1);
      }
   }
}

