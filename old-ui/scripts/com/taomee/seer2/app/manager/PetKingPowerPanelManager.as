package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.core.manager.GlobalsManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.manager.VersionManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class PetKingPowerPanelManager
   {
      
      public static const END_DATE:Date = new Date(2012,6,22,15);
      
      public function PetKingPowerPanelManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc2_:Number = END_DATE.getTime() / 1000;
         var _loc1_:Number = TimeManager.getServerTime();
         if(GlobalsManager.lastLoginTime < VersionManager.versionTime && _loc1_ < _loc2_)
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("PetKingPowerPanel"),"精灵王争霸之抢分赛");
         }
      }
   }
}

