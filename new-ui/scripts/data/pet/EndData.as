package data.pet
{
   public class EndData
   {
      
      public static const DEFAULT:int = 0;
      
      public static const HIDDEN:int = 2;
      
      public var winner:int;
      
      public var alert:int;
      
      public function EndData()
      {
         super();
      }
      
      public static function from(param1:Object) : EndData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:EndData = new EndData();
         _loc2_.winner = param1.winner;
         _loc2_.alert = param1.alert;
         return _loc2_;
      }
      
      public static function clone(param1:EndData) : EndData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:EndData = new EndData();
         _loc2_.winner = param1.winner;
         _loc2_.alert = param1.alert;
         return _loc2_;
      }
   }
}

