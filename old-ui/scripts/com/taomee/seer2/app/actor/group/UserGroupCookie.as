package com.taomee.seer2.app.actor.group
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import flash.net.SharedObject;
   
   public class UserGroupCookie
   {
      
      private static const COOKIE_NAME:String = "userGroup";
      
      public function UserGroupCookie()
      {
         super();
      }
      
      public static function write() : void
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("userGroup");
         var _loc1_:Vector.<UserInfo> = UserGroupManager.getGroupAllUser("buddy");
         var _loc3_:Vector.<UserInfo> = UserGroupManager.getGroupAllUser("black");
         writeUserInfoVec(_loc1_,_loc2_,"buddy");
         writeUserInfoVec(_loc3_,_loc2_,"black");
      }
      
      public static function read() : Object
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("userGroup");
         var _loc1_:Vector.<UserInfo> = getUserInfoVec(_loc2_,"buddy");
         var _loc3_:Vector.<UserInfo> = getUserInfoVec(_loc2_,"black");
         return {
            "buddy":_loc1_,
            "black":_loc3_
         };
      }
      
      public static function addIntervieweeCount(param1:uint) : void
      {
         var _loc3_:Object = null;
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("userGroup");
         var _loc4_:Vector.<Object> = _loc2_.data["buddy"] as Vector.<Object>;
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.userId == param1)
            {
               ++_loc3_.interviewCount;
               SharedObjectManager.flush(_loc2_);
               break;
            }
         }
      }
      
      public static function getIntervieweeVec() : Vector.<Object>
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("userGroup");
         var _loc1_:Vector.<Object> = _loc2_.data["buddy"] as Vector.<Object>;
         if(_loc1_ == null)
         {
            _loc1_ = new Vector.<Object>();
         }
         else
         {
            _loc1_.sort(sortByInterviewCount);
         }
         return _loc1_;
      }
      
      private static function writeUserInfoVec(param1:Vector.<UserInfo>, param2:SharedObject, param3:String) : void
      {
         var _loc7_:UserInfo = null;
         var _loc6_:Object = null;
         var _loc8_:Vector.<Object> = new Vector.<Object>();
         var _loc5_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = param1[_loc4_];
            _loc6_ = convertUserInfoToObject(_loc7_,param2);
            _loc8_.push(_loc6_);
            _loc4_++;
         }
         param2.data[param3] = _loc8_;
         SharedObjectManager.flush(param2);
      }
      
      private static function getUserInfoVec(param1:SharedObject, param2:String) : Vector.<UserInfo>
      {
         var _loc7_:* = undefined;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:Object = null;
         var _loc5_:UserInfo = null;
         var _loc8_:Vector.<UserInfo> = new Vector.<UserInfo>();
         _loc7_ = param1.data[param2] as Vector.<Object>;
         if(_loc7_ != null)
         {
            _loc4_ = int(_loc7_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = _loc7_[_loc3_];
               _loc5_ = convertObjectToUserInfo(_loc6_);
               _loc8_.push(_loc5_);
               _loc3_++;
            }
         }
         return _loc8_;
      }
      
      private static function sortByInterviewCount(param1:Object, param2:Object) : int
      {
         if(param1.interviewCount < param2.interviewCount)
         {
            return -1;
         }
         if(param1.interviewCount > param2.interviewCount)
         {
            return 1;
         }
         return 0;
      }
      
      private static function getInterviewCountById(param1:uint, param2:SharedObject) : int
      {
         var _loc3_:Object = null;
         var _loc5_:int = 0;
         var _loc4_:Vector.<Object> = param2.data["buddy"] as Vector.<Object>;
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.userId == param1)
            {
               _loc5_ = int(_loc3_.interviewCount);
               break;
            }
         }
         return _loc5_;
      }
      
      private static function convertUserInfoToObject(param1:UserInfo, param2:SharedObject) : Object
      {
         var _loc3_:Object = {};
         _loc3_.userId = param1.id;
         _loc3_.nick = param1.nick;
         _loc3_.interviewCount = getInterviewCountById(param1.id,param2);
         _loc3_.vipFlag = param1.vipInfo.vipFlag;
         return _loc3_;
      }
      
      private static function convertObjectToUserInfo(param1:Object) : UserInfo
      {
         var _loc2_:UserInfo = new UserInfo();
         _loc2_.id = param1.userId;
         _loc2_.nick = param1.nick;
         _loc2_.vipInfo.vipFlag = param1.vipFlag;
         return _loc2_;
      }
   }
}

