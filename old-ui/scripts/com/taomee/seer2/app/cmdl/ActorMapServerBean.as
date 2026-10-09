package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.gameRule.ring.RingSupport;
   import com.taomee.seer2.app.manager.MapUserStatusManager;
   import com.taomee.seer2.app.morphSystem.MorphManager;
   import com.taomee.seer2.app.morphSystem.MorphSwitch;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.helper.UserInfoParseHelper;
   import com.taomee.seer2.app.processor.activity.ghostMorph.GhostMorphStart;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.SceneType;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   
   public class ActorMapServerBean extends BaseBean
   {
      
      public function ActorMapServerBean()
      {
         super();
         Connection.addCommandListener(CommandSet.LIST_USER_1004,this.onUserList);
         Connection.addCommandListener(CommandSet.USER_ENTER_MAP_1002,this.onUserEnterMap);
         Connection.addCommandListener(CommandSet.USER_LEAVE_MAP_1003,this.onUserLeaveMap);
         finish();
      }
      
      public static function syncToServer() : void
      {
         if(SceneManager.active.type == 2)
         {
            syncLeaveMap();
            syncEnterMap();
         }
         else
         {
            if(SceneManager.prevSceneType != 2)
            {
               syncLeaveMap();
            }
            syncEnterMap();
         }
      }
      
      private static function syncLeaveMap() : void
      {
         Connection.send(CommandSet.USER_LEAVE_MAP_1003);
      }
      
      private static function syncEnterMap() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         var _loc4_:Point = null;
         var _loc3_:int = 0;
         if(SceneManager.active.type != 2)
         {
            _loc2_ = SceneManager.active.mapID;
            _loc1_ = SceneType.getServerType(SceneManager.active.type);
            _loc4_ = SceneManager.active.mapModel.initialPoint;
            _loc3_ = SceneManager.active.mapModel.userBehavior;
            Connection.send(CommandSet.USER_ENTER_MAP_1002,_loc2_,_loc1_,_loc4_.x,_loc4_.y,_loc3_);
            Connection.send(CommandSet.LIST_USER_1004);
         }
         else
         {
            ActorManager.dispatchEvent("actorSyncSvr");
         }
      }
      
      private static function syncToServerComplete() : void
      {
         ActorManager.dispatchEvent("actorSyncSvr");
      }
      
      private function onUserList(param1:MessageEvent) : void
      {
         var _loc3_:UserInfo = null;
         var _loc2_:uint = 0;
         var _loc4_:ByteArray = param1.message.getRawData();
         var _loc6_:int = int(_loc4_.readUnsignedInt());
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = new UserInfo();
            UserInfoParseHelper.parseEnterMap(_loc3_,_loc4_);
            if(_loc3_.id != ActorManager.actorInfo.id)
            {
               ActorManager.createRemoteActor(_loc3_);
               MapUserStatusManager.addMapUser(_loc3_);
               MapUserStatusManager.updateMapUser(_loc3_.id,_loc4_.readUnsignedByte());
            }
            _loc3_.updateNonoInfo(_loc4_);
            _loc3_.morphInfo.morphId = MorphSwitch.morphSwitch(_loc4_.readUnsignedInt());
            _loc2_ = _loc4_.readUnsignedInt();
            _loc3_.isYearVip = _loc4_.readUnsignedInt();
            if(_loc2_ != 0)
            {
               _loc3_.birthdayInfo.isOpen = true;
               _loc3_.birthdayInfo.year = _loc2_ / 10000;
               _loc3_.birthdayInfo.month = _loc2_ % 10000 / 100;
               _loc3_.birthdayInfo.day = _loc2_ % 100;
            }
            if(_loc3_.id != ActorManager.actorInfo.id && _loc3_.morphInfo.morphId != 0)
            {
               MorphManager.startRemoteMorph(_loc3_.morphInfo.morphId,ActorManager.getRemoteActor(_loc3_.id));
            }
            else if(_loc3_.id != ActorManager.actorInfo.id)
            {
               MorphManager.removeMorph(ActorManager.getRemoteActor(_loc3_.id));
            }
            if(_loc3_.id == ActorManager.actorInfo.id)
            {
               GhostMorphStart.startMorph(ActorManager.getActor());
            }
            else
            {
               GhostMorphStart.startMorph(ActorManager.getRemoteActor(_loc3_.id));
            }
            _loc5_++;
         }
      }
      
      private function onUserEnterMap(param1:MessageEvent) : void
      {
         var _loc2_:RemoteActor = null;
         var _loc3_:ByteArray = param1.message.getRawDataCopy();
         var _loc5_:UserInfo = new UserInfo();
         UserInfoParseHelper.parseEnterMap(_loc5_,_loc3_);
         MapUserStatusManager.updateMapUser(_loc5_.id,_loc3_.readUnsignedByte());
         _loc5_.updateNonoInfo(_loc3_);
         _loc5_.morphInfo.morphId = MorphSwitch.morphSwitch(_loc3_.readUnsignedInt());
         var _loc4_:uint = _loc3_.readUnsignedInt();
         _loc5_.isYearVip = _loc3_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            _loc5_.birthdayInfo.isOpen = true;
            _loc5_.birthdayInfo.year = _loc4_ / 10000;
            _loc5_.birthdayInfo.month = _loc4_ % 10000 / 100;
            _loc5_.birthdayInfo.day = _loc4_ % 100;
         }
         if(_loc5_.id == ActorManager.getActor().id)
         {
            ActorManager.actorInfo.activityData = _loc5_.activityData;
            MapUserStatusManager.clearMapUsers();
            MapUserStatusManager.addMapUser(_loc5_);
            syncToServerComplete();
         }
         else
         {
            _loc2_ = ActorManager.getRemoteActor(_loc5_.id);
            if(_loc2_ != null)
            {
               this.addMorph(_loc2_);
            }
            else
            {
               ActorManager.createRemoteActor(_loc5_);
               MapUserStatusManager.addMapUser(_loc5_);
            }
         }
         if(SceneManager.active != null && SceneManager.active.mapID == 81)
         {
            RingSupport.getInstance().onEnterMapUpdate();
         }
      }
      
      private function addMorph(param1:RemoteActor) : void
      {
         if(param1.getInfo().morphInfo.morphId != 0)
         {
            MorphManager.startRemoteMorph(param1.getInfo().morphInfo.morphId,param1);
         }
         else
         {
            MorphManager.removeMorph(param1);
         }
         GhostMorphStart.startMorph(param1);
      }
      
      private function onUserLeaveMap(param1:MessageEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ByteArray = param1.message.getRawDataCopy();
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         _loc3_ = int(_loc2_.readUnsignedByte());
         if(_loc3_ == 1)
         {
            MapUserStatusManager.updateMapUser(_loc4_,1);
         }
         else
         {
            ActorManager.removeRemoteActor(_loc4_);
            MapUserStatusManager.removeMapUser(_loc4_);
         }
      }
   }
}

