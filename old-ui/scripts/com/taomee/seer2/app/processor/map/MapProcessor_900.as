package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activity.processor.FightNana;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import flash.utils.IDataInput;
   
   public class MapProcessor_900 extends TitleMapProcessor
   {
      
      private var _fightHrader:FightNana;
      
      public function MapProcessor_900(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initFight();
         StatisticsManager.sendNovice("0x10033455");
         _map.content["smokeBtn"].visible = false;
         DayLimitListManager.getDaylimitList([5241],(function():*
         {
            var callback:Function;
            return callback = function(param1:DayLimitListInfo):void
            {
               if(param1.getCount(5241) == 0)
               {
                  _map.content["smokeBtn"].visible = true;
               }
            };
         })());
         TooltipManager.addCommonTip(_map.content["smokeBtn"],"烟尘蒸汽团");
         _map.content["smokeBtn"].addEventListener("click",this.onSmokeClick);
      }
      
      private function onSmokeClick(param1:*) : void
      {
         var e:* = param1;
         _map.content["smokeBtn"].visible = false;
         SwapManager.swapItem(4572,1,(function():*
         {
            var success:Function;
            return success = function(param1:IDataInput):void
            {
               new SwapInfo(param1);
            };
         })(),(function():*
         {
            var failed:Function;
            return failed = function(param1:uint):void
            {
            };
         })());
      }
      
      private function initFight() : void
      {
         this._fightHrader = new FightNana();
      }
      
      override public function dispose() : void
      {
         if(this._fightHrader)
         {
            this._fightHrader.dispose();
         }
         TooltipManager.remove(_map.content["smokeBtn"]);
         _map.content["smokeBtn"].removeEventListener("click",this.onSmokeClick);
         super.dispose();
      }
   }
}

