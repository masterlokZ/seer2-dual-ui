package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actives.GuanXingBossHurtAct;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class MapProcessor_80171 extends MapProcessor
   {
      
      public function MapProcessor_80171(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         GuanXingBossHurtAct.getInstance().setUp();
         if(SceneManager.prevSceneType != 2)
         {
            ModuleManager.showAppModule("GuanXingZhiZiAlertPanel");
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         GuanXingBossHurtAct.getInstance().dispose();
      }
   }
}

