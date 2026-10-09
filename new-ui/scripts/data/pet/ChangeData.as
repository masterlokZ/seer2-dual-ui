package data.pet
{
   public class ChangeData
   {
      
      public static const DEFAULT:int = 0;
      
      public static const REPLACE:int = 1;
      
      public static const MORPH:int = 2;
      
      public var left:int;
      
      public var right:int;
      
      public function ChangeData()
      {
         super();
      }
      
      public static function from(param1:Object) : ChangeData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ChangeData = new ChangeData();
         _loc2_.left = param1.left;
         _loc2_.right = param1.right;
         return _loc2_;
      }
      
      public static function clone(param1:ChangeData) : ChangeData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ChangeData = new ChangeData();
         _loc2_.left = param1.left;
         _loc2_.right = param1.right;
         return _loc2_;
      }
   }
}

