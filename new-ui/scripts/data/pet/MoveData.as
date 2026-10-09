package data.pet
{
   public class MoveData
   {
      
      public var side:int;
      
      public var skill:String;
      
      public var category:String;
      
      public var damage:int;
      
      public var critical:int;
      
      public var miss:int;
      
      public var rate:int;
      
      public var soundUrl:String;
      
      public var effectUrl:String;
      
      public var hits:Vector.<int>;
      
      public function MoveData()
      {
         super();
      }
      
      public static function from(param1:Object) : MoveData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:MoveData = new MoveData();
         _loc2_.side = param1.side;
         _loc2_.skill = param1.skill;
         _loc2_.category = param1.category;
         _loc2_.damage = param1.damage;
         _loc2_.critical = param1.critical;
         _loc2_.miss = param1.miss;
         _loc2_.rate = param1.rate;
         _loc2_.soundUrl = param1.soundUrl;
         _loc2_.effectUrl = param1.effectUrl;
         _loc2_.hits = transHits(param1.hits);
         return _loc2_;
      }
      
      public static function clone(param1:MoveData) : MoveData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:MoveData = new MoveData();
         _loc2_.side = param1.side;
         _loc2_.skill = param1.skill;
         _loc2_.category = param1.category;
         _loc2_.damage = param1.damage;
         _loc2_.critical = param1.critical;
         _loc2_.miss = param1.miss;
         _loc2_.rate = param1.rate;
         _loc2_.soundUrl = param1.soundUrl;
         _loc2_.effectUrl = param1.effectUrl;
         _loc2_.hits = cloneHits(param1.hits);
         return _loc2_;
      }
      
      private static function transHits(param1:Array) : Vector.<int>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<int> = new Vector.<int>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_] == 0 ? 1 : param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function cloneHits(param1:Vector.<int>) : Vector.<int>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<int> = new Vector.<int>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

