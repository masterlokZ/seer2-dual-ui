package data.pet
{
   public class ItemData
   {
      
      public var id:int;
      
      public var name:String;
      
      public var count:int;
      
      public var icon:String;
      
      public var tips:String;
      
      public function ItemData()
      {
         super();
      }
      
      public static function from(param1:Object) : ItemData
      {
         var _loc2_:ItemData = new ItemData();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.count = param1.count;
         _loc2_.icon = param1.icon;
         _loc2_.tips = param1.tips;
         return _loc2_;
      }
      
      public static function clone(param1:ItemData) : ItemData
      {
         var _loc2_:ItemData = new ItemData();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.count = param1.count;
         _loc2_.icon = param1.icon;
         _loc2_.tips = param1.tips;
         return _loc2_;
      }
   }
}

