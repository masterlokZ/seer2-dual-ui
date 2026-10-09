package data.pet
{
   public class SkillData
   {
      
      public var id:int;
      
      public var name:String;
      
      public var power:int;
      
      public var anger:int;
      
      public var category:String;
      
      public var typeIcon:String;
      
      public var tips:String;
      
      public var enable:Boolean;
      
      public function SkillData()
      {
         super();
      }
      
      public static function from(param1:Object) : SkillData
      {
         var _loc2_:SkillData = new SkillData();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.power = param1.power;
         _loc2_.anger = param1.anger;
         _loc2_.category = param1.category;
         _loc2_.typeIcon = param1.typeIcon;
         _loc2_.tips = param1.tips;
         _loc2_.enable = param1.enable;
         return _loc2_;
      }
      
      public static function clone(param1:SkillData) : SkillData
      {
         var _loc2_:SkillData = new SkillData();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.power = param1.power;
         _loc2_.anger = param1.anger;
         _loc2_.category = param1.category;
         _loc2_.typeIcon = param1.typeIcon;
         _loc2_.tips = param1.tips;
         _loc2_.enable = param1.enable;
         return _loc2_;
      }
   }
}

