package animation.layer
{
   import animation.event.Events;
   import com.chunshu.seer2.uclient.UClientUniversalBattleAdapter;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import data.FightPet;
   import data.location.FighterLocation;
   import data.pet.ArenaData;
   import data.pet.ChangeData;
   import data.pet.FrameData;
   import data.pet.MoveData;
   import data.pet.PetData;
   import enums.FighterActionType;
   import enums.SkillCategoryName;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import utils.CacheUtils;
   import utils.Utils;
   
   public class PetLayer extends Sprite
   {
      
      public static const IDLE:String = "待机";
      
      public static const LEFT_SUB:int = 0;
      
      public static const RIGHT_SUB:int = 1;
      
      public static const LEFT_MAIN:int = 2;
      
      public static const RIGHT_MAIN:int = 3;
      
      private static const MOVE_ACTION_END:String = "fuiMoveActionEnd";
      
      private static const NATIVE_FRAME_RATE:Number = 40;
      
      private static const NATIVE_FRAME_INTERVAL_MS:Number = 25;
      
      private static const EXTERNAL_MAX_RENDER_WIDTH:Number = 720;
      
      private static const EXTERNAL_MAX_RENDER_HEIGHT:Number = 650;
      
      private static const EXTERNAL_TEMPLATE_CENTER_X:Number = 0;
      
      private static const EXTERNAL_TEMPLATE_BASELINE_Y:Number = 145;
      
      private static const EXTERNAL_TARGET_CENTER_X:Number = 163;
      
      private static const EXTERNAL_TARGET_BASELINE_Y:Number = 375;
      
      private static const EXTERNAL_UClient_TARGET_BASELINE_Y:Number = 375;
      
      private static const EXTERNAL_LEGACY_SCENE_SCALE:Number = 0.9;
      
      private var nativeActions:Dictionary = new Dictionary(true);
      
      private var fighters:Vector.<FightPet>;
      
      public var bgLayer:BackLayer;
      
      public var sceneProjectionLayer:Sprite;
      
      public var fgLayer:FrontLayer;
      
      public var soundLayer:SoundLayer;
      
      public var _version:int;
      
      private var externalActions:Dictionary = new Dictionary(true);
      
      private var externalPendingActions:Dictionary = new Dictionary(true);
      
      private var externalTerminalSuppressed:Dictionary = new Dictionary(true);
      
      private var externalPlaced:Dictionary = new Dictionary(true);
      
      private var externalPlacementAttempts:Dictionary = new Dictionary(true);
      
      private var externalPlacementHandlers:Dictionary = new Dictionary(true);
      
      private var externalShapeCoverStates:Dictionary = new Dictionary(true);
      
      private var externalAttackCoverBounds:Dictionary = new Dictionary(true);
      
      private var externalAttackCoverPending:Dictionary = new Dictionary(true);
      
      private var _dedicatedMovesCache:Dictionary = new Dictionary(true);
      
      public function PetLayer()
      {
         var _loc1_:int = 0;
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage,false,0,true);
         this.fighters = new Vector.<FightPet>();
         this.fighters.push(FightPet.build(1,2));
         this.fighters.push(FightPet.build(2,2));
         this.fighters.push(FightPet.build(1,1));
         this.fighters.push(FightPet.build(2,1));
         _loc1_ = 0;
         while(_loc1_ < fighters.length)
         {
            addChild(fighters[_loc1_].pet);
            _loc1_++;
         }
      }
      
      public function initData(param1:FrameData, param2:Function) : void
      {
         _version += 1;
         var _loc3_:int = _version;
         if(param1.move)
         {
            loadMoveFrame(param1,param2,_loc3_);
         }
         else if(param1.event)
         {
            loadEventFrame(param1,param2,_loc3_);
         }
         else
         {
            loadFrame(param1,param2,_loc3_);
         }
      }
      
      private function loadMoveFrame(param1:FrameData, param2:Function, param3:int) : void
      {
         var moveLabel:String;
         var hitLabel:String;
         var pets:Vector.<PetData>;
         var frame:FrameData = param1;
         var cb:Function = param2;
         var version:int = param3;
         var moveData:MoveData = frame.move;
         var moveSides:Vector.<int> = buildMoveSide(moveData.side);
         var atkSide:int = moveSides[0];
         var defSide:int = moveSides[1];
         var atk:MovieClip = fighters[1 + atkSide].pet;
         var def:MovieClip = fighters[1 + defSide].pet;
         setChildIndex(def,2);
         setChildIndex(atk,3);
         moveLabel = SkillCategoryName.atkLabel(moveData.category);
         hitLabel = buildHurtLabel(moveData.miss,moveData.critical);
         pets = Vector.<PetData>([null,frame.data.left.master,frame.data.right.master]);
         fgLayer.stopCustomSkillEffect();
         if(FighterActionType.superAtk().indexOf(moveLabel) >= 0)
         {
            fgLayer.playSuperAtkStart(atkSide);
            bgLayer.vibrate();
            soundLayer.playSkillSound(moveData.soundUrl);
         }
         updateStatus(atk,moveLabel,version);
         Utils.promiseAll([function(param1:Function):void
         {
            var resolve:Function = param1;
            onChild0Complete(atk,function():void
            {
               if(!checkVersion(version))
               {
                  return;
               }
               atk.dispatchEvent(new Event(MOVE_ACTION_END));
               updateStatus(atk,buildIdleLabel(pets[atkSide]),version);
               resolve();
            });
         },function(param1:Function):void
         {
            var handleHitFrame:Function = null;
            var resolve:Function = param1;
            var playHit:* = function():void
            {
               var hitSnapshot:int;
               var isFirstHit:Boolean;
               var isLastHit:Boolean;
               var hitDamage:int;
               if(!checkVersion(version))
               {
                  return;
               }
               if(currentHit > 0)
               {
                  return;
               }
               if(handleHitFrame != null)
               {
                  atk.removeEventListener(Event.ENTER_FRAME,handleHitFrame);
                  handleHitFrame = null;
               }
               currentHit += 1;
               hitSnapshot = currentHit;
               isFirstHit = hitSnapshot === 1;
               isLastHit = hitSnapshot === expectHitMax;
               hitDamage = int(hitDamages[hitSnapshot - 1]);
               cb && cb(Events.frameMoveHit());
               if(isFirstHit && FighterActionType.superAtk().indexOf(moveLabel) < 0)
               {
                  soundLayer.playSkillSound(moveData.soundUrl);
               }
               if(isLastHit)
               {
                  if(FighterActionType.superAtk().indexOf(moveLabel) >= 0)
                  {
                     fgLayer.playCustomSkillEffect(buildCustomSkillUrl(pets[atkSide]),atkSide);
                  }
                  fgLayer.playSkillEffect(moveData.effectUrl,atkSide);
               }
               if("属性攻击" === moveLabel)
               {
                  updateStatus(def,buildIdleLabel(pets[defSide]),version);
                  if(isLastHit)
                  {
                     resolve();
                  }
                  return;
               }
               if(FighterActionType.damage().indexOf(moveLabel) >= 0)
               {
                  if(hitDamage > 0)
                  {
                     fgLayer.playHpReduceSplash(defSide,hitDamage,moveData.critical,moveData.rate);
                  }
                  else if(moveData.miss > 0)
                  {
                     fgLayer.playMiss(defSide);
                  }
                  else
                  {
                     fgLayer.playAbsorb(defSide);
                  }
                  if(isFirstHit && moveData.miss <= 0)
                  {
                     if(moveData.critical > 0)
                     {
                        fgLayer.playCriticalHit();
                     }
                  }
               }
               updateStatus(def,hitLabel,version);
               onChild0Complete(def,function():void
               {
                  if(!checkVersion(version))
                  {
                     return;
                  }
                  if(currentHit !== hitSnapshot)
                  {
                     return;
                  }
                  updateStatus(def,buildIdleLabel(pets[defSide]),version);
                  if(isLastHit)
                  {
                     resolve();
                  }
               });
            };
            var totalDamage:int = moveData.damage;
            var currentHit:int = 0;
            var expectHitMax:int = 1;
            var hitDamages:Array = [totalDamage];
            var hits:Vector.<int> = moveData.hits;
            var targetHitFrame:int = 0;
            var lastActionFrame:int = -1;
            if(isExternalCompactTimeline(atk))
            {
               Utils.once(atk,"hit",playHit);
            }
            else if(hits && hits.length)
            {
               targetHitFrame = hits[hits.length - 1];
               handleHitFrame = function(param1:Event):void
               {
                  var action:MovieClip = findCompletionClip(atk);
                  var frame:int = action == null ? -1 : action.currentFrame;
                  if(frame < 0)
                  {
                     return;
                  }
                  if(frame >= targetHitFrame || lastActionFrame > frame && lastActionFrame >= targetHitFrame)
                  {
                     playHit();
                     return;
                  }
                  lastActionFrame = frame;
               };
               atk.addEventListener(Event.ENTER_FRAME,handleHitFrame,false,0,true);
            }
            else
            {
               Utils.once(atk,"hit",playHit);
            }
            Utils.once(atk,MOVE_ACTION_END,playHit);
         }],function():void
         {
            cb && cb(Events.framePlayEnd());
         });
      }
      
      private function loadEventFrame(param1:FrameData, param2:Function, param3:int) : void
      {
         var main:FightPet;
         var sub:FightPet;
         var frame:FrameData = param1;
         var cb:Function = param2;
         var version:int = param3;
         var typ:int = frame.event.type;
         var side:int = frame.event.side;
         var change:int = frame.event.change;
         var delay:int = frame.event.delay;
         if(typ === 5)
         {
            fgLayer.playCatchFailed(function():void
            {
               if(!checkVersion(version))
               {
                  return;
               }
               loadFrame(frame,cb,version);
            });
            return;
         }
         if(typ === 6)
         {
            fgLayer.playCatchSuccess(function():void
            {
               loadFrame(frame,function():void
               {
                  if(!checkVersion(version))
                  {
                     return;
                  }
                  var _loc1_:FightPet = fighters[3];
                  if(_loc1_.pet)
                  {
                     _loc1_.url = "unreachable";
                     _loc1_.pet.visible = false;
                  }
               },version);
            },function():void
            {
               if(!checkVersion(version))
               {
                  return;
               }
               cb && cb(Events.framePlayEnd());
            });
            return;
         }
         if(typ === 7)
         {
            main = fighters[side === 2 ? 3 : 2];
            sub = fighters[side === 2 ? 1 : 0];
            Utils.promiseAll([function(param1:Function):void
            {
               TweenLite.to(main.pet,0.5,{
                  "x":sub.x,
                  "y":sub.y,
                  "scaleX":sub.scaleX,
                  "scaleY":sub.scaleY,
                  "ease":Strong.easeIn,
                  "onComplete":param1
               });
            },function(param1:Function):void
            {
               TweenLite.to(sub.pet,0.5,{
                  "x":main.x,
                  "y":main.y,
                  "scaleX":main.scaleX,
                  "scaleY":main.scaleY,
                  "ease":Strong.easeIn,
                  "onComplete":param1
               });
            }],function():void
            {
               if(!checkVersion(version))
               {
                  return;
               }
               var _loc1_:MovieClip = main.pet;
               main.pet = sub.pet;
               sub.pet = _loc1_;
               loadFrame(frame,cb,version);
            });
            return;
         }
         if(typ === 1)
         {
            fgLayer.playHPIncrease(side,change);
         }
         else if(typ === 2)
         {
            fgLayer.playHPDecrease(side,change);
         }
         else if(typ === 3)
         {
            fgLayer.playItemUse(side,0,1,change);
         }
         else if(typ === 4)
         {
            fgLayer.playItemUse(side,0,2,change);
         }
         setTimeout(function():void
         {
            loadFrame(frame,cb,version);
         },delay);
      }
      
      private function loadFrame(param1:FrameData, param2:Function, param3:int) : void
      {
         var frame:FrameData = param1;
         var cb:Function = param2;
         var version:int = param3;
         var arenaData:ArenaData = frame.data;
         var change:ChangeData = frame.change || new ChangeData();
         var winner:int = frame.end ? frame.end.winner : 0;
         var showReplace:int = frame.start ? 1 : 0;
         Utils.promiseAll([function(param1:Function):void
         {
            lazyApplyPet(fighters[0],arenaData.left.slave,showReplace || 0,version,param1,winner);
         },function(param1:Function):void
         {
            lazyApplyPet(fighters[1],arenaData.right.slave,showReplace || 0,version,param1,winner);
         },function(param1:Function):void
         {
            lazyApplyPet(fighters[2],arenaData.left.master,showReplace || change.left,version,param1,winner);
         },function(param1:Function):void
         {
            lazyApplyPet(fighters[3],arenaData.right.master,showReplace || change.right,version,param1,winner);
         }],function():void
         {
            cb && cb(Events.framePlayEnd());
         });
      }
      
      private function updateStatus(param1:MovieClip, param2:String, param3:int) : void
      {
         var pet:MovieClip = param1;
         var label:String = param2;
         var version:int = param3;
         if(isExternalIdleOnlyPose(pet))
         {
            updateExternalIdleOnlyStatus(pet,label);
            return;
         }
         if(isExternalCompactTimeline(pet))
         {
            updateExternalStatus(pet,label);
            return;
         }
         stopNativeAction(pet);
         if(!Utils.hasLabel(pet,label))
         {
            if(FighterActionType.atk().indexOf(label) >= 0)
            {
               label = "物理攻击";
            }
            else if(FighterActionType.hurt().indexOf(label) >= 0)
            {
               label = "被打";
            }
            else
            {
               label = "待机";
            }
         }
         pet.gotoAndStop(label);
         startNativeAction(pet,label);
         if(FighterActionType.end().indexOf(label) >= 0)
         {
            onChild0Complete(pet,function():void
            {
               if(checkVersion(version))
               {
                  (pet.getChildAt(0) as MovieClip).stop();
               }
            });
         }
      }
      
      private function buildCustomSkillUrl(param1:PetData) : String
      {
         var url:String = param1 == null ? "" : param1.petSwf || "";
         if(url.indexOf("/fight/") < 0)
         {
            return "";
         }
         return url.replace("/fight/","/skill/");
      }
      
      private function updateExternalStatus(param1:MovieClip, param2:String) : void
      {
         var pet:MovieClip = param1;
         var status:String = param2;
         var terminal:Boolean = status == "濒死" || status == "失败";
         var ownAction:Boolean = FighterActionType.atk().indexOf(status) >= 0;
         var hurtAction:Boolean = FighterActionType.hurt().indexOf(status) >= 0;
         var label:String = "";
         var action:MovieClip = null;
         if(ownAction)
         {
            externalTerminalSuppressed[pet] = true;
         }
         else if(hurtAction)
         {
            externalTerminalSuppressed[pet] = false;
         }
         if(terminal && externalTerminalSuppressed[pet] === true)
         {
            status = IDLE;
            terminal = false;
         }
         if(terminal && isExternalHurtLabel(pet.currentLabel))
         {
            action = findExternalAction(pet);
            if(action != null && action.currentFrame >= action.totalFrames)
            {
               stopExternalAction(pet);
               action.stop();
               if(hasAnimatedDescendant(action,0))
               {
                  return;
               }
               externalTerminalSuppressed[pet] = true;
               status = IDLE;
               terminal = false;
            }
         }
         label = resolveExternalLabel(pet,status);
         if(label == "")
         {
            label = resolveExternalLabel(pet,IDLE);
            status = IDLE;
            terminal = false;
         }
         if(label == "")
         {
            return;
         }
         if(status == IDLE && UClientUniversalBattleAdapter.supports(pet) && isExternalIdleLabel(pet.currentLabel) && isExternalIdleLabel(label) && externalActions[pet] == null && externalPendingActions[pet] == null)
         {
            return;
         }
         stopExternalAction(pet);
         try
         {
            pet.gotoAndStop(label);
         }
         catch(ignored:*)
         {
            return;
         }
         action = findExternalAction(pet);
         if(action == null)
         {
            scheduleExternalAction(pet,status,ownAction);
            return;
         }
         applyExternalActionState(pet,status,ownAction,action);
      }
      
      private function isExternalIdleLabel(param1:String) : Boolean
      {
         var label:String = (param1 || "").toLowerCase();
         return label == "standby" || label == "idle" || label == "stand" || label == "wait" || label == "待机";
      }
      
      private function scheduleExternalAction(param1:MovieClip, param2:String, param3:Boolean) : void
      {
         var pet:MovieClip = param1;
         var status:String = param2;
         var ownAction:Boolean = param3;
         var handler:Function = null;
         handler = function(param1:Event):void
         {
            var action:MovieClip = null;
            pet.removeEventListener(Event.FRAME_CONSTRUCTED,handler);
            delete externalPendingActions[pet];
            action = findExternalAction(pet);
            if(action != null)
            {
               applyExternalActionState(pet,status,ownAction,action);
            }
         };
         externalPendingActions[pet] = {"handler":handler};
         pet.addEventListener(Event.FRAME_CONSTRUCTED,handler,false,0,true);
      }
      
      private function applyExternalActionState(param1:MovieClip, param2:String, param3:Boolean, param4:MovieClip) : void
      {
         var pet:MovieClip = param1;
         var status:String = param2;
         var ownAction:Boolean = param3;
         var action:MovieClip = param4;
         var ultimateAttackFallback:Boolean = isExternalUltimateAttackFallback(pet,status);
         var coverAction:Boolean = ownAction || ultimateAttackFallback;
         var continuousAttack:Boolean = FighterActionType.atk().indexOf(status) >= 0 || ultimateAttackFallback;
         var terminalHurtFallback:Boolean = (status == "濒死" || status == "失败") && isExternalHurtLabel(pet.currentLabel);
         if(status == IDLE)
         {
            try
            {
               action.gotoAndStop(1);
            }
            catch(idleError:*)
            {
               action.stop();
            }
            return;
         }
         playExternalAction(pet,action,terminalHurtFallback,coverAction,continuousAttack);
      }
      
      private function isExternalHurtLabel(param1:String) : Boolean
      {
         var label:String = (param1 || "").toLowerCase();
         return label == "hited" || label == "hurt" || label == "hit" || label == "behit" || label == "damage";
      }
      
      private function playExternalAction(param1:MovieClip, param2:MovieClip, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         var pet:MovieClip = param1;
         var action:MovieClip = param2;
         var terminalHurtFallback:Boolean = param3;
         var ownAction:Boolean = param4 && !isExternalLegacySceneTimeline(pet);
         var continuousCover:Boolean = param5;
         var hitSent:Boolean = false;
         var lastFrame:int = -1;
         var stalledTicks:int = 0;
         var handler:Function = function(param1:Event):void
         {
            var hit:Boolean = false;
            var currentFrame:int = 0;
            if(externalActions[pet] == null || externalActions[pet].action !== action)
            {
               action.removeEventListener(Event.ENTER_FRAME,handler);
               return;
            }
            if(ownAction)
            {
               attachExternalShapeCover(pet,action);
            }
            try
            {
               hit = "hit" in action && Boolean(action["hit"]);
               if(hit)
               {
                  action["hit"] = 0;
               }
            }
            catch(ignored:*)
            {
            }
            if(hit && !hitSent)
            {
               hitSent = true;
               pet.dispatchEvent(new Event("hit"));
            }
            currentFrame = action.currentFrame;
            if(currentFrame >= action.totalFrames)
            {
               action.removeEventListener(Event.ENTER_FRAME,handler);
               delete externalActions[pet];
               resetExternalShapeCover(pet);
               action.stop();
               if(terminalHurtFallback && !hasAnimatedDescendant(action,0))
               {
                  updateExternalStatus(pet,IDLE);
               }
               return;
            }
            if(currentFrame == lastFrame)
            {
               ++stalledTicks;
            }
            else
            {
               lastFrame = currentFrame;
               stalledTicks = 0;
            }
            if(stalledTicks >= 2)
            {
               stalledTicks = 0;
               try
               {
                  action.play();
               }
               catch(resumeError:*)
               {
               }
            }
         };
         externalActions[pet] = {
            "action":action,
            "handler":handler,
            "continuousCover":continuousCover
         };
         action.addEventListener(Event.ENTER_FRAME,handler,false,0,true);
         try
         {
            if(ownAction)
            {
               attachExternalShapeCover(pet,action);
               primeExternalShapeCover(pet,action);
            }
            action.gotoAndPlay(action.totalFrames > 1 ? 2 : 1);
            if(ownAction)
            {
               applyExternalShapeCover(pet,action);
            }
         }
         catch(playError:*)
         {
            action.stop();
         }
      }
      
      private function primeExternalShapeCover(param1:MovieClip, param2:MovieClip) : void
      {
         var pet:MovieClip = param1;
         var action:MovieClip = param2;
         var actionClass:Class = null;
         var probe:MovieClip = null;
         var state:Object = pet == null ? null : externalShapeCoverStates[pet];
         var viewport:Rectangle = null;
         var seed:Shape = null;
         var seedBounds:Rectangle = null;
         var delta:Matrix = null;
         var frame:int = 1;
         var limit:int = 0;
         if(pet == null || action == null || state == null || state.action !== action || state.frozenDelta != null || action.stage == null || hasExternalFullscreenRoute(pet,action))
         {
            return;
         }
         try
         {
            viewport = getExternalActionViewport(action);
            if(viewport == null || viewport.width <= 1 || viewport.height <= 1)
            {
               return;
            }
            if(UClientUniversalBattleAdapter.supports(pet))
            {
               if(isExternalAttackCoverLabel(pet.currentLabel))
               {
                  seedBounds = externalAttackCoverBounds[pet] as Rectangle;
                  if(seedBounds != null)
                  {
                     delta = buildExternalShapeCoverDelta(seedBounds,viewport);
                     if(delta != null)
                     {
                        state.seed = null;
                        state.frozenDelta = delta.clone();
                     }
                  }
               }
               return;
            }
            actionClass = action.constructor as Class;
            if(actionClass == null)
            {
               return;
            }
            probe = new actionClass() as MovieClip;
            if(probe == null)
            {
               return;
            }
            limit = Math.min(probe.totalFrames,96);
            probe.stop();
            while(frame <= limit && state.frozenDelta == null)
            {
               probe.gotoAndStop(frame);
               seed = findExternalShapeSeed(probe,viewport);
               if(seed != null)
               {
                  seedBounds = seed.getBounds(probe);
                  delta = buildExternalShapeCoverDelta(seedBounds,viewport);
                  if(delta != null)
                  {
                     state.seed = null;
                     state.frozenDelta = delta.clone();
                     break;
                  }
               }
               frame++;
            }
         }
         catch(primeError:*)
         {
         }
      }
      
      private function isExternalAttackCoverLabel(param1:String) : Boolean
      {
         var label:String = (param1 || "").toLowerCase();
         return label == "attack" || label == "atk" || label == "attack1" || label == "normalattack" || label == "cp" || label == "sa" || label == "skill" || label == "attribute" || label == "support" || label == "special" || label == "magic" || label == "hidemove" || label == "sa5" || label == "as5" || label == "attack5" || label == "ultimate" || label == "ultra" || label == "power" || label == "add1";
      }
      
      private function isExternalUltimateAttackFallback(param1:MovieClip, param2:String) : Boolean
      {
         return param1 != null && FighterActionType.superAtk().indexOf(param2) >= 0 && isExternalAttackCoverLabel(param1.currentLabel);
      }
      
      private function isExternalContinuousCoverAction(param1:MovieClip, param2:MovieClip) : Boolean
      {
         var pet:MovieClip = param1;
         var action:MovieClip = param2;
         var state:Object = pet == null ? null : externalActions[pet];
         return state != null && state.action === action && state.continuousCover === true;
      }
      
      private function prewarmExternalAttackCover(param1:MovieClip) : void
      {
         var pet:MovieClip = param1;
         var rootClass:Class = null;
         var probeRoot:MovieClip = null;
         var probeAction:MovieClip = null;
         var eventBlocker:Function = null;
         var finish:Function = null;
         var scan:Function = null;
         var state:Object = null;
         var frame:int = 1;
         var limit:int = 0;
         var viewport:Rectangle = new Rectangle(0,0,1000,550);
         if(pet == null || !UClientUniversalBattleAdapter.supports(pet) || externalAttackCoverBounds[pet] != null || externalAttackCoverPending[pet] != null)
         {
            return;
         }
         state = {};
         externalAttackCoverPending[pet] = state;
         setTimeout(function():void
         {
            var seed:Shape = null;
            var seedBounds:Rectangle = null;
            try
            {
               if(externalAttackCoverPending[pet] !== state)
               {
                  return;
               }
               rootClass = pet.constructor as Class;
               probeRoot = rootClass == null ? null : new rootClass() as MovieClip;
               if(probeRoot == null)
               {
                  delete externalAttackCoverPending[pet];
                  return;
               }
               probeRoot.gotoAndStop("attack");
               probeAction = findExternalAction(probeRoot);
               if(probeAction == null)
               {
                  delete externalAttackCoverPending[pet];
                  return;
               }
               eventBlocker = function(param1:Event):void
               {
                  param1.stopImmediatePropagation();
               };
               probeAction.addEventListener("uClientFtrEventVideo",eventBlocker,false,int.MAX_VALUE,true);
               probeAction.stop();
               limit = Math.min(probeAction.totalFrames,96);
               finish = function():void
               {
                  try
                  {
                     if(probeAction != null && eventBlocker != null)
                     {
                        probeAction.removeEventListener("uClientFtrEventVideo",eventBlocker);
                        probeAction.stop();
                     }
                  }
                  catch(cleanupError:*)
                  {
                  }
                  if(externalAttackCoverPending[pet] === state)
                  {
                     delete externalAttackCoverPending[pet];
                  }
                  probeAction = null;
                  probeRoot = null;
               };
               scan = function():void
               {
                  var chunkEnd:int = 0;
                  if(externalAttackCoverPending[pet] !== state)
                  {
                     finish();
                     return;
                  }
                  try
                  {
                     chunkEnd = Math.min(limit,frame + 7);
                     while(frame <= chunkEnd)
                     {
                        probeAction.gotoAndStop(frame);
                        seed = findExternalShapeSeed(probeAction,viewport);
                        if(seed != null)
                        {
                           seedBounds = seed.getBounds(probeAction);
                           if(seedBounds != null)
                           {
                              externalAttackCoverBounds[pet] = seedBounds.clone();
                              finish();
                              return;
                           }
                        }
                        ++frame;
                     }
                  }
                  catch(scanError:*)
                  {
                     finish();
                     return;
                  }
                  if(frame <= limit)
                  {
                     setTimeout(scan,1);
                  }
                  else
                  {
                     finish();
                  }
               };
               scan();
            }
            catch(createError:*)
            {
               if(externalAttackCoverPending[pet] === state)
               {
                  delete externalAttackCoverPending[pet];
               }
            }
         },1);
      }
      
      private function stopExternalAction(param1:MovieClip) : void
      {
         var pending:Object = externalPendingActions[param1];
         var state:Object = externalActions[param1];
         if(pending != null && pending.handler != null)
         {
            param1.removeEventListener(Event.FRAME_CONSTRUCTED,pending.handler);
         }
         delete externalPendingActions[param1];
         if(state != null && state.action != null && state.handler != null)
         {
            state.action.removeEventListener(Event.ENTER_FRAME,state.handler);
         }
         resetExternalShapeCover(param1);
         delete externalActions[param1];
      }
      
      private function attachExternalShapeCover(param1:MovieClip, param2:MovieClip) : void
      {
         var pet:MovieClip = param1;
         var action:MovieClip = param2;
         var state:Object = externalShapeCoverStates[pet];
         var handler:Function = null;
         if(pet == null || action == null)
         {
            return;
         }
         if(state != null && state.action === action && state.handler != null)
         {
            return;
         }
         resetExternalShapeCover(pet);
         handler = function(param1:Event):void
         {
            if(externalShapeCoverStates[pet] == null || externalShapeCoverStates[pet].action !== action || action.parent == null)
            {
               resetExternalShapeCover(pet);
               return;
            }
            restoreExternalShapeCover(pet);
            applyExternalShapeCover(pet,action);
         };
         state = {
            "action":action,
            "handler":handler,
            "saved":[],
            "seed":null,
            "frozenDelta":null
         };
         externalShapeCoverStates[pet] = state;
         action.addEventListener(Event.EXIT_FRAME,handler,false,int.MIN_VALUE,true);
      }
      
      private function applyExternalShapeCover(param1:MovieClip, param2:MovieClip) : void
      {
         var pet:MovieClip = param1;
         var action:MovieClip = param2;
         var state:Object = externalShapeCoverStates[pet];
         var viewport:Rectangle = null;
         var seed:Shape = null;
         var seedBounds:Rectangle = null;
         var delta:Matrix = null;
         var index:int = 0;
         var child:Shape = null;
         var childBounds:Rectangle = null;
         var nextMatrix:Matrix = null;
         var continuousCover:Boolean = false;
         if(pet == null || action == null || state == null || state.action !== action)
         {
            return;
         }
         restoreExternalShapeCover(pet);
         state.saved = [];
         continuousCover = isExternalContinuousCoverAction(pet,action);
         if(hasExternalFullscreenRoute(pet,action) || action.parent == null || action.stage == null)
         {
            return;
         }
         viewport = getExternalActionViewport(action);
         if(viewport == null || viewport.width <= 1 || viewport.height <= 1)
         {
            return;
         }
         delta = state.frozenDelta as Matrix;
         if(delta == null && UClientUniversalBattleAdapter.supports(pet) && isExternalAttackCoverLabel(pet.currentLabel))
         {
            seedBounds = externalAttackCoverBounds[pet] as Rectangle;
            if(seedBounds != null)
            {
               delta = buildExternalShapeCoverDelta(seedBounds,viewport);
               if(delta != null)
               {
                  state.seed = null;
                  state.frozenDelta = delta.clone();
               }
            }
         }
         if(delta == null)
         {
            seed = state.seed as Shape;
            if(!isExternalShapeSeedValid(seed,action,viewport))
            {
               seed = findExternalShapeSeed(action,viewport);
               state.seed = seed;
            }
            if(seed == null)
            {
               return;
            }
            try
            {
               seedBounds = seed.getBounds(action);
               delta = buildExternalShapeCoverDelta(seedBounds,viewport);
            }
            catch(geometryError:*)
            {
               return;
            }
            if(delta != null)
            {
               state.frozenDelta = delta.clone();
            }
         }
         if(delta == null)
         {
            return;
         }
         for(; index < action.numChildren; index++)
         {
            child = action.getChildAt(index) as Shape;
            if(child != null)
            {
               try
               {
                  childBounds = child.getBounds(action);
                  if(isExternalShapeBoundsValid(childBounds) && hasExternalShapeRectOccupancy(child,childBounds))
                  {
                     state.saved.push({
                        "shape":child,
                        "matrix":child.transform.matrix.clone()
                     });
                     nextMatrix = child.transform.matrix.clone();
                     nextMatrix.concat(delta);
                     child.transform.matrix = nextMatrix;
                  }
               }
               catch(applyError:*)
               {
                  continue;
               }
            }
         }
      }
      
      private function getExternalActionViewport(param1:MovieClip) : Rectangle
      {
         var action:MovieClip = param1;
         var stageWidth:Number = FighterLocation.WIDTH;
         var stageHeight:Number = FighterLocation.HEIGHT;
         var topLeft:Point = null;
         var bottomRight:Point = null;
         if(action == null || action.stage == null)
         {
            return null;
         }
         try
         {
            if(action.stage.stageWidth > 1)
            {
               stageWidth = action.stage.stageWidth;
            }
            if(action.stage.stageHeight > 1)
            {
               stageHeight = action.stage.stageHeight;
            }
            topLeft = action.globalToLocal(new Point(0,0));
            bottomRight = action.globalToLocal(new Point(stageWidth,stageHeight));
            return new Rectangle(Math.min(topLeft.x,bottomRight.x),Math.min(topLeft.y,bottomRight.y),Math.abs(bottomRight.x - topLeft.x),Math.abs(bottomRight.y - topLeft.y));
         }
         catch(viewportError:*)
         {
            return null;
         }
      }
      
      private function isExternalShapeBoundsValid(param1:Rectangle) : Boolean
      {
         var bounds:Rectangle = param1;
         return bounds != null && Boolean(isFinite(bounds.x)) && Boolean(isFinite(bounds.y)) && Boolean(isFinite(bounds.width)) && Boolean(isFinite(bounds.height)) && Math.abs(bounds.x) < 100000 && Math.abs(bounds.y) < 100000 && bounds.width > 1 && bounds.height > 1;
      }
      
      private function hasExternalShapeViewportCover(param1:MovieClip, param2:Rectangle) : Boolean
      {
         var action:MovieClip = param1;
         var viewport:Rectangle = param2;
         var tolerance:Number = 0;
         var seed:Shape = null;
         var seedBounds:Rectangle = null;
         var bounds:Rectangle = null;
         if(action == null || viewport == null)
         {
            return false;
         }
         seed = findExternalShapeSeed(action,viewport);
         if(seed == null)
         {
            return false;
         }
         tolerance = Math.max(1,Math.min(viewport.width,viewport.height) * 0.002);
         try
         {
            seedBounds = seed.getBounds(action);
            if(!isExternalShapeBoundsValid(seedBounds) || seedBounds.width < viewport.width - tolerance && seedBounds.height < viewport.height - tolerance)
            {
               return false;
            }
            bounds = action.getBounds(action);
            return isExternalShapeBoundsValid(bounds) && bounds.left <= viewport.left + tolerance && bounds.top <= viewport.top + tolerance && bounds.right >= viewport.right - tolerance && bounds.bottom >= viewport.bottom - tolerance;
         }
         catch(coverCheckError:*)
         {
         }
         return false;
      }
      
      private function isExternalShapeSeedValid(param1:Shape, param2:MovieClip, param3:Rectangle) : Boolean
      {
         var candidate:Shape = param1;
         var action:MovieClip = param2;
         var viewport:Rectangle = param3;
         var bounds:Rectangle = null;
         var ratio:Number = 0;
         var area:Number = 0;
         if(candidate == null || action == null || viewport == null || candidate.parent !== action || !candidate.visible || candidate.alpha <= 0 || candidate.blendMode !== BlendMode.NORMAL || candidate.mask != null || isExternalShapeMask(candidate,action))
         {
            return false;
         }
         try
         {
            bounds = candidate.getBounds(action);
            ratio = bounds.width / bounds.height;
            area = bounds.width * bounds.height;
            return isExternalShapeBoundsValid(bounds) && bounds.width > 2 && bounds.height > 2 && ratio >= 1.2 && ratio <= 3.5 && bounds.width >= viewport.width * 0.65 && bounds.height >= viewport.height * 0.55 && area >= viewport.width * viewport.height * 0.35 && hasExternalShapeRectOccupancy(candidate,bounds);
         }
         catch(seedValidationError:*)
         {
            return false;
         }
      }
      
      private function hasExternalShapeRectOccupancy(param1:Shape, param2:Rectangle) : Boolean
      {
         var candidate:Shape = param1;
         var bounds:Rectangle = null;
         var bitmap:BitmapData = null;
         var sampleWidth:int = 32;
         var sampleHeight:int = 20;
         var scaleX:Number = 0;
         var scaleY:Number = 0;
         var occupied:int = 0;
         var total:int = 0;
         var x:int = 0;
         var y:int = 0;
         var alpha:uint = 0;
         var matrix:Matrix = null;
         var result:Boolean = false;
         if(candidate == null)
         {
            return false;
         }
         bounds = candidate.getBounds(candidate);
         if(!isExternalShapeBoundsValid(bounds) || bounds.width <= 2 || bounds.height <= 2)
         {
            return false;
         }
         bitmap = new BitmapData(sampleWidth,sampleHeight,true,0);
         scaleX = (sampleWidth - 2) / bounds.width;
         scaleY = (sampleHeight - 2) / bounds.height;
         matrix = new Matrix(scaleX,0,0,scaleY,1 - bounds.x * scaleX,1 - bounds.y * scaleY);
         bitmap.draw(candidate,matrix,null,BlendMode.NORMAL,null,false);
         y = 1;
         while(y < sampleHeight - 1)
         {
            x = 1;
            while(x < sampleWidth - 1)
            {
               total++;
               alpha = uint(bitmap.getPixel32(x,y) >>> 24 & 0xFF);
               if(alpha >= 32)
               {
                  occupied++;
               }
               x++;
            }
            y++;
         }
         result = total > 0 && occupied / total >= 0.65;
         bitmap.dispose();
         return result;
      }
      
      private function findExternalShapeSeed(param1:MovieClip, param2:Rectangle) : Shape
      {
         var action:MovieClip = param1;
         var viewport:Rectangle = param2;
         var best:Shape = null;
         var bestArea:Number = 0;
         var index:int = 0;
         var candidate:Shape = null;
         var bounds:Rectangle = null;
         var ratio:Number = 0;
         var area:Number = 0;
         if(action == null || viewport == null)
         {
            return null;
         }
         for(; index < action.numChildren; index++)
         {
            candidate = action.getChildAt(index) as Shape;
            if(candidate != null && candidate.visible && candidate.alpha > 0 && candidate.blendMode === BlendMode.NORMAL && candidate.mask == null && !isExternalShapeMask(candidate,action))
            {
               try
               {
                  bounds = candidate.getBounds(action);
                  if(isExternalShapeBoundsValid(bounds) && bounds.width > 2 && bounds.height > 2)
                  {
                     ratio = bounds.width / bounds.height;
                     area = bounds.width * bounds.height;
                     if(ratio >= 1.2 && ratio <= 3.5 && bounds.width >= viewport.width * 0.65 && bounds.height >= viewport.height * 0.55 && area >= viewport.width * viewport.height * 0.35 && hasExternalShapeRectOccupancy(candidate,bounds) && area > bestArea)
                     {
                        best = candidate;
                        bestArea = area;
                     }
                  }
               }
               catch(seedError:*)
               {
                  continue;
               }
            }
         }
         return best;
      }
      
      private function isExternalShapeMask(param1:Shape, param2:MovieClip) : Boolean
      {
         var candidate:Shape = param1;
         var action:MovieClip = param2;
         var index:int = 0;
         var sibling:DisplayObject = null;
         if(candidate == null || action == null)
         {
            return false;
         }
         while(index < action.numChildren)
         {
            sibling = action.getChildAt(index);
            if(sibling !== candidate && sibling.mask === candidate)
            {
               return true;
            }
            index++;
         }
         return false;
      }
      
      private function buildExternalShapeCoverDelta(param1:Rectangle, param2:Rectangle) : Matrix
      {
         var source:Rectangle = param1;
         var target:Rectangle = param2;
         var scale:Number = 1;
         var sourceCenterX:Number = 0;
         var sourceCenterY:Number = 0;
         var targetCenterX:Number = 0;
         var targetCenterY:Number = 0;
         if(source == null || target == null || source.width <= 1 || source.height <= 1 || target.width <= 1 || target.height <= 1)
         {
            return null;
         }
         scale = Math.max(target.width / source.width,target.height / source.height);
         if(!isFinite(scale) || scale <= 0)
         {
            return null;
         }
         sourceCenterX = source.x + source.width * 0.5;
         sourceCenterY = source.y + source.height * 0.5;
         targetCenterX = target.x + target.width * 0.5;
         targetCenterY = target.y + target.height * 0.5;
         return new Matrix(scale,0,0,scale,targetCenterX - sourceCenterX * scale,targetCenterY - sourceCenterY * scale);
      }
      
      private function hasExternalFullscreenRoute(param1:MovieClip, param2:MovieClip) : Boolean
      {
         var routeState:*;
         var pet:MovieClip = param1;
         var action:MovieClip = param2;
         try
         {
            if("eventPaused" in action && Boolean(action["eventPaused"]))
            {
               return true;
            }
            if("uClientEventVideoActive" in pet && Boolean(pet["uClientEventVideoActive"]))
            {
               return true;
            }
            if("eventVideoActive" in pet && Boolean(pet["eventVideoActive"]))
            {
               return true;
            }
            if("uClientCinematicActive" in pet && Boolean(pet["uClientCinematicActive"]))
            {
               return true;
            }
            if("cinematicActive" in pet && Boolean(pet["cinematicActive"]))
            {
               return true;
            }
            if("getEmbeddedCinematicState" in pet && pet["getEmbeddedCinematicState"] is Function)
            {
               routeState = pet["getEmbeddedCinematicState"]();
               if(routeState != null && (routeState.active === true || routeState.attached === true))
               {
                  return true;
               }
            }
         }
         catch(ignored:*)
         {
         }
         return false;
      }
      
      private function restoreExternalShapeCover(param1:MovieClip) : void
      {
         var state:Object = param1 == null ? null : externalShapeCoverStates[param1];
         var item:Object = null;
         if(state == null)
         {
            return;
         }
         for each(item in state.saved)
         {
            try
            {
               if(item.shape != null && item.matrix != null && item.shape.parent != null)
               {
                  item.shape.transform.matrix = (item.matrix as Matrix).clone();
               }
            }
            catch(ignored:*)
            {
            }
         }
         state.saved = [];
      }
      
      private function resetExternalShapeCover(param1:MovieClip) : void
      {
         var state:Object = param1 == null ? null : externalShapeCoverStates[param1];
         if(state == null)
         {
            return;
         }
         restoreExternalShapeCover(param1);
         state.frozenDelta = null;
         state.seed = null;
         if(state.action != null && state.handler != null)
         {
            state.action.removeEventListener(Event.EXIT_FRAME,state.handler);
         }
         delete externalShapeCoverStates[param1];
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         for(var key in externalActions)
         {
            stopExternalAction(key as MovieClip);
         }
         for(var nativeKey in nativeActions)
         {
            stopNativeAction(nativeKey as MovieClip);
         }
         for(key in externalShapeCoverStates)
         {
            resetExternalShapeCover(key as MovieClip);
         }
         externalAttackCoverPending = new Dictionary(true);
         externalAttackCoverBounds = new Dictionary(true);
         if(fighters != null)
         {
            for each(var fighterItem in fighters)
            {
               if(fighterItem != null && fighterItem.pet != null)
               {
                  disableUClientBattleBackdrop(fighterItem.pet);
               }
            }
         }
      }
      
      private function hasAnimatedDescendant(param1:DisplayObject, param2:int) : Boolean
      {
         var container:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var child:DisplayObject = null;
         var clip:MovieClip = null;
         var index:int = 0;
         if(container == null || param2 > 8)
         {
            return false;
         }
         while(index < container.numChildren)
         {
            try
            {
               child = container.getChildAt(index);
               clip = child as MovieClip;
               if(clip != null && clip.totalFrames > 1)
               {
                  return true;
               }
               if(hasAnimatedDescendant(child,param2 + 1))
               {
                  return true;
               }
            }
            catch(ignored:*)
            {
            }
            index++;
         }
         return false;
      }
      
      private function updateExternalIdleOnlyStatus(param1:MovieClip, param2:String) : void
      {
         var pet:MovieClip = param1;
         var status:String = param2;
         var shouldHit:Boolean = FighterActionType.atk().indexOf(status) >= 0;
         var action:MovieClip = null;
         if(pet == null)
         {
            return;
         }
         stopExternalAction(pet);
         externalTerminalSuppressed[pet] = true;
         try
         {
            pet.gotoAndStop(1);
         }
         catch(ignored:*)
         {
         }
         action = findExternalAction(pet);
         if(action != null)
         {
            resumeExternalIdleOnlyPose(action,0);
         }
         if(shouldHit)
         {
            setTimeout(function():void
            {
               if(pet != null && pet.parent != null)
               {
                  pet.dispatchEvent(new Event("hit"));
               }
            },0);
         }
      }
      
      private function isExternalIdleOnlyPose(param1:MovieClip) : Boolean
      {
         var item:Object = null;
         var name:String = "";
         if(param1 == null || param1.totalFrames > 1 || param1.numChildren <= 0)
         {
            return false;
         }
         try
         {
            for each(item in param1.currentLabels)
            {
               name = item == null || item.name == null ? "" : item.name.toLowerCase();
               if(name != "" && name != "attack" && name != "atk" && name != "attack1")
               {
                  return false;
               }
            }
         }
         catch(ignored:*)
         {
            return false;
         }
         return findExternalAction(param1) != null;
      }
      
      private function resumeExternalIdleOnlyPose(param1:DisplayObject, param2:int = 0) : void
      {
         var container:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var child:DisplayObject = null;
         var clip:MovieClip = param1 as MovieClip;
         var index:int = 0;
         if(param1 == null || param2 > 8)
         {
            return;
         }
         if(clip != null)
         {
            if(clip.totalFrames > 1)
            {
               try
               {
                  clip.play();
               }
               catch(ignored:*)
               {
               }
            }
         }
         if(container == null)
         {
            return;
         }
         while(index < container.numChildren)
         {
            try
            {
               child = container.getChildAt(index);
               resumeExternalIdleOnlyPose(child,param2 + 1);
            }
            catch(ignored:*)
            {
            }
            index++;
         }
      }
      
      private function isExternalCompactTimeline(param1:MovieClip) : Boolean
      {
         if(isExternalIdleOnlyPose(param1))
         {
            return true;
         }
         if(param1 == null || findTimelineLabel(param1,["待机","物理攻击","属性攻击","特殊攻击","被打","必杀"]) != "")
         {
            return false;
         }
         return findTimelineLabel(param1,["attack","atk","attack1","sa","sa5","cp","hidemove","hited","hurt","hit"]) != "" || hasAnyMoveLabel(param1);
      }
      
      private function hasAnyMoveLabel(param1:MovieClip) : Boolean
      {
         var item:Object = null;
         var name:String = null;
         if(param1 == null)
         {
            return false;
         }
         for each(item in param1.currentLabels)
         {
            if(item != null && item.name != null)
            {
               name = item.name.toLowerCase();
               if(name.indexOf("moves_") == 0 || name.indexOf("move_") == 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function resolveExternalLabel(param1:MovieClip, param2:String) : String
      {
         var dedicated:String = "";
         if(param2 == IDLE)
         {
            return findTimelineLabel(param1,["idle","stand","wait","attack","atk","attack1"]);
         }
         if(param2 == "物理攻击")
         {
            return findTimelineLabel(param1,["attack","atk","attack1","normalAttack","skill"]);
         }
         if(param2 == "属性攻击")
         {
            return findTimelineLabel(param1,["cp","attribute","support","skill","sa","attack","atk"]);
         }
         if(param2 == "特殊攻击")
         {
            return findTimelineLabel(param1,["sa","special","magic","skill","attack","atk"]);
         }
         if(FighterActionType.superAtk().indexOf(param2) >= 0)
         {
            dedicated = findDedicatedMoveLabel(param1);
            return dedicated != "" ? dedicated : findTimelineLabel(param1,["hidemove","sa5","as5","attack5","ultimate","ultra","power","attack1","normalAttack","attack","atk","physical"]);
         }
         if(FighterActionType.hurt().indexOf(param2) >= 0)
         {
            return findTimelineLabel(param1,["hited","hurt","hit","beHit","damage","attack","atk"]);
         }
         if(param2 == "濒死" || param2 == "失败")
         {
            return findTimelineLabel(param1,["lose","lost","failure","fail","defeat","dead","death","dying","lowhp","weak","hited","hurt","hit","beHit","damage"]);
         }
         if(param2 == "胜利")
         {
            return findTimelineLabel(param1,["win","victory"]);
         }
         return "";
      }
      
      private function findTimelineLabel(param1:MovieClip, param2:Array) : String
      {
         var item:Object = null;
         var candidate:String = null;
         var actual:String = "";
         if(param1 == null || param2 == null)
         {
            return "";
         }
         for each(candidate in param2)
         {
            for each(item in param1.currentLabels)
            {
               actual = item == null || item.name == null ? "" : item.name;
               if(actual.toLowerCase() == candidate.toLowerCase())
               {
                  return actual;
               }
            }
         }
         return "";
      }
      
      private function findDedicatedMoveLabel(param1:MovieClip) : String
      {
         var authoritative:String = null;
         var moveList:Array = null;
         var moveRegex:RegExp = null;
         var distinctAttack:Boolean = false;
         var authList:Array = null;
         var lblName:String = null;
         var item:Object = null;
         var availableMoves:Array = null;
         var len:int = 0;
         if(param1 == null)
         {
            return "";
         }
         if(this._dedicatedMovesCache[param1] !== undefined)
         {
            availableMoves = this._dedicatedMovesCache[param1] as Array;
            if(availableMoves == null)
            {
               return "";
            }
            len = int(availableMoves.length);
            if(len == 0)
            {
               return "";
            }
            if(len == 1)
            {
               return availableMoves[0];
            }
            return availableMoves[int(Math.random() * len)];
         }
         distinctAttack = findTimelineLabel(param1,["attack","atk","physical"]) != "";
         authList = distinctAttack ? ["sa5","as5","attack5","attack1","hidemove","ultimate","ultra","power","add1"] : ["sa5","as5","attack5","hidemove","ultimate","ultra","power","add1"];
         authoritative = findTimelineLabel(param1,authList);
         if(authoritative != "")
         {
            this._dedicatedMovesCache[param1] = [authoritative];
            return authoritative;
         }
         moveList = [];
         moveRegex = /^moves?_?\d+(?:_\d+)?$/i;
         for each(item in param1.currentLabels)
         {
            if(item != null && item.name != null)
            {
               lblName = item.name;
               if(moveRegex.test(lblName) || /^add\d+$/i.test(lblName) || /^attack\d+$/i.test(lblName) && lblName.toLowerCase() != "attack" && lblName.toLowerCase() != "atk")
               {
                  moveList.push(item.name);
               }
            }
         }
         if(moveList.length >= 1)
         {
            availableMoves = collectDedicatedMoveCandidates(param1,moveList);
         }
         else
         {
            availableMoves = [];
         }
         this._dedicatedMovesCache[param1] = availableMoves;
         if(availableMoves == null)
         {
            return "";
         }
         len = int(availableMoves.length);
         if(len == 0)
         {
            return "";
         }
         if(len == 1)
         {
            return availableMoves[0];
         }
         return availableMoves[int(Math.random() * len)];
      }
      
      private function collectDedicatedMoveCandidates(param1:MovieClip, param2:Array) : Array
      {
         var hasLaterFrame:Boolean;
         var distItem:Object;
         var nonFrame1:Array;
         var fallbackMoves:Array;
         var physLabel:String = null;
         var specLabel:String = null;
         var propLabel:String = null;
         var currentF:int = 0;
         var physStats:Object = null;
         var specStats:Object = null;
         var propStats:Object = null;
         var distinct:Array = null;
         var m:String = null;
         var st:Object = null;
         var isDup:Boolean = false;
         var pool:Array = null;
         var candItem:Object = null;
         var multiFrameMoves:Array = null;
         var lbl:String = null;
         if(param2 == null || param2.length == 0)
         {
            return [];
         }
         if(param1 == null)
         {
            return [param2[0]];
         }
         if(param1 != null && UClientUniversalBattleAdapter.supports(param1))
         {
            return param2;
         }
         physLabel = findTimelineLabel(param1,["attack","atk","attack1","at1","physical"]);
         specLabel = findTimelineLabel(param1,["sa","special","magic","attack2","at2","add2"]);
         propLabel = findTimelineLabel(param1,["cp","property","buff","effect","attribute","support","skill","add3"]);
         currentF = param1.currentFrame;
         physStats = getActionLabelStats(param1,physLabel);
         if(physStats == null)
         {
            physStats = getActionFrameStats(param1,1);
         }
         specStats = getActionLabelStats(param1,specLabel);
         propStats = getActionLabelStats(param1,propLabel);
         distinct = [];
         for each(m in param2)
         {
            st = getActionLabelStats(param1,m);
            if(st != null)
            {
               st.label = m;
               isDup = false;
               if(physStats != null && isDuplicateActionStats(st,physStats))
               {
                  isDup = true;
               }
               if(specStats != null && isDuplicateActionStats(st,specStats))
               {
                  isDup = true;
               }
               if(propStats != null && isDuplicateActionStats(st,propStats))
               {
                  isDup = true;
               }
               if(!isDup)
               {
                  distinct.push(st);
               }
            }
         }
         try
         {
            param1.gotoAndStop(currentF);
         }
         catch(ignored:*)
         {
         }
         if(distinct.length == 0)
         {
            return [];
         }
         hasLaterFrame = false;
         for each(distItem in distinct)
         {
            if(int(distItem.frame) > 1)
            {
               hasLaterFrame = true;
               break;
            }
         }
         pool = distinct;
         if(hasLaterFrame)
         {
            nonFrame1 = [];
            for each(candItem in distinct)
            {
               if(int(candItem.frame) > 1)
               {
                  nonFrame1.push(candItem);
               }
            }
            if(nonFrame1.length > 0)
            {
               pool = nonFrame1;
            }
         }
         multiFrameMoves = [];
         for each(candItem in pool)
         {
            if(candItem != null && candItem.label != null && int(candItem.totalFrames) > 1)
            {
               lbl = candItem.label;
               if(multiFrameMoves.indexOf(lbl) < 0)
               {
                  multiFrameMoves.push(lbl);
               }
            }
         }
         if(multiFrameMoves.length > 0)
         {
            return multiFrameMoves;
         }
         if(pool.length > 0)
         {
            fallbackMoves = [];
            for each(candItem in pool)
            {
               if(candItem != null && candItem.label != null)
               {
                  lbl = candItem.label;
                  if(fallbackMoves.indexOf(lbl) < 0)
                  {
                     fallbackMoves.push(lbl);
                  }
               }
            }
            return fallbackMoves;
         }
         return [];
      }
      
      private function pickBestUltimateMove(param1:MovieClip, param2:Array) : String
      {
         var hasLaterFrame:Boolean;
         var distItem:Object;
         var nonFrame1:Array;
         var candItem:Object;
         var physLabel:String = null;
         var specLabel:String = null;
         var propLabel:String = null;
         var currentF:int = 0;
         var physStats:Object = null;
         var specStats:Object = null;
         var propStats:Object = null;
         var distinct:Array = null;
         var allStats:Array = null;
         var m:String = null;
         var st:Object = null;
         var isDup:Boolean = false;
         var pool:Array = null;
         var best:Object = null;
         var candidate:Object = null;
         var bestScore:int = 0;
         var candScore:int = 0;
         if(param2 == null || param2.length == 0)
         {
            return "";
         }
         if(param1 == null)
         {
            return param2[0];
         }
         physLabel = findTimelineLabel(param1,["attack","atk","attack1","at1","physical"]);
         specLabel = findTimelineLabel(param1,["sa","special","magic","attack2","at2","add2"]);
         propLabel = findTimelineLabel(param1,["cp","property","buff","effect","attribute","support","skill","add3"]);
         currentF = param1.currentFrame;
         physStats = getActionLabelStats(param1,physLabel);
         if(physStats == null)
         {
            physStats = getActionFrameStats(param1,1);
         }
         specStats = getActionLabelStats(param1,specLabel);
         propStats = getActionLabelStats(param1,propLabel);
         distinct = [];
         allStats = [];
         for each(m in param2)
         {
            st = getActionLabelStats(param1,m);
            if(st != null)
            {
               st.label = m;
               allStats.push(st);
               isDup = false;
               if(physStats != null && isDuplicateActionStats(st,physStats))
               {
                  isDup = true;
               }
               if(specStats != null && isDuplicateActionStats(st,specStats))
               {
                  isDup = true;
               }
               if(propStats != null && isDuplicateActionStats(st,propStats))
               {
                  isDup = true;
               }
               if(!isDup)
               {
                  distinct.push(st);
               }
            }
         }
         try
         {
            param1.gotoAndStop(currentF);
         }
         catch(ignored:*)
         {
         }
         if(distinct.length == 0)
         {
            return physLabel != "" ? physLabel : (findTimelineLabel(param1,["attack","atk","physical"]) != "" ? findTimelineLabel(param1,["attack","atk","physical"]) : "");
         }
         hasLaterFrame = false;
         for each(distItem in distinct)
         {
            if(int(distItem.frame) > 1)
            {
               hasLaterFrame = true;
               break;
            }
         }
         pool = distinct;
         if(hasLaterFrame)
         {
            nonFrame1 = [];
            for each(candItem in distinct)
            {
               if(int(candItem.frame) > 1)
               {
                  nonFrame1.push(candItem);
               }
            }
            if(nonFrame1.length > 0)
            {
               pool = nonFrame1;
            }
         }
         best = pool[0];
         for each(candidate in pool)
         {
            bestScore = this.scoreMoveCandidate(best.label,int(best.totalFrames),best.child as MovieClip);
            candScore = this.scoreMoveCandidate(candidate.label,int(candidate.totalFrames),candidate.child as MovieClip);
            if(candScore > bestScore)
            {
               best = candidate;
            }
         }
         return best.label;
      }
      
      private function scoreMoveCandidate(param1:String, param2:int, param3:MovieClip = null) : int
      {
         var hasHit:Boolean = false;
         if(param3 != null)
         {
            try
            {
               if("hit" in param3 || "damage" in param3 || "beHit" in param3)
               {
                  hasHit = true;
               }
            }
            catch(err:*)
            {
            }
            if(!hasHit)
            {
               hasHit = this.findTimelineLabel(param3,["hit","damage","attack","atk"]) != "";
            }
         }
         return (hasHit ? 1000000 : 0) + param2;
      }
      
      private function getActionLabelStats(param1:MovieClip, param2:String) : Object
      {
         var f:int = 0;
         var child:MovieClip = null;
         var dur:int = 0;
         var childFrames:int = 0;
         var descFrames:int = 0;
         var maxF:int = 0;
         if(param1 == null || param2 == null || param2 == "")
         {
            return null;
         }
         f = frameForLabel(param1,param2);
         if(f <= 0)
         {
            return null;
         }
         try
         {
            param1.gotoAndStop(f);
         }
         catch(e:*)
         {
            return null;
         }
         child = firstDirectMovieChild(param1);
         dur = endFrameForLabel(param1,param2) - f + 1;
         childFrames = child != null ? child.totalFrames : 1;
         descFrames = child != null ? maxDescendantFrames(child) : 1;
         maxF = Math.max(dur,childFrames,descFrames);
         return {
            "frame":f,
            "child":child,
            "totalFrames":maxF
         };
      }
      
      private function getActionFrameStats(param1:MovieClip, param2:int) : Object
      {
         var child:MovieClip = null;
         var childFrames:int = 0;
         var descFrames:int = 0;
         var maxF:int = 0;
         if(param1 == null || param2 <= 0)
         {
            return null;
         }
         try
         {
            param1.gotoAndStop(param2);
         }
         catch(e:*)
         {
            return null;
         }
         child = firstDirectMovieChild(param1);
         childFrames = child != null ? child.totalFrames : 1;
         descFrames = child != null ? maxDescendantFrames(child) : 1;
         maxF = Math.max(1,childFrames,descFrames);
         return {
            "frame":param2,
            "child":child,
            "totalFrames":maxF
         };
      }
      
      private function isDuplicateActionStats(param1:Object, param2:Object) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            return false;
         }
         var l1:String = param1.label != null ? param1.label.toLowerCase() : "";
         var l2:String = param2.label != null ? param2.label.toLowerCase() : "";
         if(l1 != "" && l2 != "" && l1 == l2)
         {
            return true;
         }
         if(param1.frame > 0 && param2.frame > 0 && param1.frame == param2.frame)
         {
            return true;
         }
         if(param1.child != null && param2.child != null)
         {
            if(param1.child === param2.child)
            {
               if(param1.child.parent is MovieClip && UClientUniversalBattleAdapter.supports(param1.child.parent as MovieClip))
               {
                  return false;
               }
               return true;
            }
            var symbolA:String = getQualifiedClassName(param1.child);
            var symbolB:String = getQualifiedClassName(param2.child);
            if(symbolA == symbolB)
            {
               if(symbolA != "flash.display::MovieClip" && param1.child.constructor === param2.child.constructor)
               {
                  return true;
               }
               if(param1.child.totalFrames > 1 && param1.child.totalFrames == param2.child.totalFrames)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function firstDirectMovieChild(param1:DisplayObjectContainer) : MovieClip
      {
         var i:int = 0;
         var clip:MovieClip = null;
         if(param1 == null)
         {
            return null;
         }
         i = 0;
         while(i < param1.numChildren)
         {
            clip = param1.getChildAt(i) as MovieClip;
            if(clip != null)
            {
               return clip;
            }
            i++;
         }
         return null;
      }
      
      private function maxDescendantFrames(param1:DisplayObjectContainer, param2:int = 0) : int
      {
         var maximum:int = 1;
         var i:int = 0;
         var child:DisplayObject = null;
         var clip:MovieClip = null;
         var nested:DisplayObjectContainer = null;
         if(param1 == null || param2 > 6)
         {
            return maximum;
         }
         i = 0;
         while(i < param1.numChildren)
         {
            child = param1.getChildAt(i);
            clip = child as MovieClip;
            if(clip != null)
            {
               maximum = Math.max(maximum,clip.totalFrames);
            }
            nested = child as DisplayObjectContainer;
            if(nested != null)
            {
               maximum = Math.max(maximum,maxDescendantFrames(nested,param2 + 1));
            }
            i++;
         }
         return maximum;
      }
      
      private function frameForLabel(param1:MovieClip, param2:String) : int
      {
         var item:Object = null;
         if(param1 == null || param2 == null || param2 == "")
         {
            return 0;
         }
         for each(item in param1.currentLabels)
         {
            if(item != null && item.name != null && item.name.toLowerCase() == param2.toLowerCase())
            {
               return int(item.frame);
            }
         }
         return 0;
      }
      
      private function endFrameForLabel(param1:MovieClip, param2:String) : int
      {
         var i:int = 0;
         var labels:Array = null;
         if(param1 == null || param2 == null || param2 == "")
         {
            return 1;
         }
         labels = param1.currentLabels;
         if(labels == null || labels.length == 0)
         {
            return param1.totalFrames;
         }
         i = 0;
         while(i < labels.length)
         {
            if(labels[i] != null && labels[i].name != null && labels[i].name.toLowerCase() == param2.toLowerCase())
            {
               return i + 1 < labels.length ? Math.max(int(labels[i].frame),int(labels[i + 1].frame) - 1) : param1.totalFrames;
            }
            i++;
         }
         return param1.totalFrames;
      }
      
      private function findExternalAction(param1:MovieClip) : MovieClip
      {
         var index:int = 0;
         var child:MovieClip = null;
         if(param1 == null)
         {
            return null;
         }
         index = 0;
         while(index < param1.numChildren)
         {
            child = param1.getChildAt(index) as MovieClip;
            if(child != null && child.totalFrames > 1)
            {
               return child;
            }
            index++;
         }
         return param1.numChildren > 0 ? param1.getChildAt(0) as MovieClip : null;
      }
      
      private function isExternalLegacySceneTimeline(param1:MovieClip, param2:Rectangle = null) : Boolean
      {
         var action:MovieClip = null;
         if(param1 == null || UClientUniversalBattleAdapter.supports(param1) || !isExternalCompactTimeline(param1))
         {
            return false;
         }
         action = findExternalAction(param1);
         if(action == null || action.totalFrames <= 120 || findTimelineLabel(param1,["idle","stand","standby","wait","待机"]) != "")
         {
            return false;
         }
         var w:Number = param2 != null ? param2.width : param1.width;
         var h:Number = param2 != null ? param2.height : param1.height;
         return w >= 900 || h >= 550;
      }
      
      private function applyExternalPlacement(param1:MovieClip, param2:FightPet) : void
      {
         var legacyScene:Boolean;
         var scAction:MovieClip;
         var scSubject:Object;
         var scCenterX:Number;
         var scBottom:Number;
         var pet:MovieClip = param1;
         var fighter:FightPet = param2;
         var bounds:Rectangle = null;
         var fitScale:Number = 1;
         var targetBaselineY:Number = EXTERNAL_TARGET_BASELINE_Y;
         var effectiveBaselineY:Number = EXTERNAL_TEMPLATE_BASELINE_Y;
         var subject:Object = null;
         if(pet == null || fighter == null || externalPlaced[pet] === true || !isExternalCompactTimeline(pet))
         {
            return;
         }
         try
         {
            bounds = pet.getBounds(pet);
            if(bounds == null || bounds.width <= 0 || bounds.height <= 0)
            {
               scheduleExternalPlacement(pet,fighter);
               return;
            }
            if(isFinite(bounds.width) && isFinite(bounds.height) && bounds.width < 10000 && bounds.height < 10000)
            {
               legacyScene = isExternalLegacySceneTimeline(pet,bounds);
               fitScale = 1.0;
               if(UClientUniversalBattleAdapter.supports(pet))
               {
                  targetBaselineY = EXTERNAL_UClient_TARGET_BASELINE_Y;
                  subject = this.measureRenderedSubject(pet,bounds,pet);
                  if(subject != null && !isNaN(Number(subject.bottom)) && Number(subject.bottom) >= 40 && Number(subject.bottom) <= 500)
                  {
                     effectiveBaselineY = Number(subject.bottom);
                  }
               }
               else if(legacyScene)
               {
                  scAction = findExternalAction(pet);
                  scSubject = scAction == null ? null : measureStructuralSubject(pet,scAction,bounds);
                  scCenterX = scSubject == null ? bounds.x + bounds.width * 0.5 : Number(scSubject.centerX);
                  scBottom = scSubject == null ? bounds.bottom : Number(scSubject.bottom);
                  pet.scaleX = fighter.scaleX;
                  pet.scaleY = fighter.scaleY;
                  pet.x = fighter.x + (EXTERNAL_TARGET_CENTER_X - scCenterX) * fighter.scaleX;
                  pet.y = fighter.y + (targetBaselineY - scBottom) * fighter.scaleY;
                  externalPlaced[pet] = true;
                  delete externalPlacementAttempts[pet];
                  return;
               }
               pet.scaleX = fighter.scaleX;
               pet.scaleY = fighter.scaleY;
               pet.x = fighter.x + (EXTERNAL_TARGET_CENTER_X - EXTERNAL_TEMPLATE_CENTER_X) * fighter.scaleX;
               if(fighter.side === 2)
               {
                  pet.y = fighter.y;
               }
               else
               {
                  var clampedBaseline:Number = Math.max(120, Math.min(260, effectiveBaselineY));
                  pet.y = fighter.y + (targetBaselineY - clampedBaseline) * fighter.scaleY;
               }
               externalPlaced[pet] = true;
               delete externalPlacementAttempts[pet];
            }
         }
         catch(ignored:*)
         {
         }
      }
      
      private function setUClientBattleBackdropHostForPet(param1:MovieClip) : void
      {
         var target:Object = param1;
         try
         {
            if(target != null && sceneProjectionLayer != null && target["setUClientBattleBackdropHost"] is Function)
            {
               target["setUClientBattleBackdropHost"](sceneProjectionLayer,param1);
            }
         }
         catch(ignored:*)
         {
         }
      }
      
      private function disableUClientBattleBackdrop(param1:MovieClip) : void
      {
         var target:Object = param1;
         try
         {
            if(target != null && target["setUClientBattleBackdropHost"] is Function)
            {
               target["setUClientBattleBackdropHost"](null,param1);
            }
         }
         catch(ignored:*)
         {
         }
      }
      
      private function scheduleExternalPlacement(param1:MovieClip, param2:FightPet) : void
      {
         var pet:MovieClip = param1;
         var fighter:FightPet = param2;
         var handler:Function = null;
         if(pet == null || externalPlacementHandlers[pet] != null)
         {
            return;
         }
         externalPlacementAttempts[pet] = int(externalPlacementAttempts[pet]) + 1;
         handler = function(param1:Event):void
         {
            pet.removeEventListener(Event.FRAME_CONSTRUCTED,handler);
            delete externalPlacementHandlers[pet];
            applyExternalPlacement(pet,fighter);
         };
         externalPlacementHandlers[pet] = handler;
         pet.addEventListener(Event.FRAME_CONSTRUCTED,handler,false,0,true);
      }
      
      private function measureStructuralSubject(param1:MovieClip, param2:DisplayObjectContainer, param3:Rectangle) : Object
      {
         var best:Object = {"count":0};
         var inspect:Function = null;
         inspect = function(param4:DisplayObjectContainer, param5:int):void
         {
            var centers:Array = [];
            var bottoms:Array = [];
            var child:DisplayObject = null;
            var container:DisplayObjectContainer = null;
            var childBounds:Rectangle = null;
            var area:Number = 0;
            var index:int = 0;
            if(param4 == null || param5 > 2)
            {
               return;
            }
            while(index < param4.numChildren)
            {
               try
               {
                  child = param4.getChildAt(index);
                  if(child != null && child.visible && child.alpha > 0.08)
                  {
                     childBounds = child.getBounds(param1);
                     area = childBounds.width * childBounds.height;
                     if(childBounds.width > 2 && childBounds.height > 2 && childBounds.width < param3.width * 0.55 && childBounds.height < param3.height * 0.75 && area < param3.width * param3.height * 0.18)
                     {
                        centers.push(childBounds.x + childBounds.width * 0.5);
                        bottoms.push(childBounds.bottom);
                     }
                     container = child as DisplayObjectContainer;
                     if(container != null)
                     {
                        inspect(container,param5 + 1);
                     }
                  }
               }
               catch(ignored:*)
               {
               }
               index++;
            }
            if(centers.length >= 6 && centers.length > int(best.count))
            {
               centers.sort(Array.NUMERIC);
               bottoms.sort(Array.NUMERIC);
               best = {
                  "count":centers.length,
                  "centerX":Number(centers[int((centers.length - 1) * 0.5)]),
                  "bottom":Number(bottoms[int((bottoms.length - 1) * 0.85)])
               };
            }
         };
         inspect(param2,0);
         return int(best.count) >= 6 ? best : null;
      }
      
      private function weightedAxisQuantile(param1:Array, param2:Number, param3:Number) : int
      {
         var target:Number = param2 * param3;
         var sum:Number = 0;
         var index:int = 0;
         while(index < param1.length)
         {
            sum += Number(param1[index]);
            if(sum >= target)
            {
               return index;
            }
            index++;
         }
         return Math.max(0,param1.length - 1);
      }
      
      private function measureRenderedSubject(param1:MovieClip, param2:Rectangle, param3:MovieClip = null) : Object
      {
         var result:Object;
         var bitmapCenter:Number;
         var bitmapTop:Number;
         var bitmapBottom:Number;
         var useDetachedStructuralAnchor:Boolean;
         var scale:Number;
         var width:int;
         var height:int;
         var bitmap:BitmapData;
         var matrix:Matrix;
         var pixels:Vector.<uint>;
         var xWeights:Array;
         var yWeights:Array;
         var total:Number;
         var index:int;
         var alpha:int;
         var weight:Number;
         var x:int;
         var y:int;
         var sampleLimit:Number = 320;
         var resourceBytes:Number = 0;
         var coordinateRoot:MovieClip = param3 == null ? param1 : param3;
         var structural:Object = this.measureStructuralSubject(coordinateRoot,param1,param2);
         try
         {
            resourceBytes = param1.loaderInfo.bytesTotal;
         }
         catch(metricsError:*)
         {
         }
         if(resourceBytes >= 12 * 1024 * 1024)
         {
            sampleLimit = 96;
         }
         scale = Math.min(1,sampleLimit / Math.max(1,param2.width),sampleLimit / Math.max(1,param2.height));
         width = Math.max(4,Math.ceil(param2.width * scale));
         height = Math.max(4,Math.ceil(param2.height * scale));
         bitmap = null;
         matrix = null;
         pixels = null;
         xWeights = [];
         yWeights = [];
         total = 0;
         index = 0;
         alpha = 0;
         weight = 0;
         x = 0;
         y = 0;
         if(width > 512 || height > 512)
         {
            return null;
         }
         try
         {
            bitmap = new BitmapData(width,height,true,0);
            matrix = coordinateRoot === param1 ? new Matrix() : param1.transform.matrix.clone();
            matrix.a *= scale;
            matrix.b *= scale;
            matrix.c *= scale;
            matrix.d *= scale;
            matrix.tx = (matrix.tx - param2.x) * scale;
            matrix.ty = (matrix.ty - param2.y) * scale;
            bitmap.draw(param1,matrix,null,null,null,true);
            pixels = bitmap.getVector(bitmap.rect);
            while(x < width)
            {
               xWeights[x++] = 0;
            }
            while(y < height)
            {
               yWeights[y++] = 0;
            }
            while(index < pixels.length)
            {
               alpha = pixels[index] >>> 24 & 0xFF;
               if(alpha >= 24)
               {
                  weight = alpha * alpha;
                  x = index % width;
                  y = int(index / width);
                  xWeights[x] = Number(xWeights[x]) + weight;
                  yWeights[y] = Number(yWeights[y]) + weight;
                  total += weight;
               }
               index++;
            }
            if(total <= 0)
            {
               bitmap.dispose();
               return null;
            }
            bitmapCenter = param2.x + (this.weightedAxisQuantile(xWeights,total,0.5) + 0.5) / scale;
            bitmapTop = param2.y + (this.weightedAxisQuantile(yWeights,total,0.015) + 0.5) / scale;
            bitmapBottom = param2.y + (this.weightedAxisQuantile(yWeights,total,0.985) + 0.5) / scale;
            useDetachedStructuralAnchor = structural != null && param2.width >= 900 && param2.height >= 500 && (Math.abs(bitmapCenter - Number(structural.centerX)) >= 120 || Math.abs(bitmapBottom - Number(structural.bottom)) >= 80);
            result = {
               "centerX":(structural == null ? bitmapCenter : Number(structural.centerX)),
               "top":bitmapTop,
               "bottom":(useDetachedStructuralAnchor ? Number(structural.bottom) : bitmapBottom)
            };
            bitmap.dispose();
            return result;
         }
         catch(ignored:*)
         {
            if(bitmap != null)
            {
               bitmap.dispose();
            }
            return null;
         }
      }
      
      private function lazyApplyPet(param1:FightPet, param2:PetData, param3:int, param4:int, param5:Function, param6:int) : void
      {
         var url:String;
         var petSound:String;
         var status:String;
         var fighter:FightPet = param1;
         var petData:PetData = param2;
         var change:int = param3;
         var version:int = param4;
         var resolve:Function = param5;
         var winner:int = param6;
         if(!petData)
         {
            fighter.url = "unreachable";
            fighter.pet.visible = false;
            resolve();
            return;
         }
         url = petData.petSwf;
         petSound = petData.petSound;
         status = buildIdleLabel(petData);
         if(winner === fighter.side)
         {
            status = "胜利";
         }
         if(!change && fighter.url === url)
         {
            updateStatus(fighter.pet,status,version);
            resolve();
            return;
         }
         CacheUtils.loadPet(url,function(param1:MovieClip):void
         {
            var first:Boolean;
            var exist:MovieClip;
            var pet:MovieClip = param1;
            var twiceWillRemove:* = function(param1:MovieClip):void
            {
               if(param1)
               {
                  disableUClientBattleBackdrop(param1);
                  if(first)
                  {
                     first = false;
                  }
                  else
                  {
                     removeChild(param1);
                  }
               }
            };
            var petDisappear:* = function(param1:MovieClip):void
            {
               var exit:MovieClip = param1;
               if(exit)
               {
                  TweenLite.to(exit,0.5,{
                     "x":(fighter.side == 1 ? -200 : 1160),
                     "ease":Strong.easeIn,
                     "onComplete":function():void
                     {
                        twiceWillRemove(exit);
                        exist.visible = false;
                     },
                     "onCompleteParams":[]
                  });
               }
            };
            var applyPet:* = function(param1:MovieClip, param2:Boolean):void
            {
               var exist:MovieClip = param1;
               var present:Boolean = param2;
               if(exist)
               {
                  twiceWillRemove(exist);
               }
               addChildAt(pet,fighter.depth);
               pet.x = fighter.x;
               pet.y = fighter.y;
               pet.scaleX = fighter.scaleX;
               pet.scaleY = fighter.scaleY;
               fighter.url = url;
               fighter.pet = pet;
               setUClientBattleBackdropHostForPet(pet);
               UClientUniversalBattleAdapter.attach(pet);
               prewarmExternalAttackCover(pet);
               if(isExternalCompactTimeline(pet))
               {
                  externalTerminalSuppressed[pet] = true;
                  status = IDLE;
               }
               if(present && Utils.hasLabel(pet,"个性出场"))
               {
                  stopNativeAction(pet);
                  pet.gotoAndStop("个性出场");
                  startNativeAction(pet,"个性出场");
                  onChild0Complete(pet,function():void
                  {
                     if(!checkVersion(version))
                     {
                        return;
                     }
                     updateStatus(pet,status,version);
                  });
               }
               else
               {
                  updateStatus(pet,status,version);
                  applyExternalPlacement(pet,fighter);
               }
            };
            if(!checkVersion(version))
            {
               return;
            }
            first = true;
            exist = fighter.pet;
            if(change === 2 && exist && Utils.hasLabel(exist,"变身效果"))
            {
               setChildIndex(exist,3);
               updateStatus(exist,"变身效果",version);
               onChild0Complete(exist,function():void
               {
                  if(!checkVersion(version))
                  {
                     return;
                  }
                  twiceWillRemove(exist);
                  applyPet(exist,false);
                  resolve();
               });
            }
            else if(change === 1)
            {
               if(fighter.side === 1)
               {
                  petDisappear(exist);
                  fgLayer.playLeftPresent(function():void
                  {
                     if(!checkVersion(version))
                     {
                        if(exist)
                        {
                           exist.x = fighter.x;
                           exist.visible = true;
                        }
                        return;
                     }
                     soundLayer.playPetSound(petSound);
                     applyPet(exist,false);
                  },resolve);
               }
               else
               {
                  petDisappear(exist);
                  applyPet(exist,true);
                  resolve();
               }
            }
            else
            {
               twiceWillRemove(exist);
               applyPet(exist,false);
               resolve();
            }
         });
      }
      
      private function checkVersion(param1:int) : Boolean
      {
         return this._version === param1;
      }
      
      private function buildIdleLabel(param1:PetData) : String
      {
         if(param1.alive <= 0)
         {
            return "失败";
         }
         if(param1.hp < param1.maxHp * 0.2)
         {
            return "濒死";
         }
         return "待机";
      }
      
      private function buildHurtLabel(param1:int, param2:int) : String
      {
         if(param1 > 0)
         {
            return "闪避";
         }
         if(param2 > 0)
         {
            return "被暴击";
         }
         return "被打";
      }
      
      private function buildMoveSide(param1:int) : Vector.<int>
      {
         if(param1 == 1)
         {
            return Vector.<int>([1,2]);
         }
         return Vector.<int>([2,1]);
      }
      
      private function onChild0Complete(param1:MovieClip, param2:Function) : void
      {
         var handleEnterFrame:*;
         var pet:MovieClip = param1;
         var cb:Function = param2;
         var observed:MovieClip = null;
         var lastFrame:int = -1;
         var stalledTicks:int = 0;
         if(isExternalIdleOnlyPose(pet))
         {
            setTimeout(function():void
            {
               cb();
            },0);
            return;
         }
         handleEnterFrame = function(param1:Event):void
         {
            var action:MovieClip = observed;
            if(action == null || action.parent == null)
            {
               action = findCompletionClip(pet);
            }
            if(action == null)
            {
               pet.removeEventListener("enterFrame",handleEnterFrame);
               cb();
               return;
            }
            if(action !== observed)
            {
               observed = action;
               lastFrame = action.currentFrame;
               stalledTicks = 0;
               return;
            }
            if(action.currentFrame >= action.totalFrames || lastFrame > action.currentFrame && lastFrame >= action.totalFrames - 1)
            {
               pet.removeEventListener("enterFrame",handleEnterFrame);
               cb();
               return;
            }
            if(action.currentFrame == lastFrame)
            {
               ++stalledTicks;
            }
            else
            {
               stalledTicks = 0;
            }
            if(stalledTicks >= 2)
            {
               stalledTicks = 0;
               if(action.currentFrame >= Math.max(1,action.totalFrames - 1))
               {
                  pet.removeEventListener("enterFrame",handleEnterFrame);
                  cb();
                  return;
               }
               try
               {
                  action.play();
               }
               catch(resumeError:*)
               {
               }
            }
            lastFrame = action.currentFrame;
         };
         pet.addEventListener("enterFrame",handleEnterFrame);
      }
      
      private function findCompletionClip(param1:MovieClip) : MovieClip
      {
         var child:MovieClip = null;
         var desc:MovieClip = null;
         if(param1 == null)
         {
            return null;
         }
         if(isExternalCompactTimeline(param1))
         {
            child = findExternalAction(param1);
            if(child != null)
            {
               return child;
            }
         }
         try
         {
            if(param1.numChildren > 0)
            {
               child = param1.getChildAt(0) as MovieClip;
               if(child != null && child.totalFrames > 1)
               {
                  return child;
               }
            }
         }
         catch(ignored:*)
         {
         }
         desc = findAnimatedDescendant(param1,0);
         if(desc != null)
         {
            return desc;
         }
         try
         {
            if(param1.numChildren > 0)
            {
               return param1.getChildAt(0) as MovieClip;
            }
         }
         catch(ignored:*)
         {
         }
         return null;
      }
      
      private function isNativeLoopingAction(param1:String) : Boolean
      {
         return param1 == "待机" || param1 == FighterActionType.IDLE;
      }
      
      private function stopNativeAction(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         var state:Object = nativeActions[param1];
         if(state != null)
         {
            if(state.handler != null)
            {
               param1.removeEventListener(Event.ENTER_FRAME,state.handler);
            }
            delete nativeActions[param1];
         }
      }
      
      private function startNativeAction(param1:MovieClip, param2:String = "") : void
      {
         var action:MovieClip;
         var resolvedLabel:String;
         var looping:Boolean;
         var state:Object;
         var handler:*;
         var pet:MovieClip = param1;
         var requestedLabel:String = param2;
         if(pet == null || isExternalCompactTimeline(pet) || isExternalIdleOnlyPose(pet))
         {
            return;
         }
         stopNativeAction(pet);
         action = findCompletionClip(pet);
         if(action != null && action.totalFrames <= 1)
         {
            return;
         }
         resolvedLabel = requestedLabel != "" ? requestedLabel : pet.currentLabel || pet.currentFrameLabel || "";
         looping = isNativeLoopingAction(resolvedLabel);
         if(action != null)
         {
            try
            {
               action.stop();
            }
            catch(ignored:*)
            {
            }
         }
         state = {
            "action":action,
            "lastTime":getTimer(),
            "accumulatedMs":0,
            "isLooping":looping,
            "handler":null
         };
         handler = function(param1:Event):void
         {
            var total:int;
            var now:int;
            var deltaMs:int;
            var framesToAdvance:int;
            var current:int;
            var isLoop:Boolean;
            var i:int;
            var reachedEnd:Boolean;
            var targetAction:MovieClip = state.action as MovieClip;
            if(nativeActions[pet] == null || nativeActions[pet] !== state)
            {
               pet.removeEventListener(Event.ENTER_FRAME,handler);
               return;
            }
            if(targetAction == null || targetAction.parent == null)
            {
               targetAction = findCompletionClip(pet);
               if(targetAction == null)
               {
                  return;
               }
               state.action = targetAction;
               try
               {
                  targetAction.stop();
               }
               catch(ignored:*)
               {
               }
            }
            total = targetAction.totalFrames;
            if(total <= 1)
            {
               stopNativeAction(pet);
               return;
            }
            now = getTimer();
            deltaMs = now - int(state.lastTime);
            state.lastTime = now;
            if(deltaMs <= 0)
            {
               return;
            }
            if(deltaMs > 500)
            {
               deltaMs = 500;
            }
            state.accumulatedMs = Number(state.accumulatedMs) + deltaMs;
            framesToAdvance = int(Number(state.accumulatedMs) / NATIVE_FRAME_INTERVAL_MS);
            if(framesToAdvance <= 0)
            {
               return;
            }
            state.accumulatedMs = Number(state.accumulatedMs) - framesToAdvance * NATIVE_FRAME_INTERVAL_MS;
            current = targetAction.currentFrame;
            isLoop = Boolean(state.isLooping);
            i = 0;
            if(isLoop)
            {
               if(framesToAdvance > total)
               {
                  framesToAdvance %= total;
               }
               while(i < framesToAdvance)
               {
                  current++;
                  if(current > total)
                  {
                     current = 1;
                  }
                  targetAction.gotoAndStop(current);
                  i++;
               }
            }
            else
            {
               reachedEnd = false;
               while(i < framesToAdvance)
               {
                  current++;
                  if(current >= total)
                  {
                     current = total;
                     targetAction.gotoAndStop(current);
                     reachedEnd = true;
                     break;
                  }
                  targetAction.gotoAndStop(current);
                  i++;
               }
               if(reachedEnd)
               {
                  stopNativeAction(pet);
                  return;
               }
            }
         };
         state.handler = handler;
         nativeActions[pet] = state;
         pet.addEventListener(Event.ENTER_FRAME,handler,false,0,true);
      }
      
      private function findAnimatedDescendant(param1:DisplayObjectContainer, param2:int) : MovieClip
      {
         var i:int = 0;
         var child:DisplayObject = null;
         var clip:MovieClip = null;
         var nested:MovieClip = null;
         if(param1 == null || param2 > 5)
         {
            return null;
         }
         while(i < param1.numChildren)
         {
            try
            {
               child = param1.getChildAt(i);
               clip = child as MovieClip;
               if(clip != null && clip.totalFrames > 1)
               {
                  return clip;
               }
               nested = findAnimatedDescendant(child as DisplayObjectContainer,param2 + 1);
               if(nested != null)
               {
                  return nested;
               }
            }
            catch(ignored:*)
            {
            }
            i++;
         }
         return null;
      }
   }
}

