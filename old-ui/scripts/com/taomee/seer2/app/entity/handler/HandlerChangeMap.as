package com.taomee.seer2.app.entity.handler
{
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class HandlerChangeMap extends HandlerEntityClick
   {
      
      private var _targetMapId:uint;
      
      public function HandlerChangeMap()
      {
         super();
      }
      
      override public function initData(param1:XML) : void
      {
         this._targetMapId = uint(param1.toString());
      }
      
      override protected function action() : void
      {
         if(this._targetMapId > 80000)
         {
            SceneManager.changeScene(9,this._targetMapId);
         }
         else
         {
            SceneManager.changeScene(1,this._targetMapId);
         }
      }
   }
}

