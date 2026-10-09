package com.taomee.seer2.app.notify
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.chat.data.ChatReceivedMessage;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.notify.data.notice.BuddyNotice;
   import com.taomee.seer2.app.notify.data.notice.ChatNotice;
   import com.taomee.seer2.app.notify.data.notice.ChristmasNotice;
   import com.taomee.seer2.app.notify.data.notice.CommonNotice;
   import com.taomee.seer2.app.notify.data.notice.LeiyiKaisaNotice;
   import com.taomee.seer2.app.notify.data.notice.LocalMsgNotice;
   import com.taomee.seer2.app.notify.data.notice.Notice;
   import com.taomee.seer2.app.notify.data.notice.PetKingNotice;
   import com.taomee.seer2.app.notify.data.notice.SysMsgNotice;
   import com.taomee.seer2.app.notify.data.notice.TeamChatNotice;
   import com.taomee.seer2.app.notify.data.notice.TeamNotice;
   import com.taomee.seer2.app.notify.data.notice.VipNotice;
   import com.taomee.seer2.app.notify.data.queue.NoticeQueue;
   import com.taomee.seer2.app.team.TeamManager;
   import com.taomee.seer2.app.team.data.TeamMainInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   
   public class NoticeManager
   {
      
      public static const NEW_NOTICE:String = "newNotice";
      
      private static var _map:HashMap;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      initialize();
      
      public function NoticeManager(param1:Blocker)
      {
         super();
      }
      
      public static function block() : void
      {
         Connection.blockCommand(CommandSet.BUDDY_NOTIFY_ADD_1026);
         Connection.blockCommand(CommandSet.VIP_PAY_NOTICE);
         Connection.blockCommand(CommandSet.CHAT_1102);
         Connection.blockCommand(CommandSet.TEAM_INVITE_NOTIFY_1085);
         Connection.blockCommand(CommandSet.VIP_LUCKY_MSG_1168);
         Connection.blockCommand(CommandSet.BEAT_CAPTAIN_1070);
         Connection.blockCommand(CommandSet.NOTIFY_SYS_MSG_1073);
      }
      
      public static function relase() : void
      {
         Connection.releaseCommand(CommandSet.BUDDY_NOTIFY_ADD_1026);
         Connection.releaseCommand(CommandSet.CHAT_1102);
         Connection.releaseCommand(CommandSet.VIP_PAY_NOTICE);
         Connection.releaseCommand(CommandSet.TEAM_INVITE_NOTIFY_1085);
         Connection.releaseCommand(CommandSet.VIP_LUCKY_MSG_1168);
         Connection.releaseCommand(CommandSet.BEAT_CAPTAIN_1070);
         Connection.releaseCommand(CommandSet.NOTIFY_SYS_MSG_1073);
      }
      
      private static function initialize() : void
      {
         _map = new HashMap();
         _map.add("buddy",new NoticeQueue());
         _map.add("chat",new NoticeQueue());
         _map.add("team",new NoticeQueue());
         _map.add("VIP",new NoticeQueue());
         _map.add("teamChat",new NoticeQueue());
         _map.add("christmas",new NoticeQueue());
         _map.add("common",new NoticeQueue());
         _map.add("sysmsg",new NoticeQueue());
         _map.add("localMsg",new NoticeQueue());
         _map.add("petkingPanel",new NoticeQueue());
         _map.add("leiyiKaisaFight",new NoticeQueue());
      }
      
      public static function addBuddyNotice(param1:uint, param2:String) : void
      {
         var _loc3_:Notice = null;
         var _loc4_:NoticeQueue = getNoticeQueue("buddy");
         if(!_loc4_.getNotice(param1))
         {
            _loc3_ = new BuddyNotice(param1,param2);
            _loc4_.enQueue(_loc3_);
            dispatchEvent("newNotice");
         }
      }
      
      public static function addChatNotice(param1:uint, param2:ChatReceivedMessage) : void
      {
         var _loc3_:ChatNotice = null;
         var _loc4_:NoticeQueue = getNoticeQueue("chat");
         _loc3_ = _loc4_.getNotice(param1) as ChatNotice;
         if(_loc3_ == null)
         {
            _loc3_ = new ChatNotice(param1);
            _loc4_.enQueue(_loc3_);
         }
         _loc3_.addMessage(param2);
         dispatchEvent("newNotice");
      }
      
      public static function addLeiyiKaisaFightNotici() : void
      {
         var _loc2_:NoticeQueue = getNoticeQueue("leiyiKaisaFight");
         var _loc1_:Notice = new LeiyiKaisaNotice("leiyiKaisaFight",ActorManager.actorInfo.id);
         _loc2_.enQueue(_loc1_);
         dispatchEvent("newNotice");
      }
      
      public static function addTeamChatNotice(param1:ChatReceivedMessage) : void
      {
         var _loc2_:NoticeQueue = getNoticeQueue("teamChat");
         var _loc3_:TeamChatNotice = _loc2_.getNotice(ActorManager.actorInfo.id) as TeamChatNotice;
         if(_loc3_ == null && Boolean(TeamManager.teamId))
         {
            _loc3_ = new TeamChatNotice();
            _loc2_.enQueue(_loc3_);
         }
         _loc3_.addMessage(param1);
         dispatchEvent("newNotice");
      }
      
      public static function addPetKingPanel() : void
      {
         var _loc2_:NoticeQueue = getNoticeQueue("petkingPanel");
         var _loc1_:Notice = new PetKingNotice("petkingPanel",ActorManager.actorInfo.id);
         _loc2_.enQueue(_loc1_);
         dispatchEvent("newNotice");
      }
      
      public static function addTeamNotice(param1:uint, param2:uint, param3:TeamMainInfo, param4:String = "", param5:uint = 0) : void
      {
         var _loc6_:NoticeQueue = null;
         var _loc7_:Notice = null;
         _loc6_ = getNoticeQueue("team");
         if(!_loc6_.getNotice(param2))
         {
            _loc7_ = new TeamNotice(param1,param2,param3,param4,param5);
            _loc6_.enQueue(_loc7_);
            dispatchEvent("newNotice");
         }
      }
      
      public static function addVipNotice(param1:int, param2:int) : void
      {
         var _loc4_:NoticeQueue = getNoticeQueue("VIP");
         var _loc3_:Notice = new VipNotice(param1,param2);
         _loc4_.enQueue(_loc3_);
         dispatchEvent("newNotice");
      }
      
      public static function addChristmasNotice(param1:String, param2:uint) : void
      {
         var _loc4_:NoticeQueue = getNoticeQueue("christmas");
         var _loc3_:Notice = new ChristmasNotice(param1,param2);
         _loc4_.enQueue(_loc3_);
         dispatchEvent("newNotice");
      }
      
      public static function addCommNotice(param1:String) : void
      {
         var _loc2_:NoticeQueue = getNoticeQueue("common");
         var _loc3_:Notice = new CommonNotice(param1);
         _loc2_.enQueue(_loc3_);
         dispatchEvent("newNotice");
      }
      
      public static function addSysMsgNotice(param1:Object) : void
      {
         var _loc2_:NoticeQueue = getNoticeQueue("sysmsg");
         var _loc3_:Notice = new SysMsgNotice(param1);
         _loc2_.enQueue(_loc3_);
         dispatchEvent("newNotice");
      }
      
      public static function addLocalMsgNotice(param1:Object) : void
      {
         var _loc2_:NoticeQueue = getNoticeQueue("localMsg");
         var _loc3_:Notice = new LocalMsgNotice(param1);
         _loc2_.enQueue(_loc3_);
         dispatchEvent("newNotice");
      }
      
      private static function getNoticeQueue(param1:String) : NoticeQueue
      {
         if(_map.containsKey(param1))
         {
            return _map.getValue(param1);
         }
         return new NoticeQueue();
      }
      
      public static function getNoticeCount() : int
      {
         var _loc1_:NoticeQueue = null;
         var _loc2_:int = 0;
         for each(_loc1_ in _map.getValues())
         {
            _loc2_ += _loc1_.length;
         }
         return _loc2_;
      }
      
      public static function shiftNotice() : Notice
      {
         var _loc2_:Notice = null;
         var _loc1_:NoticeQueue = null;
         for each(_loc1_ in _map.getValues())
         {
            if(_loc1_.length > 0)
            {
               _loc2_ = _loc1_.deQueue();
               break;
            }
         }
         return _loc2_;
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public static function dispatchEvent(param1:String) : void
      {
         if(_dispatcher.hasEventListener(param1))
         {
            _dispatcher.dispatchEvent(new Event(param1));
         }
      }
   }
}

class Blocker
{
   
   public function Blocker()
   {
      super();
   }
}
