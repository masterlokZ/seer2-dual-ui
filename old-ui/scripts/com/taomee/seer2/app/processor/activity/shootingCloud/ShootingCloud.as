package com.taomee.seer2.app.processor.activity.shootingCloud
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.FightVerifyManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1051;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.shoot.ShootController;
   import com.taomee.seer2.app.shoot.ShootEvent;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.IDataInput;
   
   public class ShootingCloud
   {
      
      private const PET_SHOW:String = "activityPetShow";
      
      private const PET_HIDE:String = "activityPetHide";
      
      private const CLOUD_CONIS:String = "cloudConis";
      
      private const CLOUD_YUMAO:String = "cloudYumao";
      
      private const CLOUD_GUOSHI:String = "cloudGuoshi";
      
      private const CLOUD_FIGHT:String = "cloudFight";
      
      private var _map:MapModel;
      
      private var _cloudVec:Vector.<Cloud>;
      
      private var _day:int;
      
      private var _cloud:Cloud;
      
      private var _petMC:MovieClip;
      
      public function ShootingCloud(param1:MapModel)
      {
         super();
         this._map = param1;
         this.init();
         this.initData();
      }
      
      private function init() : void
      {
         this._cloudVec = Vector.<Cloud>([]);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._cloudVec.push(new Cloud(this._map.content["cloud" + _loc1_]));
            this._cloudVec[_loc1_].mc.gotoAndStop(1);
            _loc1_++;
         }
         this._petMC = this._map.front["petMC"];
         this._petMC.gotoAndStop("常态");
      }
      
      private function initData() : void
      {
         ServerBufferManager.getServerBuffer(10,this.onGetStatus,false);
      }
      
      private function onGetStatus(param1:ServerBuffer) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc5_:int = _loc3_.date;
         this._day = param1.readDataAtPostion(0);
         if(this._day == _loc5_)
         {
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               this._cloudVec[_loc4_].setBlood(param1.readDataAtPostion(_loc4_ + 1));
               _loc4_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               this._cloudVec[_loc2_].setBlood(10);
               _loc2_++;
            }
         }
         this.initCloudStatus();
         this.initEvent();
      }
      
      private function initCloudStatus() : void
      {
         var _loc1_:Cloud = null;
         for each(_loc1_ in this._cloudVec)
         {
            if(_loc1_.getBlood() <= 0)
            {
               _loc1_.mc.visible = false;
            }
            else
            {
               _loc1_.mc.visible = true;
            }
         }
      }
      
      private function initEvent() : void
      {
         this._petMC.addEventListener("activityPetShow",this.onShow);
         this._petMC.addEventListener("activityPetHide",this.onHide);
         ShootController.addEventListener("playEnd",this.onShootReward);
      }
      
      private function onShootReward(param1:ShootEvent) : void
      {
         var _loc2_:Cloud = null;
         for each(_loc2_ in this._cloudVec)
         {
            if(param1.info.userID == ActorManager.actorInfo.id && _loc2_.mc.hitTestPoint(param1.info.endPos.x,param1.info.endPos.y) && _loc2_.getBlood() >= 0)
            {
               StatisticsManager.sendNoviceAccountHttpd("0x10033065");
               this._cloud = _loc2_;
               this._cloud.mc.addEventListener("cloudConis",this.onPlayComplete);
               this._cloud.mc.addEventListener("cloudFight",this.onPlayComplete);
               this._cloud.mc.addEventListener("cloudGuoshi",this.onPlayComplete);
               this._cloud.mc.addEventListener("cloudYumao",this.onPlayComplete);
               ItemManager.addEventListener1("serverItemGiven",this.onServerItemGiven);
               Connection.addCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
               Connection.send(CommandSet.RANDOM_EVENT_1140,18,0);
            }
         }
      }
      
      private function onServerItemGiven(param1:ItemEvent) : void
      {
         ItemManager.removeEventListener1("serverItemGiven",this.onServerItemGiven);
         var _loc2_:Parser_1051 = param1.content as Parser_1051;
         if(_loc2_.cmdId == 1140)
         {
            this.showCloud(_loc2_.itemDes[0].referenceId,_loc2_.itemDes[0].quantity);
         }
      }
      
      private function onPlayComplete(param1:Event) : void
      {
         this.hideCloud();
      }
      
      private function onRandomStatus(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
         var _loc4_:IDataInput = param1.message.getRawDataCopy();
         var _loc6_:uint = _loc4_.readUnsignedInt();
         var _loc5_:uint = _loc4_.readUnsignedInt();
         var _loc3_:uint = _loc4_.readUnsignedInt();
         var _loc2_:uint = _loc4_.readUnsignedInt();
         this._cloud.setBlood(this._cloud.getBlood() - 1);
         if(_loc2_ != 0 && _loc6_ == 18)
         {
            this._cloud.mc.gotoAndStop("云常态打击动画");
            this._petMC.gotoAndStop("出现动画");
         }
         this.setCloudBlood();
      }
      
      private function setCloudBlood() : void
      {
         var _loc3_:Cloud = null;
         var _loc2_:Vector.<int> = Vector.<int>([]);
         var _loc1_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc4_:int = _loc1_.date;
         for each(_loc3_ in this._cloudVec)
         {
            _loc2_.push(_loc3_.getBlood());
         }
         ServerBufferManager.updateServerBufferList(10,_loc4_,_loc2_);
      }
      
      private function onShow(param1:Event) : void
      {
         var event:Event = param1;
         NpcDialog.show(469,"艾萨卡",[[0,"让我好好睡个觉好呗？你点的手不酸的呗？？"]],["跟我走吧，艾萨卡！"],[function():void
         {
            NpcDialog.show(469,"艾萨卡",[[1,"陪我玩一玩再说呗~~如果你能让我高兴，我就跟你走~~！"]],["没问题！","算啦！"],[function():void
            {
               if(FightVerifyManager.validateFightStart())
               {
                  FightManager.startFightWithWild(72);
               }
               else
               {
                  _petMC.gotoAndStop("常态");
               }
            },function():void
            {
               _petMC.gotoAndStop("消失动画");
            }]);
         }]);
      }
      
      private function onHide(param1:Event) : void
      {
         this._petMC.gotoAndStop("常态");
      }
      
      private function showCloud(param1:uint, param2:uint) : void
      {
         if(param1 == 1)
         {
            ServerMessager.addMessage("因为头部射击，获得了" + param2 + "赛尔豆");
            this._cloud.mc.gotoAndStop("爆赛尔豆动画");
         }
         if(param1 == 400044)
         {
            ServerMessager.addMessage("因为头部射击，获得了" + ItemConfig.getItemName(param1));
            this._cloud.mc.gotoAndStop("爆羽毛动画");
         }
         if(param1 == 200213)
         {
            ServerMessager.addMessage("因为头部射击，获得了" + ItemConfig.getItemName(param1));
            this._cloud.mc.gotoAndStop("爆果实动画");
         }
      }
      
      private function hideCloud() : void
      {
         this._cloud.mc.gotoAndStop("常态");
         if(this._cloud.getBlood() <= 0)
         {
            this._cloud.mc.visible = false;
         }
      }
      
      public function dispose() : void
      {
         if(this._cloud)
         {
            this._cloud.mc.removeEventListener("cloudConis",this.onPlayComplete);
            this._cloud.mc.removeEventListener("cloudFight",this.onPlayComplete);
            this._cloud.mc.removeEventListener("cloudGuoshi",this.onPlayComplete);
            this._cloud.mc.removeEventListener("cloudYumao",this.onPlayComplete);
         }
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
         if(this._petMC)
         {
            this._petMC.removeEventListener("activityPetShow",this.onShow);
            this._petMC.removeEventListener("activityPetHide",this.onHide);
         }
         ShootController.removeEventListener("playEnd",this.onShootReward);
         this._cloudVec = null;
         this._day = 0;
         this._cloud = null;
         this._petMC = null;
         this._map = null;
      }
   }
}

