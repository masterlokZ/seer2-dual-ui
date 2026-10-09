package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MapMailManager
   {
      
      private static var _instance:MapMailManager;
      
      private var _myself:Actor;
      
      public function MapMailManager(param1:PrivateClass)
      {
         super();
      }
      
      public static function getInstance() : MapMailManager
      {
         if(_instance == null)
         {
            _instance = new MapMailManager(new PrivateClass());
         }
         return _instance;
      }
      
      public function initMail(param1:MovieClip) : void
      {
         param1.buttonMode = true;
         TooltipManager.addCommonTip(param1,"下周预告");
         param1.addEventListener("click",this.onMail);
      }
      
      private function onMail(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PetKingAdvancePanel"),"正在打开...");
         this._myself = ActorManager.getActor();
         if(SceneManager.active.mapID == 70)
         {
            StatisticsManager.sendNovice("0x10033468");
         }
         else if(SceneManager.active.mapID == 80)
         {
            StatisticsManager.sendNovice("0x10033472");
         }
         else if(SceneManager.active.mapID == 40)
         {
            StatisticsManager.sendNovice("0x10033475");
         }
         else if(SceneManager.active.mapID == this._myself.getInfo().id)
         {
            StatisticsManager.sendNovice("0x10033491");
         }
      }
      
      public function destroyMail(param1:MovieClip) : void
      {
         param1.removeEventListener("click",this.onMail);
         TooltipManager.remove(param1);
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
