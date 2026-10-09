package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   
   public class TreeHouseWarAct
   {
      
      private static var _instance:TreeHouseWarAct;
      
      private var _npc:Mobile;
      
      public function TreeHouseWarAct()
      {
         super();
      }
      
      public static function getInstance() : TreeHouseWarAct
      {
         if(!_instance)
         {
            _instance = new TreeHouseWarAct();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.createNpc();
      }
      
      private function createNpc() : void
      {
         if(!this._npc)
         {
            this._npc = new Mobile();
            this._npc.resourceUrl = URLUtil.getActivityMobile("TreeHouseMobile");
            this._npc.x = 11;
            this._npc.y = 22;
            this._npc.buttonMode = true;
            this._npc.mouseChildren = false;
         }
         this._npc.addEventListener("click",this.showActPanel);
         MobileManager.addMobile(this._npc,"npc");
      }
      
      private function showComplete(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("LoginGiftPanel","show",this.showComplete);
         ModuleManager.getModule("LoginGiftPanel").module.hide();
      }
      
      private function showActPanel(param1:MouseEvent = null) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("TreeHouseWarPanel"));
      }
   }
}

