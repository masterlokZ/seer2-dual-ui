package com.taomee.seer2.app.scene
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.actor.events.ActorEvent;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.gameRule.nono.Nono;
   import com.taomee.seer2.app.lobby.effect.StageClickEffectPool;
   import com.taomee.seer2.app.pet.FollowingPet;
   import com.taomee.seer2.app.robot.RobotActorManager;
   import com.taomee.seer2.core.entity.events.MoveEvent;
   import com.taomee.seer2.core.scene.BaseScene;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.EventManager;
   
   public class BigPathScene extends BaseScene
   {
      
      public function BigPathScene(param1:int)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         ActorManager.initialize(this);
      }
      
      override protected function clearScene() : void
      {
         ActorManager.leaveMap();
         RobotActorManager.removeAllRobotActor();
         this.removeGroundMouseEventListener();
         super.clearScene();
      }
      
      override protected function onTick(param1:int) : void
      {
         super.onTick(param1);
         ActorManager.update();
         RobotActorManager.update();
         mapModel.gameMap.sortDepth(this.getActors());
      }
      
      override protected function updateScene() : void
      {
         super.updateScene();
         ActorManager.enterMap();
         this.addGroundMouseEventListener();
      }
      
      override protected function syncToServer() : void
      {
         ActorManager.syncToServer();
         completeMap();
      }
      
      private function getActors() : Array
      {
         var _loc2_:FollowingPet = null;
         var _loc5_:Nono = null;
         var _loc1_:uint = 0;
         var _loc3_:Array = [];
         var _loc4_:Vector.<RemoteActor> = ActorManager.getAllRemoteActors();
         while(_loc1_ < _loc4_.length)
         {
            _loc3_.push(_loc4_[_loc1_]);
            _loc2_ = _loc4_[_loc1_].getFollowingPet();
            if(Boolean(_loc2_) && _loc2_.visible)
            {
               _loc3_.push(_loc2_);
            }
            _loc5_ = _loc4_[_loc1_].getNono();
            if((Boolean(_loc5_)) && _loc5_.isFollowing)
            {
               _loc3_.push(_loc5_);
            }
            _loc1_++;
         }
         _loc3_.push(ActorManager.getActor());
         _loc2_ = ActorManager.getActor().getFollowingPet();
         if(Boolean(_loc2_) && _loc2_.visible)
         {
            _loc3_.push(_loc2_);
         }
         _loc5_ = ActorManager.getActor().getNono();
         if((Boolean(_loc5_)) && _loc5_.isFollowing)
         {
            _loc3_.push(_loc5_);
         }
         return _loc3_;
      }
      
      private function addGroundMouseEventListener() : void
      {
         mapModel.ground.addEventListener("click",this.onGroundClick);
         ActorManager.getActor().addEventListener("move",this.onMove);
      }
      
      private function removeGroundMouseEventListener() : void
      {
         mapModel.ground.removeEventListener("click",this.onGroundClick);
         ActorManager.getActor().removeEventListener("move",this.onMove);
      }
      
      private function onMove(param1:MoveEvent) : void
      {
         var _loc2_:Point = param1.param;
         if(_loc2_)
         {
            this.moveScreen(_loc2_);
         }
      }
      
      private function moveScreen(param1:Point) : void
      {
         var _loc9_:Actor = ActorManager.getActor();
         var _loc11_:int = _loc9_.speed;
         var _loc10_:Number = -_loc11_ * param1.x;
         var _loc4_:Number = -_loc11_ * param1.y;
         var _loc3_:Sprite = mapModel.ground;
         var _loc7_:Sprite = mapModel.content;
         var _loc5_:Number = _loc3_.x - _loc10_;
         var _loc2_:Number = _loc3_.y - _loc4_;
         var _loc6_:Number = 960;
         var _loc8_:Number = 560;
         if(_loc5_ < 0 && _loc5_ > -(_loc3_.width - _loc6_) && _loc9_.x >= _loc6_ / 2 && _loc9_.x <= _loc3_.width - _loc6_ / 2)
         {
            _loc3_.x -= _loc10_;
            _loc7_.x -= _loc10_;
         }
         if(_loc2_ < 0 && _loc2_ > -(_loc3_.height - _loc8_) && _loc9_.y >= _loc8_ / 2 && _loc9_.y <= _loc3_.height - _loc8_ / 2)
         {
            _loc3_.y -= _loc4_;
            _loc7_.y -= _loc4_;
         }
         mapModel.gameMap.mapLayer.checkLoad(new Point(_loc9_.x,_loc9_.y));
      }
      
      private function onGroundClick(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.localX;
         var _loc3_:int = param1.localY;
         if(!ActorManager.getActor().isStop)
         {
            EventManager.dispatchEvent(new ActorEvent("actorOnhookWalk"));
            ActorManager.getActor().walk(_loc2_,_loc3_);
            mapModel.content.addChild(StageClickEffectPool.checkOut(_loc2_,_loc3_));
         }
         if(FightManager.autoFightFlag == true)
         {
            FightManager.autoFightFlag = false;
         }
      }
   }
}

