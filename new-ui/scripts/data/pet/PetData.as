package data.pet
{
   public class PetData
   {
      
      public var pid:int;
      
      public var petIcon:String;
      
      public var petSwf:String;
      
      public var petSound:String;
      
      public var name:String;
      
      public var level:int;
      
      public var typeIcon:String;
      
      public var position:int;
      
      public var alive:int;
      
      public var anger:int;
      
      public var maxAnger:int;
      
      public var hp:int;
      
      public var maxHp:int;
      
      public var rate:int;
      
      public var atk:int;
      
      public var def:int;
      
      public var spa:int;
      
      public var spd:int;
      
      public var spe:int;
      
      public var skills:Vector.<SkillData>;
      
      public var buffs:Vector.<BuffData>;
      
      public var items:Vector.<ItemData>;
      
      public var ext:PetExtData;
      
      public function PetData()
      {
         super();
      }
      
      public static function from(param1:Object) : PetData
      {
         var _loc2_:PetData = new PetData();
         _loc2_.pid = param1.pid;
         _loc2_.petIcon = param1.petIcon;
         _loc2_.petSwf = param1.petSwf;
         _loc2_.petSound = param1.petSound;
         _loc2_.name = param1.name;
         _loc2_.level = param1.level;
         _loc2_.typeIcon = param1.typeIcon;
         _loc2_.position = param1.position;
         _loc2_.alive = param1.alive;
         _loc2_.anger = param1.anger;
         _loc2_.maxAnger = param1.maxAnger;
         _loc2_.hp = param1.hp;
         _loc2_.maxHp = param1.maxHp;
         _loc2_.rate = param1.rate;
         _loc2_.atk = param1.atk;
         _loc2_.def = param1.def;
         _loc2_.spa = param1.spa;
         _loc2_.spd = param1.spd;
         _loc2_.spe = param1.spe;
         _loc2_.skills = transSkill(param1.skills);
         _loc2_.buffs = transBuff(param1.buffs);
         _loc2_.items = transItem(param1.items);
         _loc2_.ext = PetExtData.from(param1.ext);
         return _loc2_;
      }
      
      public static function clone(param1:PetData) : PetData
      {
         var _loc2_:PetData = new PetData();
         _loc2_.pid = param1.pid;
         _loc2_.petIcon = param1.petIcon;
         _loc2_.petSwf = param1.petSwf;
         _loc2_.petSound = param1.petSound;
         _loc2_.name = param1.name;
         _loc2_.level = param1.level;
         _loc2_.typeIcon = param1.typeIcon;
         _loc2_.position = param1.position;
         _loc2_.alive = param1.alive;
         _loc2_.anger = param1.anger;
         _loc2_.maxAnger = param1.maxAnger;
         _loc2_.hp = param1.hp;
         _loc2_.maxHp = param1.maxHp;
         _loc2_.rate = param1.rate;
         _loc2_.atk = param1.atk;
         _loc2_.def = param1.def;
         _loc2_.spa = param1.spa;
         _loc2_.spd = param1.spd;
         _loc2_.spe = param1.spe;
         _loc2_.skills = cloneSkill(param1.skills);
         _loc2_.buffs = cloneBuff(param1.buffs);
         _loc2_.items = cloneItem(param1.items);
         _loc2_.ext = PetExtData.clone(param1.ext);
         return _loc2_;
      }
      
      private static function transSkill(param1:Array) : Vector.<SkillData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<SkillData> = new Vector.<SkillData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(SkillData.from(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function transBuff(param1:Array) : Vector.<BuffData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<BuffData> = new Vector.<BuffData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(BuffData.from(param1[_loc3_]));
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
      
      private static function cloneSkill(param1:Vector.<SkillData>) : Vector.<SkillData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<SkillData> = new Vector.<SkillData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(SkillData.clone(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function cloneBuff(param1:Vector.<BuffData>) : Vector.<BuffData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<BuffData> = new Vector.<BuffData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(BuffData.clone(param1[_loc3_]));
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
   }
}

