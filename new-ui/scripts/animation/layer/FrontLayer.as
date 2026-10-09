package animation.layer
{
   import animation.fight.BaoJiHitAnimation;
   import animation.fight.CatchFighterFailAnimation;
   import animation.fight.CatchFighterSuccessAnimation;
   import animation.fight.CatchHintAnimation;
   import animation.fight.FightAbsorbAnimation;
   import animation.fight.FightCountDownAnimation;
   import animation.fight.FightMissAnimation;
   import animation.fight.FightWaitingAnimation;
   import animation.fight.HPIncreaseAnimation;
   import animation.fight.HpDecreaseAnimation;
   import animation.fight.ItemUseAnimation;
   import animation.fight.KOAnimation;
   import animation.fight.PowSkillHitAnimation;
   import animation.fight.PowSkillStartAnimation;
   import animation.fight.PresentAnimation;
   import data.location.FighterLocation;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Rectangle;
   import flash.media.Video;
   import flash.net.URLRequest;
   import utils.CacheUtils;
   import utils.Utils;
   import utils.an.DisplayObjectUtil;
   
   public class FrontLayer extends Sprite
   {
      
      private static var customSkillClasses:Object = {};
      
      private static var customSkillWaiters:Object = {};
      
      private static const CUSTOM_SKILL_READY:String = "uclientVideoReady";
      
      private static const CUSTOM_SKILL_COMPLETE:String = "uclientVideoComplete";
      
      private static const CUSTOM_SKILL_ERROR:String = "uclientVideoError";
      
      private var currentSkillEffectUrl:String;
      
      private var customSkillOverlay:MovieClip;
      
      private var customSkillOverlayFrameHandler:Function;
      
      private var customSkillOverlayConstructHandler:Function;
      
      private var customSkillOverlayReadyHandler:Function;
      
      private var customSkillOverlayCompleteHandler:Function;
      
      private var customSkillOverlayErrorHandler:Function;
      
      private var customSkillSerial:int = 0;
      
      public function FrontLayer()
      {
         super();
         DisplayObjectUtil.disableSprite(this);
      }
      
      private static function loadOptionalCustomSkill(param1:String, param2:Function) : void
      {
         var url:String = param1;
         var cb:Function = param2;
         var cached:Class = null;
         var instance:MovieClip = null;
         var loader:Loader = null;
         var finish:Function = null;
         if(!url)
         {
            cb(null);
            return;
         }
         if(customSkillClasses.hasOwnProperty(url))
         {
            cached = customSkillClasses[url] as Class;
            if(cached == null)
            {
               delete customSkillClasses[url];
               cb(null);
            }
            else
            {
               instance = buildCustomSkillInstance(cached);
               if(instance == null)
               {
                  delete customSkillClasses[url];
               }
               cb(instance);
            }
            return;
         }
         if(customSkillWaiters[url] != null)
         {
            customSkillWaiters[url].push(cb);
            return;
         }
         customSkillWaiters[url] = [cb];
         loader = new Loader();
         finish = function(param1:Class):void
         {
            var callbacks:Array = customSkillWaiters[url] as Array;
            var callback:Function = null;
            if(param1 != null)
            {
               customSkillClasses[url] = param1;
            }
            else
            {
               delete customSkillClasses[url];
            }
            delete customSkillWaiters[url];
            if(callbacks == null)
            {
               return;
            }
            for each(callback in callbacks)
            {
               callback(buildCustomSkillInstance(param1));
            }
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            var clazz:Class = null;
            try
            {
               clazz = param1.currentTarget.applicationDomain.getDefinition("skill") as Class;
            }
            catch(ignored:*)
            {
            }
            finish(clazz);
         });
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
         {
            finish(null);
         });
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(param1:SecurityErrorEvent):void
         {
            finish(null);
         });
         try
         {
            loader.load(new URLRequest(url));
         }
         catch(loadError:*)
         {
            finish(null);
         }
      }
      
      private static function buildCustomSkillInstance(param1:Class) : MovieClip
      {
         if(param1 == null)
         {
            return null;
         }
         try
         {
            return new param1() as MovieClip;
         }
         catch(ignored:*)
         {
         }
         return null;
      }
      
      public function playSuperAtkStart(param1:int) : void
      {
         var side:int = param1;
         var sprite:PowSkillStartAnimation = new PowSkillStartAnimation();
         sprite.initData({"side":side});
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playHpReduceSplash(param1:int, param2:int, param3:int, param4:int) : void
      {
         var skillTypeRelation:int;
         var sprite:HpDecreaseAnimation;
         var side:int = param1;
         var damage:int = param2;
         var critical:int = param3;
         var rate:int = param4;
         if(damage <= 0)
         {
            return;
         }
         skillTypeRelation = 0;
         if(rate > 100)
         {
            skillTypeRelation = 2;
         }
         else if(rate < 100)
         {
            skillTypeRelation = 1;
         }
         sprite = new HpDecreaseAnimation();
         sprite.initData({
            "reducedHp":damage,
            "fightSide":side,
            "isBaoJi":critical,
            "skillTypeRelation":skillTypeRelation
         });
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playSuperAtkHit() : void
      {
         var sprite:PowSkillHitAnimation = new PowSkillHitAnimation();
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playCriticalHit() : void
      {
         var sprite:BaoJiHitAnimation = new BaoJiHitAnimation();
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playLeftPresent(param1:Function, param2:Function) : void
      {
         var pcb:Function = param1;
         var ecb:Function = param2;
         var sprite:PresentAnimation = new PresentAnimation();
         addChild(sprite);
         sprite.initData({"onFighterPresentFun":pcb});
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            if(ecb != null)
            {
               ecb();
            }
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playHPIncrease(param1:int, param2:int) : void
      {
         var side:int = param1;
         var change:int = param2;
         var sprite:HPIncreaseAnimation = new HPIncreaseAnimation();
         addChild(sprite);
         sprite.initData({
            "fightSide":side,
            "changedHp":change,
            "startInterval":0
         });
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playHPDecrease(param1:int, param2:int) : void
      {
         playHpReduceSplash(param1,param2,0,100);
      }
      
      public function playItemUse(param1:int, param2:int, param3:int, param4:int) : void
      {
         var side:int = param1;
         var position:int = param2;
         var type0:int = param3;
         var change:int = param4;
         var sprite:ItemUseAnimation = new ItemUseAnimation();
         addChild(sprite);
         sprite.initData({
            "side":side,
            "position":position,
            "type":type0,
            "change":change
         });
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playAbsorb(param1:int) : void
      {
         var side:int = param1;
         var sprite:FightAbsorbAnimation = new FightAbsorbAnimation();
         addChild(sprite);
         sprite.initData({"side":side});
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playMiss(param1:int) : void
      {
         var side:int = param1;
         var sprite:FightMissAnimation = new FightMissAnimation();
         addChild(sprite);
         sprite.initData({"side":side});
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playKO(param1:Function) : void
      {
         var cb:Function = param1;
         var sprite:KOAnimation = new KOAnimation();
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
         });
      }
      
      public function playCountDown(param1:Function) : void
      {
         var cb:Function = param1;
         var sprite:FightCountDownAnimation = new FightCountDownAnimation();
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
         });
      }
      
      public function playFightWaiting() : void
      {
         var sprite:FightWaitingAnimation = new FightWaitingAnimation();
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playSkillEffect(param1:String, param2:int) : void
      {
         var url:String = param1;
         var side:int = param2;
         if(!url)
         {
            return;
         }
         currentSkillEffectUrl = url;
         CacheUtils.loadEffect(url,function(param1:MovieClip):void
         {
            var location:FighterLocation;
            var sprite:MovieClip = param1;
            if(currentSkillEffectUrl !== url)
            {
               return;
            }
            addChild(sprite);
            sprite.gotoAndPlay(1);
            location = FighterLocation.build(side,1);
            sprite.x = location.targetX;
            sprite.y = location.targetY;
            if(side === 2)
            {
               sprite.scaleX *= -1;
            }
            Utils.onComplete(sprite,function():void
            {
               DisplayObjectUtil.removeFromParent(sprite);
            });
         });
      }
      
      public function playCustomSkillEffect(param1:String, param2:int) : void
      {
         var url:String = param1;
         var side:int = param2;
         var serial:int = 0;
         stopCustomSkillEffect();
         serial = customSkillSerial;
         if(!url)
         {
            return;
         }
         loadOptionalCustomSkill(url,function(param1:MovieClip):void
         {
            var sprite:MovieClip = param1;
            var positioned:Boolean = false;
            var explicitReady:Boolean = false;
            var progressSource:MovieClip = null;
            var lastProgressFrame:int = -1;
            var progressSeen:Boolean = false;
            if(serial !== customSkillSerial || sprite == null)
            {
               return;
            }
            customSkillOverlay = sprite;
            sprite.x = 0;
            sprite.y = 0;
            if(side === 2)
            {
               sprite.scaleX = -Math.abs(sprite.scaleX);
            }
            customSkillOverlayReadyHandler = function(param1:Event):void
            {
               explicitReady = true;
               if(!positioned)
               {
                  positioned = tryPositionCustomSkillOverlay(sprite);
               }
            };
            customSkillOverlayCompleteHandler = function(param1:Event):void
            {
               if(customSkillOverlay === sprite && serial === customSkillSerial)
               {
                  stopCustomSkillEffect();
               }
            };
            customSkillOverlayErrorHandler = function(param1:Event):void
            {
               if(customSkillOverlay === sprite && serial === customSkillSerial)
               {
                  stopCustomSkillEffect();
               }
            };
            customSkillOverlayConstructHandler = function(param1:Event):void
            {
               if(customSkillOverlay !== sprite)
               {
                  return;
               }
               if(!positioned)
               {
                  positioned = tryPositionCustomSkillOverlay(sprite);
               }
               if(progressSource == null || !isDisplayObjectAttached(progressSource,sprite))
               {
                  progressSource = findVisibleProgressClip(sprite);
                  lastProgressFrame = progressSource == null ? -1 : progressSource.currentFrame;
                  progressSeen = false;
               }
            };
            sprite.addEventListener(CUSTOM_SKILL_READY,customSkillOverlayReadyHandler,false,0,true);
            sprite.addEventListener(CUSTOM_SKILL_COMPLETE,customSkillOverlayCompleteHandler,false,0,true);
            sprite.addEventListener(CUSTOM_SKILL_ERROR,customSkillOverlayErrorHandler,false,0,true);
            sprite.addEventListener(Event.COMPLETE,customSkillOverlayCompleteHandler,false,0,true);
            sprite.addEventListener("animationEnd",customSkillOverlayCompleteHandler,false,0,true);
            sprite.addEventListener(Event.FRAME_CONSTRUCTED,customSkillOverlayConstructHandler,false,0,true);
            addChild(sprite);
            positioned = tryPositionCustomSkillOverlay(sprite);
            progressSource = findVisibleProgressClip(sprite);
            lastProgressFrame = progressSource == null ? -1 : progressSource.currentFrame;
            customSkillOverlayFrameHandler = function(param1:Event):void
            {
               var currentFrame:int = -1;
               if(customSkillOverlay !== sprite || serial !== customSkillSerial)
               {
                  return;
               }
               if(!positioned && (explicitReady || hasVisibleAsyncMedia(sprite)))
               {
                  positioned = tryPositionCustomSkillOverlay(sprite);
               }
               if(hasCustomSkillCompleteCapability(sprite))
               {
                  stopCustomSkillEffect();
                  return;
               }
               if(progressSource == null || !isDisplayObjectAttached(progressSource,sprite) || !isEffectivelyVisible(progressSource,sprite))
               {
                  progressSource = findVisibleProgressClip(sprite);
                  lastProgressFrame = progressSource == null ? -1 : progressSource.currentFrame;
                  progressSeen = false;
                  return;
               }
               currentFrame = progressSource.currentFrame;
               if(lastProgressFrame >= 0 && currentFrame != lastProgressFrame)
               {
                  progressSeen = true;
               }
               if(progressSeen && (currentFrame >= progressSource.totalFrames || lastProgressFrame > currentFrame && lastProgressFrame >= progressSource.totalFrames - 1))
               {
                  stopCustomSkillEffect();
                  return;
               }
               lastProgressFrame = currentFrame;
            };
            sprite.addEventListener(Event.ENTER_FRAME,customSkillOverlayFrameHandler,false,0,true);
            if(sprite.totalFrames > 1)
            {
               sprite.gotoAndPlay(1);
            }
            else
            {
               sprite.play();
            }
         });
      }
      
      private function tryPositionCustomSkillOverlay(param1:MovieClip) : Boolean
      {
         var bounds:Rectangle = null;
         if(param1 == null)
         {
            return false;
         }
         try
         {
            bounds = param1.getBounds(param1);
            if(bounds != null && bounds.width > 1 && bounds.height > 1)
            {
               param1.x = FighterLocation.WIDTH / 2 - (bounds.x + bounds.width / 2) * param1.scaleX;
               param1.y = FighterLocation.HEIGHT / 2 - (bounds.y + bounds.height / 2) * param1.scaleY;
               return true;
            }
         }
         catch(ignored:*)
         {
         }
         return false;
      }
      
      private function findVisibleProgressClip(param1:DisplayObject) : MovieClip
      {
         var rootClip:MovieClip = param1 as MovieClip;
         var container:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var child:DisplayObject = null;
         var clip:MovieClip = null;
         var nested:MovieClip = null;
         var index:int = 0;
         if(param1 == null || !isEffectivelyVisible(param1,param1))
         {
            return null;
         }
         if(rootClip != null && rootClip.totalFrames > 1)
         {
            return rootClip;
         }
         if(container == null)
         {
            return null;
         }
         while(index < container.numChildren)
         {
            try
            {
               child = container.getChildAt(index);
               clip = child as MovieClip;
               if(clip != null && clip.totalFrames > 1 && isEffectivelyVisible(clip,param1))
               {
                  return clip;
               }
            }
            catch(ignored:*)
            {
            }
            index++;
         }
         index = 0;
         while(index < container.numChildren)
         {
            try
            {
               child = container.getChildAt(index);
               if(isEffectivelyVisible(child,param1))
               {
                  nested = findVisibleProgressClip(child);
                  if(nested != null)
                  {
                     return nested;
                  }
               }
            }
            catch(ignored:*)
            {
            }
            index++;
         }
         return null;
      }
      
      private function hasVisibleAsyncMedia(param1:DisplayObject) : Boolean
      {
         var container:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var child:DisplayObject = null;
         var index:int = 0;
         if(param1 == null || !isEffectivelyVisible(param1,param1))
         {
            return false;
         }
         if(param1 is Video)
         {
            return true;
         }
         if(container == null)
         {
            return false;
         }
         while(index < container.numChildren)
         {
            try
            {
               child = container.getChildAt(index);
               if(isEffectivelyVisible(child,param1) && hasVisibleAsyncMedia(child))
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
      
      private function hasCustomSkillCompleteCapability(param1:DisplayObject) : Boolean
      {
         var state:Object = null;
         if(param1 == null)
         {
            return false;
         }
         try
         {
            if("isEnd" in param1 && Boolean(param1["isEnd"]))
            {
               return true;
            }
            if("isComplete" in param1 && Boolean(param1["isComplete"]))
            {
               return true;
            }
            if("completed" in param1 && Boolean(param1["completed"]))
            {
               return true;
            }
            if("playbackComplete" in param1 && Boolean(param1["playbackComplete"]))
            {
               return true;
            }
            if("getPlaybackState" in param1 && param1["getPlaybackState"] is Function)
            {
               state = param1["getPlaybackState"]();
               if(state != null && (Boolean(state.complete) || Boolean(state.completed) || String(state.status).toLowerCase() == "complete"))
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
      
      private function isDisplayObjectAttached(param1:DisplayObject, param2:DisplayObjectContainer) : Boolean
      {
         var current:DisplayObject = param1;
         if(current == null || param2 == null)
         {
            return false;
         }
         while(current != null)
         {
            if(current === param2)
            {
               return true;
            }
            current = current.parent;
         }
         return false;
      }
      
      private function isEffectivelyVisible(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         var current:DisplayObject = param1;
         if(current == null)
         {
            return false;
         }
         while(current != null)
         {
            if(!current.visible || current.alpha <= 0)
            {
               return false;
            }
            if(current === param2)
            {
               return true;
            }
            current = current.parent;
         }
         return param1 === param2;
      }
      
      public function stopCustomSkillEffect() : void
      {
         ++customSkillSerial;
         if(customSkillOverlay != null)
         {
            if(customSkillOverlayFrameHandler != null)
            {
               customSkillOverlay.removeEventListener(Event.ENTER_FRAME,customSkillOverlayFrameHandler);
            }
            if(customSkillOverlayConstructHandler != null)
            {
               customSkillOverlay.removeEventListener(Event.FRAME_CONSTRUCTED,customSkillOverlayConstructHandler);
            }
            if(customSkillOverlayReadyHandler != null)
            {
               customSkillOverlay.removeEventListener(CUSTOM_SKILL_READY,customSkillOverlayReadyHandler);
            }
            if(customSkillOverlayCompleteHandler != null)
            {
               customSkillOverlay.removeEventListener(CUSTOM_SKILL_COMPLETE,customSkillOverlayCompleteHandler);
               customSkillOverlay.removeEventListener(Event.COMPLETE,customSkillOverlayCompleteHandler);
               customSkillOverlay.removeEventListener("animationEnd",customSkillOverlayCompleteHandler);
            }
            if(customSkillOverlayErrorHandler != null)
            {
               customSkillOverlay.removeEventListener(CUSTOM_SKILL_ERROR,customSkillOverlayErrorHandler);
            }
            try
            {
               if("disposePlayback" in customSkillOverlay && customSkillOverlay["disposePlayback"] is Function)
               {
                  customSkillOverlay["disposePlayback"]();
               }
               else if("dispose" in customSkillOverlay && customSkillOverlay["dispose"] is Function)
               {
                  customSkillOverlay["dispose"]();
               }
               else
               {
                  customSkillOverlay.stop();
               }
            }
            catch(ignored:*)
            {
            }
            DisplayObjectUtil.removeFromParent(customSkillOverlay);
         }
         customSkillOverlay = null;
         customSkillOverlayFrameHandler = null;
         customSkillOverlayConstructHandler = null;
         customSkillOverlayReadyHandler = null;
         customSkillOverlayCompleteHandler = null;
         customSkillOverlayErrorHandler = null;
      }
      
      public function playCatchHit() : void
      {
         var sprite:CatchHintAnimation = new CatchHintAnimation();
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
         });
      }
      
      public function playCatchSuccess(param1:Function, param2:Function) : void
      {
         var onSuccess:Function = param1;
         var cb:Function = param2;
         var sprite:CatchFighterSuccessAnimation = new CatchFighterSuccessAnimation();
         addChild(sprite);
         sprite.initData({"onCatchSuccessFun":onSuccess});
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
         });
      }
      
      public function playCatchFailed(param1:Function) : void
      {
         var cb:Function = param1;
         var sprite:CatchFighterFailAnimation = new CatchFighterFailAnimation();
         addChild(sprite);
         sprite.play();
         Utils.once(sprite,"animationEnd",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
         });
      }
   }
}

