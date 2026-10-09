package data.pet
{
   public class EventData
   {
      
      public static const HP_INCREASE:int = 1;
      
      public static const HP_DECREASE:int = 2;
      
      public static const ITEM_HP:int = 3;
      
      public static const ITEM_ANGER:int = 4;
      
      public static const CATCH_FAILED:int = 5;
      
      public static const CATCH_SUCCESS:int = 6;
      
      public static const PET_EXCHANGE:int = 7;
      
      public var type:int;
      
      public var side:int;
      
      public var change:int;
      
      public var delay:int;
      
      public function EventData()
      {
         super();
      }
      
      public static function from(param1:Object) : EventData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:EventData = new EventData();
         _loc2_.type = param1.type;
         _loc2_.side = param1.side;
         _loc2_.change = param1.change;
         _loc2_.delay = param1.delay;
         return _loc2_;
      }
      
      public static function clone(param1:EventData) : EventData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:EventData = new EventData();
         _loc2_.type = param1.type;
         _loc2_.side = param1.side;
         _loc2_.change = param1.change;
         _loc2_.delay = param1.delay;
         return _loc2_;
      }
   }
}

