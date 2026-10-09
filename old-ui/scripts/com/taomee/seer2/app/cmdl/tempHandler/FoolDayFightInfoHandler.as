package com.taomee.seer2.app.cmdl.tempHandler
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.net.parser.Parser_1548;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   
   public class FoolDayFightInfoHandler implements IHandler
   {
      
      public function FoolDayFightInfoHandler()
      {
         super();
      }
      
      public function handle(param1:Parser_1548) : void
      {
         SceneManager.addEventListener("switchComplete",this.onComplete);
         SceneManager.changeScene(8,ActorManager.actorInfo.id);
      }
      
      private function onComplete(param1:SceneEvent) : void
      {
         SceneManager.removeEventListener("switchComplete",this.onComplete);
         AlertManager.showAlert("你已经被射中30次了,不能继续参与射击了哦！");
         ModuleManager.showAppModule("FoolDayFightPanel");
      }
   }
}

