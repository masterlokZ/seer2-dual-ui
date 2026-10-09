package com.taomee.seer2.app.arena
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import com.taomee.seer2.app.arena.animation.ArenaAnimationManager;
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.data.BuffResultInfo;
   import com.taomee.seer2.app.arena.data.FighterBuffInfo;
   import com.taomee.seer2.app.arena.data.FighterInfo;
   import com.taomee.seer2.app.arena.data.FighterPositionInfo;
   import com.taomee.seer2.app.arena.data.FighterTurnResultInfo;
   import com.taomee.seer2.app.arena.data.TurnResultInfo;
   import com.taomee.seer2.app.arena.effect.FighterSound;
   import com.taomee.seer2.app.arena.effect.SkillEffect;
   import com.taomee.seer2.app.arena.effect.SkillSound;
   import com.taomee.seer2.app.arena.events.FighterEvent;
   import com.taomee.seer2.app.arena.util.ArenaUtil;
   import com.taomee.seer2.app.config.PetSkinConfig;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.entity.AnimateElement;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.ds.HashMap;
   import seer2.next.entry.DynSwitch;
   
   public class Fighter extends AnimateElement
   {
      
      public static var MAIN_FIGHTER_Y:int = 90;
      
      public static var SUB_FIGHTER_Y:int = -5;
      
      public static var FIX_SCALE:Number = 0.55;
      
      private var _arenaData:ArenaDataInfo;
      
      private var _fighterInfo:FighterInfo;
      
      private var _fighterSide:int;
      
      private var _changeFighterSide:int;
      
      private var _isFit:Boolean = false;
      
      private var _fighterMC:MovieClip;
      
      private var _currentAction:String;
      
      private var _fighterAnimation:FighterAnimation;
      
      private var _currentSkillInfo:SkillInfo;
      
      private var _fighterSound:FighterSound;
      
      private var _skillSoundMap:HashMap;
      
      private var _activeSkillSound:SkillSound;
      
      private var _skillEffectMap:HashMap;
      
      private var _activeSkillEffect:SkillEffect;
      
      private var _resourceUrl:String;
      
      private var _turnResultInfo:TurnResultInfo;
      
      private var _fighterTurnResultInfo:FighterTurnResultInfo;
      
      private var _fighterBuffResultInfo:BuffResultInfo;
      
      private var _appearTriggered:Boolean = false;
      
      public function Fighter(param1:FighterInfo, param2:uint, param3:ArenaDataInfo, param4:Boolean = false)
      {
         super();
         this._arenaData = param3;
         this._fighterInfo = param1;
         this._fighterSide = param2;
         this._isFit = param4;
         this._currentAction = "个性出场";
         this._skillEffectMap = new HashMap();
         this._skillSoundMap = new HashMap();
         if(this._fighterSide == 2)
         {
            this.scaleX = -1;
            this.x = LayerManager.root.width - 120;
            this.y = 50;
         }
         else
         {
            this.x = 120;
            this.y = 50;
         }
         this.updatePosition();
         if(this._fighterSide == 1)
         {
            if(PetSkinConfig.getSkinId(this._fighterInfo.resourceId))
            {
               this._resourceUrl = URLUtil.getPetFightSwf(PetSkinConfig.getSkinId(this._fighterInfo.resourceId));
            }
            else
            {
               this._resourceUrl = URLUtil.getPetFightSwf(this._fighterInfo.resourceId);
            }
         }
         else
         {
            this._resourceUrl = URLUtil.getPetFightSwf(this._fighterInfo.resourceId);
         }
         if(DynSwitch.clearMode)
         {
            this._resourceUrl = URLUtil.getPetFightSwf(7890);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:SkillEffect = null;
         var _loc4_:Array = null;
         var _loc3_:SkillSound = null;
         this.deactive();
         TweenLite.killTweensOf(this);
         this._fighterInfo = null;
         this._currentSkillInfo = null;
         this._turnResultInfo = null;
         this._fighterTurnResultInfo = null;
         this._fighterBuffResultInfo = null;
         this._activeSkillEffect = null;
         this._activeSkillSound = null;
         var _loc2_:Array = this._skillEffectMap.getValues();
         for each(_loc1_ in _loc2_)
         {
            _loc1_.dispose();
            DisplayObjectUtil.removeFromParent(_loc1_);
         }
         this._skillEffectMap = null;
         _loc4_ = this._skillSoundMap.getValues();
         for each(_loc3_ in _loc4_)
         {
            _loc3_.dispose();
         }
         this._skillSoundMap = null;
         if(this._fighterAnimation != null)
         {
            this._fighterAnimation.dispose();
            this._fighterAnimation = null;
         }
         super.dispose();
      }
      
      public function takeAction() : void
      {
         if(this._fighterTurnResultInfo.skillId == 0)
         {
            this.playDefAction();
         }
         else
         {
            this.playAtkAction(this._fighterTurnResultInfo.skillId);
         }
      }
      
      public function fakeAct() : void
      {
         this.dispatchActionEvent("actionEnd");
      }
      
      public function updateInfo() : void
      {
         this._fighterInfo.hp = this._fighterTurnResultInfo.hp;
         this._fighterInfo.maxHp = this._fighterTurnResultInfo.maxHp;
         this.updateAnger(this._fighterTurnResultInfo.anger);
         this.updateFighterBuffer(this._fighterTurnResultInfo.buffInfoVec);
      }
      
      public function updateAnger(param1:uint) : void
      {
         this._fighterInfo.fightAnger = param1;
      }
      
      public function updateFighterBuffer(param1:Vector.<FighterBuffInfo>) : void
      {
         this._fighterInfo.fightBuffInfoVec = param1;
      }
      
      public function dyingHp() : void
      {
         this._fighterInfo.hp = 1;
      }
      
      public function isDead() : Boolean
      {
         return this._fighterInfo.hp == 0;
      }
      
      public function updatePosition() : void
      {
         var _loc1_:FighterPositionInfo = null;
         if(this._arenaData.isDoubleMode)
         {
            _loc1_ = this.getFighterTargetPosition();
            setPostion(_loc1_.point);
            this.scaleX = _loc1_.targetScaleX;
            this.scaleY = _loc1_.targetScaleY;
         }
      }
      
      public function getFighterTargetPosition() : FighterPositionInfo
      {
         var _loc1_:FighterPositionInfo = new FighterPositionInfo();
         if(this._fighterInfo.position == 1)
         {
            if(this._fighterSide == 2)
            {
               _loc1_.targetScaleX = -1;
               _loc1_.targetX = LayerManager.root.width - 120;
            }
            else
            {
               _loc1_.targetScaleX = 1;
               _loc1_.targetX = 120;
            }
            _loc1_.targetScaleY = 1;
            _loc1_.targetY += MAIN_FIGHTER_Y;
         }
         else
         {
            if(this._fighterSide == 2)
            {
               _loc1_.targetScaleX = -1 * FIX_SCALE;
               _loc1_.targetX = ((1 - FIX_SCALE) / 2 + FIX_SCALE) * LayerManager.root.width - 120;
            }
            else
            {
               _loc1_.targetScaleX = FIX_SCALE;
               _loc1_.targetX = (1 - FIX_SCALE) * LayerManager.root.width / 2 + 120;
            }
            _loc1_.targetScaleY = FIX_SCALE;
            _loc1_.targetY = (1 - FIX_SCALE) * LayerManager.root.height / 2;
            _loc1_.targetY += SUB_FIGHTER_Y * FIX_SCALE;
         }
         return _loc1_;
      }
      
      public function tweenToPosition(param1:Function) : void
      {
         var _loc2_:FighterPositionInfo = null;
         if(this._arenaData.isDoubleMode)
         {
            _loc2_ = this.getFighterTargetPosition();
            TweenLite.to(this,0.5,{
               "x":_loc2_.targetX,
               "y":_loc2_.targetY,
               "scaleX":_loc2_.targetScaleX,
               "scaleY":_loc2_.targetScaleY,
               "ease":Strong.easeIn,
               "onComplete":param1
            });
         }
         else
         {
            param1();
         }
      }
      
      public function disappear(param1:int) : void
      {
         var _loc2_:Fighter = this;
         if(param1 == 1)
         {
            if(this._fighterInfo.isChangeStatus == 1)
            {
               this._changeFighterSide = param1;
               this.action = "变身效果";
            }
            else
            {
               TweenLite.to(this,0.5,{
                  "x":-200,
                  "ease":Strong.easeIn,
                  "onComplete":this.onDisapper,
                  "onCompleteParams":[param1]
               });
            }
         }
         else if(param1 == 2)
         {
            TweenLite.to(this,0.5,{
               "x":1160,
               "ease":Strong.easeIn,
               "onComplete":this.onDisapper,
               "onCompleteParams":[param1]
            });
         }
      }
      
      public function onDisapper(param1:int) : void
      {
         var _loc2_:Fighter = this;
         this._fighterInfo.position = 0;
         this.deactive();
         if(this._fighterSide == 1)
         {
            _loc2_.x = 120;
         }
         else if(param1 == 2)
         {
            _loc2_.x = LayerManager.root.width - 120;
         }
         DisplayObjectUtil.removeFromParent(_loc2_);
      }
      
      public function onResoureceLoaded(param1:ContentInfo) : void
      {
         this._fighterMC = param1.content;
      }
      
      override public function set action(param1:String) : void
      {
         if(this._fighterInfo.hp <= 0 || this._fighterTurnResultInfo != null && this._fighterTurnResultInfo.hp <= 0)
         {
            param1 = "失败";
         }
         this._currentAction = param1;
         if(this._fighterAnimation == null)
         {
            return;
         }
         this._fighterAnimation.addEventListener("end",this.onActionEnd);
         this._fighterAnimation.addEventListener("fighterHit",this.onHit);
         super.action = this._currentAction;
      }
      
      public function hasAppearAction() : Boolean
      {
         return this._fighterAnimation != null && this._fighterAnimation.hasAppearAction();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var wasVisible:Boolean = super.visible;
         super.visible = param1;
         if(!wasVisible && param1 && this._fighterSide == 1 && !this._appearTriggered)
         {
            if(this.hasAppearAction())
            {
               this._appearTriggered = true;
               this.action = "个性出场";
            }
         }
      }
      
      public function winAction() : void
      {
      }
      
      public function active() : void
      {
         if(this._fighterAnimation == null)
         {
            this._fighterAnimation = new FighterAnimation();
            if(this._fighterSide == 1)
            {
               if(DynSwitch.clearMode)
               {
                  this._fighterAnimation.setup(this._fighterMC,7890);
               }
               else if(PetSkinConfig.getSkinId(this._fighterInfo.resourceId))
               {
                  this._fighterAnimation.setup(this._fighterMC,PetSkinConfig.getSkinId(this._fighterInfo.resourceId));
               }
               else
               {
                  this._fighterAnimation.setup(this._fighterMC,this._fighterInfo.resourceId);
               }
            }
            else if(DynSwitch.clearMode)
            {
               this._fighterAnimation.setup(this._fighterMC,7890);
            }
            else
            {
               this._fighterAnimation.setup(this._fighterMC,this._fighterInfo.resourceId);
            }
            animation = this._fighterAnimation;
         }
         if(this._fighterSide == 1 && this.hasAppearAction())
         {
            this._currentAction = "待机";
         }
         else
         {
            this._currentAction = "个性出场";
         }
         if(this._fighterInfo.hp <= 0)
         {
            this._currentAction = "失败";
         }
         this.action = this._currentAction;
      }
      
      public function deactive() : void
      {
         this.action = "空";
      }
      
      private function playDefAction() : void
      {
         var _loc2_:int = int(this._fighterInfo.hp);
         var _loc1_:int = int(this._fighterTurnResultInfo.hp);
         var _loc3_:int = int(this._fighterTurnResultInfo.maxHp);
         if(_loc1_ == 0)
         {
            this.action = "失败";
         }
         else if(_loc1_ < _loc3_ * 0.2)
         {
            this.action = "濒死";
         }
         else if(_loc1_ <= _loc2_)
         {
            this.action = "被打";
         }
         else
         {
            this.action = "闪避";
         }
      }
      
      public function sectionSkill() : void
      {
         var _loc2_:int = int(this._fighterInfo.hp);
         var _loc1_:int = int(this._fighterTurnResultInfo.hp);
         var _loc3_:int = int(this._fighterTurnResultInfo.maxHp);
         if(_loc1_ < _loc3_ * 0.2)
         {
            this._currentAction = "濒死";
         }
         else if(_loc1_ <= _loc2_)
         {
            this._currentAction = "被打";
         }
         else
         {
            this._currentAction = "闪避";
         }
         super.action = this._currentAction;
      }
      
      private function playAtkAction(param1:int) : void
      {
         this._currentSkillInfo = this._fighterInfo.getSkillInfo(param1);
         switch(this._currentSkillInfo.category)
         {
            case "物理":
               this.action = "物理攻击";
               break;
            case "必杀":
               ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.PowSkillStartAnimation",{
                  "target":this._fighterInfo.catchTime,
                  "side":this._fighterSide
               });
               ArenaUtil.vibrate(SceneManager.active.mapModel);
               if(this._currentSkillInfo.isIntercourse)
               {
                  this.action = "合体攻击";
               }
               else
               {
                  this.action = "必杀";
               }
               this.playSkillSound(this._currentSkillInfo.id);
               break;
            case "属性":
               this.action = "属性攻击";
               break;
            case "特殊":
               this.action = "特殊攻击";
         }
      }
      
      private function onHit(param1:Event) : void
      {
         this._fighterAnimation.removeEventListener("fighterHit",this.onHit);
         if(this._turnResultInfo.atkTimes > 0)
         {
            if(this._currentSkillInfo.category != "必杀")
            {
               this.playSkillSound(this._currentSkillInfo.id);
            }
            if(!this._fighterAnimation.usesExternalCompactTimeline)
            {
               this.playSkillEffect(this._fighterTurnResultInfo.skillId);
            }
         }
         this.dispatchActionEvent("sexHit");
         param1.stopImmediatePropagation();
      }
      
      private function onActionEnd(param1:Event) : void
      {
         if(this._fighterInfo.isChangeStatus == 1)
         {
            this.onDisapper(this._changeFighterSide);
            this._fighterInfo.isChangeStatus = 0;
         }
         if(this._fighterAnimation.hasEventListener("fighterHit"))
         {
            this._fighterAnimation.removeEventListener("fighterHit",this.onHit);
         }
         this._fighterAnimation.removeEventListener("end",this.onActionEnd);
         this.dispatchActionEvent("actionEnd");
      }
      
      public function setFighterSound(param1:FighterSound) : void
      {
         this._fighterSound = param1;
      }
      
      public function playFighterSound() : void
      {
         if(this._fighterSound != null)
         {
            this._fighterSound.playFighterSound();
         }
      }
      
      private function playSkillEffect(param1:int) : void
      {
         if(Boolean(this._activeSkillEffect) && contains(this._activeSkillEffect))
         {
            removeChild(this._activeSkillEffect);
         }
         this._activeSkillEffect = this._skillEffectMap.getValue(param1) as SkillEffect;
         if(this._activeSkillEffect)
         {
            this._activeSkillEffect.active();
            addChild(this._activeSkillEffect);
         }
      }
      
      public function addSkillEffect(param1:SkillEffect) : void
      {
         this._skillEffectMap.add(param1.skillId,param1);
      }
      
      private function playSkillSound(param1:uint) : void
      {
         if(this._activeSkillSound)
         {
            this._activeSkillSound.stop();
         }
         this._activeSkillSound = this._skillSoundMap.getValue(param1) as SkillSound;
         if(this._activeSkillSound)
         {
            this._activeSkillSound.play();
         }
      }
      
      public function addSkillSound(param1:SkillSound) : void
      {
         this._skillSoundMap.add(param1.skillId,param1);
      }
      
      override public function set resourceUrl(param1:String) : void
      {
         this._resourceUrl = param1;
      }
      
      override public function get resourceUrl() : String
      {
         return this._resourceUrl;
      }
      
      override public function set id(param1:uint) : void
      {
         throw new Error("DOT NEEDED!");
      }
      
      override public function get id() : uint
      {
         return this._fighterInfo.catchTime;
      }
      
      public function get fighterInfo() : FighterInfo
      {
         return this._fighterInfo;
      }
      
      public function get iconUrl() : String
      {
         return URLUtil.getPetIcon(this._fighterInfo.resourceId);
      }
      
      public function get fighterSide() : int
      {
         return this._fighterSide;
      }
      
      public function get isFit() : Boolean
      {
         return this._isFit;
      }
      
      private function dispatchActionEvent(param1:String) : void
      {
         if(hasEventListener(param1))
         {
            dispatchEvent(new FighterEvent(param1));
         }
      }
      
      public function set turnResultInfo(param1:TurnResultInfo) : void
      {
         var _loc2_:FighterTurnResultInfo = null;
         this._turnResultInfo = param1;
         for each(_loc2_ in this._turnResultInfo.fighterTurnResultInfoVec)
         {
            if(_loc2_.userId == this._fighterInfo.userId && _loc2_.catchTime == this._fighterInfo.catchTime)
            {
               this._fighterTurnResultInfo = _loc2_;
            }
         }
      }
      
      public function get fighterTurnResultInfo() : FighterTurnResultInfo
      {
         return this._fighterTurnResultInfo;
      }
      
      public function get turnResultInfo() : TurnResultInfo
      {
         return this._turnResultInfo;
      }
      
      public function set fighterBuffResultInfo(param1:BuffResultInfo) : void
      {
         this._fighterBuffResultInfo = param1;
      }
      
      public function get fighterBuffResultInfo() : BuffResultInfo
      {
         return this._fighterBuffResultInfo;
      }
      
      public function get fighterAnimation() : FighterAnimation
      {
         return this._fighterAnimation;
      }
   }
}

