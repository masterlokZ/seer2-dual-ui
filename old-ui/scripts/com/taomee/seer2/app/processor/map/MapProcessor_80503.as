package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actives.ShengJiaYongYeAct;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class MapProcessor_80503 extends MapProcessor
   {
      
      public function MapProcessor_80503(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         ShengJiaYongYeAct.getInstance().setUp();
         if(SceneManager.prevSceneType != 2)
         {
            ModuleManager.showAppModule("ShengJiaYongYeAlertPanel");
         }
      }
      
      override public function dispose() : void
      {
         ShengJiaYongYeAct.getInstance().dispose();
         super.dispose();
      }
   }
}

