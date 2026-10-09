package com.taomee.seer2.app.controls.widget
{
   import com.taomee.seer2.app.controls.widget.core.IToolBarWidgetClick;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.BaseScene;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   
   public class ShipMapWidgetClick implements IToolBarWidgetClick
   {
      
      public static const SHIP_MAP:String = "shipmap";
      
      private var _widget:ToolBarWidget;
      
      public function ShipMapWidgetClick()
      {
         super();
      }
      
      public function get widget() : ToolBarWidget
      {
         return this._widget;
      }
      
      public function set widget(param1:ToolBarWidget) : void
      {
         this._widget = param1;
      }
      
      public function onWidgetClick(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         StatisticsManager.sendNovice("0x10030605");
         var _loc2_:BaseScene = SceneManager.active;
         if(_loc2_.mapCategoryID == 890)
         {
            AlertManager.showAlert("正在探索中...");
            return;
         }
         if(ModuleManager.getModuleStatus("MapPanel") == "show")
         {
            ModuleManager.closeForName("MapPanel");
         }
         if(_loc2_.mapCategoryID == 100)
         {
            if(ModuleManager.getModuleStatus("ShipMap2Panel") == "show")
            {
               ModuleManager.closeForName("ShipMap2Panel");
            }
            if(ModuleManager.getModuleStatus("MapSignPanel") == "show")
            {
               ModuleManager.closeForName("MapSignPanel");
            }
            ModuleManager.toggleModule(URLUtil.getAppModule("DoorMapPanel"),"正在打开英格瓦要塞……");
         }
         else if(_loc2_.mapCategoryID == 1)
         {
            if(ModuleManager.getModuleStatus("DoorMapPanel") == "show")
            {
               ModuleManager.closeForName("DoorMapPanel");
            }
            if(ModuleManager.getModuleStatus("MapSignPanel") == "show")
            {
               ModuleManager.closeForName("MapSignPanel");
            }
            _loc3_ = {};
            _loc3_["mapCategoryId"] = _loc2_.mapCategoryID;
            _loc3_["mapId"] = _loc2_.mapID;
            ModuleManager.toggleModule(URLUtil.getAppModule("ShipMap2Panel"),"正在打开地图导航...",_loc3_);
         }
         else
         {
            if(ModuleManager.getModuleStatus("ShipMap2Panel") == "show")
            {
               ModuleManager.closeForName("ShipMap2Panel");
            }
            if(ModuleManager.getModuleStatus("DoorMapPanel") == "show")
            {
               ModuleManager.closeForName("DoorMapPanel");
            }
            ModuleManager.toggleModule(URLUtil.getAppModule("MapSignPanel"),"正在打开地图指示模块...",{"categoryId":_loc2_.mapCategoryID});
         }
      }
   }
}

