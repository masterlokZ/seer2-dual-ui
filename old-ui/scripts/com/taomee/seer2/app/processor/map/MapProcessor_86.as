package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.component.teleport.DeferTeleport;
   import com.taomee.seer2.app.gameRule.door.BinaryDoor;
   import com.taomee.seer2.app.gameRule.door.IDoor;
   import com.taomee.seer2.app.gameRule.door.PVPDoor;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcessor_86 extends MapProcessor
   {
      
      private var _doors:Vector.<IDoor> = new Vector.<IDoor>();
      
      private var _goFortDeferTeleport:DeferTeleport;
      
      private var _goFort:MovieClip;
      
      public function MapProcessor_86(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.initDeferTeleport();
         var _loc2_:LobbyScene = SceneManager.active as LobbyScene;
         _loc2_.showToolbar();
         ActorManager.showRemoteActor = true;
         var _loc1_:Sprite = _map.content;
         this._doors.push(new BinaryDoor(_loc1_["leftPassage"],0));
         this._doors.push(new PVPDoor(_loc1_["leftPassage4"],2,5));
         StatisticsManager.sendNovice("0x10033463");
      }
      
      private function initDeferTeleport() : void
      {
         this._goFort = _map.content["goFort"];
         initInteractor(this._goFort);
         TooltipManager.addCommonTip(this._goFort,"英格瓦要塞");
         this._goFort.addEventListener("click",this.onFortClick);
         this._goFortDeferTeleport = new DeferTeleport(this._goFort);
         this._goFortDeferTeleport.setActorPostion(new Point(480,370));
         this._goFortDeferTeleport.setActorTargetMapId(81);
         this._goFortDeferTeleport.addEventListener("actorArrived",this.onActorArrivedFort);
      }
      
      private function onFortClick(param1:MouseEvent) : void
      {
         this._goFortDeferTeleport.actorMoveClose();
      }
      
      private function onActorArrivedFort(param1:Event) : void
      {
         this._goFort.play();
      }
      
      override public function dispose() : void
      {
         var _loc1_:IDoor = null;
         this._goFortDeferTeleport.removeEventListener("actorArrived",this.onActorArrivedFort);
         this._goFortDeferTeleport = null;
         TooltipManager.remove(this._goFort);
         this._goFort.removeEventListener("click",this.onFortClick);
         this._goFort = null;
         var _loc2_:uint = this._doors.length;
         while(this._doors.length > 0)
         {
            _loc1_ = this._doors.pop();
            _loc1_.dispose();
         }
         super.dispose();
      }
   }
}

