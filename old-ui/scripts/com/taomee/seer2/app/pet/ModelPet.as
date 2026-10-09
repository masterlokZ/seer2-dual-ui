package com.taomee.seer2.app.pet
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.bubble.Bubble;
   import com.taomee.seer2.app.actor.bubble.BubblePool;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.pet.bubble.BubbleController;
   import com.taomee.seer2.app.pet.bubble.IBubbleHost;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.effect.SpawnedPetPresentEffectPool;
   import com.taomee.seer2.app.pet.effect.SpawnedPetSupriseEffectPool;
   import com.taomee.seer2.core.entity.PathMobile;
   import com.taomee.seer2.core.entity.events.ActionEvent;
   import com.taomee.seer2.core.entity.events.MoveEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ModelPet extends PathMobile implements IBubbleHost
   {
      
      protected static const MAX_IDEL_INTERVAL:int = 250;
      
      protected static const PERSONAL:String = "personal";
      
      protected static const STAND_DOWN:String = "standDown";
      
      protected static const ACTOR_CLOSE_DISTANCE:int = 20;
      
      protected var _petInfo:PetInfo;
      
      private var _positionIndex:int;
      
      private var _maxIdelTime:int;
      
      private var _idleTime:int;
      
      private var _actorTargetPoint:Point;
      
      private var _supriseEffect:MovieClip;
      
      private var _presendEffect:MovieClip;
      
      private var _presentEffectType:uint;
      
      private var _bubble:Bubble;
      
      private var _shadow:Sprite;
      
      private var _point:Point;
      
      private var _petId:uint;
      
      public function ModelPet(param1:Point, param2:uint)
      {
         super();
         this._petId = param2;
         this._petInfo = new PetInfo();
         this._petInfo.resourceId = param2;
         this._point = param1;
         this.initialize();
      }
      
      public static function isSpawnedPosition(param1:int) : Boolean
      {
         return param1 >= 0 && param1 <= 9;
      }
      
      private function initialize() : void
      {
         this.setResource();
         this.showLabel();
         this.addClickEventListener();
         this.hideAimation();
         addEventListener("addedToStage",this.onAddToStage);
      }
      
      protected function setResource() : void
      {
         this.buttonMode = true;
         this.mouseChildren = false;
         this.resourceUrl = URLUtil.getPetSwf(this._petInfo.resourceId);
      }
      
      private function hideAimation() : void
      {
         (this.animation as DisplayObject).visible = false;
      }
      
      protected function showAnimation() : void
      {
         (this.animation as DisplayObject).visible = true;
         BubbleController.getInstance().addBubbleHost(this);
         this.generateMaxIdelTime();
         this.addShadow();
      }
      
      private function addShadow() : void
      {
         this._shadow = UIManager.getSprite("UI_PetShadow");
         this._shadow.scaleX = this._shadow.scaleY = width / 40;
         addChildAt(this._shadow,0);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         this.present();
      }
      
      private function showLabel() : void
      {
         setLabelStyle(13395456,16777215);
         this.label = this._petInfo.name;
      }
      
      private function addClickEventListener() : void
      {
         addEventListener("click",this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PetDictionary"),"正在打开面板...",{
            "tabIndex":3,
            "showNewPetId":this._petId
         });
         param1.stopImmediatePropagation();
      }
      
      private function closeInteraction() : void
      {
         this.mouseEnabled = false;
      }
      
      private function openInteraction() : void
      {
         this.mouseEnabled = true;
      }
      
      private function stopAction() : void
      {
         this.stand();
         this.playSupriseEffect();
      }
      
      private function playSupriseEffect() : void
      {
         this._supriseEffect = SpawnedPetSupriseEffectPool.checkout();
         this._supriseEffect.y = 0 - this.height + 20;
         this._supriseEffect.addEventListener("enterFrame",this.onSuprisePlay);
         addChild(this._supriseEffect);
      }
      
      private function onSuprisePlay(param1:Event) : void
      {
         if(this._supriseEffect.currentFrame == this._supriseEffect.totalFrames)
         {
            this.recycleSupriseEffect();
         }
      }
      
      private function recycleSupriseEffect() : void
      {
         if(this._supriseEffect != null)
         {
            this._supriseEffect.removeEventListener("enterFrame",this.onSuprisePlay);
            this._supriseEffect.stop();
            removeChild(this._supriseEffect);
            SpawnedPetSupriseEffectPool.checkin(this._supriseEffect);
            this._supriseEffect = null;
         }
      }
      
      private function actorMoveClose() : void
      {
         var _loc1_:Actor = null;
         var _loc2_:Rectangle = new Rectangle(this.x - 20,this.y - 20,20 * 2,20 * 2);
         this._actorTargetPoint = this.generateWalkablePoint(_loc2_);
         if(this.isActorArrived(this._actorTargetPoint) == true)
         {
            this.startFight();
         }
         else
         {
            _loc1_ = ActorManager.getActor();
            _loc1_.addEventListener("finished",this.onActorReached,false,1);
            _loc1_.runToLocation(this._actorTargetPoint.x,this._actorTargetPoint.y);
         }
      }
      
      private function isActorArrived(param1:Point) : Boolean
      {
         var _loc2_:Actor = ActorManager.getActor();
         return _loc2_.isArrivedPosition(param1);
      }
      
      private function onActorReached(param1:MoveEvent) : void
      {
         if(this.isActorArrived(this._actorTargetPoint) == true)
         {
            this.startFight();
         }
         this.removeActorEventListener();
         this.openInteraction();
         param1.stopImmediatePropagation();
      }
      
      private function removeActorEventListener() : void
      {
         ActorManager.getActor().removeEventListener("finished",this.onActorReached);
      }
      
      protected function startFight() : void
      {
         FightManager.startFightWithWild(this._positionIndex);
      }
      
      protected function present() : void
      {
         var _loc2_:Rectangle = new Rectangle(0,0,LayerManager.root.width,LayerManager.root.height - 80);
         var _loc1_:Point = this.generateWalkablePoint(_loc2_);
         this.x = this._point.x;
         this.y = this._point.y;
         this.action = "standDown";
         this.playPresentEffect();
      }
      
      private function playPresentEffect() : void
      {
         this._presentEffectType = this._petInfo.type;
         this._presendEffect = SpawnedPetPresentEffectPool.checkout(this._presentEffectType);
         this._presendEffect.x = this.x;
         this._presendEffect.y = this.y - 10;
         this._presendEffect.addEventListener("enterFrame",this.onPresentEffectPlay);
         this.parent.addChild(this._presendEffect);
      }
      
      private function onPresentEffectPlay(param1:Event) : void
      {
         if(this._presendEffect.currentFrame == this._presendEffect.totalFrames)
         {
            this.recylePresentEffect();
            this.showAnimation();
         }
      }
      
      private function recylePresentEffect() : void
      {
         if(this._presendEffect != null)
         {
            this._presendEffect.removeEventListener("enterFrame",this.onPresentEffectPlay);
            this._presendEffect.stop();
            SpawnedPetPresentEffectPool.checkin(this._presendEffect,this._presentEffectType);
            this._presendEffect = null;
         }
      }
      
      protected function generateWalkablePoint(param1:Rectangle) : Point
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         do
         {
            _loc2_ = param1.x + Math.random() * param1.width;
            _loc3_ = param1.y + Math.random() * param1.height;
         }
         while(SceneManager.active.mapModel.canWalk(_loc2_,_loc3_) == false);
         return new Point(_loc2_,_loc3_);
      }
      
      override public function update() : void
      {
         this.checkIdleState();
         super.update();
      }
      
      private function checkIdleState() : void
      {
         if(this._maxIdelTime > 0 && this.moveStyle == "stand")
         {
            ++this._idleTime;
            if(this._idleTime > 250)
            {
               this.playIdelAnimation();
               this._idleTime = 0;
            }
            else if(this._idleTime > this._maxIdelTime)
            {
               this.randomWalk();
            }
         }
      }
      
      private function playIdelAnimation() : void
      {
         addActionEventListener("finished",this.onActionEnd);
         this.action = "personal";
      }
      
      private function onActionEnd(param1:ActionEvent) : void
      {
         removeActionEventListener("finished",this.onActionEnd);
         this.randomWalk();
      }
      
      private function randomWalk() : void
      {
         var _loc2_:Rectangle = new Rectangle(0,0,LayerManager.root.width,LayerManager.root.height - 80);
         var _loc1_:Point = this.generateWalkablePoint(_loc2_);
         walkToLocation(_loc1_.x,_loc1_.y);
         this.generateMaxIdelTime();
      }
      
      private function generateMaxIdelTime() : void
      {
         this._maxIdelTime = (250 >> 1) + (250 >> 1) * Math.random();
         this._idleTime = 0;
      }
      
      public function showBubble() : void
      {
      }
      
      private function getSlogan() : String
      {
         var _loc2_:Vector.<String> = this._petInfo.getSloganVec();
         var _loc1_:int = Math.random() * _loc2_.length;
         return _loc2_[_loc1_];
      }
      
      private function onBubbleDisappear(param1:Event) : void
      {
         this.checkInBubble();
      }
      
      private function checkInBubble() : void
      {
         if(this._bubble != null)
         {
            this._bubble.removeEventListener("close",this.onBubbleDisappear);
            BubblePool.checkIn(this._bubble);
            removeChild(this._bubble);
            this._bubble = null;
         }
      }
      
      override public function dispose() : void
      {
         BubbleController.getInstance().removeBubbleHost(this);
         this.recycleSupriseEffect();
         this.recylePresentEffect();
         this.removeActorEventListener();
         this.checkInBubble();
         super.dispose();
      }
   }
}

