package com.taomee.seer2.app.dialog.functionality
{
   import com.taomee.seer2.app.actives.IActiveProcess;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class ActiveUnit extends BaseUnit
   {
      
      public function ActiveUnit()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.type = "active";
      }
      
      override protected function addIcon() : void
      {
         _icon = UIManager.getSprite("UI_DialogReward");
         addChild(_icon);
      }
      
      override protected function onBtnClick(param1:MouseEvent) : void
      {
         var _loc3_:IActiveProcess = null;
         var _loc2_:String = "com.taomee.seer2.app.actives.ActiveProcess_" + params;
         var _loc4_:Class = ApplicationDomain.currentDomain.getDefinition(_loc2_) as Class;
         _loc3_ = new _loc4_();
         _loc3_.start();
         DialogPanel.hide("");
      }
   }
}

