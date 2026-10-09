package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.MonsterInfo;
   
   public class MonsterConfig
   {
      
      private static var _xml:XML;
      
      private static var _monsterInfoList:Vector.<MonsterInfo>;
      
      private static var _xmlClass:Class = MonsterConfig__xmlClass;
      
      initlize();
      
      public function MonsterConfig()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc4_:MonsterInfo = null;
         var _loc3_:XML = null;
         var _loc2_:XML = XML(new _xmlClass());
         var _loc1_:XMLList = _loc2_.child("Monster");
         _monsterInfoList = Vector.<MonsterInfo>([]);
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new MonsterInfo();
            _loc4_.numbersID = uint(_loc3_.@NumbersID);
            _loc4_.id = uint(_loc3_.@Id);
            _monsterInfoList.push(_loc4_);
         }
      }
      
      public static function getList() : Vector.<MonsterInfo>
      {
         return _monsterInfoList;
      }
   }
}

