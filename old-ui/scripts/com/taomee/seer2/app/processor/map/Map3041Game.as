package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.pet.ActivePet;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.HitTest;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.Timer;
   import org.taomee.utils.DomainUtil;
   import org.taomee.utils.Tick;
   
   public class Map3041Game
   {
      
      private static const Petid:int = 146;
      
      private static const PetsPosition:Array = [new Point(826,325),new Point(788,442),new Point(621,460)];
      
      private static const PetsTargetPos:Point = new Point(315,230);
      
      private var _mapModel:MapModel;
      
      private var _resLibs:ApplicationDomain;
      
      private var _npc:MovieClip;
      
      private var _bloodMC:MovieClip;
      
      private var _startMC:SimpleButton;
      
      private var _leaveMC:SimpleButton;
      
      private var _petsList:Vector.<ActivePet>;
      
      private var _playMcPos:Point;
      
      private var _hitCount:int = 0;
      
      private var _timeCount:int = 30;
      
      private var _timer:Timer;
      
      private var _timerContainer:Sprite;
      
      private var _timerTxt:TextField;
      
      private const petNum:int = 3;
      
      public function Map3041Game(param1:MapModel)
      {
         super();
         this._mapModel = param1;
         this.getDomain();
      }
      
      public function dispose() : void
      {
         this.endGame();
         if(this._startMC)
         {
            DisplayObjectUtil.removeFromParent(this._startMC);
            this._startMC.removeEventListener("click",this.onStart);
            this._startMC = null;
         }
         if(this._leaveMC)
         {
            DisplayObjectUtil.removeFromParent(this._leaveMC);
            this._leaveMC.removeEventListener("click",this.onLeave);
            this._leaveMC = null;
         }
      }
      
      private function getDomain() : void
      {
         QueueLoader.load(URLUtil.getActivityAnimation("protectHomeGame/ProtectHome"),"swf",function(param1:ContentInfo):void
         {
            _resLibs = param1.domain;
            init();
         });
      }
      
      private function init() : void
      {
         LayerManager.uiLayer.visible = false;
         this._npc = this.getMovie("npcMC") as MovieClip;
         this._mapModel.front.addChild(this._npc);
         this._npc.x = 315;
         this._npc.y = 258;
         this._bloodMC = this.getMovie("bloodMC") as MovieClip;
         this._mapModel.front.addChild(this._bloodMC);
         this._bloodMC.x = 265;
         this._bloodMC.y = 80;
         this._bloodMC.gotoAndStop(1);
         this._startMC = this.getMovie("startMc") as SimpleButton;
         this._mapModel.front.addChild(this._startMC);
         this._startMC.x = 460;
         this._startMC.y = 450;
         this._startMC.addEventListener("click",this.onStart);
         this._leaveMC = this.getMovie("leaveMc") as SimpleButton;
         this._leaveMC.x = 600;
         this._leaveMC.y = 450;
         this._mapModel.front.addChild(this._leaveMC);
         this._leaveMC.addEventListener("click",this.onLeave);
         this._timerContainer = this.getMovie("timeContainer") as Sprite;
         this._timerTxt = this._timerContainer["timeTxt"];
         this._mapModel.front.addChild(this._timerContainer);
         this._timerContainer.x = 410;
         this._timerContainer.y = 100;
      }
      
      private function onStart(param1:MouseEvent) : void
      {
         StatisticsManager.sendNovice("0x10034182");
         this._startMC.removeEventListener("click",this.onStart);
         DisplayObjectUtil.removeFromParent(this._startMC);
         this._leaveMC.removeEventListener("click",this.onLeave);
         DisplayObjectUtil.removeFromParent(this._leaveMC);
         ActorManager.getActor().hide();
         this.startGame();
      }
      
      private function onLeave(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         ActorManager.getActor().show();
         this.endGame();
         AlertManager.showConfirm("你确定离开当前场景吗？",function():void
         {
            SceneManager.changeScene(1,70);
         });
      }
      
      private function startGame() : void
      {
         this.createPets();
         this.startTimer();
         Tick.instance.addRender(this.checkHitsTest,100);
      }
      
      private function createPets() : void
      {
         var _loc2_:ActivePet = null;
         this._petsList = new Vector.<ActivePet>();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = new ActivePet(PetsPosition[_loc1_],146);
            _loc2_.speed = 1;
            this._petsList.push(_loc2_);
            this._petsList[_loc1_].addEventListener("click",this.onClickPet);
            this._petsList[_loc1_].targetPoint = PetsTargetPos;
            MobileManager.addMobile(this._petsList[_loc1_],"modelPet");
            _loc1_++;
         }
      }
      
      private function startTimer() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener("timer",this.onTimer);
         this._timer.start();
      }
      
      private function checkHitsTest(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Rectangle = null;
         var _loc4_:ActivePet = null;
         if(this._petsList == null || this._petsList.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._petsList.length)
         {
            _loc4_ = this._petsList[_loc2_];
            if((Boolean(_loc4_)) && HitTest.complexHitTestObject(_loc4_,this._npc))
            {
               _loc5_ = HitTest.intersectionRectangle(_loc4_,this._npc);
               this._hitCount += 1;
               if(this._hitCount >= 10)
               {
                  Tick.instance.removeRender(this.checkHitsTest);
                  this.endGame();
                  this.showGameResult();
               }
               else
               {
                  this._bloodMC.gotoAndStop(this._hitCount + 1);
                  this._playMcPos = new Point(_loc5_.x,_loc5_.y);
                  this.playHitDispose();
                  MobileManager.removeMobile(_loc4_,"modelPet");
                  _loc4_.removeEventListener("click",this.onClickPet);
                  _loc3_ = this._petsList.indexOf(_loc4_);
                  if(_loc3_ != -1)
                  {
                     this._petsList.splice(_loc3_,1);
                  }
                  if(this._petsList.length == 0)
                  {
                     this.createPets();
                  }
               }
            }
            _loc2_++;
         }
      }
      
      private function endGame() : void
      {
         var _loc1_:int = 0;
         LayerManager.uiLayer.visible = true;
         if(this._timer)
         {
            if(this._timer.running)
            {
               this._timer.stop();
            }
            this._timer.removeEventListener("timer",this.onTimer);
            this._timer = null;
         }
         if(this._petsList)
         {
            _loc1_ = 0;
            while(_loc1_ < this._petsList.length)
            {
               MobileManager.removeMobile(this._petsList[_loc1_],"modelPet");
               this._petsList[_loc1_].removeEventListener("click",this.onClickPet);
               _loc1_++;
            }
            this._petsList.length = 0;
         }
         if(Tick.instance.hasRender(this.checkHitsTest))
         {
            Tick.instance.removeRender(this.checkHitsTest);
         }
      }
      
      private function showGameResult() : void
      {
         if(this._hitCount < 10)
         {
            this.win();
         }
         else
         {
            this._bloodMC.gotoAndStop(11);
            this.lose();
         }
      }
      
      private function win() : void
      {
         ModuleManager.showModule(URLUtil.getAppModule("ProtectHomeWinPanel"),"");
         SwapManager.swapItem(2037);
      }
      
      private function lose() : void
      {
         ModuleManager.showModule(URLUtil.getAppModule("ProtectHomeLosePanel"),"");
         SwapManager.swapItem(2046);
      }
      
      private function onClickPet(param1:MouseEvent) : void
      {
         var _loc2_:ActivePet = param1.currentTarget as ActivePet;
         _loc2_.removeEventListener("click",this.onClickPet);
         this._playMcPos = new Point(_loc2_.x,_loc2_.y);
         this.playClickDispose();
         MobileManager.removeMobile(_loc2_,"modelPet");
         var _loc3_:int = this._petsList.indexOf(_loc2_);
         if(_loc3_ != -1)
         {
            this._petsList.splice(_loc3_,1);
         }
         if(this._petsList.length == 0)
         {
            this.createPets();
         }
      }
      
      private function playClickDispose() : void
      {
         this.playMc("ClickDispose");
      }
      
      private function playHitDispose() : void
      {
         this._npc.gotoAndPlay("被攻击");
      }
      
      private function playMc(param1:String) : void
      {
         var mc:MovieClip = null;
         var value:String = param1;
         mc = this.getMovie(value) as MovieClip;
         mc.x = this._playMcPos.x;
         mc.y = this._playMcPos.y;
         this._mapModel.content.addChild(mc);
         MovieClipUtil.playMc(mc,1,mc.totalFrames,function():void
         {
            mc.stop();
            DisplayObjectUtil.removeFromParent(mc);
            mc = null;
         });
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         --this._timeCount;
         if(this._timeCount <= 0)
         {
            this._timeCount = 0;
            this.endGame();
            this.showGameResult();
         }
         this._timerTxt.text = String(this._timeCount);
      }
      
      private function getMovie(param1:String) : DisplayObject
      {
         if(this._resLibs)
         {
            return DomainUtil.getDisplayObject(param1,this._resLibs);
         }
         return null;
      }
   }
}

