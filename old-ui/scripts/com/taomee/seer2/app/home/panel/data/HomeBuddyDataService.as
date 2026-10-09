package com.taomee.seer2.app.home.panel.data
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.group.UserGroupCookie;
   import com.taomee.seer2.app.actor.group.UserGroupEvent;
   import com.taomee.seer2.app.actor.group.UserGroupManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class HomeBuddyDataService extends EventDispatcher
   {
      
      public static const BUDDY_DATA_CHANGE:String = "buddyDataChange";
      
      private static const MAX_NUM:int = 5;
      
      private var _dataUnitVec:Vector.<HomeBuddyDataUnit>;
      
      private var _userInfoVec:Vector.<UserInfo>;
      
      public function HomeBuddyDataService()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.initDataUnitVec();
         UserGroupManager.addEventListener("add",this.onAddUser);
         UserGroupManager.addEventListener("remove",this.onRemoveUser);
      }
      
      private function initDataUnitVec() : void
      {
         var _loc1_:UserInfo = null;
         var _loc3_:HomeBuddyDataUnit = null;
         this._dataUnitVec = new Vector.<HomeBuddyDataUnit>();
         var _loc2_:Vector.<UserInfo> = UserGroupManager.getGroupAllUser("buddy");
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = new HomeBuddyDataUnit();
            _loc3_.id = _loc1_.id;
            _loc3_.userInfo = _loc1_;
            _loc3_.status = "busy";
            this._dataUnitVec.push(_loc3_);
         }
         this.sortDataUnitVec();
      }
      
      private function sortDataUnitVec() : void
      {
         var _loc3_:Object = null;
         var _loc2_:Vector.<Object> = UserGroupCookie.getIntervieweeVec();
         var _loc1_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            if(_loc4_ < _loc1_)
            {
               _loc3_ = _loc2_[_loc4_];
               this.sortDataUnitByUserId(_loc3_.userId);
            }
            _loc4_++;
         }
      }
      
      private function sortDataUnitByUserId(param1:uint) : void
      {
         var _loc3_:HomeBuddyDataUnit = null;
         var _loc2_:int = int(this._dataUnitVec.length);
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = this._dataUnitVec[_loc4_];
            if(_loc3_.id == param1)
            {
               this._dataUnitVec.splice(_loc4_,1);
               this._dataUnitVec.unshift(_loc3_);
               break;
            }
            _loc4_--;
         }
      }
      
      private function onAddUser(param1:UserGroupEvent) : void
      {
         if(param1.userGroupType == "buddy")
         {
            this.updateUserInfoVec();
         }
      }
      
      private function onRemoveUser(param1:UserGroupEvent) : void
      {
         if(param1.userGroupType == "buddy")
         {
            this.updateUserInfoVec();
         }
      }
      
      private function updateUserInfoVec() : void
      {
         this._userInfoVec = UserGroupManager.getGroupAllUser("buddy");
         this.updateDataUnitVec();
         dispatchEvent(new Event("buddyDataChange"));
      }
      
      private function updateDataUnitVec() : void
      {
         this.addUserInfoToDataUnit();
         this.removeUserInfoFromDataUnit();
      }
      
      private function addUserInfoToDataUnit() : void
      {
         var _loc2_:UserInfo = null;
         var _loc1_:HomeBuddyDataUnit = null;
         for each(_loc2_ in this._userInfoVec)
         {
            if(this.containsDataUnitById(_loc2_.id) == false)
            {
               _loc1_ = new HomeBuddyDataUnit();
               _loc1_.id = _loc2_.id;
               _loc1_.userInfo = _loc2_;
               _loc1_.status = "ready";
               this._dataUnitVec.push(_loc1_);
            }
         }
      }
      
      private function containsDataUnitById(param1:uint) : Boolean
      {
         var _loc2_:HomeBuddyDataUnit = null;
         for each(_loc2_ in this._dataUnitVec)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function removeUserInfoFromDataUnit() : void
      {
         var _loc3_:HomeBuddyDataUnit = null;
         var _loc2_:int = int(this._dataUnitVec.length);
         var _loc1_:int = _loc2_ - 1;
         while(_loc1_ >= 0)
         {
            _loc3_ = this._dataUnitVec[_loc1_];
            if(this.containsUserInfoById(_loc3_.id) == false)
            {
               this._dataUnitVec.splice(_loc1_,1);
            }
            _loc1_--;
         }
      }
      
      private function containsUserInfoById(param1:uint) : Boolean
      {
         var _loc2_:UserInfo = null;
         for each(_loc2_ in this._userInfoVec)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get dataUnitVec() : Vector.<HomeBuddyDataUnit>
      {
         return this._dataUnitVec;
      }
      
      public function dispose() : void
      {
         UserGroupManager.removeEventListener("add",this.onAddUser);
         UserGroupManager.removeEventListener("remove",this.onRemoveUser);
      }
   }
}

