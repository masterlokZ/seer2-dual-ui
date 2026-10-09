package com.taomee.seer2.app.net.helper
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.group.UserGroupCookie;
   import com.taomee.seer2.app.actor.group.UserGroupManager;
   import com.taomee.seer2.app.actor.util.ActorEquipAssembler;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.team.data.TeamMainInfo;
   import flash.utils.IDataInput;
   
   public class UserInfoParseHelper
   {
      
      public function UserInfoParseHelper()
      {
         super();
      }
      
      public static function parseEnterMap(param1:UserInfo, param2:IDataInput) : void
      {
         var _loc5_:PetInfo = null;
         readBaseInfo(param1,param2);
         var _loc7_:uint = param2.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = new PetInfo();
            _loc5_.catchTime = param2.readUnsignedInt();
            _loc5_.resourceId = param2.readUnsignedInt();
            _loc5_.sex = param2.readUnsignedByte();
            _loc5_.level = param2.readUnsignedByte();
            _loc5_.character = param2.readUnsignedInt();
            _loc5_.potential = param2.readUnsignedInt();
            _loc5_.flag = param2.readUnsignedInt();
            _loc5_.petRideChipId = param2.readUnsignedInt();
            _loc5_.chipPutOnTime = param2.readUnsignedInt();
            _loc5_.evolveLevel = param2.readUnsignedInt();
            if(_loc6_ == 0)
            {
               param1.followingPetInfo = _loc5_;
            }
            else
            {
               param1.ridingPetInfo = _loc5_;
            }
            _loc6_++;
         }
         param1.troop = param2.readUnsignedInt();
         param1.vipInfo.paserUserSimpleInfo(param2);
         var _loc4_:uint = param2.readUnsignedInt();
         param1.activityData = Vector.<uint>([]);
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            param1.activityData.push(param2.readUnsignedInt());
            _loc3_++;
         }
         param1.trainerScore = param2.readUnsignedInt();
      }
      
      public static function readBaseInfo(param1:UserInfo, param2:IDataInput) : void
      {
         var _loc5_:EquipItem = null;
         param1.id = param2.readUnsignedInt();
         param1.nick = param2.readUTFBytes(16);
         param1.color = param2.readUnsignedInt();
         param1.x = param2.readUnsignedInt();
         param1.y = param2.readUnsignedInt();
         param1.medalId = param2.readUnsignedInt();
         param1.createTime = param2.readUnsignedInt();
         var _loc8_:uint = param2.readUnsignedInt();
         param1.equipVec = new Vector.<EquipItem>();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc8_)
         {
            _loc5_ = new EquipItem(param2.readUnsignedInt());
            param1.equipVec.push(_loc5_);
            _loc7_++;
         }
         var _loc4_:uint = param2.readUnsignedInt();
         var _loc3_:uint = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc3_ = param2.readUnsignedInt();
            _loc6_++;
         }
         param1.getNonoInfo().equipId = _loc3_;
         ActorEquipAssembler.mergeDefaultEquip(param1.color,param1.equipVec);
      }
      
      public static function parseUserSimpleInfo(param1:UserInfo, param2:IDataInput) : void
      {
         param1.id = param2.readUnsignedInt();
         readSimpleInfo(param1,param2);
      }
      
      public static function readSimpleInfo(param1:UserInfo, param2:IDataInput) : void
      {
         var _loc3_:EquipItem = null;
         param1.sex = param2.readUnsignedByte();
         param1.nick = param2.readUTFBytes(16);
         param1.color = param2.readUnsignedInt();
         param1.trainerScore = param2.readUnsignedInt();
         param1.equipVec = new Vector.<EquipItem>();
         var _loc5_:uint = param2.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new EquipItem(param2.readUnsignedInt());
            param1.equipVec.push(_loc3_);
            _loc4_++;
         }
         ActorEquipAssembler.mergeDefaultEquip(param1.color,param1.equipVec);
         param1.vipInfo.paserUserSimpleInfo(param2);
         param1.plantLevel = param2.readUnsignedInt();
         UserGroupManager.updateUserNew(param1);
         UserGroupCookie.write();
      }
      
      public static function parseUserDetailInfo(param1:UserInfo, param2:IDataInput) : void
      {
         parseUserSimpleInfo(param1,param2);
         param1.createTime = param2.readUnsignedInt();
         param1.medalId = param2.readUnsignedInt();
         param1.petCount = param2.readUnsignedInt();
         param1.petLevel = param2.readUnsignedByte();
         param1.sptCount = param2.readUnsignedInt();
         param1.medalCount = param2.readUnsignedInt();
         var _loc3_:int = int(param2.readUnsignedInt());
         param1.signature = param2.readUTFBytes(_loc3_);
         TeamMainInfo.readBaseInfo(param1.teamInfo,param2);
         UserGroupManager.updateUserNew(param1);
         UserGroupCookie.write();
      }
   }
}

