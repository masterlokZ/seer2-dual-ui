package com.taomee.seer2.app.rightToolbar.toolbar
{
   import com.taomee.seer2.app.rightToolbar.RightToolbar;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   
   public class PetKingOverPrize extends RightToolbar
   {
      
      public function PetKingOverPrize()
      {
         super();
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         if(DateUtil.inInDateScope(5,13,1,16,1) || DateUtil.inInDateScope(6,14,30,15,1) || DateUtil.inInDateScope(0,14,30,15,1) || DateUtil.inInDateScope(1,14,30,15,1) || DateUtil.inInDateScope(2,14,30,15,1) || DateUtil.inInDateScope(3,14,30,15,1) || DateUtil.inInDateScope(4,14,30,15,1))
         {
            SceneManager.changeScene(1,980);
         }
         else
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("PetAlertUI"),"正在系统消息...");
         }
      }
   }
}

