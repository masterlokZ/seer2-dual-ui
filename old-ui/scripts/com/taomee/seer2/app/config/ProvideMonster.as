package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.MonsterDayInfo;
   
   public class ProvideMonster
   {
      
      private static var _xml:XML;
      
      private static var _monsterInfoList:Vector.<MonsterDayInfo>;
      
      private static var _xmlClass:Class = ProvideMonster__xmlClass;
      
      initlize();
      
      public function ProvideMonster()
      {
         super();
      }
      
      private static function initlize() : void
      {
         var _loc4_:MonsterDayInfo = null;
         var _loc3_:XML = null;
         var _loc2_:XML = XML(new _xmlClass());
         var _loc1_:XMLList = _loc2_.child("Monster");
         _monsterInfoList = Vector.<MonsterDayInfo>([]);
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new MonsterDayInfo();
            _loc4_.numbersID = uint(_loc3_.@NumbersID);
            _loc4_.id = uint(_loc3_.@Id);
            _monsterInfoList.push(_loc4_);
         }
      }
      
      public static function getList() : Vector.<MonsterDayInfo>
      {
         return _monsterInfoList;
      }
   }
}

