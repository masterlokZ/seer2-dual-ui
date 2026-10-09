package com.taomee.seer2.app.processor.activity.frozen
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.RemoteActor;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   
   public class UpdateActivityActor
   {
      
      private static var _frozenActorList:Vector.<FrozenActor>;
      
      private static var _fun:Function;
      
      public function UpdateActivityActor()
      {
         super();
      }
      
      public static function enterMap(param1:Function) : void
      {
         _fun = param1;
         Connection.addCommandListener(CommandSet.LIST_USER_1004,listUsers);
         Connection.addCommandListener(CommandSet.USER_ENTER_MAP_1002,listUsers);
      }
      
      private static function listUsers(param1:MessageEvent) : void
      {
         var _loc4_:FrozenActor = null;
         var _loc3_:RemoteActor = null;
         var _loc2_:Vector.<RemoteActor> = ActorManager.getAllRemoteActors();
         _frozenActorList = Vector.<FrozenActor>([]);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new FrozenActor();
            _loc4_.actor = _loc3_;
            _loc4_.hp = _loc3_.getInfo().activityData[0];
            _loc4_.status = true;
            _loc4_.actor.buttonMode = false;
            _loc4_.actor.mouseChildren = false;
            _loc4_.actor.mouseEnabled = false;
            if(_loc4_.actor.getFollowingPet())
            {
               _loc4_.actor.getFollowingPet().mouseChildren = false;
               _loc4_.actor.getFollowingPet().mouseEnabled = false;
            }
            _frozenActorList.push(_loc4_);
         }
         if(_fun != null)
         {
            _fun();
         }
         _fun = null;
      }
      
      public static function getList() : Vector.<FrozenActor>
      {
         return _frozenActorList;
      }
      
      public static function getActor(param1:uint) : FrozenActor
      {
         var _loc2_:FrozenActor = null;
         for each(_loc2_ in _frozenActorList)
         {
            if(_loc2_.actor.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function remove() : void
      {
         var _loc1_:FrozenActor = null;
         Connection.removeCommandListener(CommandSet.LIST_USER_1004,listUsers);
         Connection.removeCommandListener(CommandSet.USER_ENTER_MAP_1002,listUsers);
         for each(_loc1_ in _frozenActorList)
         {
            _loc1_.removeTimer();
            _loc1_.status = true;
            if(_loc1_.actor.getFollowingPet())
            {
               _loc1_.actor.getFollowingPet().mouseChildren = true;
               _loc1_.actor.getFollowingPet().mouseEnabled = true;
            }
            _loc1_.actor.buttonMode = true;
            _loc1_.actor.mouseChildren = true;
            _loc1_.actor.mouseEnabled = true;
         }
      }
   }
}

