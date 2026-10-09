package com.taomee.seer2.app.entity.handler
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.core.scene.SceneManager;
   
   public class HandlerChangePlant extends HandlerEntityClick
   {
      
      private var _targetMapId:uint;
      
      public function HandlerChangePlant()
      {
         super();
      }
      
      override public function initData(param1:XML) : void
      {
         this._targetMapId = uint(param1.toString());
      }
      
      override protected function action() : void
      {
         SceneManager.changeScene(8,ActorManager.actorInfo.id);
      }
   }
}

