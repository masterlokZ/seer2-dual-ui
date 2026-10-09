package com.taomee.seer2.app.utils
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.manager.WebJumpManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class FightHelpUtil
   {
      
      private var _petBag:SimpleButton;
      
      private var _getBlood:SimpleButton;
      
      private var _itemShop:SimpleButton;
      
      private var _goBBS:SimpleButton;
      
      private var _bbsId:int = -1;
      
      private var _oldCoinNum:int = 0;
      
      public function FightHelpUtil(param1:SimpleButton = null, param2:SimpleButton = null, param3:SimpleButton = null, param4:SimpleButton = null, param5:Object = null)
      {
         super();
         if(param1)
         {
            this._petBag = param1;
         }
         if(param2)
         {
            this._getBlood = param2;
         }
         if(param3)
         {
            this._itemShop = param3;
         }
         if(param4)
         {
            this._goBBS = param4;
         }
         if(param5)
         {
            if(param5.hasOwnProperty("bbsId"))
            {
               this._bbsId = int(param5["bbsId"]);
            }
         }
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(this._petBag)
         {
            this._petBag.addEventListener("click",this.onPetBag);
         }
         if(this._getBlood)
         {
            this._getBlood.addEventListener("click",this.onGetBlood);
         }
         if(this._itemShop)
         {
            this._itemShop.addEventListener("click",this.onItemShop);
         }
         if(this._goBBS)
         {
            this._goBBS.addEventListener("click",this.onGoBBS);
         }
      }
      
      private function onGetBlood(param1:MouseEvent) : void
      {
         if(PetInfoManager.canCure() == false)
         {
            ServerMessager.addMessage("你的精灵不需要恢复");
            return;
         }
         this._oldCoinNum = ActorManager.actorInfo.coins;
         this.recoverAllPetBagPet();
      }
      
      private function recoverAllPetBagPet() : void
      {
         Connection.addCommandListener(CommandSet.TREAT_ALL_PET_1215,this.onAddAllPetBlood);
         Connection.send(CommandSet.TREAT_ALL_PET_1215);
      }
      
      private function onAddAllPetBlood(param1:MessageEvent) : void
      {
         var _loc4_:PetInfo = null;
         var _loc3_:int = 0;
         Connection.removeCommandListener(CommandSet.TREAT_ALL_PET_1215,this.onAddAllPetBlood);
         var _loc2_:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         for each(_loc4_ in _loc2_)
         {
            _loc4_.hp = _loc4_.maxHp;
            PetInfoManager.dispatchEvent("petPropertiesChange",_loc4_);
         }
         _loc3_ = int(param1.message.getRawData().readUnsignedInt());
         ActorManager.actorInfo.coins = _loc3_;
         ServerMessager.addMessage("消耗" + (this._oldCoinNum - _loc3_) + "赛尔豆恢复背包中所有精灵！");
      }
      
      private function onItemShop(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("MedicineShopPanel");
      }
      
      private function onGoBBS(param1:MouseEvent) : void
      {
         if(this._bbsId != -1)
         {
            WebJumpManager.toBBSForId(this._bbsId);
         }
      }
      
      private function onPetBag(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("PetBagPanel");
      }
      
      public function dispose() : void
      {
         if(this._petBag)
         {
            this._petBag.removeEventListener("click",this.onPetBag);
            this._petBag = null;
         }
         if(this._getBlood)
         {
            this._getBlood.removeEventListener("click",this.onGetBlood);
            this._getBlood = null;
         }
         if(this._itemShop)
         {
            this._itemShop.removeEventListener("click",this.onItemShop);
            this._itemShop = null;
         }
         if(this._goBBS)
         {
            this._goBBS.removeEventListener("click",this.onGoBBS);
            this._goBBS = null;
         }
      }
   }
}

