package ui
{
   import ui.status.UI_FightFighterTraitX;
   import ui.status.UI_WeatherIconN;
   
   public class Resource
   {
      
      public static const MARK:String = "internal://";
      
      public static const clazz:Object = {};
      
      Resource.init();
      
      public function Resource()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ <= 23)
         {
            clazz["UI_PetTypeIcon_" + _loc1_] = UI_PetTypeIcon_N.find(_loc1_);
            _loc1_++;
         }
         _loc1_ = 1;
         while(_loc1_ <= 24)
         {
            clazz["UI_WeatherIcon" + _loc1_] = UI_WeatherIconN.find(_loc1_);
            _loc1_++;
         }
         clazz.UI_FightFighterTraitIncrease_Atk = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_Atk;
         clazz.UI_FightFighterTraitIncrease_Defense = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_Defense;
         clazz.UI_FightFighterTraitIncrease_SpecialAtk = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_SpecialAtk;
         clazz.UI_FightFighterTraitIncrease_SpecialDefense = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_SpecialDefense;
         clazz.UI_FightFighterTraitIncrease_Speed = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_Speed;
         clazz.UI_FightFighterTraitDecrease_Atk = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_Atk;
         clazz.UI_FightFighterTraitDecrease_Defense = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_Defense;
         clazz.UI_FightFighterTraitDecrease_SpecialAtk = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_SpecialAtk;
         clazz.UI_FightFighterTraitDecrease_SpecialDefense = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_SpecialDefense;
         clazz.UI_FightFighterTraitDecrease_Speed = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_Speed;
      }
   }
}

