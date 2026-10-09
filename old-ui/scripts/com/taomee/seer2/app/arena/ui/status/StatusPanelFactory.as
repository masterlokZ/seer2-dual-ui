package com.taomee.seer2.app.arena.ui.status
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.ui.status.panel.DoubleFightStatusPanel;
   import com.taomee.seer2.app.arena.ui.status.panel.FightStatusPanel;
   import com.taomee.seer2.app.arena.ui.status.panel.PVEFightStatusPanel;
   import com.taomee.seer2.app.arena.ui.status.panel.SPTFightStatusPanel;
   
   public class StatusPanelFactory
   {
      
      public function StatusPanelFactory()
      {
         super();
      }
      
      public static function createStatusPanel(param1:ArenaDataInfo) : FightStatusPanel
      {
         var _loc2_:FightStatusPanel = null;
         var _loc3_:uint = 0;
         if(param1.isDoubleMode)
         {
            _loc2_ = new DoubleFightStatusPanel();
         }
         else
         {
            _loc3_ = param1.fightMode;
            switch(int(_loc3_) - 1)
            {
               case 0:
               case 1:
               case 5:
                  _loc2_ = new PVEFightStatusPanel();
                  break;
               case 2:
                  _loc2_ = new SPTFightStatusPanel();
                  break;
               case 6:
                  if(FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.bloodType == 1)
                  {
                     _loc2_ = new SPTFightStatusPanel();
                  }
                  else
                  {
                     _loc2_ = new PVEFightStatusPanel();
                  }
                  break;
               default:
                  _loc2_ = new PVEFightStatusPanel();
            }
         }
         _loc2_.initStatusPanelInfo(param1);
         return _loc2_;
      }
   }
}

