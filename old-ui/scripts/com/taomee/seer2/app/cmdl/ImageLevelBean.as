package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.core.scene.ImageLevelManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import org.taomee.bean.BaseBean;
   
   public class ImageLevelBean extends BaseBean
   {
      
      public function ImageLevelBean()
      {
         super();
         SceneManager.addEventListener("switchComplete",this.onSwitchComplete);
         finish();
      }
      
      private function onSwitchComplete(param1:SceneEvent) : void
      {
         if(Boolean(SceneManager.active) && SceneManager.active.type == 2)
         {
            if(ImageLevelManager.getFightImageQuality() == "")
            {
               ImageLevelManager.setFightImageLevel("medium");
            }
            else
            {
               ImageLevelManager.setFightImageLevel(ImageLevelManager.getFightImageQuality());
            }
         }
         else if(SceneManager.active)
         {
            if(ImageLevelManager.getImageQuality() == "")
            {
               ImageLevelManager.setImageLevel("high");
            }
            else
            {
               ImageLevelManager.setImageLevel(ImageLevelManager.getImageQuality());
            }
         }
      }
   }
}

