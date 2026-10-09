package com.taomee.seer2.app.processor.activity.nextyearActivity
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.core.map.MapModel;
   
   public class NextYearActivityShip
   {
      
      private static const JiXieRoom:int = 50;
      
      private static const DongLiRoom:int = 40;
      
      private static const ChuanSongRoom:int = 70;
      
      private static const MAX_NUM:int = 10;
      
      private var _map:MapModel;
      
      public function NextYearActivityShip()
      {
         super();
      }
      
      public function init(param1:MapModel) : void
      {
         this._map = param1;
         if(this._map.id == 50 || this._map.id == 40 || this._map.id == 70)
         {
            DialogPanel.addEventListener("customUnitClick",this.onCustomUnitClick);
         }
      }
      
      public function dispose() : void
      {
         if(this._map.id == 50 || this._map.id == 40 || this._map.id == 70)
         {
            DialogPanel.removeEventListener("customUnitClick",this.onCustomUnitClick);
         }
      }
      
      private function onCustomUnitClick(param1:DialogPanelEvent) : void
      {
         var evt:DialogPanelEvent = param1;
         if(evt.content.params != "nextYearActivityShip")
         {
            return;
         }
         switch(this._map.id)
         {
            case 50:
               NpcDialog.show(4,"菲鲁",[[3,"你是来拿暗之精华的？哈哈！那得和我较量较量！好就没动手了！准备好了吗？"]],["比拼开始！","我要先去准备下！"],[function():void
               {
                  DayLimitManager.getDoCount(327,onGetDayLimit);
               },null]);
               break;
            case 40:
               NpcDialog.show(5,"乔休尔",[[4,"你是来拿暗之精华的？哈哈！那得和我较量较量！好就没动手了！准备好了吗？"]],[" 比拼开始！","我要先去准备下！"],[function():void
               {
                  DayLimitManager.getDoCount(328,onGetDayLimit);
               },null]);
               break;
            case 70:
               NpcDialog.show(8,"艾农",[[1,"我不但人美丽！歌喉动人！我的精灵也很厉害哟！啧啧啧~~不厉害的我不那出来的！"]],[" 比拼开始！","我要先去准备下！"],[function():void
               {
                  DayLimitManager.getDoCount(329,onGetDayLimit);
               },null]);
         }
      }
      
      private function onGetDayLimit(param1:int) : void
      {
         if(param1 <= 10)
         {
            switch(this._map.id)
            {
               case 50:
                  FightManager.startFightWithWild(53);
                  break;
               case 40:
                  FightManager.startFightWithWild(54);
                  break;
               case 70:
                  FightManager.startFightWithWild(55);
            }
         }
      }
   }
}

