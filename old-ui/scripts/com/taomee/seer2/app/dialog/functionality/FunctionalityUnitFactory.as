package com.taomee.seer2.app.dialog.functionality
{
   public class FunctionalityUnitFactory
   {
      
      public function FunctionalityUnitFactory()
      {
         super();
      }
      
      public static function createUnit(param1:String, param2:String, param3:String) : BaseUnit
      {
         var _loc11_:GameUnit = null;
         var _loc6_:ModuleUnit = null;
         var _loc5_:ShopUnit = null;
         var _loc9_:RewardUnit = null;
         var _loc7_:ActiveUnit = null;
         var _loc4_:URLUnit = null;
         var _loc8_:FishBookUnit = null;
         var _loc10_:YingYingGuaiUnit = null;
         switch(param1)
         {
            case "game":
               _loc11_ = new GameUnit();
               _loc11_.label = param2;
               _loc11_.params = param3;
               return _loc11_;
            case "module":
               _loc6_ = new ModuleUnit();
               _loc6_.label = param2;
               _loc6_.params = param3;
               return _loc6_;
            case "shop":
               _loc5_ = new ShopUnit();
               _loc5_.label = param2;
               _loc5_.params = param3;
               return _loc5_;
            case "reward":
               _loc9_ = new RewardUnit();
               _loc9_.label = param2;
               _loc9_.params = param3;
               return _loc9_;
            case "active":
               _loc7_ = new ActiveUnit();
               _loc7_.label = param2;
               _loc7_.params = param3;
               return _loc7_;
            case "url":
               _loc4_ = new URLUnit();
               _loc4_.label = param2;
               _loc4_.params = param3;
               return _loc4_;
            case "fishBook":
               _loc8_ = new FishBookUnit();
               _loc8_.label = param2;
               _loc8_.params = param3;
               return _loc8_;
            case "yingyingguai":
               _loc10_ = new YingYingGuaiUnit();
               _loc10_.label = param2;
               _loc10_.params = param3;
               return _loc10_;
            default:
               return new CustomUnit(param1,param2,param3);
         }
      }
   }
}

