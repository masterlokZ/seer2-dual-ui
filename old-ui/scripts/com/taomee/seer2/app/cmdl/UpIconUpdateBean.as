package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.events.FightStartEvent;
   import com.taomee.seer2.app.controls.ToolBar;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dream.DreamMapOrganize;
   import com.taomee.seer2.app.home.panel.HomePanel;
   import com.taomee.seer2.app.plant.panelControl.PlantPanelControl;
   import com.taomee.seer2.app.questTiny.QuestTinyPanel;
   import com.taomee.seer2.app.rightToolbar.RightToolbarConter;
   import com.taomee.seer2.core.map.ResContentLibrary;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import flash.events.Event;
   import org.taomee.bean.BaseBean;
   
   public class UpIconUpdateBean extends BaseBean
   {
      
      public function UpIconUpdateBean()
      {
         super();
         LayerManager.stage.addEventListener("resize",this.onResize);
         SceneManager.addEventListener("switchComplete",this.onSwitchComplete);
         finish();
      }
      
      private function onSwitchComplete(param1:SceneEvent) : void
      {
         if(Boolean(SceneManager.active) && (SceneManager.active.type == 2 || SceneManager.active.type == 6 || SceneManager.active.type == 10 || SceneManager.active.type == 11 || SceneManager.active.type != 12 || SceneManager.active.type != 13))
         {
            FightManager.addEventListener("FIGHT_LOADING_END",this.onFightEnd);
         }
         else if(Boolean(SceneManager.active) && SceneManager.prevSceneType == 2)
         {
            SceneManager.active.mapModel.content.scaleX = 1;
            SceneManager.active.mapModel.content.scaleY = 1;
         }
      }
      
      private function onResize(param1:Event) : void
      {
         if(SceneManager.active && SceneManager.active.type != 6 && SceneManager.active.type != 10 && SceneManager.active.type != 11 && SceneManager.active.type != 12 && SceneManager.active.type != 13 && SceneManager.active.type != 14 && SceneManager.active.type != 15 && SceneManager.active.type != 16)
         {
            DialogPanel.layIcon();
            ResContentLibrary.updateRes();
            RightToolbarConter.instance.upupdate();
            LayerManager.layout();
            ToolBar.layIcons();
            QuestTinyPanel.layout();
            DreamMapOrganize.layout();
         }
         if(SceneManager.active && ActorManager.actorInfo && SceneManager.active.type == 3)
         {
            HomePanel.layIcons();
         }
         if(SceneManager.active && ActorManager.actorInfo && SceneManager.active.type == 8)
         {
            PlantPanelControl.layIcons();
         }
         if(Boolean(SceneManager.active) && (SceneManager.active.type == 2 || SceneManager.active.type == 6 || SceneManager.active.type == 10 || SceneManager.active.type == 11 || SceneManager.active.type != 12 || SceneManager.active.type != 13))
         {
            this.fightLayout();
         }
      }
      
      private function onFightEnd(param1:FightStartEvent) : void
      {
         FightManager.removeEventListener("FIGHT_LOADING_END",this.onFightEnd);
         this.fightLayout();
      }
      
      private function fightLayout() : void
      {
         var _loc1_:ArenaScene = SceneManager.active as ArenaScene;
         if(Boolean(_loc1_) && Boolean(_loc1_.arenaUIController))
         {
            _loc1_.arenaUIController.layOut();
            SceneManager.active.mapModel.content.scaleX = LayerManager.stage.stageWidth / 1200;
            SceneManager.active.mapModel.content.scaleY = LayerManager.stage.stageHeight / 660;
         }
      }
   }
}

