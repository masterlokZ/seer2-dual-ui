package data.pet
{
   public class ArenaData
   {
      
      public var left:TeamData;
      
      public var right:TeamData;
      
      public var round:int;
      
      public var mapSwf:String;
      
      public var mapSound:String;
      
      public var weatherIcon:String;
      
      public var weatherTips:String;
      
      public function ArenaData()
      {
         super();
      }
      
      public static function from(param1:Object) : ArenaData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ArenaData = new ArenaData();
         _loc2_.left = TeamData.from(param1.left);
         _loc2_.right = TeamData.from(param1.right);
         _loc2_.round = param1.round;
         _loc2_.mapSwf = param1.mapSwf;
         _loc2_.mapSound = param1.mapSound;
         _loc2_.weatherIcon = param1.weatherIcon;
         _loc2_.weatherTips = param1.weatherTips;
         return _loc2_;
      }
      
      public static function clone(param1:ArenaData) : ArenaData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ArenaData = new ArenaData();
         _loc2_.left = TeamData.clone(param1.left);
         _loc2_.right = TeamData.clone(param1.right);
         _loc2_.round = param1.round;
         _loc2_.mapSwf = param1.mapSwf;
         _loc2_.mapSound = param1.mapSound;
         _loc2_.weatherIcon = param1.weatherIcon;
         _loc2_.weatherTips = param1.weatherTips;
         return _loc2_;
      }
   }
}

