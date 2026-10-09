package data.pet
{
   public class BuffData
   {
      
      public var id:int;
      
      public var name:String;
      
      public var icon:String;
      
      public var tips:String;
      
      public var count:int;
      
      public function BuffData()
      {
         super();
      }
      
      public static function from(param1:Object) : BuffData
      {
         var _loc2_:BuffData = new BuffData();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.icon = param1.icon;
         _loc2_.tips = param1.tips;
         _loc2_.count = param1.count;
         return _loc2_;
      }
      
      public static function clone(param1:BuffData) : BuffData
      {
         var _loc2_:BuffData = new BuffData();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.icon = param1.icon;
         _loc2_.tips = param1.tips;
         _loc2_.count = param1.count;
         return _loc2_;
      }
   }
}

