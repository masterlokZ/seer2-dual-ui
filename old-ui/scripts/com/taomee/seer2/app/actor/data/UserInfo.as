package com.taomee.seer2.app.actor.data
{
   import com.adobe.crypto.MD5;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.events.UserInfoEvent;
   import com.taomee.seer2.app.actor.util.ActorEquipAssembler;
   import com.taomee.seer2.app.gameRule.nono.NonoInfoEvent;
   import com.taomee.seer2.app.gameRule.nono.core.NonoInfo;
   import com.taomee.seer2.app.gameRule.nono.time.NonoButlerController;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.morphSystem.MorphInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.helper.UserInfoParseHelper;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.processor.activity.decoration.BirthdayInfo;
   import com.taomee.seer2.app.team.data.TeamMainInfo;
   import com.taomee.seer2.app.vip.data.VipInfo;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import flash.events.EventDispatcher;
   import flash.utils.IDataInput;
   
   public class UserInfo extends EventDispatcher
   {
      
      public static const NICK_DATA_LEN:int = 16;
      
      public static const IP_ARRAY_LEN:int = 20;
      
      public var loginAccount:String;
      
      public var id:uint;
      
      public var nick:String;
      
      public var x:int;
      
      public var y:int;
      
      public var medalId:int;
      
      public var createTime:uint;
      
      public var serverID:uint;
      
      private var _trainerScore:int;
      
      public var color:uint;
      
      public var equipVec:Vector.<EquipItem>;
      
      public var sex:uint;
      
      public var coins:uint;
      
      private var _highestPetLevel:uint;
      
      public var petCount:int;
      
      private var _petLevel:int;
      
      public var sptCount:int;
      
      public var medalCount:int;
      
      public var signature:String;
      
      public var followingPetInfo:PetInfo;
      
      public var ridingPetInfo:PetInfo;
      
      public var teamInfo:TeamMainInfo = new TeamMainInfo();
      
      public var vipInfo:VipInfo = new VipInfo();
      
      private var _nonoInfo:NonoInfo = new NonoInfo();
      
      public var activityData:Vector.<uint> = Vector.<uint>([]);
      
      public var clientCacheData:Array = [];
      
      public var stateFlag:uint;
      
      public var callerUserId:uint;
      
      public var troop:uint = 0;
      
      public var activityStatus:int = 0;
      
      public var honorNum:uint = 0;
      
      public var _isPlanHook:uint = 0;
      
      public var _isOnhook:uint = 0;
      
      public var plantLevel:uint = 0;
      
      public var moneyCount:uint = 0;
      
      public var morphInfo:MorphInfo = new MorphInfo();
      
      public var birthdayInfo:BirthdayInfo = new BirthdayInfo();
      
      public var ip:String;
      
      public var isYearVip:uint;
      
      public function UserInfo(param1:IDataInput = null)
      {
         super();
         if(param1 != null)
         {
            UserInfoParseHelper.readBaseInfo(this,param1);
         }
      }
      
      public function requestNewestMoney() : void
      {
         Connection.send(CommandSet.CLI_MONEY_COUNT_1253,this.getResult());
      }
      
      private function getResult() : LittleEndianByteArray
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         var _loc4_:LittleEndianByteArray = new LittleEndianByteArray();
         var _loc3_:String = MD5.hash("0");
         var _loc6_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc2_ = _loc3_.substr(_loc5_,2);
            _loc1_ = parseInt(_loc2_,16);
            _loc4_.writeByte(_loc1_);
            _loc5_ += 2;
         }
         return _loc4_;
      }
      
      public function updateEquipVec(param1:Vector.<EquipItem>) : void
      {
         ActorEquipAssembler.mergeDefaultEquip(this.color,param1);
         this.equipVec = param1;
         dispatchEvent(new UserInfoEvent("equipUpdate"));
         CookieUserInfo.serialize(ActorManager.actorInfo);
      }
      
      public function updateColor(param1:uint) : void
      {
         ActorEquipAssembler.removeDefaultEquip(this.color,this.equipVec);
         this.color = param1;
         ActorEquipAssembler.mergeDefaultEquip(this.color,this.equipVec);
         dispatchEvent(new UserInfoEvent("equipUpdate"));
         CookieUserInfo.serialize(ActorManager.actorInfo);
      }
      
      public function setFollowingPetInfo(param1:PetInfo) : void
      {
         this.followingPetInfo = param1;
         dispatchEvent(new UserInfoEvent("followingPetUpdate"));
      }
      
      public function setPetRidePetInfo(param1:PetInfo) : void
      {
         this.ridingPetInfo = param1;
         dispatchEvent(new UserInfoEvent("RIDING_PET_UPDATE"));
      }
      
      public function updateNonoInfo(param1:IDataInput) : void
      {
         this._nonoInfo.readData(param1);
         dispatchEvent(new NonoInfoEvent("NONOINFO_UPDATE"));
      }
      
      public function updateNonoTimeButler(param1:IDataInput) : void
      {
         NonoButlerController.getInstance().parserData(param1);
      }
      
      public function getNonoInfo() : NonoInfo
      {
         return this._nonoInfo;
      }
      
      public function update(param1:UserInfo) : void
      {
         if(this.id == param1.id)
         {
            this.nick = param1.nick;
            this.color = param1.color;
            this.trainerScore = param1.trainerScore;
            this.equipVec = param1.equipVec;
            this.vipInfo = param1.vipInfo;
         }
      }
      
      public function set trainerScore(param1:int) : void
      {
         this._trainerScore = param1;
      }
      
      public function get trainerScore() : int
      {
         return this._trainerScore;
      }
      
      public function setTrainerScore(param1:int) : void
      {
         this.trainerScore = param1;
         dispatchEvent(new UserInfoEvent("trainerScoreUpdate"));
      }
      
      public function get trainerLevel() : int
      {
         if(this.trainerScore < 40)
         {
            return 1;
         }
         return Math.sqrt((this.trainerScore - 40) / 20) + 1;
      }
      
      public function get nextLevelNeedExp() : int
      {
         if(this.trainerLevel == 1)
         {
            return 60;
         }
         return ((this.trainerLevel - 1) * 2 + 1) * 20;
      }
      
      public function get currentLevelExp() : int
      {
         if(this.trainerLevel == 1)
         {
            return this.trainerScore;
         }
         return int(this.trainerScore - (Math.pow(this.trainerLevel - 1,2) * 20 + 40));
      }
      
      public function isRemote() : Boolean
      {
         return ActorManager.actorInfo.id != this.id;
      }
      
      public function get highestPetLevel() : uint
      {
         if(this._highestPetLevel > this._petLevel)
         {
            return this._highestPetLevel;
         }
         return this._petLevel;
      }
      
      public function set highestPetLevel(param1:uint) : void
      {
         this._highestPetLevel = param1;
         dispatchEvent(new UserInfoEvent("highestPetLevelUpdate"));
      }
      
      public function get petLevel() : int
      {
         return this.highestPetLevel;
      }
      
      public function set petLevel(param1:int) : void
      {
         this._petLevel = param1;
         dispatchEvent(new UserInfoEvent("highestPetLevelUpdate"));
      }
   }
}

