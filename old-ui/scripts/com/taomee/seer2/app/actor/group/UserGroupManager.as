package com.taomee.seer2.app.actor.group
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import flash.events.EventDispatcher;
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   
   public class UserGroupManager
   {
      
      private static var _groupMap:HashMap;
      
      private static var _buddyGroup:UserGroup;
      
      private static var _blackGroup:UserGroup;
      
      private static var _teamGroup:UserGroup;
      
      private static var _eventDispatcher:EventDispatcher;
      
      initialize();
      
      public function UserGroupManager()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _buddyGroup = new UserGroup("buddy");
         _blackGroup = new UserGroup("black");
         _teamGroup = new UserGroup("team");
         _groupMap = new HashMap();
         _groupMap.add("buddy",_buddyGroup);
         _groupMap.add("black",_blackGroup);
         _groupMap.add("team",_teamGroup);
         _eventDispatcher = new EventDispatcher();
      }
      
      public static function setup(param1:IDataInput) : void
      {
         var _loc4_:UserInfo = null;
         var _loc6_:uint = param1.readUnsignedInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = new UserInfo();
            _loc4_.id = param1.readUnsignedInt();
            addUser("buddy",_loc4_);
            _loc5_++;
         }
         var _loc3_:uint = param1.readUnsignedInt();
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new UserInfo();
            _loc4_.id = param1.readUnsignedInt();
            addUser("black",_loc4_);
            _loc2_++;
         }
      }
      
      public static function addUser(param1:String, param2:UserInfo) : void
      {
         var _loc3_:UserGroup = getUserGroup(param1);
         if(_loc3_)
         {
            _loc3_.addUser(param2);
            dispatchUserGroupEvent("add",param1,param2);
         }
      }
      
      public static function removeUser(param1:String, param2:UserInfo) : void
      {
         var _loc3_:UserGroup = getUserGroup(param1);
         if(_loc3_)
         {
            _loc3_.removeUser(param2);
            dispatchUserGroupEvent("remove",param1,param2);
         }
      }
      
      public static function removeAllUserByType(param1:String) : void
      {
         var _loc2_:UserGroup = getUserGroup(param1);
         if(_loc2_)
         {
            _loc2_.clear();
         }
      }
      
      public static function updateUser(param1:String, param2:UserInfo) : void
      {
         var _loc3_:UserGroup = getUserGroup(param1);
         if(_loc3_)
         {
            _loc3_.updateUser(param2);
            dispatchUserGroupEvent("update",param1,param2);
         }
      }
      
      public static function updateUserNew(param1:UserInfo) : void
      {
         if(containsUser("team",param1.id))
         {
            updateUser("team",param1);
         }
         if(containsUser("buddy",param1.id))
         {
            updateUser("buddy",param1);
         }
         else if(containsUser("passerby",param1.id))
         {
            updateUser("passerby",param1);
         }
         else if(containsUser("black",param1.id))
         {
            updateUser("black",param1);
         }
      }
      
      public static function getUser(param1:String, param2:uint) : UserInfo
      {
         var _loc3_:UserGroup = getUserGroup(param1);
         if(_loc3_)
         {
            return _loc3_.getUser(param2);
         }
         return null;
      }
      
      public static function containsUser(param1:String, param2:uint) : Boolean
      {
         var _loc3_:UserGroup = null;
         var _loc4_:Boolean = false;
         _loc3_ = getUserGroup(param1);
         if(_loc3_)
         {
            _loc4_ = _loc3_.containsUser(param2);
         }
         return _loc4_;
      }
      
      public static function getAllPasserByUser() : Vector.<UserInfo>
      {
         var _loc3_:RemoteActor = null;
         var _loc2_:Vector.<RemoteActor> = ActorManager.getAllRemoteActors();
         var _loc1_:Vector.<UserInfo> = new Vector.<UserInfo>();
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push(_loc3_.getInfo());
         }
         return _loc1_;
      }
      
      public static function getGroupAllUser(param1:String) : Vector.<UserInfo>
      {
         var _loc2_:UserGroup = getUserGroup(param1);
         if(_loc2_)
         {
            return _loc2_.getAllUser();
         }
         return new Vector.<UserInfo>();
      }
      
      private static function getUserGroup(param1:String) : UserGroup
      {
         if(_groupMap.containsKey(param1))
         {
            return _groupMap.getValue(param1);
         }
         return null;
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      private static function dispatchUserGroupEvent(param1:String, param2:String, param3:UserInfo = null) : void
      {
         if(_eventDispatcher.hasEventListener(param1))
         {
            _eventDispatcher.dispatchEvent(new UserGroupEvent(param1,param2,param3));
         }
      }
   }
}

