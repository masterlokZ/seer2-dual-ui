package com.taomee.seer2.core.scene.events
{
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.InteractiveObject;
   import flash.utils.Dictionary;
   import org.taomee.utils.DisplayUtil;
   
   public class SceneLinstenerManager
   {
      
      public static var _instance:SceneLinstenerManager;
      
      private var _dic:Dictionary = new Dictionary();
      
      public function SceneLinstenerManager()
      {
         super();
         SceneManager.addEventListener("switchComplete",this.onSwitchComplete);
      }
      
      public static function get instance() : SceneLinstenerManager
      {
         if(_instance == null)
         {
            _instance = new SceneLinstenerManager();
         }
         return _instance;
      }
      
      public function add(param1:InteractiveObject, param2:Function = null) : void
      {
         if(param1)
         {
            if(param2 != null)
            {
               if(param1.hasEventListener("click"))
               {
                  if(this._dic[param1] != null)
                  {
                     param1.removeEventListener("click",this._dic[param1]);
                  }
               }
               param1.addEventListener("click",param2);
            }
            this._dic[param1] = param2;
         }
      }
      
      public function remove(param1:InteractiveObject, param2:Boolean = true) : void
      {
         this.removeListener(param1,param2);
         delete this._dic[param1];
      }
      
      private function onSwitchComplete(param1:*) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._dic)
         {
            this.removeListener(_loc2_);
         }
         this._dic = new Dictionary();
      }
      
      private function removeListener(param1:InteractiveObject, param2:Boolean = true) : void
      {
         if(param2)
         {
            DisplayUtil.removeForParent(param1,param2);
         }
         if(this._dic[param1] != null)
         {
            param1.removeEventListener("click",this._dic[param1]);
         }
      }
   }
}

