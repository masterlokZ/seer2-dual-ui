package com.taomee.seer2.app.processor.activity.lovePaoPaoAct
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.shoot.ShootController;
   import com.taomee.seer2.app.shoot.ShootEvent;
   import com.taomee.seer2.app.shoot.ShootInfo;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.grids.HashMap;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.DomainUtil;
   import org.taomee.utils.Tick;
   
   public class LovePaoPaoAct
   {
      
      private static const SHOOT_SWAP:int = 2481;
      
      private static const UPDATE_TYPE:int = 10;
      
      private static const ACT_INDEX:int = 9;
      
      private static const SHOOT_OVER_ERROR_CODE:int = 200036;
      
      private static const DAY_LIST:Array = [1012,1011];
      
      private static const NUM_RULE:Vector.<int> = Vector.<int>([30,100]);
      
      private var _resLib:ApplicationDomain;
      
      private var _map:MapModel;
      
      private var _actTip:SimpleButton;
      
      private var _resHash:HashMap;
      
      private var _isShootOver:Boolean;
      
      public function LovePaoPaoAct(param1:MapModel)
      {
         var i:int;
         var map:MapModel = param1;
         super();
         this._map = map;
         this._resHash = new HashMap();
         for(i = 0; i < 5; )
         {
            (this._map.content["cloud" + i] as MovieClip).visible = false;
            i++;
         }
         this.addListener();
         this.getURL(function():void
         {
            _actTip = getSimple("ActTip");
            _actTip.x = 10;
            _actTip.y = 150;
            _map.front.addChild(_actTip);
            _actTip.addEventListener("click",onActTip);
            if(isInActTime())
            {
               initHandle();
            }
            else
            {
               SceneManager.changeScene(1,70);
            }
         });
      }
      
      private function onActTip(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("ShootIntroducePanel"));
      }
      
      private function getURL(param1:Function = null) : void
      {
         var callBack:Function = param1;
         QueueLoader.load(URLUtil.getActivityAnimation("lovePaoPaoAct/LovePaoPaoAct"),"swf",function(param1:ContentInfo):void
         {
            _resLib = param1.domain;
            if(callBack != null)
            {
               callBack();
            }
         });
      }
      
      private function initHandle() : void
      {
         this._resHash = new HashMap();
         this.showSelf();
         this.updateShootOtherState();
         Tick.instance.addRender(this.actTimeValidate,4000);
         ShootController.addEventListener("playEnd",this.onShootEnd);
      }
      
      private function onShootEnd(param1:ShootEvent) : void
      {
         var evt:ShootEvent = param1;
         var shootActor:RemoteActor = this.getCurShootActor(evt.info);
         if(shootActor)
         {
            if(this._isShootOver)
            {
               ServerMessager.addMessage("你当前射击获得泡泡的次数已用完，明天再来吧!");
               return;
            }
            SwapManager.swapItem(2481,1,function(param1:IDataInput):void
            {
               new SwapInfo(param1);
            },function(param1:uint):void
            {
               if(param1 == 200036)
               {
                  ServerMessager.addMessage("你当前射击获得泡泡的次数已用完，明天再来吧!");
                  _isShootOver = true;
               }
            },new SpecialInfo(1,shootActor.getInfo().id));
         }
      }
      
      private function getCurShootActor(param1:ShootInfo) : RemoteActor
      {
         var _loc3_:RemoteActor = null;
         var _loc2_:RemoteActor = null;
         if(param1.userID == ActorManager.actorInfo.id)
         {
            for each(_loc3_ in ActorManager.getAllRemoteActors())
            {
               if(Boolean(this._resHash.getValue(_loc3_.getInfo().id)) && (this._resHash.getValue(_loc3_.getInfo().id) as MovieClip).hitTestPoint(param1.endPos.x,param1.endPos.y))
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      private function updateShootOtherState() : void
      {
         DayLimitManager.getDoCount(DAY_LIST[1],function(param1:int):void
         {
            if(param1 >= NUM_RULE[1])
            {
               _isShootOver = true;
            }
            else
            {
               _isShootOver = false;
            }
         });
      }
      
      private function addListener() : void
      {
         Connection.addCommandListener(CommandSet.LIST_USER_1004,this.listUsers);
         Connection.addCommandListener(CommandSet.USER_ENTER_MAP_1002,this.addUser);
         Connection.addCommandListener(CommandSet.FROZEN_ACTIVITY_TYPE_1151,this.onBroadCast);
      }
      
      private function removeListener() : void
      {
         Connection.removeCommandListener(CommandSet.LIST_USER_1004,this.listUsers);
         Connection.removeCommandListener(CommandSet.USER_ENTER_MAP_1002,this.addUser);
         Connection.removeCommandListener(CommandSet.FROZEN_ACTIVITY_TYPE_1151,this.onBroadCast);
      }
      
      private function onBroadCast(param1:MessageEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc4_:RemoteActor = null;
         if(SceneManager.active.mapID != 3820)
         {
            return;
         }
         var _loc5_:IDataInput = param1.message.getRawData();
         var _loc7_:uint = _loc5_.readUnsignedInt();
         var _loc6_:uint = _loc5_.readUnsignedInt();
         var _loc3_:uint = _loc5_.readUnsignedInt();
         if(_loc7_ == 10)
         {
            if(ActorManager.actorInfo.id == _loc3_)
            {
               _loc2_ = this._resHash.getValue(_loc3_) as MovieClip;
               if(_loc2_)
               {
                  DisplayUtil.removeForParent(this._resHash.getValue(_loc3_) as MovieClip);
                  this._resHash.remove(_loc3_);
               }
               else
               {
                  TweenNano.delayedCall(3,this.onRemoveHoly,[_loc3_]);
               }
            }
            else
            {
               _loc4_ = ActorManager.getRemoteActor(_loc3_);
               if(_loc4_)
               {
                  DisplayUtil.removeForParent(this._resHash.getValue(_loc3_) as MovieClip);
                  this._resHash.remove(_loc3_);
               }
            }
         }
      }
      
      private function actTimeValidate(param1:int) : void
      {
         if(!this.isInActTime())
         {
            Tick.instance.removeRender(this.actTimeValidate);
            ShootController.removeEventListener("playEnd",this.onShootEnd);
            ServerMessager.addMessage("街心花园即将关闭，每天13:00-14:00、18:00-19:00是花园开放时间。");
            SceneManager.changeScene(1,70);
         }
      }
      
      private function listUsers(param1:MessageEvent) : void
      {
         var _loc4_:MovieClip = null;
         var _loc3_:RemoteActor = null;
         if(SceneManager.active.mapID != 3820)
         {
            return;
         }
         var _loc2_:Vector.<RemoteActor> = ActorManager.getAllRemoteActors();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getInfo().activityData[9] < 30)
            {
               _loc4_ = this.getMovieClip("LoveMark");
               if(_loc4_ == null)
               {
                  TweenNano.delayedCall(3,this.onAddHoly,[DisplayObjectContainer(_loc3_.animation),_loc4_,_loc3_.getInfo().id]);
               }
               else
               {
                  this._resHash.put(_loc3_.getInfo().id,_loc4_);
                  _loc4_.y = -105;
                  DisplayObjectContainer(_loc3_.animation).addChild(_loc4_);
               }
            }
         }
      }
      
      private function onRemoveHoly(param1:int) : void
      {
         var _loc2_:MovieClip = this._resHash.getValue(param1) as MovieClip;
         if(_loc2_)
         {
            DisplayUtil.removeForParent(this._resHash.getValue(param1) as MovieClip);
            this._resHash.remove(param1);
         }
         else
         {
            TweenNano.delayedCall(2,this.onRemoveHoly,[param1]);
         }
      }
      
      private function onAddHoly(param1:DisplayObjectContainer, param2:MovieClip, param3:int) : void
      {
         var _loc5_:DisplayObjectContainer = param1;
         var _loc4_:MovieClip = param2;
         _loc4_ = this.getMovieClip("LoveMark");
         if(_loc4_)
         {
            _loc4_.x = -_loc4_.width / 2;
            _loc4_.y = -130;
            _loc5_.addChild(_loc4_);
            this._resHash.put(param3,_loc4_);
         }
         else
         {
            TweenNano.delayedCall(2,this.onAddHoly,[_loc5_,_loc4_,param3]);
         }
      }
      
      private function showSelf() : void
      {
         DayLimitManager.getDoCount(DAY_LIST[0],function(param1:int):void
         {
            var _loc2_:MovieClip = null;
            if(param1 < NUM_RULE[0])
            {
               _loc2_ = getMovieClip("LoveMark");
               _resHash.put(ActorManager.getActor().id,_loc2_);
               _loc2_.y = -105;
               DisplayObjectContainer(ActorManager.getActor().animation).addChild(_loc2_);
            }
         });
      }
      
      private function removeSelf() : void
      {
         var _loc1_:MovieClip = this._resHash.getValue(ActorManager.getActor().id) as MovieClip;
         if(_loc1_)
         {
            DisplayUtil.removeForParent(_loc1_);
         }
      }
      
      private function getMovieClip(param1:String) : MovieClip
      {
         if(this._resLib)
         {
            return DomainUtil.getMovieClip(param1,this._resLib);
         }
         return null;
      }
      
      private function getSimple(param1:String) : SimpleButton
      {
         if(this._resLib)
         {
            return DomainUtil.getSimpleButton(param1,this._resLib);
         }
         return null;
      }
      
      private function addUser(param1:MessageEvent) : void
      {
         var _loc4_:RemoteActor = null;
         var _loc2_:MovieClip = null;
         if(SceneManager.active.mapID != 3820)
         {
            return;
         }
         var _loc3_:ByteArray = param1.message.getRawDataCopy();
         var _loc5_:int = int(_loc3_.readUnsignedInt());
         _loc4_ = ActorManager.getRemoteActor(_loc5_);
         if(_loc4_)
         {
            if(_loc4_.getInfo().activityData[9] < 30)
            {
               _loc2_ = this.getMovieClip("LoveMark");
               this._resHash.put(_loc4_.getInfo().id,_loc2_);
               if(_loc2_ == null)
               {
                  TweenNano.delayedCall(5,this.onAddHoly,[DisplayObjectContainer(_loc4_.animation),_loc2_]);
               }
               else
               {
                  _loc2_.y = -105;
                  DisplayObjectContainer(_loc4_.animation).addChild(_loc2_);
               }
            }
         }
      }
      
      private function isInActTime() : Boolean
      {
         var _loc1_:Boolean = false;
         if(DateUtil.isInTime(new Date(2016,10,11,6,0,0),new Date(2016,10,18,23,59,0)))
         {
            if(DateUtil.isInHourScope(13,14,0,0) || DateUtil.isInHourScope(18,19,0,0))
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this.removeSelf();
         this._resHash.clear();
         this.removeListener();
         if(this._actTip)
         {
            this._actTip.removeEventListener("click",this.onActTip);
            this._actTip = null;
         }
         ShootController.removeEventListener("playEnd",this.onShootEnd);
         Tick.instance.removeRender(this.actTimeValidate);
      }
   }
}

