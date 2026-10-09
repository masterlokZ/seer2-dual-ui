package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.manager.SeatTipsManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class LeiyiChargingAct
   {
      
      private static var _instance:LeiyiChargingAct;
      
      private const PVE_MOBILE_IDS:Array = [498,592,593,594];
      
      private const PVE_FIGHT_IDS:Array = [495,496,497,498];
      
      private var mobileList:Vector.<Mobile>;
      
      public function LeiyiChargingAct()
      {
         super();
      }
      
      public static function getInstance() : LeiyiChargingAct
      {
         if(!_instance)
         {
            _instance = new LeiyiChargingAct();
         }
         return _instance;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.PVE_MOBILE_IDS.length)
         {
            this.mobileList[_loc1_].removeEventListener("click",this.toFight);
            _loc1_++;
         }
      }
      
      public function setup() : void
      {
         var _loc2_:Mobile = null;
         StatisticsManager.sendNovice("0x10033919");
         this.mobileList = new Vector.<Mobile>();
         var _loc1_:int = 0;
         while(_loc1_ < this.PVE_MOBILE_IDS.length)
         {
            _loc2_ = MobileManager.getMobile(this.PVE_MOBILE_IDS[_loc1_],"npc");
            _loc2_.buttonMode = true;
            _loc2_.mouseChildren = false;
            _loc2_.addEventListener("click",this.toFight);
            this.mobileList.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         if(_loc2_.hours < 13 || _loc2_.hours >= 15)
         {
            AlertManager.showAlert("每天下午13:00-15:00，才可以挑战我哦！");
            return;
         }
         var _loc3_:int = this.PVE_MOBILE_IDS.indexOf(Mobile(param1.target).id);
         FightManager.startFightWithWild(this.PVE_FIGHT_IDS[_loc3_]);
         SeatTipsManager.removeSeat(new Point(255,175),860);
         SeatTipsManager.removeSeat(new Point(580,175),860);
         SeatTipsManager.removeSeat(new Point(395,130),860);
         SeatTipsManager.removeSeat(new Point(245,320),860);
      }
   }
}

