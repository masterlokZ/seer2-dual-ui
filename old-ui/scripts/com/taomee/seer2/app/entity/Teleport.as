package com.taomee.seer2.app.entity
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.entity.pool.TeleportResourcePool;
   import com.taomee.seer2.core.entity.AnimateElement;
   import com.taomee.seer2.core.entity.IExtendedEntity;
   import com.taomee.seer2.core.entity.events.MoveEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.Util;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class Teleport extends AnimateElement implements IExtendedEntity
   {
      
      private const HOME_MAP_ID:uint = 50000;
      
      private const COPY_MAP_ID:uint = 80000;
      
      private const PLANT_MAP_ID:uint = 70000;
      
      private var _targetMapId:uint;
      
      private var _actorTargetPoint:Point;
      
      private var _spot:Sprite;
      
      public function Teleport()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.buttonMode = true;
      }
      
      public function setData(param1:XML) : void
      {
         var _loc4_:Point = null;
         this.name = param1.attribute("name").toString();
         var _loc2_:String = param1.attribute("pos").toString();
         _loc4_ = Util.parsePositionStr(_loc2_);
         this.x = _loc4_.x;
         this.y = _loc4_.y;
         var _loc3_:String = param1.attribute("targetPos").toString();
         this._actorTargetPoint = Util.parsePositionStr(_loc3_);
         this._targetMapId = uint(param1.attribute("targetMapId").toString());
         this.addSpot();
         this.addTooltip();
         addEventListener("click",this.onMouseClick);
      }
      
      protected function addSpot() : void
      {
         this._spot = TeleportResourcePool.checkOut();
         addChild(this._spot);
      }
      
      private function addTooltip() : void
      {
         if(this.name != "")
         {
            TooltipManager.addCommonTip(this,this.name);
         }
      }
      
      private function removeTooltip() : void
      {
         TooltipManager.remove(this);
      }
      
      public function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Actor = ActorManager.getActor();
         var _loc3_:Boolean = this.isTargetArrived();
         if(_loc3_)
         {
            this.changeMap();
         }
         else
         {
            _loc2_.addEventListener("finished",this.onActorMoveFinished);
            _loc2_.runToLocation(this.x,this.y);
         }
         param1.stopImmediatePropagation();
      }
      
      protected function isTargetArrived() : Boolean
      {
         var _loc1_:Actor = ActorManager.getActor();
         return _loc1_.x == this.x && _loc1_.y == this.y;
      }
      
      protected function onActorMoveFinished(param1:MoveEvent) : void
      {
         ActorManager.getActor().removeEventListener("finished",this.onActorMoveFinished);
         var _loc2_:Boolean = this.isTargetArrived();
         if(_loc2_)
         {
            this.changeMap();
         }
      }
      
      protected function changeMap() : void
      {
         var _loc1_:Actor = ActorManager.getActor();
         _loc1_.stand();
         if(this._targetMapId == 50000)
         {
            SceneManager.changeScene(3,ActorManager.actorInfo.id);
         }
         if(this._targetMapId == 70000)
         {
            SceneManager.changeScene(8,ActorManager.actorInfo.id);
         }
         else if(this._targetMapId < 50000 && this._targetMapId >= 10)
         {
            SceneManager.changeScene(1,this._targetMapId,this._actorTargetPoint.x,this._actorTargetPoint.y);
         }
         else if(this._targetMapId > 0 && this._targetMapId < 10)
         {
            SceneManager.changeScene(5,this._targetMapId,this._actorTargetPoint.x,this._actorTargetPoint.y);
         }
         else if(this._targetMapId > 80000)
         {
            SceneManager.changeScene(9,this._targetMapId,this._actorTargetPoint.x,this._actorTargetPoint.y);
         }
      }
      
      protected function checkPortInPool() : void
      {
         TeleportResourcePool.checkIn(this._spot);
      }
      
      override public function dispose() : void
      {
         ActorManager.getActor().removeEventListener("finished",this.onActorMoveFinished);
         this.checkPortInPool();
         this._spot = null;
         this.removeTooltip();
         super.dispose();
      }
   }
}

