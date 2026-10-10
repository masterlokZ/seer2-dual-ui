package com.taomee.seer2.app.arena
{
   import com.chunshu.seer2.uclient.UClientUniversalBattleAdapter;
   import com.taomee.seer2.app.arena.data.AnimiationHitInfo;
   import com.taomee.seer2.app.arena.util.FighterActionType;
   import com.taomee.seer2.app.arena.util.HitInfoConfig;
   import com.taomee.seer2.core.animation.IAnimation;
   import com.taomee.seer2.core.player.FighterMoviePlayer;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class FighterAnimation extends Sprite implements IAnimation
   {
      
      public static const EVT_END:String = "end";
      
      public static const EVT_HIT:String = "fighterHit";
      
      private static const MODE_STOP_IDLE:String = "stopIdle";
      
      private static const MODE_STOP_LAST_FRAME:String = "stopLastFrame";
      
      private static const MODE_REPLAY:String = "replay";
      
      private static const MODE_BLANK:String = "blank";
      
      private static const MODE_EXTERNAL_IDLE:String = "externalIdle";
      
      private static const MODE_EXTERNAL_STATIC_WIN:String = "externalStaticWin";
      
      private static const MODE_EXTERNAL_STATIC_ENTRY:String = "externalStaticEntry";
      
      private static const EXTERNAL_TEMPLATE_CENTER_X:Number = 0;
      
      private static const EXTERNAL_TEMPLATE_BASELINE_Y:Number = 145;
      
      private static const EXTERNAL_TARGET_CENTER_X:Number = 163;
      
      private static const EXTERNAL_TARGET_BASELINE_Y:Number = 375;
      
      private static const EXTERNAL_TARGET_BOTTOM_Y:Number = 375;
      
      private static const EXTERNAL_FALLBACK_ANCHOR_X:Number = 111;
      
      private static const EXTERNAL_FALLBACK_ANCHOR_Y:Number = 188;
      
      private static const EXTERNAL_UClient_TARGET_BASELINE_Y:Number = 375;
      
      private static const EXTERNAL_MAX_RENDER_WIDTH:Number = 720;
      
      private static const EXTERNAL_MAX_RENDER_HEIGHT:Number = 650;
      
      private static const EXTERNAL_NORMALIZATION_MAX_ATTEMPTS:int = 3;
      
      private static const EXTERNAL_IDLE_NORMALIZATION_RETRY_LIMIT:int = 8;
      
      private static const OLD_UI_IDLE_EXTREME_MASS_TRIGGER_Y:Number = 140;
      
      private static const OLD_UI_IDLE_COMPACT_MASS_TRIGGER_Y:Number = 165;
      
      private static const OLD_UI_IDLE_TALL_MASS_TRIGGER_Y:Number = 210;
      
      private static const OLD_UI_IDLE_TALL_HEIGHT_TRIGGER:Number = 600;
      
      private static const OLD_UI_IDLE_BOTTOM_TRIGGER_Y:Number = 460;
      
      private static const OLD_UI_IDLE_MAX_SHIFT_Y:Number = 0;
      
      private static const OLD_UI_IDLE_SAMPLE_FRAMES:int = 8;
      
      private static const OLD_UI_IDLE_SAMPLE_LIMIT:Number = 128;
      
      private static const OLD_UI_ENTRY_VIEWPORT_TIMEOUT_MS:int = 1200;
      
      private static const CUSTOM_SKILL_STAGE_WIDTH:Number = 1200;
      
      private static const CUSTOM_SKILL_STAGE_HEIGHT:Number = 660;
      
      private static const CUSTOM_SKILL_TARGET_LEFT_X:Number = 300;
      
      private static const CUSTOM_SKILL_TARGET_RIGHT_X:Number = 900;
      
      private static const CUSTOM_SKILL_TARGET_Y:Number = 330;
      
      private static var _customSkillClasses:Object = {};
      
      private static var _customSkillWaiters:Object = {};
      
      private var _mc:MovieClip;
      
      private var _uclientAdapter:UClientUniversalBattleAdapter;
      
      private var _actionAnimation:MovieClip;
      
      private var _currentLabel:String;
      
      private var _requestedLabel:String;
      
      private var _mode:String;
      
      private var _fighterResourceId:uint;
      
      private var _moviePlayer:FighterMoviePlayer;
      
      private var _nativeTerminalClip:MovieClip;
      
      private var _nativeTerminalHandler:Function;
      
      private var _nativeTerminalTimeout:uint = 0;
      
      private var _externalCompactTimeline:Boolean = false;
      
      private var _externalIdleOnlyPose:Boolean = false;
      
      private var _externalBaseX:Number = 0;
      
      private var _externalBaseY:Number = 0;
      
      private var _externalBaseScaleX:Number = 1;
      
      private var _externalBaseScaleY:Number = 1;
      
      private var _externalFitScale:Number = 1;
      
      private var _externalNormalizationX:Number = 0;
      
      private var _externalNormalizationY:Number = 0;
      
      private var _externalNormalizationReady:Boolean = false;
      
      private var _externalNormalizationAttempts:int = 0;
      
      private var _externalTimer:uint = 0;
      
      private var _externalHitHandler:Function;
      
      private var _externalPrimaryVisual:MovieClip;
      
      private var _externalVisualExitHandler:Function;
      
      private var _externalImpactComplete:Function;
      
      private var _externalSkillCompletionTimer:uint;
      
      private var _externalUltimateCompletionSerial:int = -1;
      
      private var _externalUltimateMainComplete:Boolean = false;
      
      private var _externalUltimateSkillPending:Boolean = false;
      
      private var _externalUltimateSkillComplete:Boolean = false;
      
      private var _cachedDedicatedMoveChecked:Boolean = false;
      
      private var _cachedDedicatedMoveLabel:String = "";
      
      private var _cachedDedicatedMoves:Array = null;
      
      private var _externalUltimateCompletion:Function;
      
      private var _externalFallbackIdleVisual:MovieClip;
      
      private var _externalFallbackIdleTimer:uint = 0;
      
      private var _externalIdleRoot:MovieClip;
      
      private var _externalIdleAction:MovieClip;
      
      private var _externalIdleVisual:MovieClip;
      
      private var _externalIdleReady:Boolean = false;
      
      private var _externalIdleConstructHandler:Function;
      
      private var _externalIdleNormalizationTimer:uint = 0;
      
      private var _externalNeutralRootFrame:int = 1;
      
      private var _entryFallbackTimer:uint = 0;
      
      private var _externalActionClip:MovieClip;
      
      private var _externalActionExitHandler:Function;
      
      private var _externalCoverAction:MovieClip;
      
      private var _externalCoverExitHandler:Function;
      
      private var _externalCoverOriginals:Array;
      
      private var _externalCoverSeed:Shape;
      
      private var _externalCoverFrozenDelta:Matrix;
      
      private var _externalAttackCoverBounds:Rectangle;
      
      private var _externalAttackCoverPending:Object;
      
      private var _hitTimeout:uint = 0;
      
      private var _actionSerial:int = 0;
      
      private var _preparedSerial:int = -1;
      
      private var _hitDispatched:Boolean = false;
      
      private var _entryReroutedToIdle:Boolean = false;
      
      private var _externalPersistentStatusChecked:Boolean = false;
      
      private var _externalPersistentStatusAvailable:Boolean = false;
      
      private var _externalStatusFallbackSerial:int = -1;
      
      private var _externalStatusProbeSerial:int = -1;
      
      private var _externalStatusProbeEndBlocker:Function;
      
      private var _customSkillOverlay:MovieClip;
      
      private var _customSkillOverlayHost:DisplayObjectContainer;
      
      private var _customSkillOverlayFrameHandler:Function;
      
      private var _customSkillOverlayTimer:uint;
      
      private var _customSkillActionSerial:int = 0;
      
      private var _hostViewportNormalized:Boolean = false;
      
      private var _hostViewportProbeCount:int = 0;
      
      private var _hostViewportMedianSum:Number = 0;
      
      private var _hostViewportBottomSum:Number = 0;
      
      private var _hostViewportTopSum:Number = 0;
      
      private var _hostViewportEntryEndPending:Boolean = false;
      
      private var _hostViewportEntryEndTimer:uint = 0;
      
      private var _externalEntryNormalizationReady:Boolean = false;
      
      private var _externalForceIdleInstance:Boolean = false;
      
      private var _appearPlayed:Boolean = false;
      
      public function FighterAnimation()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.addEventListener(EVT_END,this.blockNestedEndEvent,false,int.MAX_VALUE);
      }
      
      private function blockNestedEndEvent(param1:Event) : void
      {
         if(param1.target !== this)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      public function setup(param1:MovieClip, param2:uint) : void
      {
         this._fighterResourceId = param2;
         this._cachedDedicatedMoveChecked = false;
         this._cachedDedicatedMoveLabel = "";
         this._cachedDedicatedMoves = null;
         this._appearPlayed = false;
         this._externalPersistentStatusChecked = false;
         this._externalPersistentStatusAvailable = false;
         if(param1 == null)
         {
            throw new Error("没有战斗精灵的素材资源！[" + this._fighterResourceId + "]");
         }
         this._mc = param1;
         this._externalBaseX = this._mc.x;
         this._externalBaseY = this._mc.y;
         this._externalBaseScaleX = this._mc.scaleX;
         this._externalBaseScaleY = this._mc.scaleY;
         this._externalFitScale = 1;
         this._hostViewportNormalized = false;
         this._hostViewportProbeCount = 0;
         this._hostViewportMedianSum = 0;
         this._hostViewportBottomSum = 0;
         this._hostViewportTopSum = 0;
         this._externalEntryNormalizationReady = false;
         this._externalForceIdleInstance = false;
         this._appearPlayed = false;
         this._externalIdleOnlyPose = this.isExternalIdleOnlyTimeline();
         this._externalCompactTimeline = this.isExternalTimeline();
         if(this._externalCompactTimeline)
         {
            this.primeExternalNormalization();
            this._externalNeutralRootFrame = Math.max(1,this._mc.currentFrame);
         }
         addChild(this._mc);
         if(this._externalCompactTimeline)
         {
            if(!this._externalIdleOnlyPose)
            {
               this._externalForceIdleInstance = this.shouldForceExternalIdleInstance();
               if(this._externalForceIdleInstance)
               {
                  this.y += OLD_UI_IDLE_MAX_SHIFT_Y;
                  this._hostViewportNormalized = true;
               }
            }
            if(!this._hostViewportNormalized && !UClientUniversalBattleAdapter.supports(this._mc))
            {
               this.addEventListener(Event.ENTER_FRAME,this.probeHostViewport,false,0,true);
            }
            else
            {
               this._hostViewportNormalized = true;
            }
         }
         else
         {
            this._hostViewportNormalized = true;
         }
         this.alignExternalCompactTimeline();
         if(!this._externalIdleOnlyPose)
         {
            this.createExternalIdleInstance();
         }
         this._uclientAdapter = UClientUniversalBattleAdapter.attach(this._mc);
         if(!this._externalIdleOnlyPose)
         {
            this.prewarmExternalAttackCover();
         }
         this.preloadCustomSkill();
         this.bindDefaultBattleBackdropHost();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageForBackdrop,false,0,true);
      }
      
      private function onAddedToStageForBackdrop(param1:Event) : void
      {
         this.bindDefaultBattleBackdropHost();
      }
      
      private function bindDefaultBattleBackdropHost() : void
      {
         var host:Object = null;
         try
         {
            if(SceneManager.active != null && SceneManager.active.mapModel != null && SceneManager.active.mapModel.content != null)
            {
               host = SceneManager.active.mapModel.content;
            }
            else if(this.parent != null && this.parent.parent != null)
            {
               host = this.parent.parent;
            }
         }
         catch(ignored:*)
         {
            host = null;
         }
         if(host != null)
         {
            this.setUClientBattleBackdropHost(host);
         }
      }
      
      public function setUClientBattleBackdropHost(param1:Object) : Boolean
      {
         var target:Object = this._mc;
         try
         {
            if(target != null && target["setUClientBattleBackdropHost"] is Function)
            {
               return Boolean(target["setUClientBattleBackdropHost"](param1,this._mc));
            }
         }
         catch(ignored:*)
         {
         }
         return false;
      }
      
      private function createExternalIdleInstance() : void
      {
         var rootClass:Class = null;
         var root:MovieClip = null;
         if(!this._externalCompactTimeline || this._mc == null || UClientUniversalBattleAdapter.supports(this._mc) || this.hasExternalIdleLabel() && !this._externalForceIdleInstance)
         {
            return;
         }
         try
         {
            rootClass = Object(this._mc).constructor as Class;
            if(rootClass != null)
            {
               root = new rootClass() as MovieClip;
            }
         }
         catch(createError:*)
         {
            root = null;
         }
         if(root == null || root === this._mc)
         {
            return;
         }
         this._externalIdleRoot = root;
         this._externalIdleRoot.visible = false;
         addChild(this._externalIdleRoot);
         this.alignExternalCompactTimeline();
         if(!this.prepareExternalIdleInstance())
         {
            this._externalIdleConstructHandler = function(param1:Event):void
            {
               if(prepareExternalIdleInstance())
               {
                  _externalIdleRoot.removeEventListener(Event.FRAME_CONSTRUCTED,_externalIdleConstructHandler);
                  _externalIdleConstructHandler = null;
               }
            };
            this._externalIdleRoot.addEventListener(Event.FRAME_CONSTRUCTED,this._externalIdleConstructHandler,false,0,true);
         }
      }
      
      private function shouldForceExternalIdleInstance() : Boolean
      {
         var bounds:Rectangle = null;
         if(!this._externalCompactTimeline || this._mc == null || UClientUniversalBattleAdapter.supports(this._mc))
         {
            return false;
         }
         try
         {
            bounds = this._mc.getBounds(this);
         }
         catch(ignored:*)
         {
            bounds = null;
         }
         return bounds != null && bounds.height >= OLD_UI_IDLE_TALL_HEIGHT_TRIGGER && bounds.top < -100 && bounds.bottom < 620;
      }
      
      private function getActionChildFrom(param1:MovieClip) : MovieClip
      {
         var child:MovieClip = null;
         var index:int = 0;
         if(param1 == null)
         {
            return null;
         }
         try
         {
            while(index < param1.numChildren)
            {
               child = param1.getChildAt(index) as MovieClip;
               if(child != null)
               {
                  return child;
               }
               index++;
            }
         }
         catch(ignored:*)
         {
         }
         return null;
      }
      
      private function prepareExternalIdleInstance() : Boolean
      {
         var label:String = null;
         if(this._externalIdleRoot == null)
         {
            return false;
         }
         label = this.resolveExternalLabel("待机");
         try
         {
            this._externalIdleRoot.gotoAndStop(label == "" ? this._externalNeutralRootFrame : label);
         }
         catch(labelError:*)
         {
            try
            {
               this._externalIdleRoot.gotoAndStop(this._externalNeutralRootFrame);
            }
            catch(frameError:*)
            {
               return false;
            }
         }
         this._externalIdleAction = this.getActionChildFrom(this._externalIdleRoot);
         if(this._externalIdleAction == null)
         {
            return false;
         }
         this.setActionFrame(this._externalIdleAction,1);
         try
         {
            this._externalIdleAction.stop();
         }
         catch(actionError:*)
         {
         }
         this._externalIdleVisual = this.getPrimaryActionVisual(this._externalIdleAction);
         if(this._externalIdleVisual == null)
         {
            return false;
         }
         if(!this._externalNormalizationReady)
         {
            this.captureExternalNormalization(this._externalIdleAction,this._externalIdleRoot);
            this.alignExternalCompactTimeline();
         }
         try
         {
            this._externalIdleVisual.gotoAndPlay(1);
         }
         catch(visualError:*)
         {
            try
            {
               this._externalIdleVisual.play();
            }
            catch(ignored:*)
            {
            }
         }
         this._externalIdleReady = true;
         return true;
      }
      
      private function showExternalIdleInstance() : Boolean
      {
         if(this._externalIdleRoot == null)
         {
            return false;
         }
         if(!this._externalIdleReady && !this.prepareExternalIdleInstance())
         {
            return false;
         }
         if(this._mc != null)
         {
            this._mc.visible = false;
         }
         this._externalIdleRoot.visible = true;
         this.retryExternalIdleNormalization(0);
         try
         {
            this._externalIdleVisual.play();
         }
         catch(ignored:*)
         {
         }
         this.alignExternalCompactTimeline();
         return true;
      }
      
      private function retryExternalIdleNormalization(param1:int) : void
      {
         var attempt:int = param1;
         if(this._externalIdleNormalizationTimer > 0)
         {
            clearTimeout(this._externalIdleNormalizationTimer);
            this._externalIdleNormalizationTimer = 0;
         }
         if(!this._externalCompactTimeline || this._mc == null || this._externalIdleRoot == null || !this._externalIdleRoot.visible)
         {
            return;
         }
         if(!this._externalNormalizationReady)
         {
            this.primeExternalNormalization();
         }
         this.alignExternalCompactTimeline();
         if(!this._externalNormalizationReady && attempt < EXTERNAL_IDLE_NORMALIZATION_RETRY_LIMIT)
         {
            this._externalIdleNormalizationTimer = setTimeout(function():void
            {
               retryExternalIdleNormalization(attempt + 1);
            },16);
         }
      }
      
      private function hideExternalIdleInstance() : void
      {
         if(this._externalIdleNormalizationTimer > 0)
         {
            clearTimeout(this._externalIdleNormalizationTimer);
            this._externalIdleNormalizationTimer = 0;
         }
         if(this._externalIdleRoot != null)
         {
            this._externalIdleRoot.visible = false;
         }
         if(this._externalIdleVisual != null)
         {
            try
            {
               this._externalIdleVisual.stop();
            }
            catch(ignored:*)
            {
            }
         }
         if(this._mc != null)
         {
            this._mc.visible = true;
         }
      }
      
      private function customSkillUrl() : String
      {
         var fightUrl:String = null;
         try
         {
            fightUrl = URLUtil.getPetFightSwf(this._fighterResourceId);
         }
         catch(ignored:*)
         {
            fightUrl = "";
         }
         if(fightUrl == null || fightUrl == "")
         {
            return "/res/pet/skill/" + this._fighterResourceId + ".swf";
         }
         return fightUrl.replace("/fight/","/skill/");
      }
      
      private function preloadCustomSkill(param1:Function = null) : void
      {
         var url:String = this.customSkillUrl();
         var loader:Loader = null;
         var info:LoaderInfo = null;
         var finish:Function = null;
         var context:LoaderContext = null;
         if(url == "")
         {
            if(param1 != null)
            {
               param1(null);
            }
            return;
         }
         if(_customSkillClasses.hasOwnProperty(url))
         {
            if(param1 != null)
            {
               param1(_customSkillClasses[url]);
            }
            return;
         }
         if(_customSkillWaiters[url] != null)
         {
            if(param1 != null)
            {
               _customSkillWaiters[url].push(param1);
            }
            return;
         }
         _customSkillWaiters[url] = param1 == null ? [] : [param1];
         loader = new Loader();
         info = loader.contentLoaderInfo;
         finish = function(param1:Class):void
         {
            var callbacks:Array = _customSkillWaiters[url] as Array;
            var callback:Function = null;
            delete _customSkillWaiters[url];
            if(param1 != null)
            {
               _customSkillClasses[url] = param1;
            }
            else
            {
               delete _customSkillClasses[url];
            }
            if(callbacks != null)
            {
               for each(callback in callbacks)
               {
                  callback(param1);
               }
            }
         };
         info.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            var skillClass:Class = null;
            try
            {
               skillClass = info.applicationDomain.getDefinition("skill") as Class;
            }
            catch(ignored:*)
            {
            }
            finish(skillClass);
         });
         info.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
         {
            finish(null);
         });
         info.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(param1:SecurityErrorEvent):void
         {
            finish(null);
         });
         try
         {
            context = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
            loader.load(new URLRequest(url),context);
         }
         catch(ignored:*)
         {
            finish(null);
         }
      }
      
      private function isCustomUltimateAction(param1:String) : Boolean
      {
         return param1 == FighterActionType.ATK_POW || param1 == FighterActionType.INTERCOURSE;
      }
      
      private function getCustomSkillHost() : DisplayObjectContainer
      {
         var current:DisplayObjectContainer = this;
         if(this.stage == null)
         {
            return null;
         }
         while(current.parent != null && current.parent !== this.stage)
         {
            current = current.parent;
         }
         return current;
      }
      
      private function playCustomSkillOverlay(param1:int, param3:Function = null) : void
      {
         var self:FighterAnimation = this;
         this.preloadCustomSkill(function(param2:Class):void
         {
            var host:DisplayObjectContainer = null;
            var clip:MovieClip = null;
            var boundsProbe:MovieClip = null;
            var localOrigin:Point = null;
            var positioned:Boolean = false;
            var bounds:Rectangle = null;
            var visualSeen:Boolean = false;
            var emptyFrames:int = 0;
            var durationFrames:int = 0;
            var durationMs:int = 0;
            var maxDurationFrames:int = 1;
            var overlayElapsedFrames:int = 0;
            if(param1 != self._customSkillActionSerial)
            {
               return;
            }
            if(param2 == null || self.stage == null)
            {
               if(param3 != null)
               {
                  param3();
               }
               self.completeExternalImpactTail();
               return;
            }
            self.stopCustomSkillOverlay();
            try
            {
               clip = new param2() as MovieClip;
            }
            catch(ignored:*)
            {
               clip = null;
            }
            if(clip == null)
            {
               if(param3 != null)
               {
                  param3();
               }
               self.completeExternalImpactTail();
               return;
            }
            try
            {
               boundsProbe = new param2() as MovieClip;
               bounds = self.measureCustomSkillTimelineBounds(boundsProbe);
            }
            catch(boundsProbeError:*)
            {
               boundsProbe = null;
               bounds = null;
            }
            host = self.getCustomSkillHost();
            if(host == null)
            {
               return;
            }
            self._customSkillOverlay = clip;
            self._customSkillOverlayHost = host;
            localOrigin = host.globalToLocal(self.localToGlobal(new Point(0,0)));
            clip.x = 0;
            clip.y = 0;
            if(localOrigin.x > CUSTOM_SKILL_STAGE_WIDTH / 2)
            {
               clip.scaleX = -Math.abs(clip.scaleX);
            }
            if(bounds != null && bounds.width > 1 && bounds.height > 1)
            {
               clip.x = CUSTOM_SKILL_STAGE_WIDTH / 2 - (bounds.x + bounds.width / 2) * clip.scaleX;
               clip.y = CUSTOM_SKILL_STAGE_HEIGHT / 2 - (bounds.y + bounds.height / 2) * clip.scaleY;
               positioned = true;
            }
            host.addChild(clip);
            setTimeout(function():void
            {
               if(self._customSkillOverlay !== clip || param1 != self._customSkillActionSerial || self.stage == null)
               {
                  return;
               }
               durationFrames = self.getCustomSkillDurationFrames(clip);
               if(durationFrames > 1)
               {
                  durationMs = Math.ceil(durationFrames * 1000 / Math.max(1,self.stage.frameRate));
                  self._customSkillOverlayTimer = setTimeout(function():void
                  {
                     if(self._customSkillOverlay === clip && param1 == self._customSkillActionSerial)
                     {
                        self.stopCustomSkillOverlay();
                        if(param3 != null)
                        {
                           param3();
                        }
                        self.completeExternalImpactTail();
                     }
                  },durationMs);
               }
            },0);
            self._customSkillOverlayFrameHandler = function(param1:Event):void
            {
               var liveBounds:Rectangle = null;
               ++overlayElapsedFrames;
               maxDurationFrames = Math.max(maxDurationFrames,self.getCustomSkillDurationFrames(clip));
               if(!positioned)
               {
                  try
                  {
                     bounds = clip.getBounds(clip);
                     if(bounds.width > 1 && bounds.height > 1)
                     {
                        clip.x = CUSTOM_SKILL_STAGE_WIDTH / 2 - (bounds.x + bounds.width / 2) * clip.scaleX;
                        clip.y = CUSTOM_SKILL_STAGE_HEIGHT / 2 - (bounds.y + bounds.height / 2) * clip.scaleY;
                        positioned = true;
                     }
                  }
                  catch(ignored:*)
                  {
                  }
               }
               try
               {
                  liveBounds = clip.getBounds(clip);
                  if(liveBounds != null && liveBounds.width > 1 && liveBounds.height > 1)
                  {
                     visualSeen = true;
                     emptyFrames = 0;
                  }
                  else if(visualSeen)
                  {
                     ++emptyFrames;
                  }
               }
               catch(boundsError:*)
               {
               }
               if(self._customSkillOverlay === clip && (self.hasCustomSkillEndMarker(clip) || maxDurationFrames > 1 && overlayElapsedFrames >= maxDurationFrames + 2 || clip.totalFrames > 1 && clip.currentFrame >= clip.totalFrames || visualSeen && (emptyFrames >= 2 || !clip.visible)))
               {
                  self.stopCustomSkillOverlay();
                  if(param3 != null)
                  {
                     param3();
                  }
                  self.completeExternalImpactTail();
               }
            };
            self.addEventListener(Event.ENTER_FRAME,self._customSkillOverlayFrameHandler);
            clip.gotoAndPlay(1);
         });
      }
      
      private function measureCustomSkillTimelineBounds(param1:MovieClip) : Rectangle
      {
         var frame:int = 0;
         var frameBounds:Rectangle = null;
         var result:Rectangle = null;
         if(param1 == null)
         {
            return null;
         }
         try
         {
            param1.stop();
            frame = 1;
            while(frame <= Math.max(1,param1.totalFrames))
            {
               param1.gotoAndStop(frame);
               frameBounds = param1.getBounds(param1);
               if(frameBounds != null && frameBounds.width > 1 && frameBounds.height > 1)
               {
                  result = result == null ? frameBounds.clone() : result.union(frameBounds);
               }
               frame++;
            }
            param1.gotoAndStop(1);
         }
         catch(ignored:*)
         {
         }
         return result;
      }
      
      private function stopCustomSkillOverlay() : void
      {
         if(this._customSkillOverlayTimer > 0)
         {
            clearTimeout(this._customSkillOverlayTimer);
            this._customSkillOverlayTimer = 0;
         }
         if(this._customSkillOverlay != null)
         {
            if(this._customSkillOverlayFrameHandler != null)
            {
               this.removeEventListener(Event.ENTER_FRAME,this._customSkillOverlayFrameHandler);
            }
            try
            {
               this._customSkillOverlay.stop();
            }
            catch(ignored:*)
            {
            }
            if(this._customSkillOverlay.parent != null)
            {
               this._customSkillOverlay.parent.removeChild(this._customSkillOverlay);
            }
         }
         this._customSkillOverlay = null;
         this._customSkillOverlayHost = null;
         this._customSkillOverlayFrameHandler = null;
      }
      
      private function getCustomSkillDurationFrames(param1:DisplayObject, param2:int = 0) : int
      {
         var result:int = 1;
         var clip:MovieClip = null;
         var container:DisplayObjectContainer = null;
         var index:int = 0;
         var childFrames:int = 1;
         if(param1 == null || param2 > 12)
         {
            return result;
         }
         clip = param1 as MovieClip;
         if(clip != null)
         {
            result = Math.max(result,clip.totalFrames);
         }
         container = param1 as DisplayObjectContainer;
         if(container != null)
         {
            while(index < container.numChildren)
            {
               try
               {
                  childFrames = this.getCustomSkillDurationFrames(container.getChildAt(index),param2 + 1);
                  result = Math.max(result,childFrames);
               }
               catch(ignored:*)
               {
               }
               index++;
            }
         }
         return result;
      }
      
      private function hasCustomSkillEndMarker(param1:DisplayObject, param2:int = 0) : Boolean
      {
         var container:DisplayObjectContainer = null;
         var index:int = 0;
         if(param1 == null || param2 > 12)
         {
            return false;
         }
         try
         {
            if("isEnd" in param1 && Boolean(param1["isEnd"]))
            {
               return true;
            }
         }
         catch(ignored:*)
         {
         }
         container = param1 as DisplayObjectContainer;
         if(container == null)
         {
            return false;
         }
         while(index < container.numChildren)
         {
            try
            {
               if(this.hasCustomSkillEndMarker(container.getChildAt(index),param2 + 1))
               {
                  return true;
               }
            }
            catch(childError:*)
            {
            }
            index++;
         }
         return false;
      }
      
      private function completeExternalImpactTail() : void
      {
         if(!this._externalCompactTimeline || !this._hitDispatched || !this.isCustomUltimateAction(this._requestedLabel) || !this._externalUltimateSkillPending || this._externalUltimateCompletionSerial != this._actionSerial)
         {
            return;
         }
         this._externalUltimateSkillComplete = true;
         this.tryCompleteExternalUltimate();
      }
      
      private function tryCompleteExternalUltimate() : void
      {
         var completion:Function = null;
         if(this._externalUltimateCompletionSerial != this._actionSerial || !this._externalUltimateMainComplete || !this._externalUltimateSkillPending || !this._externalUltimateSkillComplete || this._externalUltimateCompletion == null)
         {
            return;
         }
         completion = this._externalUltimateCompletion;
         this._externalUltimateCompletion = null;
         this._externalUltimateSkillPending = false;
         completion();
      }
      
      private function scheduleExternalSkillCompletion(param1:int) : void
      {
         var self:FighterAnimation = this;
         this.preloadCustomSkill(function(param2:Class):void
         {
            var probe:MovieClip = null;
            var durationFrames:int = 0;
            var durationMs:int = 0;
            if(param1 != self._actionSerial || param2 == null || self.stage == null)
            {
               if(param1 == self._actionSerial)
               {
                  self.completeExternalImpactTail();
               }
               return;
            }
            try
            {
               probe = new param2() as MovieClip;
               durationFrames = self.getCustomSkillDurationFrames(probe);
            }
            catch(ignored:*)
            {
               durationFrames = 0;
            }
            if(durationFrames <= 1)
            {
               self.completeExternalImpactTail();
               return;
            }
            durationMs = Math.ceil(durationFrames * 1000 / Math.max(1,self.stage.frameRate));
            self._externalSkillCompletionTimer = setTimeout(function():void
            {
               self._externalSkillCompletionTimer = 0;
               if(param1 == self._actionSerial)
               {
                  self.completeExternalImpactTail();
               }
            },durationMs);
         });
      }
      
      public function get usesExternalCompactTimeline() : Boolean
      {
         return this._externalCompactTimeline;
      }
      
      public function get totalFrameNum() : uint
      {
         return this._mc == null ? 0 : this._mc.totalFrames;
      }
      
      public function get currentFrameIndex() : uint
      {
         return this._mc == null ? 0 : this._mc.currentFrame;
      }
      
      public function get currentFrameLabel() : String
      {
         if(this._requestedLabel != null && this._requestedLabel != "")
         {
            return this._requestedLabel;
         }
         return this._mc == null ? "" : this._mc.currentFrameLabel;
      }
      
      public function play() : void
      {
         if(this._mc != null)
         {
            if(this._externalCompactTimeline && this._mode == MODE_EXTERNAL_IDLE && (this._externalForceIdleInstance || !this.hasExternalIdleLabel()))
            {
               this.showExternalIdleInstance();
               return;
            }
            this._mc.play();
         }
      }
      
      public function stop() : void
      {
         if(this._externalIdleVisual != null && this._externalIdleRoot != null && this._externalIdleRoot.visible)
         {
            try
            {
               this._externalIdleVisual.stop();
            }
            catch(idleStopError:*)
            {
            }
         }
         if(this._mc != null)
         {
            this._mc.stop();
         }
      }
      
      public function gotoAndPlay(param1:uint) : void
      {
         if(this._mc != null)
         {
            this._mc.gotoAndPlay(param1);
         }
      }
      
      public function gotoAndStop(param1:uint) : void
      {
         if(this._mc != null)
         {
            this._mc.gotoAndStop(param1);
         }
      }
      
      public function hasLabel(param1:String) : Boolean
      {
         return this.findLabel([param1]) != "";
      }
      
      public function findAppearLabel(param1:MovieClip) : String
      {
         var candidate:String = null;
         var frameLabel:FrameLabel = null;
         if(param1 == null)
         {
            return "";
         }
         var candidates:Array = ["个性出场","appear","present","show","entrance","intro","出场","入场"];
         for each(candidate in candidates)
         {
            for each(frameLabel in param1.currentLabels)
            {
               if(frameLabel != null && frameLabel.name != null && frameLabel.name.toLowerCase() == candidate.toLowerCase())
               {
                  return frameLabel.name;
               }
            }
         }
         return "";
      }
      
      public function hasAppearAction() : Boolean
      {
         if(this.hasLabel("个性出场"))
         {
            return true;
         }
         var timeline:MovieClip = this.getEffectiveTimeline(this._mc);
         if(timeline != null && this.findAppearLabel(timeline) != "")
         {
            return true;
         }
         return false;
      }
      
      public function isEffectivelyVisible() : Boolean
      {
         var cur:DisplayObject = this;
         while(cur != null)
         {
            if(!cur.visible)
            {
               return false;
            }
            cur = cur.parent;
         }
         return true;
      }
      
      private function getEffectiveTimeline(param1:MovieClip) : MovieClip
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1.totalFrames <= 1 && (param1.currentLabels == null || param1.currentLabels.length == 0) && param1.numChildren > 0 && param1.getChildAt(0) is MovieClip)
         {
            var inner:MovieClip = param1.getChildAt(0) as MovieClip;
            if(inner != null && (inner.totalFrames > 1 || inner.currentLabels != null && inner.currentLabels.length > 0))
            {
               return inner;
            }
         }
         return param1;
      }
      
      private function findLabel(param1:Array) : String
      {
         var candidate:String = null;
         var frameLabel:FrameLabel = null;
         var timeline:MovieClip = this.getEffectiveTimeline(this._mc);
         if(timeline == null || param1 == null)
         {
            return "";
         }
         for each(candidate in param1)
         {
            if(candidate != null)
            {
               for each(frameLabel in timeline.currentLabels)
               {
                  if(frameLabel != null && frameLabel.name.toLowerCase() == candidate.toLowerCase())
                  {
                     return frameLabel.name;
                  }
               }
            }
         }
         return "";
      }
      
      private function hasAnyMoveLabel() : Boolean
      {
         var frameLabel:FrameLabel = null;
         var name:String = null;
         var timeline:MovieClip = this.getEffectiveTimeline(this._mc);
         if(timeline == null)
         {
            return false;
         }
         for each(frameLabel in timeline.currentLabels)
         {
            if(frameLabel != null && frameLabel.name != null)
            {
               name = frameLabel.name.toLowerCase();
               if(name.indexOf("moves_") == 0 || name.indexOf("move_") == 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function findDedicatedMoveLabel() : String
      {
         var authoritative:String = null;
         var moveList:Array = null;
         var moveRegex:RegExp = null;
         var distinctAttack:Boolean = false;
         var authList:Array = null;
         var lblName:String = null;
         var frameLabel:FrameLabel = null;
         var result:String = "";
         var len:int = 0;
         if(this._cachedDedicatedMoves == null)
         {
            var timeline:MovieClip = this.getEffectiveTimeline(this._mc);
            if(timeline == null)
            {
               return "";
            }
            distinctAttack = this.findLabel(["attack","atk","physical"]) != "";
            authList = distinctAttack ? ["sa5","as5","attack5","attack1","hidemove","ultimate","ultra","power","add1"] : ["sa5","as5","attack5","hidemove","ultimate","ultra","power","add1"];
            authoritative = this.findLabel(authList);
            if(authoritative != "")
            {
               this._cachedDedicatedMoves = [authoritative];
            }
            else
            {
               moveList = [];
               moveRegex = /^moves?_?\d+(?:_\d+)?$/i;
               for each(frameLabel in timeline.currentLabels)
               {
                  if(frameLabel != null && frameLabel.name != null)
                  {
                     lblName = frameLabel.name;
                     if(moveRegex.test(lblName) || /^add\d+$/i.test(lblName) || /^attack\d+$/i.test(lblName) && lblName.toLowerCase() != "attack" && lblName.toLowerCase() != "atk")
                     {
                        moveList.push(frameLabel.name);
                     }
                  }
               }
               if(moveList.length >= 1)
               {
                  this._cachedDedicatedMoves = this.collectDedicatedMoveCandidates(timeline,moveList);
               }
               else
               {
                  this._cachedDedicatedMoves = [];
               }
            }
            this._cachedDedicatedMoveChecked = true;
         }
         len = int(this._cachedDedicatedMoves.length);
         if(len == 0)
         {
            this._cachedDedicatedMoveLabel = "";
            return "";
         }
         if(len == 1)
         {
            result = String(this._cachedDedicatedMoves[0]);
            this._cachedDedicatedMoveLabel = result;
            return result;
         }
         result = String(this._cachedDedicatedMoves[int(Math.random() * len)]);
         this._cachedDedicatedMoveLabel = result;
         return result;
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
            return [String(param2[0])];
         }
         if(param1 != null && UClientUniversalBattleAdapter.supports(param1) || this._mc != null && UClientUniversalBattleAdapter.supports(this._mc))
         {
            return param2;
         }
         physLabel = this.findLabel(["attack","atk","attack1","at1","physical"]);
         specLabel = this.findLabel(["sa","special","magic","attack2","at2","add2"]);
         propLabel = this.findLabel(["cp","property","buff","effect","attribute","support","skill","add3"]);
         currentF = param1.currentFrame;
         physStats = this.getActionLabelStats(param1,physLabel);
         if(physStats == null)
         {
            physStats = this.getActionFrameStats(param1,1);
         }
         specStats = this.getActionLabelStats(param1,specLabel);
         propStats = this.getActionLabelStats(param1,propLabel);
         distinct = [];
         for each(m in param2)
         {
            st = this.getActionLabelStats(param1,m);
            if(st != null)
            {
               st.label = m;
               isDup = false;
               if(physStats != null && this.isDuplicateActionStats(st,physStats))
               {
                  isDup = true;
               }
               if(specStats != null && this.isDuplicateActionStats(st,specStats))
               {
                  isDup = true;
               }
               if(propStats != null && this.isDuplicateActionStats(st,propStats))
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
               lbl = String(candItem.label);
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
                  lbl = String(candItem.label);
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
            return String(param2[0]);
         }
         physLabel = this.findLabel(["attack","atk","attack1","at1","physical"]);
         specLabel = this.findLabel(["sa","special","magic","attack2","at2","add2"]);
         propLabel = this.findLabel(["cp","property","buff","effect","attribute","support","skill","add3"]);
         currentF = param1.currentFrame;
         physStats = this.getActionLabelStats(param1,physLabel);
         if(physStats == null)
         {
            physStats = this.getActionFrameStats(param1,1);
         }
         specStats = this.getActionLabelStats(param1,specLabel);
         propStats = this.getActionLabelStats(param1,propLabel);
         distinct = [];
         allStats = [];
         for each(m in param2)
         {
            st = this.getActionLabelStats(param1,m);
            if(st != null)
            {
               st.label = m;
               allStats.push(st);
               isDup = false;
               if(physStats != null && this.isDuplicateActionStats(st,physStats))
               {
                  isDup = true;
               }
               if(specStats != null && this.isDuplicateActionStats(st,specStats))
               {
                  isDup = true;
               }
               if(propStats != null && this.isDuplicateActionStats(st,propStats))
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
            return physLabel != "" ? physLabel : (this.findLabel(["attack","atk","physical"]) != "" ? this.findLabel(["attack","atk","physical"]) : "");
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
            bestScore = this.scoreMoveCandidate(String(best.label),int(best.totalFrames),best.child as MovieClip);
            candScore = this.scoreMoveCandidate(String(candidate.label),int(candidate.totalFrames),candidate.child as MovieClip);
            if(candScore > bestScore)
            {
               best = candidate;
            }
         }
         return String(best.label);
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
         f = this.frameForLabel(param1,param2);
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
         child = this.firstDirectMovieChild(param1);
         dur = this.endFrameForLabel(param1,param2) - f + 1;
         childFrames = child != null ? child.totalFrames : 1;
         descFrames = child != null ? this.maxDescendantFrames(child) : 1;
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
         child = this.firstDirectMovieChild(param1);
         childFrames = child != null ? child.totalFrames : 1;
         descFrames = child != null ? this.maxDescendantFrames(child) : 1;
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
         var l1:String = param1.label != null ? String(param1.label).toLowerCase() : "";
         var l2:String = param2.label != null ? String(param2.label).toLowerCase() : "";
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
               maximum = Math.max(maximum,this.maxDescendantFrames(nested,param2 + 1));
            }
            i++;
         }
         return maximum;
      }
      
      public function frameForLabel(param1:MovieClip, param2:String) : int
      {
         var item:FrameLabel = null;
         if(param1 == null || param2 == null || param2 == "")
         {
            return 0;
         }
         for each(item in param1.currentLabels)
         {
            if(item != null && item.name != null && item.name.toLowerCase() == param2.toLowerCase())
            {
               return item.frame;
            }
         }
         return 0;
      }
      
      public function endFrameForLabel(param1:MovieClip, param2:String) : int
      {
         var targetFrame:int = 0;
         var nextFrame:int = int.MAX_VALUE;
         var frameLabel:FrameLabel = null;
         if(param1 == null || param2 == null || param2 == "")
         {
            return 0;
         }
         targetFrame = this.frameForLabel(param1,param2);
         if(targetFrame <= 0)
         {
            return 0;
         }
         if(param1.currentLabels == null || param1.currentLabels.length == 0)
         {
            return param1.totalFrames;
         }
         try
         {
            for each(frameLabel in param1.currentLabels)
            {
               if(frameLabel != null && frameLabel.frame > targetFrame && frameLabel.frame < nextFrame)
               {
                  nextFrame = frameLabel.frame;
               }
            }
         }
         catch(ignored:*)
         {
         }
         if(nextFrame != int.MAX_VALUE)
         {
            return Math.max(targetFrame,nextFrame - 1);
         }
         return param1.totalFrames;
      }
      
      private function isExternalTimeline() : Boolean
      {
         if(this._mc != null && UClientUniversalBattleAdapter.supports(this._mc))
         {
            return true;
         }
         if(this.isExternalIdleOnlyTimeline())
         {
            return true;
         }
         if(this.findLabel(["待机","物理攻击","属性攻击","特殊攻击","被打","必杀"]) != "")
         {
            return false;
         }
         return this.findLabel(["attack","atk","attack1","sa","sa5","cp","hidemove","hited","hurt","hit","idle","stand","special","skill","ultimate","ultra","power"]) != "" || this.hasAnyMoveLabel();
      }
      
      private function isExternalIdleOnlyTimeline() : Boolean
      {
         var frameLabel:FrameLabel = null;
         var name:String = "";
         if(this._mc == null || this._mc.totalFrames > 1 || this._mc.numChildren <= 0)
         {
            return false;
         }
         try
         {
            for each(frameLabel in this._mc.currentLabels)
            {
               name = frameLabel == null || frameLabel.name == null ? "" : frameLabel.name.toLowerCase();
               if(name != "")
               {
                  if(name != "attack" && name != "atk" && name != "attack1")
                  {
                     return false;
                  }
               }
            }
         }
         catch(ignored:*)
         {
            return false;
         }
         return this.getActionChild() != null;
      }
      
      private function isExternalHurtAction() : Boolean
      {
         var label:String = (this._currentLabel || (this._mc == null ? "" : this._mc.currentLabel)).toLowerCase();
         return label == "hited" || label == "hurt" || label == "hit" || label == "behit" || label == "damage";
      }
      
      private function hasExternalIdleLabel() : Boolean
      {
         return this.findLabel(["idle","stand","wait"]) != "";
      }
      
      private function isHostFighterDead() : Boolean
      {
         var fighter:Fighter = null;
         try
         {
            fighter = this.parent as Fighter;
            if(fighter != null)
            {
               if(fighter.isDead() || fighter.fighterInfo != null && fighter.fighterInfo.hp <= 0)
               {
                  return true;
               }
            }
         }
         catch(error:*)
         {
         }
         return false;
      }
      
      private function shouldFallbackExternalStatusToIdle(param1:String) : Boolean
      {
         if(!this._externalCompactTimeline)
         {
            return false;
         }
         if(param1 == "濒死")
         {
            return this.findLabel(["dying","lowhp","weak"]) == "" && (this.findLabel(["hited","hurt","hit","beHit","damage"]) == "" || this._externalPersistentStatusChecked && !this._externalPersistentStatusAvailable);
         }
         if(param1 == "失败")
         {
            return false;
         }
         return false;
      }
      
      private function hasPersistentExternalStatusPose() : Boolean
      {
         var label:String = null;
         var action:MovieClip = null;
         if(this._externalPersistentStatusChecked)
         {
            return this._externalPersistentStatusAvailable;
         }
         this._externalPersistentStatusChecked = true;
         label = this.findLabel(["hited","hurt","hit","beHit","damage"]);
         if(label == "" || this._mc == null)
         {
            return false;
         }
         try
         {
            this._mc.gotoAndStop(label);
            action = this.getActionChild();
            if(action != null)
            {
               action.gotoAndStop(action.totalFrames);
               this._externalPersistentStatusAvailable = this.hasAnimatedDescendant(action,0);
            }
         }
         catch(ignored:*)
         {
            this._externalPersistentStatusAvailable = false;
         }
         return this._externalPersistentStatusAvailable;
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
               if(this.hasAnimatedDescendant(child,param2 + 1))
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
      
      private function adjustCurrentLabel(param1:String) : String
      {
         if(!this._externalCompactTimeline && (param1 == "必杀" || param1 == "合体攻击") && !this.hasLabel(param1))
         {
            return this.hasLabel("物理攻击") ? "物理攻击" : "待机";
         }
         if(!this._externalCompactTimeline && param1 == "濒死" && !this.hasLabel("濒死"))
         {
            return "失败";
         }
         if(!this._externalCompactTimeline && param1 == "变身效果" && !this.hasLabel("变身效果"))
         {
            var transformLabel:String = this.findLabel(["transform"]);
            if(transformLabel != "")
            {
               return transformLabel;
            }
            return this.hasLabel("属性攻击") ? "属性攻击" : (this.hasLabel("待机") ? "待机" : param1);
         }
         if(param1 == "个性出场" && !this.hasLabel("个性出场"))
         {
            if(this._externalCompactTimeline)
            {
               return param1;
            }
            return "待机";
         }
         return param1;
      }
      
      private function resolveExternalLabel(param1:String) : String
      {
         var candidates:Array = null;
         var dedicatedMove:String = null;
         switch(param1)
         {
            case "属性攻击":
               candidates = ["cp","attribute","support","skill","special","sa","attack","atk"];
               break;
            case "特殊攻击":
               candidates = ["sa","special","magic","skill","attack","atk","attack1"];
               break;
            case "必杀":
            case "合体攻击":
               dedicatedMove = this.findDedicatedMoveLabel();
               if(dedicatedMove != "")
               {
                  return dedicatedMove;
               }
               candidates = ["hidemove","sa5","as5","attack5","ultimate","ultra","power","attack1","normalAttack","attack","atk","physical"];
               break;
            case "被打":
            case "被暴击":
            case "闪避":
               candidates = ["hited","hurt","hit","beHit","damage","attack","atk"];
               break;
            case "失败":
            case "濒死":
               candidates = ["lose","lost","failure","fail","defeat","dead","death","hited","hurt","hit","attack","atk"];
               break;
            case "胜利":
               candidates = ["win","victory","idle","stand","attack","atk"];
               break;
            case "待机":
               candidates = ["idle","stand","wait","attack","atk","attack1"];
               break;
            case "变身效果":
               candidates = ["transform","morph","change","miracle","trans","primary","present","show","entrance","appear"];
               break;
            case "个性出场":
               candidates = ["个性出场","appear","present","show","entrance","intro","出场","入场","idle","stand"];
               break;
            case "物理攻击":
            default:
               candidates = ["attack","atk","attack1","normalAttack","skill","sa","cp"];
         }
         var label:String = this.findLabel(candidates);
         if(label != "")
         {
            return label;
         }
         if(param1 == "变身效果")
         {
            var transformFallback:String = this.findLabel(["cp","attribute","support","skill","special","属性攻击"]);
            if(transformFallback != "")
            {
               return transformFallback;
            }
            return this.findLabel(["idle","stand","wait","待机"]);
         }
         if(param1 == "个性出场")
         {
            return this.findLabel(["idle","stand","wait","attack","atk","attack1"]);
         }
         if(this._mc != null && this._mc.currentLabels.length > 0)
         {
            return this._mc.currentLabels[0].name;
         }
         return "";
      }
      
      private function calculateMode(param1:String) : String
      {
         switch(param1)
         {
            case "待机":
               return MODE_REPLAY;
            case "属性攻击":
            case "物理攻击":
            case "必杀":
            case "合体攻击":
            case "特殊攻击":
            case "闪避":
            case "被打":
            case "被暴击":
            case "个性出场":
            case "变身效果":
               return MODE_STOP_IDLE;
            case "濒死":
            case "失败":
            case "胜利":
               return MODE_STOP_LAST_FRAME;
            default:
               return MODE_BLANK;
         }
      }
      
      public function gotoLabel(param1:String) : void
      {
         var serial:int;
         var fallbackIdleStatus:Boolean;
         var actionTimeline:MovieClip;
         var fallbackTimeline:MovieClip;
         ++this._customSkillActionSerial;
         this.stopCustomSkillOverlay();
         if(this._mc == null)
         {
            return;
         }
         if(!this._externalCompactTimeline)
         {
            this.removeActionPlayEventListener();
            this._requestedLabel = this.adjustCurrentLabel(param1);
            this._currentLabel = this._requestedLabel;
            this._mode = this.calculateMode(this._currentLabel);
            if(this._mode != MODE_BLANK)
            {
               this._mc.addEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
            }
            this._mc.gotoAndStop(this._currentLabel);
            return;
         }
         this.removeActionPlayEventListener();
         this.hideExternalIdleInstance();
         ++this._actionSerial;
         serial = this._actionSerial;
         this._preparedSerial = -1;
         this._hitDispatched = false;
         this._externalUltimateCompletionSerial = -1;
         this._externalUltimateMainComplete = false;
         this._externalUltimateSkillPending = false;
         this._externalUltimateSkillComplete = false;
         this._externalUltimateCompletion = null;
         this._entryReroutedToIdle = false;
         this._requestedLabel = this.adjustCurrentLabel(param1);
         if(this._requestedLabel == "个性出场")
         {
            if(this._appearPlayed || !this.hasAppearAction())
            {
               this.gotoLabel("待机");
               return;
            }
            this._appearPlayed = true;
         }
         if(this._externalIdleOnlyPose)
         {
            this._currentLabel = "";
            this._mode = this.calculateMode(this._requestedLabel);
            this.activateExternalIdleOnlyPose(serial);
            return;
         }
         fallbackIdleStatus = this.shouldFallbackExternalStatusToIdle(this._requestedLabel);
         this._currentLabel = fallbackIdleStatus ? this.resolveExternalLabel("待机") : this.resolveExternalLabel(this._requestedLabel);
         this._mode = fallbackIdleStatus ? MODE_EXTERNAL_IDLE : this.calculateMode(this._requestedLabel);
         if(!fallbackIdleStatus && this._externalCompactTimeline && this._requestedLabel == "待机")
         {
            this._mode = MODE_EXTERNAL_IDLE;
         }
         else if(!fallbackIdleStatus && this._externalCompactTimeline && this._requestedLabel == "个性出场" && this.findAppearLabel(this.getEffectiveTimeline(this._mc)) == "")
         {
            this._mode = MODE_EXTERNAL_STATIC_ENTRY;
         }
         else if(!fallbackIdleStatus && this._externalCompactTimeline && this._requestedLabel == "胜利" && this.findLabel(["win","victory"]) == "")
         {
            this._mode = MODE_EXTERNAL_STATIC_WIN;
         }
         if(!this.hasExternalIdleLabel() && (this._mode == MODE_EXTERNAL_IDLE || this._mode == MODE_EXTERNAL_STATIC_ENTRY || this._mode == MODE_EXTERNAL_STATIC_WIN) && this.showExternalIdleInstance())
         {
            if(fallbackIdleStatus || this._mode == MODE_EXTERNAL_STATIC_ENTRY || this._mode == MODE_EXTERNAL_STATIC_WIN)
            {
               setTimeout(function():void
               {
                  if(serial == _actionSerial)
                  {
                     dispathchActionEndEvent(EVT_END);
                  }
               },0);
            }
            return;
         }
         if(this._mode == MODE_BLANK)
         {
            setTimeout(function():void
            {
               if(serial == _actionSerial)
               {
                  dispathchActionEndEvent(EVT_END);
               }
            },0);
            return;
         }
         this._mc.addEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
         try
         {
            actionTimeline = this.getEffectiveTimeline(this._mc);
            if(actionTimeline != null)
            {
               actionTimeline.visible = true;
               if(this._currentLabel == "")
               {
                  actionTimeline.gotoAndStop(1);
               }
               else
               {
                  actionTimeline.gotoAndStop(this._currentLabel);
               }
            }
            if(this._mc !== actionTimeline && this._mc != null)
            {
               this._mc.visible = true;
               try
               {
                  this._mc.gotoAndStop(1);
               }
               catch(frameError:*)
               {
               }
            }
         }
         catch(labelError:*)
         {
            try
            {
               fallbackTimeline = this.getEffectiveTimeline(this._mc);
               if(fallbackTimeline != null)
               {
                  fallbackTimeline.gotoAndStop(1);
               }
               if(this._mc !== fallbackTimeline && this._mc != null)
               {
                  this._mc.gotoAndStop(1);
               }
            }
            catch(frameError2:*)
            {
            }
         }
         setTimeout(function():void
         {
            prepareCurrentAction(serial,0);
         },0);
         if(fallbackIdleStatus)
         {
            setTimeout(function():void
            {
               if(serial == _actionSerial)
               {
                  dispathchActionEndEvent(EVT_END);
               }
            },0);
         }
      }
      
      private function getActionChild() : MovieClip
      {
         var timeline:MovieClip = this.getEffectiveTimeline(this._mc);
         return this.getActionChildFrom(timeline);
      }
      
      private function getDirectMovieChild(param1:MovieClip) : MovieClip
      {
         var child:MovieClip = null;
         var index:int = 0;
         if(param1 == null)
         {
            return null;
         }
         try
         {
            while(index < param1.numChildren)
            {
               child = param1.getChildAt(index) as MovieClip;
               if(child != null)
               {
                  return child;
               }
               index++;
            }
         }
         catch(ignored:*)
         {
         }
         return null;
      }
      
      private function getPrimaryActionVisual(param1:MovieClip) : MovieClip
      {
         var visual:MovieClip = this.getDirectMovieChild(param1);
         var nested:MovieClip = null;
         var depth:int = 0;
         while(visual != null && visual.totalFrames <= 1 && depth < 4)
         {
            nested = this.getDirectMovieChild(visual);
            if(nested == null)
            {
               break;
            }
            visual = nested;
            depth++;
         }
         return visual != null && visual.totalFrames > 1 ? visual : null;
      }
      
      private function primeExternalNormalization() : void
      {
         var referenceLabel:String = null;
         var action:MovieClip = null;
         if(!this._externalCompactTimeline || this._mc == null || this._externalNormalizationReady)
         {
            return;
         }
         if(this._externalIdleOnlyPose)
         {
            try
            {
               this._mc.gotoAndStop(1);
            }
            catch(idleRootError:*)
            {
            }
            action = this.getActionChild();
            if(action != null)
            {
               this.resumeExternalIdleOnlyPose(action,0);
               this.captureExternalNormalization(action,this._mc);
            }
            return;
         }
         referenceLabel = this.findLabel(["idle","stand","wait","attack","atk","attack1"]);
         try
         {
            if(referenceLabel == "")
            {
               this._mc.gotoAndStop(1);
            }
            else
            {
               this._mc.gotoAndStop(referenceLabel);
            }
         }
         catch(ignored:*)
         {
         }
         action = this.getActionChild();
         if(action != null)
         {
            this.forceExternalCalibrationPose(action);
            if(!this.hasExternalIdleLabel())
            {
               this.selectExternalFallbackPose(action);
            }
            this.captureExternalNormalization(action);
         }
      }
      
      private function activateExternalIdleOnlyPose(param1:int) : void
      {
         var serial:int = param1;
         var action:MovieClip = null;
         if(serial != this._actionSerial || this._mc == null)
         {
            return;
         }
         this._mc.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
         try
         {
            this._mc.gotoAndStop(1);
         }
         catch(ignored:*)
         {
         }
         this._mc.visible = true;
         action = this.getActionChild();
         this._actionAnimation = action;
         if(action != null)
         {
            this.resumeExternalIdleOnlyPose(action,0);
            if(!this._externalNormalizationReady)
            {
               this.captureExternalNormalization(action,this._mc);
            }
         }
         this.alignExternalCompactTimeline();
         this._preparedSerial = serial;
         setTimeout(function():void
         {
            if(serial != _actionSerial)
            {
               return;
            }
            if(isAttackAction())
            {
               dispatchHitOnce(serial);
            }
            dispathchActionEndEvent(EVT_END);
         },0);
      }
      
      private function resumeExternalIdleOnlyPose(param1:DisplayObject, param2:int = 0) : void
      {
         var container:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var child:DisplayObject = null;
         var clip:MovieClip = null;
         var index:int = 0;
         if(param1 == null || param2 > 8)
         {
            return;
         }
         clip = param1 as MovieClip;
         if(clip != null && clip.totalFrames > 1)
         {
            try
            {
               clip.play();
            }
            catch(ignored:*)
            {
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
               this.resumeExternalIdleOnlyPose(child,param2 + 1);
            }
            catch(ignored:*)
            {
            }
            index++;
         }
      }
      
      private function selectExternalFallbackPose(param1:MovieClip) : MovieClip
      {
         var frame:int = 1;
         var maxFrame:int = 1;
         var staticFrame:int = 1;
         var visual:MovieClip = null;
         var bounds:Rectangle = null;
         if(param1 == null)
         {
            return null;
         }
         maxFrame = Math.min(12,Math.max(1,param1.totalFrames));
         while(frame <= maxFrame)
         {
            this.setActionFrame(param1,frame);
            visual = this.getPrimaryActionVisual(param1);
            try
            {
               bounds = param1.getBounds(this._mc);
            }
            catch(ignored:*)
            {
               bounds = null;
            }
            if(bounds != null && bounds.width >= 4 && bounds.height >= 4)
            {
               staticFrame = frame;
               if(visual != null && visual.width >= 4 && visual.height >= 4)
               {
                  return visual;
               }
            }
            frame++;
         }
         this.setActionFrame(param1,staticFrame);
         return this.getPrimaryActionVisual(param1);
      }
      
      private function forceExternalCalibrationPose(param1:MovieClip) : void
      {
         var current:MovieClip = param1;
         var nested:MovieClip = null;
         var depth:int = 0;
         while(current != null && depth < 6)
         {
            try
            {
               current.gotoAndStop(1);
            }
            catch(ignored:*)
            {
               try
               {
                  current.stop();
               }
               catch(stopError:*)
               {
               }
            }
            nested = this.getDirectMovieChild(current);
            if(nested == null || nested == current)
            {
               break;
            }
            current = nested;
            depth++;
         }
      }
      
      private function isValidExternalBounds(param1:Rectangle) : Boolean
      {
         var centerX:Number = Number(NaN);
         var bottom:Number = Number(NaN);
         var aspect:Number = Number(NaN);
         var maxWidth:Number = 1600;
         var maxHeight:Number = 1200;
         try
         {
            maxWidth = Math.max(maxWidth,this._mc.loaderInfo.width * 4);
            maxHeight = Math.max(maxHeight,this._mc.loaderInfo.height * 4);
         }
         catch(ignored:*)
         {
         }
         if(param1 == null || param1.width < 4 || param1.height < 4 || param1.width > maxWidth || param1.height > maxHeight)
         {
            return false;
         }
         centerX = param1.x + param1.width * 0.5;
         bottom = param1.y + param1.height;
         aspect = param1.width / param1.height;
         if(isNaN(centerX) || isNaN(bottom) || isNaN(aspect) || centerX <= Number.NEGATIVE_INFINITY || centerX >= Number.POSITIVE_INFINITY || bottom <= Number.NEGATIVE_INFINITY || bottom >= Number.POSITIVE_INFINITY)
         {
            return false;
         }
         return aspect >= 0.02 && aspect <= 50 && Math.abs(param1.x) < 10000 && Math.abs(param1.y) < 10000 && Math.abs(centerX) < 10000 && Math.abs(bottom) < 10000;
      }
      
      private function captureExternalNormalization(param1:MovieClip, param2:MovieClip = null) : Boolean
      {
         var bounds:Rectangle = null;
         var subject:Object = null;
         var coordinateRoot:MovieClip = param2 == null ? this._mc : param2;
         var targetBaselineY:Number = EXTERNAL_TARGET_BASELINE_Y;
         var effectiveBaselineY:Number = EXTERNAL_TEMPLATE_BASELINE_Y;
         if(this._externalNormalizationReady)
         {
            return true;
         }
         ++this._externalNormalizationAttempts;
         try
         {
            bounds = param1.getBounds(coordinateRoot);
         }
         catch(ignored:*)
         {
            bounds = null;
         }
         if(this.isValidExternalBounds(bounds))
         {
            targetBaselineY = EXTERNAL_TARGET_BASELINE_Y;
            if(UClientUniversalBattleAdapter.supports(this._mc))
            {
               targetBaselineY = EXTERNAL_UClient_TARGET_BASELINE_Y;
               subject = this.measureRenderedSubject(param1,bounds,coordinateRoot);
               if(subject != null && !isNaN(Number(subject.bottom)) && Number(subject.bottom) >= 40 && Number(subject.bottom) <= 500)
               {
                  effectiveBaselineY = Number(subject.bottom);
               }
            }
            this._externalFitScale = Math.min(1,EXTERNAL_MAX_RENDER_WIDTH / bounds.width,EXTERNAL_MAX_RENDER_HEIGHT / bounds.height) * UClientUniversalBattleAdapter.fitMultiplier(this._mc,bounds);
            this._externalNormalizationX = (EXTERNAL_TARGET_CENTER_X - EXTERNAL_TEMPLATE_CENTER_X * this._externalFitScale) / this._externalFitScale;
            this._externalNormalizationY = (targetBaselineY - effectiveBaselineY * this._externalFitScale) / this._externalFitScale;
            this._externalNormalizationReady = true;
            return true;
         }
         if(this._externalNormalizationAttempts >= EXTERNAL_NORMALIZATION_MAX_ATTEMPTS)
         {
            targetBaselineY = EXTERNAL_TARGET_BASELINE_Y;
            if(UClientUniversalBattleAdapter.supports(this._mc))
            {
               targetBaselineY = EXTERNAL_UClient_TARGET_BASELINE_Y;
               if(subject == null && bounds != null)
               {
                  subject = this.measureRenderedSubject(param1,bounds,coordinateRoot);
               }
               if(subject != null && !isNaN(Number(subject.bottom)) && Number(subject.bottom) >= 40 && Number(subject.bottom) <= 500)
               {
                  effectiveBaselineY = Number(subject.bottom);
               }
            }
            this._externalNormalizationX = (EXTERNAL_TARGET_CENTER_X - EXTERNAL_TEMPLATE_CENTER_X * this._externalFitScale) / this._externalFitScale;
            this._externalNormalizationY = (targetBaselineY - effectiveBaselineY * this._externalFitScale) / this._externalFitScale;
            this._externalNormalizationReady = true;
            return true;
         }
         return false;
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
      
      private function measureStructuralSubject(param1:MovieClip, param2:Rectangle, param3:MovieClip = null) : Object
      {
         var best:Object = {"count":0};
         var root:MovieClip = param3 == null ? this._mc : param3;
         var inspect:Function = null;
         if(root == null)
         {
            return null;
         }
         inspect = function(param3:DisplayObjectContainer, param4:int):void
         {
            var centers:Array = [];
            var bottoms:Array = [];
            var child:DisplayObject = null;
            var childContainer:DisplayObjectContainer = null;
            var childBounds:Rectangle = null;
            var area:Number = 0;
            var index:int = 0;
            if(param3 == null || param4 > 2)
            {
               return;
            }
            while(index < param3.numChildren)
            {
               try
               {
                  child = param3.getChildAt(index);
                  if(child != null && child.visible && child.alpha > 0.08)
                  {
                     childBounds = child.getBounds(root);
                     area = childBounds.width * childBounds.height;
                     if(childBounds.width > 2 && childBounds.height > 2 && childBounds.width < param2.width * 0.55 && childBounds.height < param2.height * 0.75 && area < param2.width * param2.height * 0.18)
                     {
                        centers.push(childBounds.x + childBounds.width * 0.5);
                        bottoms.push(childBounds.bottom);
                     }
                     childContainer = child as DisplayObjectContainer;
                     if(childContainer != null)
                     {
                        inspect(childContainer,param4 + 1);
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
         inspect(param1,0);
         return int(best.count) >= 6 ? best : null;
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
         var structural:Object = this.measureStructuralSubject(param1,param2,param3);
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
            matrix = param3 === param1 ? new Matrix() : param1.transform.matrix.clone();
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
      
      private function alignExternalCompactTimeline() : void
      {
         if(!this._externalCompactTimeline || this._mc == null || !this._externalNormalizationReady)
         {
            return;
         }
         this._mc.scaleX = this._externalBaseScaleX * this._externalFitScale;
         this._mc.scaleY = this._externalBaseScaleY * this._externalFitScale;
         this._mc.x = this._externalBaseX + this._externalNormalizationX * this._mc.scaleX;
         this._mc.y = this._externalBaseY + this._externalNormalizationY * this._mc.scaleY;
         if(this._externalIdleRoot != null)
         {
            this._externalIdleRoot.scaleX = this._mc.scaleX;
            this._externalIdleRoot.scaleY = this._mc.scaleY;
            this._externalIdleRoot.x = this._mc.x;
            this._externalIdleRoot.y = this._mc.y;
         }
      }
      
      private function isHostIdlePose() : Boolean
      {
         var label:String = "";
         if(this._hostViewportEntryEndPending)
         {
            return true;
         }
         if(this._externalIdleRoot != null && this._externalIdleRoot.visible)
         {
            return true;
         }
         if(this._requestedLabel == "待机")
         {
            return true;
         }
         try
         {
            label = this._mc == null || this._mc.currentLabel == null ? "" : this._mc.currentLabel.toLowerCase();
         }
         catch(ignored:*)
         {
            label = "";
         }
         return label == "待机" || label == "idle" || label == "stand" || label == "standby" || label == "wait";
      }
      
      private function measureHostVerticalSubject(param1:MovieClip, param2:Rectangle) : Object
      {
         var result:Object;
         var scale:Number = Math.min(1,OLD_UI_IDLE_SAMPLE_LIMIT / Math.max(1,param2.width),OLD_UI_IDLE_SAMPLE_LIMIT / Math.max(1,param2.height));
         var width:int = Math.max(4,Math.ceil(param2.width * scale));
         var height:int = Math.max(4,Math.ceil(param2.height * scale));
         var bitmap:BitmapData = null;
         var matrix:Matrix = null;
         var pixels:Vector.<uint> = null;
         var yWeights:Array = [];
         var total:Number = 0;
         var alpha:int = 0;
         var weight:Number = 0;
         var index:int = 0;
         var yIndex:int = 0;
         try
         {
            if(width > 512 || height > 512)
            {
               return null;
            }
            bitmap = new BitmapData(width,height,true,0);
            matrix = param1.transform.matrix.clone();
            matrix.a *= scale;
            matrix.b *= scale;
            matrix.c *= scale;
            matrix.d *= scale;
            matrix.tx = (matrix.tx - param2.x) * scale;
            matrix.ty = (matrix.ty - param2.y) * scale;
            bitmap.draw(param1,matrix,null,null,null,true);
            pixels = bitmap.getVector(bitmap.rect);
            while(yIndex < height)
            {
               yWeights[yIndex++] = 0;
            }
            while(index < pixels.length)
            {
               alpha = pixels[index] >>> 24 & 0xFF;
               if(alpha >= 24)
               {
                  weight = alpha * alpha;
                  yIndex = int(index / width);
                  yWeights[yIndex] = Number(yWeights[yIndex]) + weight;
                  total += weight;
               }
               index++;
            }
            if(total <= 0)
            {
               bitmap.dispose();
               return null;
            }
            result = {
               "medianY":param2.y + (this.weightedAxisQuantile(yWeights,total,0.5) + 0.5) / scale,
               "bottomY":param2.y + (this.weightedAxisQuantile(yWeights,total,0.985) + 0.5) / scale
            };
            bitmap.dispose();
            return result;
         }
         catch(error:*)
         {
            if(bitmap != null)
            {
               bitmap.dispose();
            }
            return null;
         }
      }
      
      private function probeHostViewport(param1:Event) : void
      {
         var target:MovieClip = null;
         var action:MovieClip = null;
         var bounds:Rectangle = null;
         var subject:Object = null;
         var medianY:Number = Number(NaN);
         var bottomY:Number = Number(NaN);
         var topY:Number = Number(NaN);
         var shiftY:Number = 0;
         if(!this._externalCompactTimeline || this._hostViewportNormalized || this._mc == null || UClientUniversalBattleAdapter.supports(this._mc))
         {
            this._hostViewportNormalized = true;
            this.removeEventListener(Event.ENTER_FRAME,this.probeHostViewport);
            return;
         }
         if(!this.isHostIdlePose())
         {
            this._hostViewportProbeCount = 0;
            this._hostViewportMedianSum = 0;
            this._hostViewportBottomSum = 0;
            this._hostViewportTopSum = 0;
            return;
         }
         if(this._externalCompactTimeline && !this._externalEntryNormalizationReady && !this.hasExternalIdleLabel())
         {
            action = this.getActionChild();
            if(action != null)
            {
               this._externalNormalizationReady = false;
               if(this.captureExternalNormalization(action))
               {
                  this.alignExternalCompactTimeline();
                  this._externalEntryNormalizationReady = true;
               }
            }
         }
         target = this._externalIdleRoot != null && this._externalIdleRoot.visible ? this._externalIdleRoot : this._mc;
         try
         {
            bounds = target.getBounds(this);
            subject = this.measureHostVerticalSubject(target,bounds);
         }
         catch(error:*)
         {
            bounds = null;
            subject = null;
         }
         if(bounds == null || bounds.width < 4 || bounds.height < 4 || subject == null)
         {
            this._hostViewportProbeCount = 0;
            this._hostViewportMedianSum = 0;
            this._hostViewportBottomSum = 0;
            this._hostViewportTopSum = 0;
            return;
         }
         medianY = Number(subject.medianY);
         bottomY = bounds.bottom;
         topY = bounds.top;
         if(isNaN(medianY) || isNaN(bottomY) || isNaN(topY))
         {
            this._hostViewportProbeCount = 0;
            this._hostViewportMedianSum = 0;
            this._hostViewportBottomSum = 0;
            this._hostViewportTopSum = 0;
            return;
         }
         ++this._hostViewportProbeCount;
         this._hostViewportMedianSum += medianY;
         this._hostViewportBottomSum += bottomY;
         this._hostViewportTopSum += topY;
         if(this._hostViewportProbeCount < OLD_UI_IDLE_SAMPLE_FRAMES)
         {
            return;
         }
         medianY = this._hostViewportMedianSum / this._hostViewportProbeCount;
         bottomY = this._hostViewportBottomSum / this._hostViewportProbeCount;
         topY = this._hostViewportTopSum / this._hostViewportProbeCount;
         if(medianY < OLD_UI_IDLE_EXTREME_MASS_TRIGGER_Y || medianY < OLD_UI_IDLE_COMPACT_MASS_TRIGGER_Y && topY < 0 && bottomY < OLD_UI_IDLE_BOTTOM_TRIGGER_Y || medianY < OLD_UI_IDLE_TALL_MASS_TRIGGER_Y && topY < -100 && bottomY < 620 || bounds.height >= OLD_UI_IDLE_TALL_HEIGHT_TRIGGER && topY < -100 && bottomY < 620)
         {
            shiftY = OLD_UI_IDLE_MAX_SHIFT_Y;
         }
         if(shiftY > 0)
         {
            this.y += Math.min(OLD_UI_IDLE_MAX_SHIFT_Y,shiftY);
         }
         this._hostViewportNormalized = true;
         this.removeEventListener(Event.ENTER_FRAME,this.probeHostViewport);
         this.flushHostViewportEntryEnd();
      }
      
      private function isHostEntryAction() : Boolean
      {
         return this._requestedLabel == FighterActionType.PRESENT || this._requestedLabel == "变身效果";
      }
      
      private function armHostViewportEntryEnd() : Boolean
      {
         if(this._hostViewportNormalized)
         {
            return false;
         }
         this._hostViewportEntryEndPending = true;
         this.removeEventListener(Event.ENTER_FRAME,this.probeHostViewport);
         this.addEventListener(Event.ENTER_FRAME,this.probeHostViewport,false,0,true);
         if(this._hostViewportEntryEndTimer == 0)
         {
            this._hostViewportEntryEndTimer = setTimeout(function():void
            {
               _hostViewportEntryEndTimer = 0;
               flushHostViewportEntryEnd();
            },OLD_UI_ENTRY_VIEWPORT_TIMEOUT_MS);
         }
         return true;
      }
      
      private function flushHostViewportEntryEnd() : void
      {
         if(!this._hostViewportEntryEndPending)
         {
            return;
         }
         this._hostViewportEntryEndPending = false;
         if(this._hostViewportEntryEndTimer > 0)
         {
            clearTimeout(this._hostViewportEntryEndTimer);
            this._hostViewportEntryEndTimer = 0;
         }
         if(this.hasEventListener(EVT_END))
         {
            dispatchEvent(new Event(EVT_END));
         }
      }
      
      private function isAttackAction() : Boolean
      {
         return this._requestedLabel == "物理攻击" || this._requestedLabel == "属性攻击" || this._requestedLabel == "特殊攻击" || this._requestedLabel == "必杀" || this._requestedLabel == "合体攻击";
      }
      
      private function hasExternalHitMarker(param1:MovieClip) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         try
         {
            return "hit" in param1;
         }
         catch(ignored:*)
         {
         }
         return false;
      }
      
      private function resetExternalHitMarker() : void
      {
         if(this._actionAnimation == null)
         {
            return;
         }
         try
         {
            if("hit" in this._actionAnimation)
            {
               this._actionAnimation["hit"] = 0;
            }
         }
         catch(ignored:*)
         {
         }
      }
      
      private function captureExternalHit() : Boolean
      {
         if(this._actionAnimation == null)
         {
            return false;
         }
         try
         {
            if("hit" in this._actionAnimation && Number(this._actionAnimation["hit"]) > 0)
            {
               this._actionAnimation["hit"] = 0;
               return true;
            }
         }
         catch(ignored:*)
         {
         }
         return false;
      }
      
      private function dispatchHitOnce(param1:int) : void
      {
         if(param1 != this._actionSerial || this._hitDispatched)
         {
            return;
         }
         this._hitDispatched = true;
         if(this._hitTimeout > 0)
         {
            clearTimeout(this._hitTimeout);
            this._hitTimeout = 0;
         }
         if(this.isCustomUltimateAction(this._requestedLabel))
         {
            this._externalUltimateCompletionSerial = param1;
            this._externalUltimateSkillPending = true;
            this._externalUltimateSkillComplete = false;
            this.playCustomSkillOverlay(this._customSkillActionSerial,this._externalImpactComplete);
            this.scheduleExternalSkillCompletion(param1);
         }
         dispatchEvent(new Event(EVT_HIT));
      }
      
      private function scheduleNativeHit(param1:int) : void
      {
         var hitInfo:AnimiationHitInfo = null;
         var time:Number = Number(NaN);
         try
         {
            hitInfo = HitInfoConfig.getHitData(this._fighterResourceId);
            if(hitInfo != null)
            {
               time = hitInfo.getHitValue(this._requestedLabel) * 40;
            }
         }
         catch(ignored:*)
         {
            time = Number(NaN);
         }
         if(isNaN(time) || time < 0)
         {
            return;
         }
         this._hitTimeout = setTimeout(function():void
         {
            _hitTimeout = 0;
            dispatchHitOnce(param1);
         },time);
      }
      
      private function onFrameConstructed(param1:Event) : void
      {
         var onNativeActionPlay:Function = null;
         var dispatchNativeHit:Function = null;
         var hitInfo:AnimiationHitInfo = null;
         var time:Number = Number(NaN);
         var nativeComplete:Boolean = false;
         if(!this._externalCompactTimeline)
         {
            onNativeActionPlay = function():void
            {
               if(nativeComplete)
               {
                  return;
               }
               nativeComplete = true;
               clearNativeTerminalWatch();
               removeActionPlayEventListener();
               doActionEnd(0);
            };
            dispatchNativeHit = function():void
            {
               if(isCustomUltimateAction(_requestedLabel))
               {
                  playCustomSkillOverlay(_customSkillActionSerial);
               }
               dispatchEvent(new Event(EVT_HIT));
            };
            if(this._mc != null && this._mc.numChildren > 0)
            {
               this._mc.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
               this._actionAnimation = this.getActionChild();
               if(this.isAttackAction())
               {
                  hitInfo = HitInfoConfig.getHitData(this._fighterResourceId);
                  time = hitInfo.getHitValue(this._currentLabel) * 40;
                  setTimeout(dispatchNativeHit,time);
               }
               if(this._actionAnimation == null)
               {
                  setTimeout(onNativeActionPlay,0);
               }
               else
               {
                  this.playAnimation(onNativeActionPlay);
                  this.watchNativeTerminalStop(this._actionAnimation,onNativeActionPlay);
               }
            }
            return;
         }
         this.prepareCurrentAction(this._actionSerial,0);
      }
      
      private function prepareCurrentAction(param1:int, param2:int) : void
      {
         var complete:Function = null;
         var finalizeAction:Function = null;
         if(param1 != this._actionSerial || this._mc == null || this._preparedSerial == param1)
         {
            return;
         }
         this._actionAnimation = this.getActionChild();
         if(this._actionAnimation == null)
         {
            if(param2 < 8)
            {
               setTimeout(function():void
               {
                  prepareCurrentAction(param1,param2 + 1);
               },16);
            }
            else
            {
               this._mc.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
               this._preparedSerial = param1;
               setTimeout(function():void
               {
                  if(param1 == _actionSerial)
                  {
                     if(isAttackAction())
                     {
                        dispatchHitOnce(param1);
                     }
                     dispathchActionEndEvent(EVT_END);
                  }
               },0);
            }
            return;
         }
         if(this._requestedLabel == FighterActionType.PRESENT && !this._entryReroutedToIdle && !this.hasAppearAction() && this.hasExternalHitMarker(this._actionAnimation))
         {
            this._entryReroutedToIdle = true;
            this._currentLabel = this.resolveExternalLabel("待机");
            this._mode = MODE_EXTERNAL_STATIC_ENTRY;
            try
            {
               this._mc.gotoAndStop(this._currentLabel == "" ? 1 : this._currentLabel);
            }
            catch(entryRedirectError:*)
            {
            }
            setTimeout(function():void
            {
               prepareCurrentAction(param1,param2);
            },0);
            return;
         }
         if(this._requestedLabel == "濒死" && this.findLabel(["dying","lowhp","weak"]) == "" && this.isExternalHurtAction() && !this._externalPersistentStatusChecked && this._externalStatusProbeSerial == param1)
         {
            return;
         }
         if(this._requestedLabel == "濒死" && this.findLabel(["dying","lowhp","weak"]) == "" && this.isExternalHurtAction() && !this._externalPersistentStatusChecked)
         {
            this._externalStatusProbeSerial = param1;
            this._externalStatusProbeEndBlocker = function(param1:Event):void
            {
               param1.stopImmediatePropagation();
            };
            this._mc.addEventListener(EVT_END,this._externalStatusProbeEndBlocker,false,int.MAX_VALUE,true);
            this.setActionFrame(this._actionAnimation,this._actionAnimation.totalFrames);
            setTimeout(function():void
            {
               if(_externalStatusProbeEndBlocker != null)
               {
                  _mc.removeEventListener(EVT_END,_externalStatusProbeEndBlocker);
                  _externalStatusProbeEndBlocker = null;
               }
               if(param1 != _actionSerial)
               {
                  return;
               }
               _externalPersistentStatusChecked = true;
               _externalPersistentStatusAvailable = hasAnimatedDescendant(_actionAnimation,0);
               if(!_externalPersistentStatusAvailable)
               {
                  fallbackExternalStatusAtRuntime(param1);
               }
               else
               {
                  prepareCurrentAction(param1,param2);
               }
            },200);
            return;
         }
         if(this._externalCompactTimeline && !this._externalNormalizationReady)
         {
            this.forceExternalCalibrationPose(this._actionAnimation);
            if(!this.hasExternalIdleLabel())
            {
               this.selectExternalFallbackPose(this._actionAnimation);
            }
            if(!this.captureExternalNormalization(this._actionAnimation))
            {
               setTimeout(function():void
               {
                  prepareCurrentAction(param1,param2);
               },16);
               return;
            }
         }
         this._preparedSerial = param1;
         this._mc.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
         this.alignExternalCompactTimeline();
         if(this._mode == MODE_EXTERNAL_STATIC_WIN || this._mode == MODE_EXTERNAL_STATIC_ENTRY)
         {
            if((this._mode == MODE_EXTERNAL_STATIC_ENTRY || this._mode == MODE_EXTERNAL_STATIC_WIN) && this._externalCompactTimeline)
            {
               this.playExternalFallbackIdle(this._requestedLabel == "个性出场");
            }
            else
            {
               try
               {
                  this._actionAnimation.gotoAndStop(1);
               }
               catch(ignored:*)
               {
                  this._actionAnimation.stop();
               }
            }
            if(this._mode == MODE_EXTERNAL_STATIC_WIN || this._mode == MODE_EXTERNAL_STATIC_ENTRY)
            {
               setTimeout(function():void
               {
                  if(param1 == _actionSerial)
                  {
                     dispathchActionEndEvent(EVT_END);
                  }
               },0);
            }
            return;
         }
         if(this.isAttackAction())
         {
            if(this._externalCompactTimeline)
            {
               this.resetExternalHitMarker();
            }
            else
            {
               this.scheduleNativeHit(param1);
            }
         }
         finalizeAction = function():void
         {
            if(param1 != _actionSerial)
            {
               return;
            }
            removeActionPlayEventListener();
            doActionEnd(param1);
         };
         complete = function():void
         {
            if(param1 != _actionSerial)
            {
               return;
            }
            if(isAttackAction())
            {
               dispatchHitOnce(param1);
            }
            if(isCustomUltimateAction(_requestedLabel) && _externalUltimateSkillPending)
            {
               _externalUltimateMainComplete = true;
               _externalUltimateCompletion = finalizeAction;
               tryCompleteExternalUltimate();
               return;
            }
            finalizeAction();
         };
         this.playAnimation(complete,param1);
      }
      
      private function fallbackExternalStatusAtRuntime(param1:int) : void
      {
         if(this.isHostFighterDead() || this._requestedLabel == "失败")
         {
            if(this._actionAnimation != null)
            {
               this._actionAnimation.stop();
            }
            this.dispathchActionEndEvent(EVT_END);
            return;
         }
         if(this._externalStatusFallbackSerial == param1)
         {
            return;
         }
         this._externalStatusFallbackSerial = param1;
         this._preparedSerial = param1;
         this._mc.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
         this._currentLabel = this.resolveExternalLabel("待机");
         this._mode = MODE_EXTERNAL_IDLE;
         try
         {
            this._mc.gotoAndStop(this._currentLabel == "" ? 1 : this._currentLabel);
         }
         catch(ignored:*)
         {
         }
         setTimeout(function():void
         {
            if(param1 != _actionSerial)
            {
               return;
            }
            _actionAnimation = getActionChild();
            if(_actionAnimation != null)
            {
               playExternalFallbackIdle();
            }
            dispathchActionEndEvent(EVT_END);
         },0);
      }
      
      private function setActionFrame(param1:MovieClip, param2:int) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         try
         {
            param1.gotoAndStop(param2);
            return true;
         }
         catch(ignored:*)
         {
            try
            {
               param1.stop();
            }
            catch(stopError:*)
            {
            }
         }
         return false;
      }
      
      private function selectManagedIdleAction(param1:MovieClip) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         try
         {
            if("select" in param1 && param1["select"] is Function)
            {
               param1["select"]("standby");
               return true;
            }
         }
         catch(ignored:*)
         {
         }
         return false;
      }
      
      private function armExternalActionCover(param1:MovieClip) : void
      {
         var action:MovieClip = param1;
         this.clearExternalActionCover();
         if(!this._externalCompactTimeline || !this.isAttackAction() || action == null || this.isExternalActionVideoOrCinematic(action))
         {
            return;
         }
         this._externalCoverAction = action;
         this._externalCoverExitHandler = function(param1:Event):void
         {
            if(_externalCoverAction !== action || action.parent == null)
            {
               clearExternalActionCover();
               return;
            }
            restoreExternalActionCover();
            applyExternalActionCover(action);
         };
         action.addEventListener(Event.EXIT_FRAME,this._externalCoverExitHandler,false,int.MIN_VALUE,true);
         this.primeExternalActionCover(action);
         this.restoreExternalActionCover();
         this.applyExternalActionCover(action);
      }
      
      private function primeExternalActionCover(param1:MovieClip) : void
      {
         var action:MovieClip = param1;
         var actionClass:Class = null;
         var probe:MovieClip = null;
         var viewport:Rectangle = null;
         var seed:Shape = null;
         var seedBounds:Rectangle = null;
         var delta:Matrix = null;
         var frame:int = 1;
         var limit:int = 0;
         if(action == null || this._externalCoverAction !== action || this._externalCoverFrozenDelta != null || action.stage == null || this.isExternalActionVideoOrCinematic(action))
         {
            return;
         }
         try
         {
            viewport = this.getExternalCoverViewport(action);
            if(!this.isExternalCoverBoundsValid(viewport))
            {
               return;
            }
            if(UClientUniversalBattleAdapter.supports(this._mc))
            {
               if(this.isExternalAttackCoverLabel(this._currentLabel) && this._externalAttackCoverBounds != null)
               {
                  delta = this.buildExternalCoverDelta(this._externalAttackCoverBounds,viewport);
                  if(this.isExternalCoverMatrixValid(delta))
                  {
                     this._externalCoverSeed = null;
                     this._externalCoverFrozenDelta = delta.clone();
                  }
               }
               return;
            }
            actionClass = Object(action).constructor as Class;
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
            while(frame <= limit && this._externalCoverFrozenDelta == null)
            {
               probe.gotoAndStop(frame);
               seed = this.findExternalCoverSeed(probe,viewport);
               if(seed != null)
               {
                  seedBounds = seed.getBounds(probe);
                  delta = this.buildExternalCoverDelta(seedBounds,viewport);
                  if(this.isExternalCoverMatrixValid(delta))
                  {
                     this._externalCoverSeed = null;
                     this._externalCoverFrozenDelta = delta.clone();
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
         var label:String = (String(param1 || "")).toLowerCase();
         return label == "attack" || label == "atk" || label == "attack1";
      }
      
      private function prewarmExternalAttackCover() : void
      {
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
         if(this._mc == null || !UClientUniversalBattleAdapter.supports(this._mc) || this._externalAttackCoverBounds != null || this._externalAttackCoverPending != null)
         {
            return;
         }
         state = {};
         this._externalAttackCoverPending = state;
         setTimeout(function():void
         {
            var seed:Shape = null;
            var seedBounds:Rectangle = null;
            try
            {
               if(_externalAttackCoverPending !== state || _mc == null)
               {
                  return;
               }
               rootClass = Object(_mc).constructor as Class;
               probeRoot = rootClass == null ? null : new rootClass() as MovieClip;
               if(probeRoot == null)
               {
                  _externalAttackCoverPending = null;
                  return;
               }
               probeRoot.gotoAndStop("attack");
               probeAction = getActionChildFrom(probeRoot);
               if(probeAction == null)
               {
                  _externalAttackCoverPending = null;
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
                  if(_externalAttackCoverPending === state)
                  {
                     _externalAttackCoverPending = null;
                  }
                  probeAction = null;
                  probeRoot = null;
               };
               scan = function():void
               {
                  var chunkEnd:int = 0;
                  if(_externalAttackCoverPending !== state || _mc == null)
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
                        seed = findExternalCoverSeed(probeAction,viewport);
                        if(seed != null)
                        {
                           seedBounds = seed.getBounds(probeAction);
                           if(seedBounds != null)
                           {
                              _externalAttackCoverBounds = seedBounds.clone();
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
               if(_externalAttackCoverPending === state)
               {
                  _externalAttackCoverPending = null;
               }
            }
         },1);
      }
      
      private function isExternalActionVideoOrCinematic(param1:MovieClip) : Boolean
      {
         var i:int;
         var routeState:*;
         var child:DisplayObject = null;
         var token:String = "";
         var owner:MovieClip = this._mc;
         if(param1 == null)
         {
            return true;
         }
         try
         {
            for each(token in ["eventVideoActive","cinematicActive","videoActive","uClientCinematicActive","event_video_active"])
            {
               if(token in param1 && Boolean(param1[token]) || owner != null && token in owner && Boolean(owner[token]))
               {
                  return true;
               }
            }
            if("eventPaused" in param1 && Boolean(param1["eventPaused"]))
            {
               return true;
            }
            if("getEmbeddedCinematicState" in param1 && param1["getEmbeddedCinematicState"] is Function)
            {
               routeState = param1["getEmbeddedCinematicState"]();
               if(routeState != null && (routeState.active === true || routeState.attached === true))
               {
                  return true;
               }
            }
            if(owner != null && "getEmbeddedCinematicState" in owner && owner["getEmbeddedCinematicState"] is Function)
            {
               routeState = owner["getEmbeddedCinematicState"]();
               if(routeState != null && (routeState.active === true || routeState.attached === true))
               {
                  return true;
               }
            }
            if(owner != null)
            {
               token = (String(owner.currentLabel || owner.currentFrameLabel || "")).toLowerCase();
               if(/^moves?[_-]?\d+/.test(token))
               {
                  return true;
               }
            }
            token = getQualifiedClassName(param1).toLowerCase();
            if(token.indexOf("video") >= 0 || token.indexOf("cinematic") >= 0)
            {
               return true;
            }
            i = 0;
            while(i < param1.numChildren)
            {
               child = param1.getChildAt(i);
               token = (child.name + " " + getQualifiedClassName(child)).toLowerCase();
               if(token.indexOf("video") >= 0 || token.indexOf("cinematic") >= 0)
               {
                  return true;
               }
               i++;
            }
         }
         catch(ignored:*)
         {
            return true;
         }
         return false;
      }
      
      private function isExternalCoverBoundsValid(param1:Rectangle) : Boolean
      {
         var bounds:Rectangle = param1;
         return bounds != null && Boolean(isFinite(bounds.x)) && Boolean(isFinite(bounds.y)) && Boolean(isFinite(bounds.width)) && Boolean(isFinite(bounds.height)) && Math.abs(bounds.x) < 100000 && Math.abs(bounds.y) < 100000 && bounds.width > 1 && bounds.height > 1 && bounds.width < 100000 && bounds.height < 100000;
      }
      
      private function isExternalCoverMatrixValid(param1:Matrix) : Boolean
      {
         var matrix:Matrix = param1;
         return matrix != null && Boolean(isFinite(matrix.a)) && Boolean(isFinite(matrix.b)) && Boolean(isFinite(matrix.c)) && Boolean(isFinite(matrix.d)) && Boolean(isFinite(matrix.tx)) && Boolean(isFinite(matrix.ty)) && Math.abs(matrix.a) < 1000 && Math.abs(matrix.b) < 1000 && Math.abs(matrix.c) < 1000 && Math.abs(matrix.d) < 1000 && Math.abs(matrix.tx) < 100000 && Math.abs(matrix.ty) < 100000;
      }
      
      private function isExternalCoverMask(param1:Shape, param2:MovieClip) : Boolean
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
      
      private function hasExternalCoverRectOccupancy(param1:Shape, param2:Rectangle) : Boolean
      {
         var candidate:Shape = param1;
         var localBounds:Rectangle = null;
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
         if(candidate == null || param2 == null || param2.width <= 2 || param2.height <= 2)
         {
            return false;
         }
         localBounds = candidate.getBounds(candidate);
         if(!this.isExternalCoverBoundsValid(localBounds) || localBounds.width <= 2 || localBounds.height <= 2)
         {
            return false;
         }
         bitmap = new BitmapData(sampleWidth,sampleHeight,true,0);
         scaleX = (sampleWidth - 2) / localBounds.width;
         scaleY = (sampleHeight - 2) / localBounds.height;
         matrix = new Matrix(scaleX,0,0,scaleY,1 - localBounds.x * scaleX,1 - localBounds.y * scaleY);
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
      
      private function isExternalCoverSeedValid(param1:Shape, param2:MovieClip, param3:Rectangle) : Boolean
      {
         var candidate:Shape = param1;
         var action:MovieClip = param2;
         var viewport:Rectangle = param3;
         var bounds:Rectangle = null;
         var ratio:Number = 0;
         var area:Number = 0;
         if(candidate == null || action == null || viewport == null || candidate.parent !== action || !candidate.visible || candidate.alpha <= 0 || candidate.mask != null || this.isExternalCoverMask(candidate,action) || candidate.blendMode !== BlendMode.NORMAL || !this.isExternalCoverMatrixValid(candidate.transform.matrix))
         {
            return false;
         }
         try
         {
            bounds = candidate.getBounds(action);
            ratio = bounds.width / bounds.height;
            area = bounds.width * bounds.height;
            if(!this.isExternalCoverBoundsValid(bounds) || bounds.width <= 2 || bounds.height <= 2)
            {
               return false;
            }
            if(ratio < 0.75 || ratio > 4.5)
            {
               return false;
            }
            if(bounds.width < viewport.width * 0.55)
            {
               return false;
            }
            if(bounds.height < viewport.height * 0.45)
            {
               return false;
            }
            if(area < viewport.width * viewport.height * 0.25)
            {
               return false;
            }
            return this.hasExternalCoverRectOccupancy(candidate,bounds);
         }
         catch(seedValidationError:*)
         {
            return false;
         }
      }
      
      private function findExternalCoverSeed(param1:MovieClip, param2:Rectangle) : Shape
      {
         var action:MovieClip = param1;
         var viewport:Rectangle = param2;
         var best:Shape = null;
         var bestArea:Number = 0;
         var index:int = 0;
         var candidate:Shape = null;
         var bounds:Rectangle = null;
         var area:Number = 0;
         if(action == null || viewport == null)
         {
            return null;
         }
         while(index < action.numChildren)
         {
            candidate = action.getChildAt(index) as Shape;
            if(this.isExternalCoverSeedValid(candidate,action,viewport))
            {
               bounds = candidate.getBounds(action);
               area = bounds.width * bounds.height;
               if(area > bestArea)
               {
                  best = candidate;
                  bestArea = area;
               }
            }
            index++;
         }
         return best;
      }
      
      private function getExternalCoverViewport(param1:MovieClip) : Rectangle
      {
         var action:MovieClip = param1;
         var stageWidth:Number = CUSTOM_SKILL_STAGE_WIDTH;
         var stageHeight:Number = CUSTOM_SKILL_STAGE_HEIGHT;
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
      
      private function buildExternalCoverDelta(param1:Rectangle, param2:Rectangle) : Matrix
      {
         var source:Rectangle = param1;
         var target:Rectangle = param2;
         var scale:Number = 1;
         var sourceCenterX:Number = 0;
         var sourceCenterY:Number = 0;
         var targetCenterX:Number = 0;
         var targetCenterY:Number = 0;
         if(!this.isExternalCoverBoundsValid(source) || !this.isExternalCoverBoundsValid(target))
         {
            return null;
         }
         if(source.width >= target.width && source.height >= target.height)
         {
            scale = 1;
         }
         else
         {
            scale = Math.max(1,Math.max(target.width / source.width,target.height / source.height));
         }
         if(!isFinite(scale) || scale <= 0 || scale >= 1000)
         {
            return null;
         }
         sourceCenterX = source.x + source.width * 0.5;
         sourceCenterY = source.y + source.height * 0.5;
         targetCenterX = target.x + target.width * 0.5;
         targetCenterY = target.y + target.height * 0.5;
         return new Matrix(scale,0,0,scale,targetCenterX - sourceCenterX * scale,targetCenterY - sourceCenterY * scale);
      }
      
      private function restoreExternalActionCover() : void
      {
         var entry:Object = null;
         if(this._externalCoverOriginals == null)
         {
            return;
         }
         for each(entry in this._externalCoverOriginals)
         {
            if(entry != null && entry.target != null && entry.matrix != null && entry.target.parent === entry.parent)
            {
               try
               {
                  entry.target.transform.matrix = entry.matrix.clone();
               }
               catch(ignored:*)
               {
               }
            }
         }
         this._externalCoverOriginals = null;
      }
      
      private function applyExternalActionCover(param1:MovieClip) : void
      {
         var i:int = 0;
         var candidate:Shape = null;
         var viewport:Rectangle = null;
         var bounds:Rectangle = null;
         var delta:Matrix = null;
         var original:Matrix = null;
         var nextMatrix:Matrix = null;
         var originals:Array = [];
         this.restoreExternalActionCover();
         if(param1 == null || this._externalCoverAction !== param1 || !this._externalCompactTimeline || !this.isAttackAction() || this.isExternalActionVideoOrCinematic(param1) || param1.parent == null || param1.stage == null)
         {
            return;
         }
         try
         {
            viewport = this.getExternalCoverViewport(param1);
            if(!this.isExternalCoverBoundsValid(viewport))
            {
               return;
            }
            i = 0;
            while(i < param1.numChildren)
            {
               candidate = param1.getChildAt(i) as Shape;
               if(this.isExternalCoverSeedValid(candidate,param1,viewport))
               {
                  bounds = candidate.getBounds(param1);
                  original = candidate.transform.matrix.clone();
                  if(this.isExternalCoverBoundsValid(bounds) && this.isExternalCoverMatrixValid(original))
                  {
                     delta = this.buildExternalCoverDelta(bounds,viewport);
                     if(this.isExternalCoverMatrixValid(delta))
                     {
                        nextMatrix = original.clone();
                        nextMatrix.concat(delta);
                        if(this.isExternalCoverMatrixValid(nextMatrix))
                        {
                           originals.push({
                              "target":candidate,
                              "parent":param1,
                              "matrix":original
                           });
                           candidate.transform.matrix = nextMatrix;
                        }
                     }
                  }
               }
               i++;
            }
            this._externalCoverOriginals = originals;
         }
         catch(coverError:*)
         {
            this._externalCoverOriginals = originals;
            this.restoreExternalActionCover();
         }
      }
      
      private function clearExternalActionCover() : void
      {
         if(this._externalCoverAction != null && this._externalCoverExitHandler != null)
         {
            try
            {
               this._externalCoverAction.removeEventListener(Event.EXIT_FRAME,this._externalCoverExitHandler);
            }
            catch(listenerError:*)
            {
            }
         }
         this.restoreExternalActionCover();
         this._externalCoverAction = null;
         this._externalCoverExitHandler = null;
         this._externalCoverSeed = null;
         this._externalCoverFrozenDelta = null;
      }
      
      private function playExternalAnimation(param1:Function, param2:int) : void
      {
         var appLbl:String;
         var invisibleTicks:int;
         var action:MovieClip = this._actionAnimation;
         var watchdogId:uint = 0;
         var finish:Function = null;
         var hitEventHandler:Function = null;
         var actionExitHandler:Function = null;
         var primaryExitHandler:Function = null;
         var bindPrimaryVisual:Function = null;
         var terminalProbe:Function = null;
         var visibilityWatcher:Function = null;
         var startPlayback:Function = null;
         var primaryVisual:MovieClip = null;
         var actionPeak:int = 1;
         var actionLast:int = 1;
         var visualPeak:int = 0;
         var visualLast:int = 0;
         var finished:Boolean = false;
         var hitSeen:Boolean = false;
         var impactCompleteHandler:Function = null;
         var terminalLastFrame:int = -1;
         var terminalStableTicks:int = 0;
         var targetFrame:int = 0;
         var targetEndFrame:int = 0;
         var isAppearAction:Boolean = this._requestedLabel == "个性出场" || this._currentLabel == "appear" || this._currentLabel == "present";
         if(action != null)
         {
            if(isAppearAction)
            {
               appLbl = this.findAppearLabel(action);
               if(appLbl != "")
               {
                  targetFrame = this.frameForLabel(action,appLbl);
                  targetEndFrame = this.endFrameForLabel(action,appLbl);
               }
            }
            if(targetFrame <= 0)
            {
               targetFrame = this.frameForLabel(action,this._currentLabel);
            }
            if(targetEndFrame <= 0)
            {
               targetEndFrame = this.endFrameForLabel(action,this._currentLabel);
            }
            if(targetEndFrame <= 0)
            {
               targetEndFrame = action.totalFrames;
            }
         }
         finish = function(param3:Boolean = false):void
         {
            if(finished)
            {
               return;
            }
            finished = true;
            clearExternalActionCover();
            if(visibilityWatcher != null)
            {
               removeEventListener(Event.ENTER_FRAME,visibilityWatcher);
               visibilityWatcher = null;
            }
            if(watchdogId > 0)
            {
               clearTimeout(watchdogId);
            }
            if(_externalTimer == watchdogId)
            {
               _externalTimer = 0;
            }
            if(action != null && actionExitHandler != null)
            {
               action.removeEventListener(Event.EXIT_FRAME,actionExitHandler);
            }
            if(_externalActionClip === action)
            {
               _externalActionClip = null;
               _externalActionExitHandler = null;
            }
            if(_mc != null && hitEventHandler != null)
            {
               _mc.removeEventListener("hit",hitEventHandler);
            }
            if(_externalHitHandler === hitEventHandler)
            {
               _externalHitHandler = null;
            }
            if(primaryVisual != null && primaryExitHandler != null)
            {
               primaryVisual.removeEventListener(Event.EXIT_FRAME,primaryExitHandler);
            }
            if(_externalPrimaryVisual === primaryVisual)
            {
               _externalPrimaryVisual = null;
               _externalVisualExitHandler = null;
            }
            if(_externalImpactComplete === impactCompleteHandler)
            {
               _externalImpactComplete = null;
            }
            if(!param3)
            {
               try
               {
                  if(action != null)
                  {
                     action.stop();
                  }
                  if(primaryVisual != null)
                  {
                     primaryVisual.stop();
                  }
               }
               catch(stopError:*)
               {
               }
            }
            if(param2 == _actionSerial && param1 != null)
            {
               param1();
            }
         };
         bindPrimaryVisual = function():void
         {
            var visual:MovieClip = null;
            if(finished || primaryVisual != null || action == null || action.currentFrame < 1 || isExternalHurtAction())
            {
               return;
            }
            visual = getPrimaryActionVisual(action);
            if(isAppearAction)
            {
               if(visual == null || visual.totalFrames <= 1)
               {
                  return;
               }
            }
            else if(visual == null || visual.totalFrames < Math.max(2,action.totalFrames * 0.7) || visual.totalFrames > Math.max(600,action.totalFrames * 4))
            {
               return;
            }
            primaryVisual = visual;
            visualPeak = visual.currentFrame;
            visualLast = visual.currentFrame;
            primaryExitHandler = function(param1:Event):void
            {
               var current:int = 0;
               var total:int = 0;
               if(finished || param2 != _actionSerial || primaryVisual !== visual)
               {
                  visual.removeEventListener(Event.EXIT_FRAME,primaryExitHandler);
                  return;
               }
               current = visual.currentFrame;
               total = visual.totalFrames;
               if(current > visualPeak)
               {
                  visualPeak = current;
               }
               if(current >= total || visualPeak >= Math.max(2,total - 3) && current < visualLast)
               {
                  finish();
                  return;
               }
               visualLast = current;
            };
            _externalPrimaryVisual = visual;
            _externalVisualExitHandler = primaryExitHandler;
            visual.addEventListener(Event.EXIT_FRAME,primaryExitHandler,false,0,true);
         };
         impactCompleteHandler = function():void
         {
         };
         this._externalImpactComplete = impactCompleteHandler;
         if(this.isAttackAction() && this._mc != null)
         {
            hitEventHandler = function(param1:Event):void
            {
               if(param2 != _actionSerial)
               {
                  return;
               }
               param1.stopImmediatePropagation();
               hitSeen = true;
               dispatchHitOnce(param2);
            };
            this._externalHitHandler = hitEventHandler;
            this._mc.addEventListener("hit",hitEventHandler);
         }
         actionExitHandler = function(param1:Event):void
         {
            var effectiveEnd:int;
            var current:int = 0;
            if(finished || param2 != _actionSerial || action == null)
            {
               finish();
               return;
            }
            current = action.currentFrame;
            if(current > actionPeak)
            {
               actionPeak = current;
            }
            if(isAttackAction() && captureExternalHit())
            {
               hitSeen = true;
               dispatchHitOnce(param2);
            }
            effectiveEnd = targetEndFrame > 0 ? targetEndFrame : action.totalFrames;
            if(current >= effectiveEnd || actionPeak >= Math.max(2,effectiveEnd - 2) && current < actionLast)
            {
               try
               {
                  action.stop();
               }
               catch(actionStopError:*)
               {
               }
               finish();
               return;
            }
            actionLast = current;
         };
         terminalProbe = function():void
         {
            var targetEnd:int;
            var isActionAtEnd:Boolean;
            var isVisualAtEnd:Boolean;
            var current:int = 0;
            var visualCurrent:int = 0;
            if(finished || param2 != _actionSerial || action == null)
            {
               return;
            }
            try
            {
               current = action.currentFrame;
            }
            catch(frameError:*)
            {
               return;
            }
            targetEnd = targetEndFrame > 0 ? targetEndFrame : action.totalFrames;
            isActionAtEnd = current >= Math.max(1,targetEnd - 1);
            isVisualAtEnd = true;
            if(primaryVisual != null)
            {
               try
               {
                  visualCurrent = primaryVisual.currentFrame;
                  isVisualAtEnd = visualCurrent >= Math.max(1,primaryVisual.totalFrames - 1);
               }
               catch(vErr:*)
               {
               }
            }
            if(isActionAtEnd && isVisualAtEnd && current == terminalLastFrame)
            {
               ++terminalStableTicks;
            }
            else
            {
               terminalStableTicks = 0;
            }
            terminalLastFrame = current;
            if(terminalStableTicks >= 3)
            {
               finish();
               return;
            }
            setTimeout(terminalProbe,80);
         };
         startPlayback = function():void
         {
            if(finished || param2 != _actionSerial || action == null)
            {
               return;
            }
            action.addEventListener(Event.EXIT_FRAME,actionExitHandler,false,0,true);
            _externalActionClip = action;
            _externalActionExitHandler = actionExitHandler;
            try
            {
               action.gotoAndPlay(targetFrame > 0 ? targetFrame : 2);
               setTimeout(terminalProbe,80);
            }
            catch(playError:*)
            {
               setTimeout(finish,0);
               return;
            }
         };
         if(action == null || !this.setActionFrame(action,targetFrame > 0 ? targetFrame : 1))
         {
            setTimeout(finish,0);
            return;
         }
         this.alignExternalCompactTimeline();
         this.armExternalActionCover(action);
         if(this.isAttackAction() && this.captureExternalHit())
         {
            hitSeen = true;
            this.dispatchHitOnce(param2);
         }
         if(action.totalFrames <= 1)
         {
            setTimeout(finish,0);
            return;
         }
         startPlayback();
      }
      
      private function playAnimation(param1:Function = null, param2:int = 0) : void
      {
         if(this._externalCompactTimeline)
         {
            if(this._mode == MODE_EXTERNAL_IDLE && this._externalForceIdleInstance && this._externalIdleRoot != null)
            {
               this.showExternalIdleInstance();
            }
            else if(this._mode == MODE_EXTERNAL_IDLE)
            {
               this.playExternalFallbackIdle(this._requestedLabel == "个性出场");
            }
            else
            {
               this.playExternalAnimation(param1,param2);
            }
         }
         else
         {
            this._moviePlayer = new FighterMoviePlayer(this._actionAnimation,param1,40,1);
         }
      }
      
      private function playExternalFallbackIdle(param1:Boolean = false) : void
      {
         var visual:MovieClip = null;
         if(this._actionAnimation == null)
         {
            this._actionAnimation = this.getActionChild();
         }
         if(this._actionAnimation == null && this._mc != null && UClientUniversalBattleAdapter.supports(this._mc))
         {
            try
            {
               if("action" in this._mc && this._mc["action"] is MovieClip)
               {
                  this._actionAnimation = this._mc["action"] as MovieClip;
               }
            }
            catch(ignored:*)
            {
            }
         }
         if(this._actionAnimation == null)
         {
            return;
         }
         if(this._mc != null && UClientUniversalBattleAdapter.supports(this._mc))
         {
            this.selectManagedIdleAction(this._actionAnimation);
            try
            {
               this._mc.gotoAndStop("idle");
            }
            catch(ignored:*)
            {
            }
            try
            {
               this._actionAnimation.gotoAndStop(1);
            }
            catch(ignored:*)
            {
            }
            this.alignExternalCompactTimeline();
            return;
         }
         this.selectManagedIdleAction(this._actionAnimation);
         this.setActionFrame(this._actionAnimation,1);
         visual = this.getPrimaryActionVisual(this._actionAnimation);
         if(visual == null)
         {
            visual = this.selectExternalFallbackPose(this._actionAnimation);
         }
         try
         {
            this._actionAnimation.stop();
         }
         catch(actionStopError:*)
         {
         }
         this._externalFallbackIdleVisual = visual;
         if(visual != null && visual.totalFrames > 1)
         {
            try
            {
               visual.gotoAndPlay(1);
            }
            catch(visualPlayError:*)
            {
               try
               {
                  visual.play();
               }
               catch(ignored:*)
               {
               }
            }
         }
         this.alignExternalCompactTimeline();
      }
      
      private function clearNativeTerminalWatch() : void
      {
         if(this._nativeTerminalTimeout > 0)
         {
            clearTimeout(this._nativeTerminalTimeout);
            this._nativeTerminalTimeout = 0;
         }
         if(this._nativeTerminalClip != null && this._nativeTerminalHandler != null)
         {
            try
            {
               this._nativeTerminalClip.removeEventListener(Event.ENTER_FRAME,this._nativeTerminalHandler);
            }
            catch(ignored:*)
            {
            }
         }
         this._nativeTerminalClip = null;
         this._nativeTerminalHandler = null;
      }
      
      private function watchNativeTerminalStop(param1:MovieClip, param2:Function) : void
      {
         var action:MovieClip = param1;
         var complete:Function = param2;
         var lastFrame:int = -1;
         var stableTicks:int = 0;
         var handler:Function = null;
         this.clearNativeTerminalWatch();
         if(action == null || action.totalFrames <= 1)
         {
            return;
         }
         handler = function(param1:Event):void
         {
            var current:int = 0;
            if(_nativeTerminalClip !== action)
            {
               action.removeEventListener(Event.ENTER_FRAME,handler);
               return;
            }
            try
            {
               current = action.currentFrame;
            }
            catch(frameError:*)
            {
               clearNativeTerminalWatch();
               return;
            }
            if(current >= action.totalFrames)
            {
               clearNativeTerminalWatch();
               complete();
               return;
            }
            if(current >= Math.max(1,action.totalFrames - 1) && current == lastFrame)
            {
               ++stableTicks;
            }
            else
            {
               stableTicks = 0;
            }
            lastFrame = current;
            if(stableTicks < 3)
            {
               return;
            }
            try
            {
               action.gotoAndStop(action.totalFrames);
            }
            catch(lastFrameError:*)
            {
               try
               {
                  action.stop();
               }
               catch(stopError:*)
               {
               }
            }
            clearNativeTerminalWatch();
            complete();
         };
         this._nativeTerminalClip = action;
         this._nativeTerminalHandler = handler;
         action.addEventListener(Event.ENTER_FRAME,handler,false,0,true);
         this._nativeTerminalTimeout = setTimeout(function():void
         {
            if(_nativeTerminalClip === action)
            {
               clearNativeTerminalWatch();
               complete();
            }
         },Math.max(200,action.totalFrames * 40 + 160));
      }
      
      private function removeActionPlayEventListener() : void
      {
         this.clearExternalActionCover();
         this.clearNativeTerminalWatch();
         if(!this._externalCompactTimeline)
         {
            if(this._moviePlayer != null)
            {
               this._moviePlayer.destroy();
               this._moviePlayer = null;
            }
            return;
         }
         if(this._entryFallbackTimer > 0)
         {
            clearInterval(this._entryFallbackTimer);
            this._entryFallbackTimer = 0;
         }
         if(this._externalFallbackIdleTimer > 0)
         {
            clearInterval(this._externalFallbackIdleTimer);
            this._externalFallbackIdleTimer = 0;
         }
         if(this._externalFallbackIdleVisual != null)
         {
            try
            {
               this._externalFallbackIdleVisual.stop();
            }
            catch(fallbackIdleStopError:*)
            {
            }
            this._externalFallbackIdleVisual = null;
         }
         if(this._mc != null && this._externalHitHandler != null)
         {
            this._mc.removeEventListener("hit",this._externalHitHandler);
            this._externalHitHandler = null;
         }
         if(this._externalTimer > 0)
         {
            clearTimeout(this._externalTimer);
            this._externalTimer = 0;
         }
         if(this._externalSkillCompletionTimer > 0)
         {
            clearTimeout(this._externalSkillCompletionTimer);
            this._externalSkillCompletionTimer = 0;
         }
         if(this._externalPrimaryVisual != null && this._externalVisualExitHandler != null)
         {
            this._externalPrimaryVisual.removeEventListener(Event.EXIT_FRAME,this._externalVisualExitHandler);
         }
         this._externalPrimaryVisual = null;
         this._externalVisualExitHandler = null;
         this._externalImpactComplete = null;
         this._externalUltimateCompletion = null;
         if(this._externalActionClip != null && this._externalActionExitHandler != null)
         {
            this._externalActionClip.removeEventListener(Event.EXIT_FRAME,this._externalActionExitHandler);
            try
            {
               this._externalActionClip.stop();
            }
            catch(actionStopError:*)
            {
            }
         }
         this._externalActionClip = null;
         this._externalActionExitHandler = null;
         if(this._hitTimeout > 0)
         {
            clearTimeout(this._hitTimeout);
            this._hitTimeout = 0;
         }
         if(this._moviePlayer != null)
         {
            this._moviePlayer.destroy();
            this._moviePlayer = null;
         }
      }
      
      private function doActionEnd(param1:int) : void
      {
         var entryAction:Boolean = this.isHostEntryAction();
         if(!this._externalCompactTimeline)
         {
            if(this._mode == MODE_STOP_IDLE)
            {
               if(this.isHostFighterDead() || this._requestedLabel == "失败")
               {
                  if(this._actionAnimation != null)
                  {
                     this._actionAnimation.stop();
                  }
                  this.dispathchActionEndEvent(EVT_END);
                  return;
               }
               if(entryAction)
               {
                  this.armHostViewportEntryEnd();
               }
               if(this._mc != null && UClientUniversalBattleAdapter.supports(this._mc))
               {
                  this._mode = MODE_EXTERNAL_IDLE;
                  this._requestedLabel = "待机";
                  this.beginExternalIdleLoop(param1 == 0 ? this._actionSerial : param1);
                  this.dispathchActionEndEvent(EVT_END);
                  return;
               }
               this.gotoLabel("待机");
            }
            else if(this._mode == MODE_STOP_LAST_FRAME)
            {
               this._actionAnimation.stop();
            }
            else if(this._mode == MODE_REPLAY)
            {
               this.playAnimation(function():void
               {
                  onReplayComplete(0);
               });
            }
            this.dispathchActionEndEvent(EVT_END);
            return;
         }
         if(param1 != this._actionSerial)
         {
            return;
         }
         if(this._mode == MODE_STOP_IDLE)
         {
            if(this.isHostFighterDead() || this._requestedLabel == "失败")
            {
               if(this._actionAnimation != null)
               {
                  this._actionAnimation.stop();
               }
               this.dispathchActionEndEvent(EVT_END);
               return;
            }
            if(entryAction)
            {
               this.armHostViewportEntryEnd();
            }
            if(this._mc != null && UClientUniversalBattleAdapter.supports(this._mc))
            {
               this._mode = MODE_EXTERNAL_IDLE;
               this._requestedLabel = "待机";
               this.beginExternalIdleLoop(param1);
               this.dispathchActionEndEvent(EVT_END);
               return;
            }
            if(this._externalCompactTimeline)
            {
               this._mode = MODE_EXTERNAL_IDLE;
               if(!this.hasExternalIdleLabel() || this._externalForceIdleInstance)
               {
                  this._requestedLabel = "待机";
                  this.showExternalIdleInstance();
               }
               this.dispathchActionEndEvent(EVT_END);
               if(param1 != this._actionSerial)
               {
                  return;
               }
               if(this.hasExternalIdleLabel())
               {
                  this.beginExternalIdleLoop(param1);
               }
               return;
            }
            this.gotoLabel("待机");
            this.dispathchActionEndEvent(EVT_END);
            return;
         }
         if(this._mode == MODE_STOP_LAST_FRAME)
         {
            if(this._actionAnimation != null)
            {
               this._actionAnimation.stop();
            }
         }
         else if(this._mode == MODE_REPLAY)
         {
            this.playAnimation(function():void
            {
               onReplayComplete(param1);
            },param1);
         }
         else if(this._mode == MODE_EXTERNAL_IDLE)
         {
            this.playAnimation(function():void
            {
               onReplayComplete(param1);
            },param1);
         }
         this.dispathchActionEndEvent(EVT_END);
      }
      
      private function beginExternalIdleLoop(param1:int, param2:int = 0, param3:Function = null) : void
      {
         var label:String = null;
         if(this.isHostFighterDead() || this._requestedLabel == "失败")
         {
            return;
         }
         if(param1 != this._actionSerial || this._mc == null)
         {
            return;
         }
         if(this._externalForceIdleInstance && this._externalIdleRoot != null)
         {
            this._requestedLabel = "待机";
            this.showExternalIdleInstance();
            if(param3 != null)
            {
               param3();
            }
            return;
         }
         if(param2 == 0)
         {
            this._requestedLabel = "待机";
            label = this.resolveExternalLabel(this._requestedLabel);
            this._currentLabel = label;
            try
            {
               if(label == "")
               {
                  this._mc.gotoAndStop(1);
               }
               else
               {
                  this._mc.gotoAndStop(label);
               }
            }
            catch(ignored:*)
            {
            }
         }
         this._actionAnimation = this.getActionChild();
         if(this._actionAnimation == null && this._mc != null && UClientUniversalBattleAdapter.supports(this._mc))
         {
            try
            {
               if("action" in this._mc && this._mc["action"] is MovieClip)
               {
                  this._actionAnimation = this._mc["action"] as MovieClip;
               }
            }
            catch(ignored:*)
            {
            }
         }
         if(this._actionAnimation == null)
         {
            if(param2 < 8)
            {
               setTimeout(function():void
               {
                  beginExternalIdleLoop(param1,param2 + 1,param3);
               },16);
            }
            else if(param3 != null)
            {
               param3();
            }
            return;
         }
         this.setActionFrame(this._actionAnimation,1);
         this.alignExternalCompactTimeline();
         this.playAnimation(function():void
         {
            onReplayComplete(param1);
         },param1);
         if(param3 != null)
         {
            param3();
         }
      }
      
      private function onReplayComplete(param1:int) : void
      {
         if(!this._externalCompactTimeline)
         {
            this.removeActionPlayEventListener();
            this.playAnimation(function():void
            {
               onReplayComplete(0);
            });
            return;
         }
         if(param1 != this._actionSerial)
         {
            return;
         }
         this.removeActionPlayEventListener();
         this.playAnimation(function():void
         {
            onReplayComplete(param1);
         },param1);
      }
      
      private function dispathchActionEndEvent(param1:String) : void
      {
         if(param1 == EVT_END)
         {
            if(!this._hostViewportNormalized && (this._hostViewportEntryEndPending || this.isHostEntryAction()))
            {
               this.armHostViewportEntryEnd();
               return;
            }
            if(this._hostViewportEntryEndPending)
            {
               this.flushHostViewportEntryEnd();
               return;
            }
         }
         if(this.hasEventListener(param1))
         {
            dispatchEvent(new Event(param1));
         }
      }
      
      public function isStopAllAnimation(param1:Boolean) : void
      {
      }
      
      public function update() : void
      {
      }
      
      public function dispose() : void
      {
         this._externalAttackCoverPending = null;
         this._externalAttackCoverBounds = null;
         this.clearExternalActionCover();
         this.removeEventListener(Event.ENTER_FRAME,this.probeHostViewport);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageForBackdrop);
         this._hostViewportEntryEndPending = false;
         if(this._hostViewportEntryEndTimer > 0)
         {
            clearTimeout(this._hostViewportEntryEndTimer);
            this._hostViewportEntryEndTimer = 0;
         }
         ++this._actionSerial;
         ++this._customSkillActionSerial;
         this.stopCustomSkillOverlay();
         this._externalUltimateCompletionSerial = -1;
         this._externalUltimateMainComplete = false;
         this._externalUltimateSkillPending = false;
         this._externalUltimateSkillComplete = false;
         this._externalUltimateCompletion = null;
         this.removeActionPlayEventListener();
         if(this._externalIdleNormalizationTimer > 0)
         {
            clearTimeout(this._externalIdleNormalizationTimer);
            this._externalIdleNormalizationTimer = 0;
         }
         if(this._externalIdleRoot != null && this._externalIdleConstructHandler != null)
         {
            this._externalIdleRoot.removeEventListener(Event.FRAME_CONSTRUCTED,this._externalIdleConstructHandler);
         }
         this._externalIdleConstructHandler = null;
         if(this._externalIdleVisual != null)
         {
            try
            {
               this._externalIdleVisual.stop();
            }
            catch(idleStopError:*)
            {
            }
         }
         this._externalIdleVisual = null;
         this._externalIdleAction = null;
         this._externalIdleReady = false;
         if(this._externalIdleRoot != null)
         {
            if(this._externalIdleRoot.parent === this)
            {
               removeChild(this._externalIdleRoot);
            }
            this._externalIdleRoot = null;
         }
         this._actionAnimation = null;
         if(this._mc != null)
         {
            UClientUniversalBattleAdapter.detach(this._mc);
            this._uclientAdapter = null;
            this._mc.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
            try
            {
               this._mc.gotoAndStop("空");
            }
            catch(e:*)
            {
            }
            if(this._mc.parent === this)
            {
               removeChild(this._mc);
            }
            this._mc = null;
         }
         this._cachedDedicatedMoveChecked = false;
         this._cachedDedicatedMoveLabel = "";
         this._cachedDedicatedMoves = null;
      }
   }
}

