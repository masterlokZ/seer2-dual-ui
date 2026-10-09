package com.taomee.seer2.app.offLineExp
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.arena.data.RevenueInfo;
   import com.taomee.seer2.app.controls.PetAvatarPanel;
   import com.taomee.seer2.app.manager.FightResultPanelWrapper;
   import com.taomee.seer2.app.manager.PetExperenceHelper;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import flash.utils.IDataInput;
   
   public class OffLineExpSystem
   {
      
      private static const EXP_VALUE:uint = 203631;
      
      private static const SWAP_EXP:uint = 2294;
      
      private static var _currentExp:uint = 0;
      
      private static var _overTime:uint = 0;
      
      private static var _catchTime:uint = 0;
      
      public function OffLineExpSystem()
      {
         super();
      }
      
      public static function get overTime() : uint
      {
         return _overTime;
      }
      
      public static function get currentExp() : uint
      {
         return _currentExp;
      }
      
      public static function setup() : void
      {
         ActiveCountManager.requestActiveCount(203631,getExpValue);
      }
      
      private static function getExpValue(param1:uint, param2:uint) : void
      {
         _overTime = param2;
         var _loc3_:Number = 43200;
         if(_overTime > _loc3_)
         {
            _overTime = _loc3_;
         }
         _currentExp = Math.floor(0.9166666666666666 * _overTime);
      }
      
      public static function swapExp(param1:uint) : void
      {
         var catchTime:uint = param1;
         _catchTime = catchTime;
         PetInfoManager.addEventListener("petExperenceChange",onPetExperenceChange);
         PetExperenceHelper.startListen();
         SwapManager.swapItem(2294,1,function(param1:IDataInput):void
         {
            PetExperenceHelper.stopListen();
            new SwapInfo(param1);
            _currentExp = 0;
            _overTime = 0;
            PetAvatarPanel.hideExpIcon();
         },null,new SpecialInfo(1,_catchTime));
      }
      
      private static function onPetExperenceChange(param1:PetInfoEvent) : void
      {
         var _loc3_:RevenueInfo = null;
         var _loc5_:FightResultInfo = null;
         var _loc4_:PetInfo = null;
         _loc3_ = param1.content.revenueInfo;
         _loc5_ = param1.content.resultInfo;
         var _loc2_:int = 0;
         while(_loc2_ < PetInfoManager.getAllBagPetInfo().length)
         {
            if(PetInfoManager.getAllBagPetInfo()[_loc2_].catchTime == _catchTime)
            {
               _loc4_ = PetInfoManager.getAllBagPetInfo()[_loc2_];
               break;
            }
            _loc2_++;
         }
         PetInfoManager.removeEventListener("petExperenceChange",onPetExperenceChange);
         new FightResultPanelWrapper().show(Vector.<PetInfo>([_loc4_]),_loc3_,_loc5_);
      }
   }
}

