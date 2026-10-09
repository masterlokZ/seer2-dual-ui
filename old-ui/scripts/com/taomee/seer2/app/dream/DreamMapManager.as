package com.taomee.seer2.app.dream
{
   import com.taomee.seer2.core.scene.MapLoader;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class DreamMapManager
   {
      
      public function DreamMapManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         SceneManager.addEventListener("switchComplete",onComplete);
      }
      
      private static function onComplete(param1:SceneEvent) : void
      {
         var _loc2_:uint = 0;
         if(MapLoader.isDream)
         {
            _loc2_ = uint(SceneManager.active.mapID);
            DreamMapOrganize.show();
            SceneManager.addEventListener("switchStart",onStart);
         }
      }
      
      private static function onStart(param1:SceneEvent) : void
      {
         SceneManager.removeEventListener("switchStart",onStart);
         DreamMapOrganize.dispose();
      }
   }
}

