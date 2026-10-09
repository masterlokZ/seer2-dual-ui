package data.pet
{
   public class PetExtData
   {
      
      public var monster:int;
      
      public var sex:int;
      
      public var featureTips:String;
      
      public var emblem1:int;
      
      public var emblem1Tips:String;
      
      public var emblem2:int;
      
      public var emblem2Tips:String;
      
      public var fetterTips:String;
      
      public var morphTips:String;
      
      public var showIcon:int;
      
      public function PetExtData()
      {
         super();
      }
      
      public static function from(param1:Object) : PetExtData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:PetExtData = new PetExtData();
         _loc2_.monster = param1.monster;
         _loc2_.sex = param1.sex;
         _loc2_.featureTips = param1.featureTips;
         _loc2_.emblem1 = param1.emblem1;
         _loc2_.emblem1Tips = param1.emblem1Tips;
         _loc2_.emblem2 = param1.emblem2;
         _loc2_.emblem2Tips = param1.emblem2Tips;
         _loc2_.fetterTips = param1.fetterTips;
         _loc2_.morphTips = param1.morphTips;
         _loc2_.showIcon = param1.showIcon;
         return _loc2_;
      }
      
      public static function clone(param1:PetExtData) : PetExtData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:PetExtData = new PetExtData();
         _loc2_.monster = param1.monster;
         _loc2_.sex = param1.sex;
         _loc2_.featureTips = param1.featureTips;
         _loc2_.emblem1 = param1.emblem1;
         _loc2_.emblem1Tips = param1.emblem1Tips;
         _loc2_.emblem2 = param1.emblem2;
         _loc2_.emblem2Tips = param1.emblem2Tips;
         _loc2_.fetterTips = param1.fetterTips;
         _loc2_.morphTips = param1.morphTips;
         _loc2_.showIcon = param1.showIcon;
         return _loc2_;
      }
   }
}

