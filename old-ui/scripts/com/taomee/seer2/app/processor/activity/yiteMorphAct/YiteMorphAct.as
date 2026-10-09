package com.taomee.seer2.app.processor.activity.yiteMorphAct
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.morphSystem.MorphManager;
   import com.taomee.seer2.app.morphSystem.MorphSwitch;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.shopManager.PayManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.DomainUtil;
   import org.taomee.utils.Tick;
   
   public class YiteMorphAct
   {
      
      private var _resLib:ApplicationDomain;
      
      private var _map:MapModel;
      
      private var _timeMC:MovieClip;
      
      private var _time:TextField;
      
      private var _changeSet:MovieClip;
      
      private var _changeBuy:MovieClip;
      
      private const MORPH_DAY:int = 824;
      
      private const MORPH_TIME_FOR:uint = 203273;
      
      private const MORPH_SWAP:int = 1924;
      
      private const SEC_TIME:int = 600;
      
      private const CD_OVER_MI_ID:uint = 603315;
      
      private var _leaveTime:uint;
      
      public function YiteMorphAct(param1:MapModel)
      {
         super();
         this._map = param1;
         this.getURL();
      }
      
      private function getURL() : void
      {
         this.addNetListener();
         QueueLoader.load(URLUtil.getActivityAnimation("YiteMorphAct"),"swf",function(param1:ContentInfo):void
         {
            _resLib = param1.domain;
            initSet();
            initEvent();
         });
      }
      
      private function addNetListener() : void
      {
         Connection.addCommandListener(CommandSet.LIST_USER_1004,this.listUsers);
         Connection.addCommandListener(CommandSet.USER_ENTER_MAP_1002,this.addUser);
         Connection.addCommandListener(CommandSet.FROZEN_ACTIVITY_TYPE_1151,this.onBroadCast);
      }
      
      private function initSet() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = this.getMovie("YiteMorphSet");
         this._timeMC = _loc1_["timeMC"];
         this._time = this._timeMC["time"];
         this._changeSet = _loc1_["changeSet"];
         this._changeBuy = _loc1_["changeBuy"];
         this._changeBuy.buttonMode = true;
         _loc1_.x = 250;
         _loc1_.y = 260;
         this._map.content.addChild(_loc1_);
         this.updateSelfMorph();
         this.morphTimeUpdate();
      }
      
      private function initEvent() : void
      {
         this._changeBuy.addEventListener("click",this.onChangeBuy);
         this._changeSet.addEventListener("click",this.onChangeSet);
      }
      
      private function removeListener() : void
      {
         Connection.removeCommandListener(CommandSet.LIST_USER_1004,this.listUsers);
         Connection.removeCommandListener(CommandSet.USER_ENTER_MAP_1002,this.addUser);
         Connection.removeCommandListener(CommandSet.FROZEN_ACTIVITY_TYPE_1151,this.onBroadCast);
         this._changeBuy.removeEventListener("click",this.onChangeBuy);
         this._changeSet.removeEventListener("click",this.onChangeSet);
      }
      
      private function onChangeBuy(param1:MouseEvent) : void
      {
         if([36,37].indexOf(ActorManager.actorInfo.clientCacheData[0]) != -1)
         {
            AlertManager.showAlert("你已经获得满足挑战条件的伊特变身状态了，不需要再购买变身卡了!");
            return;
         }
         ModuleManager.showModule(URLUtil.getAppModule("YiteMorphBuyPanel"),"正在打开伊特变身卡购买面板...");
      }
      
      private function onChangeSet(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         if([36,37].indexOf(ActorManager.actorInfo.clientCacheData[0]) != -1)
         {
            AlertManager.showAlert("你已经获得满足挑战条件的伊特变身状态了，不需要再变身了哦!");
            return;
         }
         if(this._timeMC.visible)
         {
            AlertManager.showConfirm("你确定花费5星钻跳过冷却时间吗?",function():void
            {
               PayManager.buyItem(603315,function():void
               {
                  morphTimeUpdate();
               });
            });
         }
         else
         {
            SwapManager.swapItem(1924,1,function(param1:IDataInput):void
            {
               updateSelfMorph();
            });
         }
      }
      
      private function onBroadCast(param1:MessageEvent) : void
      {
         if(SceneManager.active.mapID != 984)
         {
            return;
         }
         var _loc4_:IDataInput = param1.message.getRawData();
         var _loc6_:uint = _loc4_.readUnsignedInt();
         var _loc5_:uint = _loc4_.readUnsignedInt();
         var _loc3_:uint = _loc4_.readUnsignedInt();
         var _loc2_:uint = _loc4_.readUnsignedInt();
         if(ActorManager.actorInfo.id == _loc3_)
         {
            this.updateSelfMorph();
            this.morphTimeUpdate();
         }
         else
         {
            this.updateOtherMorph(_loc3_,_loc2_);
         }
      }
      
      private function morphTimeUpdate() : void
      {
         this.setChangeSetEnable(false);
         Tick.instance.removeRender(this.updateTime);
         ActiveCountManager.requestActiveCount(203273,function(param1:int, param2:int):void
         {
            if(TimeManager.getServerTime() <= param2)
            {
               _leaveTime = 600;
               updateTimeShow();
               _timeMC.visible = true;
               setChangeSetEnable(true);
               Tick.instance.addRender(updateTime,1000);
            }
            else
            {
               if(TimeManager.getServerTime() - param2 >= 600)
               {
                  _leaveTime = 0;
               }
               else
               {
                  _leaveTime = 600 - (TimeManager.getServerTime() - param2);
               }
               if(_leaveTime == 0)
               {
                  _timeMC.visible = false;
                  setChangeSetEnable(true);
               }
               else
               {
                  updateTimeShow();
                  _timeMC.visible = true;
                  setChangeSetEnable(true);
                  Tick.instance.addRender(updateTime,1000);
               }
            }
         });
      }
      
      private function setChangeSetEnable(param1:Boolean) : void
      {
         this._changeSet.buttonMode = this._changeSet.mouseEnabled = this._changeSet.mouseChildren = param1;
      }
      
      private function updateTime(param1:int) : void
      {
         --this._leaveTime;
         this.updateTimeShow();
         if(this._leaveTime <= 0)
         {
            this._timeMC.visible = false;
            this.setChangeSetEnable(true);
            Tick.instance.removeRender(this.updateTime);
         }
      }
      
      private function updateTimeShow() : void
      {
         this._time.text = this.styleChange(this._leaveTime);
      }
      
      public function styleChange(param1:int) : String
      {
         var _loc5_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = param1 / 60;
         var _loc4_:int = param1 % 60;
         if(_loc3_ <= 9)
         {
            _loc5_ = "0" + String(_loc3_);
         }
         else
         {
            _loc5_ = String(_loc3_);
         }
         if(_loc4_ <= 9)
         {
            _loc2_ = "0" + String(_loc4_);
         }
         else
         {
            _loc2_ = String(_loc4_);
         }
         return _loc5_ + ":" + _loc2_;
      }
      
      private function listUsers(param1:MessageEvent) : void
      {
         var _loc3_:RemoteActor = null;
         if(SceneManager.active.mapID != 984)
         {
            return;
         }
         var _loc2_:Vector.<RemoteActor> = ActorManager.getAllRemoteActors();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getInfo().activityData.length >= 7)
            {
               this.updateOtherMorph(_loc3_.getInfo().id,_loc3_.getInfo().activityData[6]);
            }
         }
      }
      
      private function updateSelfMorph() : void
      {
         DayLimitManager.getDoCount(824,function(param1:int):void
         {
            var _loc2_:int = 0;
            if(param1 > 0)
            {
               _loc2_ = int(MorphSwitch.morphSwitch(param1));
               if(param1 > 37)
               {
                  _loc2_ = 0;
                  param1 = 0;
                  ActorManager.actorInfo.clientCacheData[0] = param1;
                  return;
               }
               ActorManager.actorInfo.clientCacheData[0] = param1;
               MorphManager.startThisMorph(_loc2_);
            }
            else
            {
               ActorManager.actorInfo.clientCacheData[0] = 0;
               MorphManager.removeMorph(ActorManager.getActor());
            }
         });
      }
      
      private function updateOtherMorph(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:RemoteActor = ActorManager.getRemoteActor(param1);
         if(_loc4_)
         {
            _loc3_ = int(MorphSwitch.morphSwitch(param2));
            if(param2 > 37)
            {
               _loc3_ = 0;
               param2 = 0;
            }
            _loc4_.getInfo().clientCacheData[0] = param2;
            if(_loc3_ == 0)
            {
               return;
            }
            MorphManager.startRemoteMorph(_loc3_,_loc4_);
         }
      }
      
      private function removeSelfMorph() : void
      {
         ActorManager.actorInfo.clientCacheData[0] = 0;
         MorphManager.removeMorph(ActorManager.getActor());
      }
      
      private function getMovie(param1:String) : MovieClip
      {
         if(this._resLib)
         {
            return DomainUtil.getMovieClip(param1,this._resLib);
         }
         return null;
      }
      
      private function addUser(param1:MessageEvent) : void
      {
         var _loc4_:RemoteActor = null;
         var _loc2_:int = 0;
         if(SceneManager.active.mapID != 984)
         {
            return;
         }
         var _loc3_:ByteArray = param1.message.getRawDataCopy();
         var _loc5_:int = int(_loc3_.readUnsignedInt());
         _loc4_ = ActorManager.getRemoteActor(_loc5_);
         if(_loc4_)
         {
            if(_loc4_.getInfo().activityData.length >= 7)
            {
               _loc2_ = int(_loc4_.getInfo().activityData[6]);
               this.updateOtherMorph(_loc5_,_loc2_);
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeSelfMorph();
         this.removeListener();
         Tick.instance.removeRender(this.updateTime);
         this._resLib = null;
         this._map = null;
         this._timeMC = null;
         this._time = null;
         this._changeSet = null;
         this._changeBuy = null;
      }
   }
}

