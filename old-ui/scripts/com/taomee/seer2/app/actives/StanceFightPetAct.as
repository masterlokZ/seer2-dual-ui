package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   
   public class StanceFightPetAct
   {
      
      private static var _instance:StanceFightPetAct;
      
      private var pointVec:Vector.<MovieClip>;
      
      private var eftVec:Vector.<MovieClip>;
      
      private var pointNum:int;
      
      private var actorList:Vector.<RemoteActor>;
      
      private var hasStandPlayers:Array = [false,false,false,false,false,false,false];
      
      private var boosNpc:Mobile;
      
      private var fightId:uint;
      
      private var isCall:Boolean = false;
      
      public var npcId:uint = 184;
      
      public var showFull:String = "showDragon";
      
      public var leaveFull:String = "leaveDragon";
      
      private var swapCall:int = 817;
      
      public function StanceFightPetAct()
      {
         super();
      }
      
      public static function getInstance() : StanceFightPetAct
      {
         if(!_instance)
         {
            _instance = new StanceFightPetAct();
         }
         return _instance;
      }
      
      public function dispose() : void
      {
         if(this.boosNpc)
         {
            this.boosNpc.removeEventListener("click",this.toFight);
         }
         Connection.removeCommandListener(CommandSet.SYNC_POSITION_1101,this.checkPointPlayer);
         LayerManager.stage.removeEventListener("enterFrame",this.checkPointPlayer);
      }
      
      public function setup(param1:int, param2:int = 7) : void
      {
         this.fightId = param1;
         this.pointNum = param2;
         this.initStancePointVec();
         this.hasStandPlayers = [];
         Connection.addCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,this.getCallState);
         var _loc4_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc3_:String = _loc4_.fullYear.toString();
         if(_loc4_.month < 9)
         {
            _loc3_ = _loc3_ + "0" + (_loc4_.month + 1).toString();
         }
         else
         {
            _loc3_ += (_loc4_.month + 1).toString();
         }
         if(_loc4_.date < 9)
         {
            _loc3_ = _loc3_ + "0" + _loc4_.date.toString();
         }
         else
         {
            _loc3_ += _loc4_.date.toString();
         }
         Connection.send(CommandSet.GET_TOTAL_VOTE_INFO_1219,10,int(_loc3_),int(_loc3_) + 1);
      }
      
      private function getCallState(param1:MessageEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         Connection.removeCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,this.getCallState);
         var _loc5_:IDataInput = param1.message.getRawData();
         var _loc7_:uint = _loc5_.readUnsignedInt();
         var _loc6_:uint = _loc5_.readUnsignedInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc2_ = _loc5_.readUnsignedInt();
            _loc4_ = _loc5_.readUnsignedInt();
            if(_loc4_ != 0)
            {
               this.isCall = true;
            }
            _loc3_++;
         }
         if(!this.isCall && this.isInTime())
         {
            this.setupCheck();
         }
         else if(this.isInTime())
         {
            this.addNpc();
         }
      }
      
      private function setupCheck() : void
      {
         LayerManager.stage.addEventListener("enterFrame",this.checkPointPlayer);
      }
      
      private function checkPointPlayer(param1:* = null) : void
      {
         var _loc7_:Point = null;
         var _loc4_:int = 0;
         this.actorList = ActorManager.getAllRemoteActors();
         var _loc5_:Actor = ActorManager.getActor();
         var _loc6_:int = 0;
         while(_loc6_ < this.pointNum)
         {
            this.hasStandPlayers[_loc6_] = false;
            _loc4_ = 0;
            while(_loc4_ < this.actorList.length)
            {
               _loc7_ = this.actorList[_loc4_].localToGlobal(new Point(0,0));
               if(this.pointVec[_loc6_].hitTestPoint(_loc7_.x,_loc7_.y))
               {
                  this.hasStandPlayers[_loc6_] = true;
                  this.eftVec[_loc6_].gotoAndStop(2);
                  break;
               }
               _loc4_++;
            }
            _loc7_ = _loc5_.localToGlobal(new Point(0,0));
            if(!this.hasStandPlayers[_loc6_] && this.pointVec[_loc6_].hitTestPoint(_loc7_.x,_loc7_.y))
            {
               this.hasStandPlayers[_loc6_] = true;
               this.eftVec[_loc6_].gotoAndStop(2);
            }
            if(!this.hasStandPlayers[_loc6_])
            {
            }
            _loc6_++;
         }
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.pointNum)
         {
            if(this.hasStandPlayers[_loc2_])
            {
               this.eftVec[_loc2_].gotoAndStop(2);
               _loc3_++;
            }
            else
            {
               this.eftVec[_loc2_].gotoAndStop(1);
            }
            _loc2_++;
         }
         if(_loc3_ == this.pointNum)
         {
            LayerManager.stage.removeEventListener("enterFrame",this.checkPointPlayer);
            this.sendCall();
            this.showDragon();
         }
      }
      
      private function sendCall() : void
      {
         SwapManager.swapItem(this.swapCall,1);
      }
      
      private function showDragon() : void
      {
         this.isCall = true;
         MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen(this.showFull),this.addNpc);
      }
      
      private function addNpc() : void
      {
         this.boosNpc = new Mobile();
         this.boosNpc.resourceUrl = URLUtil.getNpcSwf(this.npcId);
         this.boosNpc.buttonMode = true;
         this.boosNpc.x = 545;
         this.boosNpc.y = 230;
         this.boosNpc.addEventListener("click",this.toFight);
         MobileManager.addMobile(this.boosNpc,"npc");
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         if(this.isInTime())
         {
            FightManager.startFightWithWild(this.fightId);
         }
         else
         {
            AlertManager.showAlert("不在活动时间内!!神龙飞已经走了!");
            MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen(this.leaveFull),function():void
            {
               boosNpc.removeEventListener("click",toFight);
               MobileManager.removeMobile(boosNpc,"npc");
            },false,false,1,false);
         }
      }
      
      private function isInTime() : Boolean
      {
         var _loc1_:Date = new Date(TimeManager.getServerTime() * 1000);
         if(_loc1_.hours >= 14 && _loc1_.hours < 15)
         {
            return true;
         }
         if(_loc1_.hours >= 19 && _loc1_.hours < 20)
         {
            return true;
         }
         return false;
      }
      
      private function initStancePointVec() : void
      {
         if(!this.pointVec)
         {
            this.pointVec = new Vector.<MovieClip>(this.pointNum);
            this.eftVec = new Vector.<MovieClip>(this.pointNum);
         }
         var _loc2_:MapModel = SceneManager.active.mapModel;
         var _loc1_:int = 0;
         while(_loc1_ < this.pointNum)
         {
            this.pointVec[_loc1_] = _loc2_.ground["FightPoint" + _loc1_];
            this.eftVec[_loc1_] = _loc2_.ground["eft" + _loc1_];
            this.eftVec[_loc1_].gotoAndStop(1);
            this.eftVec[_loc1_].mouseChildren = this.eftVec[_loc1_].mouseEnabled = false;
            this.pointVec[_loc1_].mouseChildren = this.pointVec[_loc1_].mouseEnabled = false;
            this.hasStandPlayers[_loc1_] = false;
            _loc1_++;
         }
      }
   }
}

