package com.taomee.seer2.app.activity
{
   import com.taomee.seer2.app.activity.data.ActivityDefinition;
   import com.taomee.seer2.app.activity.processor.ActivityProcessor;
   import com.taomee.seer2.app.config.ActivityConfig;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.net.SharedObject;
   import flash.system.ApplicationDomain;
   import org.taomee.ds.HashMap;
   
   public class ActivityManager
   {
      
      private static var _inProgressActivityMap:HashMap;
      
      initialize();
      
      public function ActivityManager()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _inProgressActivityMap = new HashMap();
         initCommandListener();
         initTimelessActivity();
      }
      
      private static function initTimelessActivity() : void
      {
         var _loc2_:Vector.<ActivityDefinition> = null;
         var _loc1_:ActivityDefinition = null;
         var _loc3_:ActivityProcessor = null;
         if(QuestManager.isFreshQuestComplete())
         {
            _loc2_ = ActivityConfig.getTimelessActivityVec();
            for each(_loc1_ in _loc2_)
            {
               _loc3_ = createActivityProcessor(_loc1_);
               if(_loc3_ != null)
               {
                  _loc3_.start();
               }
            }
         }
      }
      
      public static function refreshActivity() : void
      {
         var _loc2_:Vector.<ActivityDefinition> = null;
         var _loc1_:ActivityDefinition = null;
         var _loc3_:ActivityProcessor = null;
         if(QuestManager.isFreshQuestComplete())
         {
            _loc2_ = ActivityConfig.getInprogressActivityVec();
            for each(_loc1_ in _loc2_)
            {
               if(_inProgressActivityMap.containsKey(_loc1_.id) == false)
               {
                  _loc3_ = createActivityProcessor(_loc1_);
                  if(_loc3_ != null)
                  {
                     _inProgressActivityMap.add(_loc1_.id,_loc3_);
                     _loc3_.start();
                  }
               }
            }
            _inProgressActivityMap.eachValue(processActivity);
         }
      }
      
      public static function removeActivityProcessor(param1:uint) : void
      {
         var _loc2_:ActivityProcessor = null;
         if(_inProgressActivityMap.containsKey(param1))
         {
            _loc2_ = _inProgressActivityMap.getValue(param1);
            _loc2_.dispose();
            _inProgressActivityMap.remove(param1);
         }
      }
      
      private static function createActivityProcessor(param1:ActivityDefinition) : ActivityProcessor
      {
         var _loc2_:String = "com.taomee.seer2.app.activity.processor." + ActivityConfig.getActivityProcessorName(param1.id);
         var _loc3_:Class = ApplicationDomain.currentDomain.getDefinition(_loc2_) as Class;
         return ActivityProcessor(new _loc3_(param1));
      }
      
      private static function processActivity(param1:ActivityProcessor) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.refresh();
      }
      
      private static function initCommandListener() : void
      {
         Connection.addErrorHandler(CommandSet.ACTIVITY_FIGHT_MONSTER_1066,onFightActivityMonsterError);
      }
      
      private static function onFightActivityMonsterError(param1:MessageEvent) : void
      {
         if(param1.message.statusCode == 100)
         {
            AlertManager.showAlert("此活动当前未开放");
         }
      }
      
      public static function addActivityAnimationPlayNum(param1:uint, param2:String, param3:int = 1) : void
      {
         var _loc7_:SharedObject = SharedObjectManager.getUserSharedObject("activityAnimation");
         var _loc5_:String = generateDateKey();
         var _loc4_:String = generateActivityKey(param1,param2);
         var _loc6_:Object = _loc7_.data[_loc5_][_loc4_];
         _loc6_.playNum = _loc6_.playNum + param3;
         SharedObjectManager.flush(_loc7_);
      }
      
      private static function isActivityAnimationPlayed(param1:uint, param2:String) : Boolean
      {
         var _loc3_:Object = null;
         var _loc6_:SharedObject = SharedObjectManager.getUserSharedObject("activityAnimation");
         var _loc5_:String = generateDateKey();
         var _loc4_:String = generateActivityKey(param1,param2);
         if(_loc6_.data[_loc5_] == null)
         {
            resetSharedObject(_loc6_,_loc5_);
         }
         _loc3_ = _loc6_.data[_loc5_][_loc4_];
         if(_loc3_ == null)
         {
            _loc3_ = {};
            _loc3_.playNum = 0;
            _loc6_.data[_loc5_][_loc4_] = _loc3_;
            SharedObjectManager.flush(_loc6_);
         }
         return _loc3_.playNum > 0;
      }
      
      private static function resetSharedObject(param1:SharedObject, param2:String) : void
      {
         param1.clear();
         param1.data[param2] = {};
         param1.flush();
      }
      
      public static function clearSo(param1:uint, param2:String) : void
      {
         var _loc5_:SharedObject = SharedObjectManager.getUserSharedObject("activityAnimation");
         var _loc4_:String = generateDateKey();
         var _loc3_:String = generateActivityKey(param1,param2);
         if(_loc5_.data[_loc4_][_loc3_] != null)
         {
            resetSharedObject(_loc5_,param2);
         }
      }
      
      private static function generateDateKey() : String
      {
         var _loc1_:Date = new Date();
         return Connection.netType.toString() + _loc1_.fullYear + "_" + _loc1_.month + "_" + _loc1_.date;
      }
      
      private static function generateActivityKey(param1:uint, param2:String) : String
      {
         var _loc4_:uint = TimeManager.getServerTime();
         var _loc3_:ActivityDefinition = ActivityConfig.getActivityById(param1);
         return "../res/activity/" + param1 + _loc3_.getPhaseIndex(_loc4_) + param2;
      }
      
      public static function isPlayActivityAnimation(param1:uint, param2:String) : Boolean
      {
         if(isActivityAnimationPlayed(param1,param2) > 0)
         {
            return false;
         }
         return true;
      }
   }
}

