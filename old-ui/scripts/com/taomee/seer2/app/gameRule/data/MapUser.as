package com.taomee.seer2.app.gameRule.data
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   
   public class MapUser
   {
      
      private var _userInfo:UserInfo;
      
      private var _status:uint;
      
      public function MapUser(param1:UserInfo)
      {
         super();
         this._userInfo = param1;
         this._status = 0;
      }
      
      public function get userInfo() : UserInfo
      {
         return this._userInfo;
      }
      
      public function get status() : uint
      {
         return this._status;
      }
      
      public function set status(param1:uint) : void
      {
         this._status = param1;
      }
   }
}

