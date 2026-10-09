package com.taomee.seer2.app.dialog.functionality
{
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   
   public class ModuleUnit extends BaseUnit
   {
      
      public function ModuleUnit()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.type = "module";
         this.priority = 4;
      }
      
      override protected function addIcon() : void
      {
         _icon = UIManager.getSprite("UI_DialogModule");
         addChild(_icon);
      }
      
      override protected function onBtnClick(param1:MouseEvent) : void
      {
         var _loc7_:Object = null;
         var _loc3_:String = null;
         var _loc2_:Array = null;
         var _loc5_:String = null;
         var _loc4_:Array = null;
         var _loc6_:String = this.params;
         var _loc8_:Array = _loc6_.split(" ");
         if(_loc8_.length > 1)
         {
            _loc7_ = {};
            _loc3_ = String(_loc8_[1]);
            _loc3_ = _loc3_.substr(1,_loc3_.length - 2);
            _loc3_.replace(" ");
            _loc2_ = _loc3_.split(",");
            for each(_loc5_ in _loc2_)
            {
               _loc4_ = _loc5_.split(":");
               _loc7_[_loc4_[0]] = _loc4_[1];
            }
            ModuleManager.toggleModule(URLUtil.getAppModule(_loc8_[0]),"正在打开..." + this.label + "...",_loc7_);
         }
         else
         {
            ModuleManager.toggleModule(URLUtil.getAppModule(_loc8_[0]),"正在打开..." + this.label + "...");
         }
         DialogPanel.hide();
      }
   }
}

