package com.taomee.seer2.app.dialog.functionality
{
   import com.taomee.seer2.app.dialog.events.FunctionalityBoxEvent;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.events.MouseEvent;
   
   public class CustomNewUnit extends BaseUnit
   {
      
      private var _questId:uint;
      
      public function CustomNewUnit()
      {
         super();
      }
      
      override protected function addIcon() : void
      {
         _icon = UIManager.getSprite("UI_DialogQuest");
         addChild(_icon);
      }
      
      public function setData(param1:uint) : void
      {
         this._questId = param1;
         this.label = "灵魂故乡的野望";
         this.type = "quest";
         this.priority = 2;
      }
      
      override protected function onBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new FunctionalityBoxEvent("customUnitClick",this._questId));
      }
   }
}

