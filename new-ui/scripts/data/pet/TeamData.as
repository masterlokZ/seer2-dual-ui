package data.pet
{
   public class TeamData
   {
      
      public var _master:PetData;
      
      public var _slave:PetData;
      
      public var pets:Vector.<PetData>;
      
      public var items:Vector.<ItemData>;
      
      public var capsules:Vector.<ItemData>;
      
      public function TeamData()
      {
         super();
      }
      
      public static function from(param1:Object) : TeamData
      {
         var _loc2_:TeamData = new TeamData();
         _loc2_.pets = transPet(param1.pets);
         _loc2_.items = transItem(param1.items);
         _loc2_.capsules = transItem(param1.capsules);
         _loc2_.init();
         return _loc2_;
      }
      
      public static function clone(param1:TeamData) : TeamData
      {
         var _loc2_:TeamData = new TeamData();
         _loc2_.pets = clonePet(param1.pets);
         _loc2_.items = cloneItem(param1.items);
         _loc2_.capsules = cloneItem(param1.capsules);
         _loc2_.init();
         return _loc2_;
      }
      
      private static function transPet(param1:Array) : Vector.<PetData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<PetData> = new Vector.<PetData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(PetData.from(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function transItem(param1:Array) : Vector.<ItemData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<ItemData> = new Vector.<ItemData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(ItemData.from(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function clonePet(param1:Vector.<PetData>) : Vector.<PetData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<PetData> = new Vector.<PetData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(PetData.clone(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function cloneItem(param1:Vector.<ItemData>) : Vector.<ItemData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<ItemData> = new Vector.<ItemData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(ItemData.clone(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get master() : PetData
      {
         return _master;
      }
      
      public function get slave() : PetData
      {
         return _slave;
      }
      
      public function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PetData = null;
         _loc1_ = 0;
         while(_loc1_ < pets.length)
         {
            _loc2_ = pets[_loc1_];
            if(_loc2_.position === 1)
            {
               _master = _loc2_;
            }
            else if(_loc2_.position === 2)
            {
               _slave = _loc2_;
            }
            _loc1_++;
         }
         if(!_master)
         {
            _master = pets[0];
         }
      }
   }
}

