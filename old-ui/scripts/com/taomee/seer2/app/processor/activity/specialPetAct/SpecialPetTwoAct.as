package com.taomee.seer2.app.processor.activity.specialPetAct
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.shoot.ShootController;
   import com.taomee.seer2.app.shoot.ShootEvent;
   import com.taomee.seer2.app.shoot.ShootInfo;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.utils.IDataInput;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.DomainUtil;
   import org.taomee.utils.Tick;
   
   public class SpecialPetTwoAct
   {
      
      private static var _playerBloodScale:Number = 0;
      
      private var _resLib:ApplicationDomain;
      
      private var _mapModel:MapModel;
      
      private var _pointSp:MovieClip;
      
      private var _pointList:Vector.<MovieClip>;
      
      private var _effectList:Vector.<MovieClip>;
      
      private var _worldBoss:MovieClip;
      
      private var _playerBlood:MovieClip;
      
      private const POINT_NUM:int = 5;
      
      private const BOSS_BLOOD_MAX:int = 5000;
      
      private const ATTACK_TIME:Vector.<int> = Vector.<int>([20,40,60]);
      
      private const CALL_BOSS_SWAP:int = 1675;
      
      private const ATTACK_BOSS_SWAP:int = 1676;
      
      private const FIGHT_INDEX:int = 526;
      
      private const FIGHT_DAY:int = 741;
      
      private var _curBlood:int;
      
      private var _timeIndex:int;
      
      private var _stopAttackedCircle:Boolean;
      
      private var _type:int;
      
      public function SpecialPetTwoAct(param1:MapModel)
      {
         super();
         this._mapModel = param1;
         if(!(DateUtil.isInHourScope(13,14,0,0) || DateUtil.isInHourScope(19,20,0,0)))
         {
            SceneManager.changeScene(1,70);
            return;
         }
         this.afterFightTipHandle(this.getURL);
      }
      
      private function getURL() : void
      {
         QueueLoader.load(URLUtil.getActivityAnimation("specialPetAct/specialPetAct"),"swf",function(param1:ContentInfo):void
         {
            _resLib = param1.domain;
            init();
         });
      }
      
      private function afterFightTipHandle(param1:Function) : void
      {
         var func:Function = param1;
         if(SceneManager.prevSceneType == 2 && FightManager.currentFightRecord.initData.positionIndex == 526)
         {
            DayLimitManager.getDoCount(741,function(param1:int):void
            {
               var _loc2_:int = 0;
               if(ActorManager.actorInfo.vipInfo.isVip())
               {
                  _loc2_ = 15 - param1;
               }
               else
               {
                  _loc2_ = 10 - param1;
               }
               if(_loc2_ > 0)
               {
                  ServerMessager.addMessage("今天还剩" + _loc2_ + "次挑战机会!");
                  func();
               }
               else
               {
                  SceneManager.changeScene(1,70);
               }
            });
         }
         else
         {
            func();
         }
      }
      
      private function init() : void
      {
         Connection.addCommandListener(CommandSet.CLI_GET_WORLD_BOSS_BLOOD_DIMUSEN_1537,this.onGetState);
         Connection.send(CommandSet.CLI_GET_WORLD_BOSS_BLOOD_DIMUSEN_1537);
         Tick.instance.addRender(this.actTimeValidate,10000);
      }
      
      private function actTimeValidate(param1:int) : void
      {
         if(!(DateUtil.isInHourScope(13,14,0,0) || DateUtil.isInHourScope(19,20,0,0)))
         {
            Tick.instance.removeRender(this.actTimeValidate);
            SceneManager.changeScene(1,70);
         }
      }
      
      private function onGetState(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawDataCopy();
         var _loc3_:int = _loc2_.readByte();
         if(this._type == 1 && _loc3_ == 2)
         {
            ServerMessager.addMessage("强大的蒂姆森已经被大家齐心协力击败，赶快去挑战它吧!");
         }
         this._type = _loc3_;
         switch(_loc3_)
         {
            case 0:
               this.callWorldBossHandle(_loc2_);
               break;
            case 1:
               this.attackWorldBossHandle(_loc2_);
               break;
            case 2:
               this.fightPetHandle(_loc2_);
         }
      }
      
      private function callWorldBossHandle(param1:IDataInput) : void
      {
         this._pointList = new Vector.<MovieClip>();
         this._effectList = new Vector.<MovieClip>();
         this._pointSp = this.getMovie("PointList");
         this._mapModel.content.addChild(this._pointSp);
         this._pointSp.mouseEnabled = this._pointSp.mouseChildren = false;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this._pointList.push(this._pointSp["thisPoint" + _loc2_]);
            this._effectList.push(this._pointSp["effect" + _loc2_]);
            _loc2_++;
         }
         LayerManager.stage.addEventListener("enterFrame",this.checkPointPlayer);
         this._stopAttackedCircle = true;
      }
      
      private function checkPointPlayer(param1:Event) : void
      {
         var _loc9_:Point = null;
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         if(this._pointList == null || this._effectList == null)
         {
            return;
         }
         var _loc8_:Vector.<RemoteActor> = ActorManager.getAllRemoteActors();
         var _loc10_:Actor = ActorManager.getActor();
         var _loc4_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            _loc4_[_loc3_] = false;
            _loc9_ = _loc10_.localToGlobal(new Point(0,0));
            if(this._pointList == null || this._effectList == null)
            {
               return;
            }
            if(!_loc4_[_loc3_] && this._pointList[_loc3_].hitTestPoint(_loc9_.x,_loc9_.y))
            {
               _loc4_[_loc3_] = true;
               this._effectList[_loc3_].gotoAndStop(2);
            }
            else
            {
               _loc2_ = 0;
               while(true)
               {
                  if(_loc2_ >= _loc8_.length)
                  {
                     break;
                  }
                  if(this._pointList == null || this._effectList == null)
                  {
                     return;
                  }
                  _loc9_ = _loc8_[_loc2_].localToGlobal(new Point(0,0));
                  if(this._pointList[_loc3_].hitTestPoint(_loc9_.x,_loc9_.y))
                  {
                     if(this._pointList == null || this._effectList == null)
                     {
                        return;
                     }
                     _loc4_[_loc3_] = true;
                     this._effectList[_loc3_].gotoAndStop(2);
                     break;
                  }
                  _loc2_++;
               }
            }
            _loc3_++;
         }
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < 5)
         {
            if(this._pointList == null || this._effectList == null)
            {
               return;
            }
            if(_loc4_[_loc6_])
            {
               this._effectList[_loc6_].gotoAndStop(2);
               _loc7_++;
            }
            else
            {
               this._effectList[_loc6_].gotoAndStop(1);
            }
            _loc6_++;
         }
         if(_loc7_ == 5)
         {
            LayerManager.stage.removeEventListener("enterFrame",this.checkPointPlayer);
            this.sendCall();
            this.showWorldBoss();
            if(this._pointList == null || this._effectList == null)
            {
               return;
            }
            _loc5_ = 0;
            while(_loc5_ < this._effectList.length)
            {
               this._effectList[_loc5_].gotoAndStop(1);
               _loc5_++;
            }
         }
      }
      
      private function sendCall() : void
      {
         SwapManager.swapItem(1675,1);
      }
      
      private function showWorldBoss() : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("specialPetAct/callBoss"),this.attackWorldBossHandle);
      }
      
      private function attackWorldBossHandle(param1:IDataInput = null) : void
      {
         if(param1)
         {
            this._curBlood = param1.readUnsignedInt();
            this.addSafePoints();
            this.addWorldBoss();
            this.updateBlood();
            if(this._curBlood > 0)
            {
               if(!ShootController.hasEventListener("playEnd"))
               {
                  ShootController.addEventListener("playEnd",this.onShootOver);
               }
            }
            if(this._curBlood <= 0)
            {
               ShootController.removeEventListener("playEnd",this.onShootOver);
               this.fightPetHandle();
               this.hideBlood();
            }
         }
         else
         {
            this._curBlood = 5000;
            this.addWorldBoss();
            this.updateBlood();
            ShootController.addEventListener("playEnd",this.onShootOver);
         }
         this.playerAttackedHandle();
      }
      
      private function addSafePoints() : void
      {
         if(!this._pointList)
         {
            this._pointList = new Vector.<MovieClip>();
         }
         if(!this._effectList)
         {
            this._effectList = new Vector.<MovieClip>();
         }
         if(!this._pointSp)
         {
            this._pointSp = this.getMovie("PointList");
         }
         this._mapModel.content.addChild(this._pointSp);
         this._pointSp.mouseEnabled = this._pointSp.mouseChildren = false;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._effectList.push(this._pointSp["effect" + _loc1_]);
            this._pointList.push(this._pointSp["thisPoint" + _loc1_]);
            _loc1_++;
         }
      }
      
      private function removeSafePoints() : void
      {
         if(this._pointList)
         {
            this._pointList = null;
         }
         if(this._effectList)
         {
            this._effectList = null;
         }
         if(this._pointSp)
         {
            DisplayUtil.removeForParent(this._pointSp);
            this._pointSp = null;
         }
      }
      
      private function playerAttackedHandle() : void
      {
         if(!this._playerBlood)
         {
            if(_playerBloodScale <= 0)
            {
               _playerBloodScale = 1;
            }
            this.addPlayerBlood();
            (this._playerBlood["bar"] as MovieClip).scaleX = _playerBloodScale;
            this._stopAttackedCircle = false;
            this.playerAttackedCircle();
         }
      }
      
      private function playerAttackedCircle() : void
      {
         var time:int;
         var pointIndex:int;
         var safeEffect:MovieClip = null;
         var safePointTarget:MovieClip = null;
         if(this._stopAttackedCircle == true)
         {
            clearInterval(this._timeIndex);
            return;
         }
         if(this._effectList == null || this._pointList == null)
         {
            return;
         }
         time = this.getRandomIndex(this.ATTACK_TIME);
         pointIndex = this.getRandom(0,4);
         safeEffect = this._effectList[pointIndex];
         safePointTarget = this._pointList[pointIndex];
         this._timeIndex = setTimeout(function():void
         {
            clearInterval(_timeIndex);
            safeEffect.gotoAndPlay(3);
            _timeIndex = setTimeout(function():void
            {
               var playerPoint:*;
               clearInterval(_timeIndex);
               playerPoint = ActorManager.getActor().localToGlobal(new Point(0,0));
               if(!_playerBlood)
               {
                  return;
               }
               if(!safePointTarget.hitTestPoint(playerPoint.x,playerPoint.y))
               {
                  _playerBloodScale = Number((_playerBloodScale - 0.05).toFixed(2));
                  (_playerBlood["bar"] as MovieClip).scaleX = _playerBloodScale;
               }
               MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("specialPetAct/attacked"),function():void
               {
                  if(_playerBloodScale <= 0)
                  {
                     SceneManager.changeScene(1,70);
                     _stopAttackedCircle = true;
                     return;
                  }
                  safeEffect.gotoAndStop(1);
                  if(_stopAttackedCircle == true)
                  {
                     clearInterval(_timeIndex);
                     return;
                  }
                  if(_effectList == null || _pointList == null)
                  {
                     return;
                  }
                  if(!_playerBlood)
                  {
                     return;
                  }
                  playerAttackedCircle();
               });
            },10000);
         },time * 1000);
      }
      
      private function getRandomIndex(param1:Vector.<int>) : int
      {
         return param1[this.getRandom(0,param1.length - 1)];
      }
      
      private function getRandom(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         _loc3_ = param1 + (int(Math.random() * (param2 - param1) + 0.5));
         if(_loc3_ > param2)
         {
            _loc3_ = param2;
         }
         return _loc3_;
      }
      
      private function addPlayerBlood() : void
      {
         this.hidePlayerBlood();
         this._playerBlood = this.getMovie("PlayerBlood");
         var _loc1_:Actor = ActorManager.getActor();
         this._playerBlood.x = -this._playerBlood.width / 2;
         this._playerBlood.y = -_loc1_.height - 10;
         ActorManager.getActor().addChild(this._playerBlood);
      }
      
      private function hidePlayerBlood() : void
      {
         DisplayUtil.removeForParent(this._playerBlood);
         this._playerBlood = null;
      }
      
      private function onShootOver(param1:ShootEvent) : void
      {
         var _loc2_:ShootInfo = param1.info;
         if(this._worldBoss["boss"].hitTestPoint(_loc2_.endPos.x,_loc2_.endPos.y))
         {
            if(_loc2_.userID == ActorManager.actorInfo.id)
            {
               SwapManager.swapItem(1676,1);
            }
            (this._worldBoss["boss"] as MovieClip).gotoAndPlay(2);
         }
      }
      
      private function addWorldBoss() : void
      {
         if(!this._worldBoss)
         {
            this._worldBoss = this.getMovie("Boss");
         }
         (this._worldBoss["boss"] as MovieClip).buttonMode = true;
         this._mapModel.content.addChild(this._worldBoss);
      }
      
      private function updateBlood() : void
      {
         if(this._worldBoss)
         {
            (this._worldBoss["bloodShow"]["bar"] as MovieClip).scaleX = this._curBlood / 5000;
         }
      }
      
      private function hideBlood() : void
      {
         if(this._worldBoss)
         {
            (this._worldBoss["bloodShow"] as MovieClip).visible = false;
         }
      }
      
      private function hideTip() : void
      {
         if(this._worldBoss)
         {
            (this._worldBoss["tip"] as MovieClip).stop();
            (this._worldBoss["tip"] as MovieClip).visible = false;
         }
      }
      
      private function fightPetHandle(param1:IDataInput = null) : void
      {
         this._stopAttackedCircle = true;
         this.addWorldBoss();
         this.hideBlood();
         this.hideTip();
         this.hidePlayerBlood();
         this.removeSafePoints();
         (this._worldBoss["boss"] as MovieClip).addEventListener("click",this.onFightPet);
      }
      
      private function onFightPet(param1:MouseEvent) : void
      {
         ModuleManager.showModule(URLUtil.getAppModule("SpecialPetActFightPanel"),"正在打开稀有精灵单人挑战面板...",2);
      }
      
      private function getMovie(param1:String) : MovieClip
      {
         if(this._resLib)
         {
            return DomainUtil.getMovieClip(param1,this._resLib);
         }
         return null;
      }
      
      public function dispose() : void
      {
         this._mapModel = null;
         this._stopAttackedCircle = true;
         clearInterval(this._timeIndex);
         LayerManager.stage.removeEventListener("enterFrame",this.checkPointPlayer);
         this._pointList = null;
         this._effectList = null;
         DisplayUtil.removeForParent(this._pointSp);
         this._pointSp = null;
         if(this._worldBoss)
         {
            (this._worldBoss["boss"] as MovieClip).removeEventListener("click",this.onFightPet);
            DisplayUtil.removeForParent(this._worldBoss);
            this._worldBoss = null;
         }
         if(this._playerBlood)
         {
            DisplayUtil.removeForParent(this._playerBlood);
            this._playerBlood = null;
         }
         ShootController.removeEventListener("playEnd",this.onShootOver);
         Connection.removeCommandListener(CommandSet.CLI_GET_WORLD_BOSS_BLOOD_DIMUSEN_1537,this.onGetState);
      }
   }
}

