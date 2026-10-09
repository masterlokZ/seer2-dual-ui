package com.taomee.seer2.app.component
{
   import com.chunshu.seer2.uclient.UClientUniversalBattleAdapter;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import org.taomee.utils.DomainUtil;
   import org.taomee.utils.MovieClipUtil;
   
   public class PetDemoDisplayer extends Sprite
   {
      
      private static const PET_LINKAGE_NAME:String = "pet";
      
      private static const BASE_WIDTH:Number = 326;
      
      private static const BASE_HEIGHT:Number = 326;
      
      private var _container:Sprite;
      
      private var _url:String;
      
      private var _complete:Function;
      
      private var _loader:Loader;
      
      private var _scaleParameter:int;
      
      private var _isPoint:Boolean;
      
      private var _isScale:Boolean;
      
      private var _scaleVal:Number;
      
      private var _demo:MovieClip;
      
      private var _uclientAdapter:UClientUniversalBattleAdapter;
      
      private var _staticMode:Boolean;
      
      private var _fitWidth:Number;
      
      private var _fitHeight:Number;
      
      private var _direction:int;
      
      private var _moveStyle:String = "stand";
      
      private var _fallbackUrl:String;
      
      private var _usingFallback:Boolean;
      
      private var _directionalMode:Boolean;
      
      private var _appliedLabel:String = "";
      
      public function PetDemoDisplayer()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._container = new Sprite();
         addChild(this._container);
         this._loader = new Loader();
      }
      
      public function setUrl(param1:String, param2:Function, param3:int = 0, param4:Boolean = false, param5:Boolean = false) : void
      {
         this._url = param1;
         this._fallbackUrl = "";
         this._usingFallback = false;
         this._directionalMode = false;
         this._staticMode = false;
         this._appliedLabel = "";
         this._scaleParameter = param3;
         this._complete = param2;
         this._isPoint = param4;
         this._isScale = param5;
         this.loadDemo();
      }
      
      public function newSetUrl(param1:String, param2:Number = 326, param3:Number = 326, param4:Function = null, param5:Boolean = false) : void
      {
         this._url = param1;
         this._fallbackUrl = "";
         this._usingFallback = false;
         this._directionalMode = false;
         this._appliedLabel = "";
         this._scaleVal = Math.min(param2 / 326,param3 / 326);
         this._fitWidth = param2;
         this._fitHeight = param3;
         this._complete = param4;
         this._staticMode = param5;
         this.loadDemo();
      }
      
      public function newSetDirectionalUrl(param1:String, param2:String, param3:Number = 326, param4:Number = 326, param5:Function = null) : void
      {
         this._url = param1;
         this._fallbackUrl = param2;
         this._usingFallback = false;
         this._directionalMode = true;
         this._staticMode = false;
         this._appliedLabel = "";
         this._scaleVal = Math.min(param3 / 326,param4 / 326);
         this._fitWidth = param3;
         this._fitHeight = param4;
         this._complete = param5;
         this.loadDemo();
      }
      
      public function clearDemo() : void
      {
         this.detachUClientAdapter();
         this._demo = null;
         this._appliedLabel = "";
         DisplayObjectUtil.removeAllChildren(this._container);
      }
      
      public function killLoad() : void
      {
         QueueLoader.cancel(this._url,this.onLoadDemo);
         if(this._fallbackUrl)
         {
            QueueLoader.cancel(this._fallbackUrl,this.onLoadDemo);
         }
      }
      
      public function setDirectionalState(param1:String, param2:int) : void
      {
         var _loc3_:String = param1 || "stand";
         if(this._moveStyle == _loc3_ && (this._direction & 3) == (param2 & 3) && this._appliedLabel != "")
         {
            return;
         }
         this._moveStyle = _loc3_;
         this._direction = param2 & 3;
         this.applyDirectionalState();
      }
      
      public function attachDirectionalDemoForTest(param1:MovieClip, param2:Number = 110, param3:Number = 110) : void
      {
         DisplayObjectUtil.removeAllChildren(this._container);
         this._directionalMode = true;
         this._usingFallback = false;
         this._staticMode = false;
         this._fitWidth = param2;
         this._fitHeight = param3;
         this._scaleVal = Math.min(param2 / 326,param3 / 326);
         this._appliedLabel = "";
         this.addDemo(param1);
      }
      
      public function getDirectionalSnapshot() : Object
      {
         var _loc1_:Object = {
            "applied":this._appliedLabel,
            "direction":this._direction,
            "moveStyle":this._moveStyle,
            "outerScaleX":this.scaleX,
            "directional":this._directionalMode,
            "fallback":this._usingFallback,
            "rootLabel":"",
            "rootFrame":0,
            "animatedFrames":""
         };
         if(this._demo != null)
         {
            _loc1_.rootLabel = this._demo.currentLabel;
            _loc1_.rootFrame = this._demo.currentFrame;
            _loc1_.animatedFrames = this.collectAnimatedFrames(this._demo);
         }
         return _loc1_;
      }
      
      private function loadDemo() : void
      {
         DisplayObjectUtil.removeAllChildren(this._container);
         QueueLoader.load(this._url,"domain",this.onLoadDemo,this.onLoadError);
      }
      
      private function onLoadDemo(param1:ContentInfo) : void
      {
         var _loc2_:MovieClip = null;
         DisplayObjectUtil.removeAllChildren(this._container);
         _loc2_ = DomainUtil.getMovieClip("pet",param1.content);
         if(_loc2_ == null && !this._usingFallback && this._fallbackUrl)
         {
            this.loadFallback();
            return;
         }
         this.addDemo(_loc2_);
         if(this._complete != null)
         {
            this._complete();
            this._complete = null;
         }
      }
      
      private function onLoadError(param1:*) : void
      {
         if(!this._usingFallback && this._fallbackUrl)
         {
            this.loadFallback();
         }
      }
      
      private function loadFallback() : void
      {
         this._usingFallback = true;
         this._directionalMode = false;
         this._staticMode = true;
         this._appliedLabel = "";
         this._url = this._fallbackUrl;
         this.loadDemo();
      }
      
      private function addDemo(param1:MovieClip) : void
      {
         if(param1 != null)
         {
            this.detachUClientAdapter();
            this._demo = param1;
            param1.x = param1.y = 0;
            this._container.addChild(param1);
            if(this._staticMode)
            {
               param1.gotoAndStop(1);
               MovieClipUtil.childStop(param1,1);
               this.fitCurrentDemo();
            }
            else if(this._directionalMode)
            {
               this._appliedLabel = "";
               this.applyDirectionalState();
            }
            else
            {
               this._uclientAdapter = UClientUniversalBattleAdapter.attach(param1);
               param1.scaleX = param1.scaleY = this.previewScale(param1);
               if(this._uclientAdapter == null && this.hasDirectionalPreviewLabels(param1))
               {
                  this._directionalMode = true;
                  this._direction = 0;
                  this._moveStyle = "stand";
                  this._appliedLabel = "";
                  this.applyDirectionalState();
               }
               else if(this._uclientAdapter == null && this.hasLegacyBattlePreviewLabels(param1))
               {
                  this.startLegacyBattleIdle(param1);
               }
            }
         }
      }
      
      private function hasDirectionalPreviewLabels(param1:MovieClip) : Boolean
      {
         var _loc2_:FrameLabel = null;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return false;
         }
         for each(_loc2_ in param1.currentLabels)
         {
            if(_loc2_.name == "down" || _loc2_.name == "up" || _loc2_.name == "leftdown" || _loc2_.name == "rightdown" || _loc2_.name == "leftup" || _loc2_.name == "rightup" || _loc2_.name == "left" || _loc2_.name == "right")
            {
               _loc3_++;
            }
         }
         return _loc3_ >= 2;
      }
      
      private function hasLegacyBattlePreviewLabels(param1:MovieClip) : Boolean
      {
         return this.hasLabelOnMovieClip(param1,"attack") || this.hasLabelOnMovieClip(param1,"atk") || this.hasLabelOnMovieClip(param1,"attack1");
      }
      
      private function startLegacyBattleIdle(root:MovieClip) : void
      {
         var label:String = this.firstLabelOnMovieClip(root,["idle","stand","wait","attack","atk","attack1"]);
         var action:MovieClip = null;
         var visual:MovieClip = null;
         if(label == "")
         {
            return;
         }
         try
         {
            root.gotoAndStop(label);
         }
         catch(rootLabelError:*)
         {
            return;
         }
         action = this.firstDirectMovieChild(root);
         if(action == null)
         {
            return;
         }
         try
         {
            action.gotoAndStop(1);
         }
         catch(actionFrameError:*)
         {
            try
            {
               action.stop();
            }
            catch(ignoredStop:*)
            {
            }
         }
         visual = this.primaryActionVisual(action);
         if(visual == null || visual.totalFrames <= 1)
         {
            return;
         }
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
            catch(ignoredPlay:*)
            {
            }
         }
      }
      
      private function hasLabelOnMovieClip(target:MovieClip, wanted:String) : Boolean
      {
         var label:FrameLabel = null;
         if(target == null)
         {
            return false;
         }
         for each(label in target.currentLabels)
         {
            if(label.name == wanted)
            {
               return true;
            }
         }
         return false;
      }
      
      private function firstLabelOnMovieClip(target:MovieClip, names:Array) : String
      {
         var wanted:String = null;
         var label:FrameLabel = null;
         if(target == null)
         {
            return "";
         }
         for each(wanted in names)
         {
            for each(label in target.currentLabels)
            {
               if(label.name == wanted)
               {
                  return wanted;
               }
            }
         }
         return "";
      }
      
      private function firstDirectMovieChild(container:DisplayObjectContainer) : MovieClip
      {
         var index:int = 0;
         var child:MovieClip = null;
         if(container == null)
         {
            return null;
         }
         while(index < container.numChildren)
         {
            child = container.getChildAt(index) as MovieClip;
            if(child != null)
            {
               return child;
            }
            index++;
         }
         return null;
      }
      
      private function primaryActionVisual(container:MovieClip) : MovieClip
      {
         var visual:MovieClip = this.firstDirectMovieChild(container);
         var nested:MovieClip = null;
         var depth:int = 0;
         while(visual != null && visual.totalFrames <= 1 && depth < 4)
         {
            nested = this.firstDirectMovieChild(visual);
            if(nested == null)
            {
               break;
            }
            visual = nested;
            depth++;
         }
         return visual != null && visual.totalFrames > 1 ? visual : null;
      }
      
      private function previewScale(param1:MovieClip) : Number
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Number = this._scaleVal;
         if(this._uclientAdapter == null)
         {
            return _loc3_;
         }
         try
         {
            param1.scaleX = param1.scaleY = 1;
            _loc2_ = param1.getBounds(param1);
            _loc3_ *= UClientUniversalBattleAdapter.fitMultiplier(param1,_loc2_);
         }
         catch(ignored:*)
         {
         }
         return _loc3_;
      }
      
      private function detachUClientAdapter() : void
      {
         if(this._demo != null)
         {
            UClientUniversalBattleAdapter.detach(this._demo);
         }
         this._uclientAdapter = null;
      }
      
      private function applyDirectionalState() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         if(this._demo == null)
         {
            return;
         }
         if(!this._directionalMode)
         {
            return;
         }
         _loc1_ = this.findDirectionalLabel();
         if(_loc1_ == "")
         {
            if(this._appliedLabel != "__static")
            {
               this._demo.gotoAndStop(1);
               MovieClipUtil.childStop(this._demo,1);
               this._appliedLabel = "__static";
               this.fitCurrentDemo();
            }
            return;
         }
         _loc2_ = _loc1_ + ":" + (this._moveStyle == "stand" ? "stand" : "walk");
         if(this._appliedLabel == _loc2_)
         {
            return;
         }
         this.scaleX = this.isExplicitFollowLabel(_loc1_) ? 1 : (this._direction & 1) * 2 - 1;
         this._demo.gotoAndStop(_loc1_);
         if(this.isGroupFollowLabel(_loc1_))
         {
            this.playAnimatedTree(this._demo);
         }
         else
         {
            MovieClipUtil.childPlay(this._demo,1);
         }
         this._appliedLabel = _loc2_;
         this.fitCurrentDemo();
      }
      
      private function playAnimatedTree(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:DisplayObjectContainer = null;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_) as MovieClip;
            if(_loc3_ != null)
            {
               if(_loc3_.totalFrames > 1)
               {
                  _loc3_.gotoAndPlay(1);
               }
               this.playAnimatedTree(_loc3_);
            }
            else
            {
               _loc4_ = param1.getChildAt(_loc2_) as DisplayObjectContainer;
               if(_loc4_ != null)
               {
                  this.playAnimatedTree(_loc4_);
               }
            }
            _loc2_++;
         }
      }
      
      private function collectAnimatedFrames(param1:DisplayObjectContainer) : String
      {
         var _loc2_:Array = [];
         this.appendAnimatedFrames(param1,_loc2_,"0");
         return _loc2_.join(",");
      }
      
      private function appendAnimatedFrames(param1:DisplayObjectContainer, param2:Array, param3:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:DisplayObjectContainer = null;
         while(_loc4_ < param1.numChildren)
         {
            _loc5_ = param1.getChildAt(_loc4_) as MovieClip;
            if(_loc5_ != null)
            {
               if(_loc5_.totalFrames > 1)
               {
                  param2.push(param3 + "." + _loc4_ + "=" + _loc5_.currentFrame + "/" + _loc5_.totalFrames);
               }
               this.appendAnimatedFrames(_loc5_,param2,param3 + "." + _loc4_);
            }
            else
            {
               _loc6_ = param1.getChildAt(_loc4_) as DisplayObjectContainer;
               if(_loc6_ != null)
               {
                  this.appendAnimatedFrames(_loc6_,param2,param3 + "." + _loc4_);
               }
            }
            _loc4_++;
         }
      }
      
      private function findDirectionalLabel() : String
      {
         var _loc1_:String = (this._direction & 2) != 0 ? "Up" : "Down";
         var _loc2_:String = _loc1_ == "Up" ? "Down" : "Up";
         var _loc3_:String = this._moveStyle;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:FrameLabel = null;
         var _loc7_:String = null;
         if((this._direction & 2) != 0)
         {
            _loc7_ = (this._direction & 1) != 0 ? "rightup" : "leftup";
         }
         else
         {
            _loc7_ = (this._direction & 1) != 0 ? "rightdown" : "leftdown";
         }
         for each(_loc6_ in this._demo.currentLabels)
         {
            if(_loc6_.name == _loc7_)
            {
               return _loc7_;
            }
         }
         if(this.hasDemoLabel("up") && this.hasDemoLabel("down"))
         {
            return (this._direction & 2) != 0 ? "up" : "down";
         }
         if(_loc3_ != "run" && _loc3_ != "walk")
         {
            _loc3_ = "stand";
         }
         if(_loc3_ == "run")
         {
            _loc4_ = ["run" + _loc1_,"walk" + _loc1_,"stand" + _loc1_,"run" + _loc2_,"walk" + _loc2_,"stand" + _loc2_];
         }
         else if(_loc3_ == "walk")
         {
            _loc4_ = ["walk" + _loc1_,"stand" + _loc1_,"walk" + _loc2_,"stand" + _loc2_];
         }
         else
         {
            _loc4_ = ["stand" + _loc1_,"stand" + _loc2_];
         }
         for each(_loc5_ in _loc4_)
         {
            for each(_loc6_ in this._demo.currentLabels)
            {
               if(_loc6_.name == _loc5_)
               {
                  return _loc5_;
               }
            }
         }
         return "";
      }
      
      private function hasDemoLabel(param1:String) : Boolean
      {
         var _loc2_:FrameLabel = null;
         if(this._demo == null)
         {
            return false;
         }
         for each(_loc2_ in this._demo.currentLabels)
         {
            if(_loc2_.name == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isGroupFollowLabel(param1:String) : Boolean
      {
         return param1 == "leftdown" || param1 == "rightdown" || param1 == "leftup" || param1 == "rightup" || param1 == "left" || param1 == "right" || param1 == "up" || param1 == "down";
      }
      
      private function isExplicitFollowLabel(param1:String) : Boolean
      {
         return param1 == "leftdown" || param1 == "rightdown" || param1 == "leftup" || param1 == "rightup" || param1 == "left" || param1 == "right";
      }
      
      private function fitCurrentDemo() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Number = Number(NaN);
         if(this._demo == null)
         {
            return;
         }
         this._demo.scaleX = this._demo.scaleY = 1;
         this._demo.x = this._demo.y = 0;
         _loc1_ = this._demo.getBounds(this._demo);
         if(_loc1_.width > 0 && _loc1_.height > 0)
         {
            _loc2_ = Math.min(this._fitWidth / _loc1_.width,this._fitHeight / _loc1_.height);
            this._demo.scaleX = this._demo.scaleY = _loc2_;
            this._demo.x = -_loc1_.x * _loc2_ - _loc1_.width * _loc2_ / 2;
            this._demo.y = -_loc1_.y * _loc2_ - _loc1_.height * _loc2_;
         }
         else
         {
            this._demo.scaleX = this._demo.scaleY = this._scaleVal;
         }
      }
   }
}

