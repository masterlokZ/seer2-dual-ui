package com.taomee.seer2.app.activity.data
{
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.utils.DateUtil;
   
   public class ActivityDefinition
   {
      
      private static const MINUTES_PER_HOUR:uint = 60;
      
      private static const MILLISECONDS_PER_SECOND:uint = 1000;
      
      public var id:uint;
      
      public var name:String;
      
      private var activityCircle:ActivityCircle;
      
      private var detailTimeVec:Vector.<String>;
      
      private var phaseTimeVec:Vector.<String>;
      
      public function ActivityDefinition(param1:uint, param2:String, param3:int, param4:Array, param5:Array, param6:Array)
      {
         super();
         this.id = param1;
         this.activityCircle = new ActivityCircle(param3,param4);
         if(param5)
         {
            this.detailTimeVec = Vector.<String>(param5);
         }
         if(param6)
         {
            this.phaseTimeVec = Vector.<String>(param6);
         }
      }
      
      public function isTimeless() : Boolean
      {
         return this.activityCircle.circleType == -1;
      }
      
      public function isEnterable() : Boolean
      {
         if(this.activityCircle.circleType == -1)
         {
            return true;
         }
         switch(this.activityCircle.circleType)
         {
            case 0:
               return this.parseOnce();
            case 1:
               return this.parseDay();
            case 2:
               return this.parseWeek();
            case 3:
               return this.parseMonth();
            case 4:
               return this.parseYear();
            default:
               return false;
         }
      }
      
      public function isActivityDate() : Boolean
      {
         var _loc4_:Date = null;
         var _loc3_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc5_:String = null;
         var _loc2_:Number = NaN;
         var _loc1_:String = null;
         if(this.activityCircle.circleType == -1)
         {
            return true;
         }
         _loc6_ = TimeManager.getServerTime();
         switch(this.activityCircle.circleType)
         {
            case 0:
               _loc5_ = DateUtil.formatCalendarWithoutMark(_loc6_);
               return this.activityCircle.circleDate.indexOf(_loc5_) != -1;
            case 1:
               return true;
            case 2:
               _loc4_ = new Date(_loc6_ * 1000);
               _loc3_ = _loc4_.day;
               return this.activityCircle.circleDate.indexOf(_loc3_.toString()) != -1;
            case 3:
               _loc4_ = new Date(_loc6_ * 1000);
               _loc3_ = _loc4_.date;
               return this.activityCircle.circleDate.indexOf(_loc3_.toString()) != -1;
            case 4:
               _loc4_ = new Date(_loc6_ * 1000);
               _loc2_ = _loc4_.month + 1;
               _loc3_ = _loc4_.date;
               _loc1_ = _loc2_.toString() + _loc3_.toString();
               return this.activityCircle.circleDate.indexOf(_loc1_) != -1;
            default:
               return false;
         }
      }
      
      private function parseOnce() : Boolean
      {
         var _loc2_:uint = TimeManager.getServerTime();
         var _loc1_:String = DateUtil.formatCalendarWithoutMark(_loc2_);
         if(this.activityCircle.circleDate.indexOf(_loc1_) != -1)
         {
            return this.parseTime();
         }
         return false;
      }
      
      private function parseDay() : Boolean
      {
         return this.parseTime();
      }
      
      private function parseWeek() : Boolean
      {
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc1_:Number = _loc2_.day;
         if(this.activityCircle.circleDate.indexOf(_loc1_.toString()) != -1)
         {
            return this.parseTime();
         }
         return false;
      }
      
      private function parseMonth() : Boolean
      {
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc1_:Number = _loc2_.date;
         if(this.activityCircle.circleDate.indexOf(_loc1_.toString()) != -1)
         {
            return this.parseTime();
         }
         return false;
      }
      
      private function parseYear() : Boolean
      {
         var _loc2_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc1_:Number = _loc2_.month + 1;
         var _loc4_:Number = _loc2_.date;
         var _loc3_:String = _loc1_.toString() + _loc4_.toString();
         if(this.activityCircle.circleDate.indexOf(_loc3_) != -1)
         {
            return this.parseTime();
         }
         return false;
      }
      
      private function parseTime() : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         var _loc4_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc3_:uint = uint(_loc4_.hours * 60 * 60) + uint(_loc4_.minutes * 60) + uint(_loc4_.seconds);
         var _loc6_:uint = 0;
         while(_loc6_ < this.phaseTimeVec.length)
         {
            _loc5_ = this.phaseTimeVec[_loc6_].indexOf(":");
            _loc2_ = uint(this.phaseTimeVec[_loc6_].substring(0,_loc5_)) * 60 * 60 + uint(this.phaseTimeVec[_loc6_].substring(_loc5_ + 1)) * 60;
            _loc5_ = this.phaseTimeVec[_loc6_ + 1].indexOf(":");
            _loc1_ = uint(this.phaseTimeVec[_loc6_ + 1].substring(0,_loc5_)) * 60 * 60 + uint(this.phaseTimeVec[_loc6_ + 1].substring(_loc5_ + 1)) * 60;
            if(_loc3_ >= _loc2_ && _loc3_ < _loc1_ - 30)
            {
               return true;
            }
            _loc6_ += 2;
         }
         return false;
      }
      
      public function isAvailableTime() : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         if(this.activityCircle.circleType == -1)
         {
            return true;
         }
         var _loc4_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc3_:uint = uint(_loc4_.hours * 60 * 60) + uint(_loc4_.minutes * 60) + uint(_loc4_.seconds);
         var _loc6_:uint = 0;
         while(_loc6_ < this.phaseTimeVec.length)
         {
            _loc5_ = this.phaseTimeVec[_loc6_].indexOf(":");
            _loc2_ = uint(this.phaseTimeVec[_loc6_].substring(0,_loc5_)) * 60 * 60 + uint(this.phaseTimeVec[_loc6_].substring(_loc5_ + 1)) * 60;
            _loc5_ = this.phaseTimeVec[_loc6_ + 1].indexOf(":");
            _loc1_ = uint(this.phaseTimeVec[_loc6_ + 1].substring(0,_loc5_)) * 60 * 60 + uint(this.phaseTimeVec[_loc6_ + 1].substring(_loc5_ + 1)) * 60;
            if(_loc3_ >= _loc2_ && _loc3_ < _loc1_)
            {
               return true;
            }
            _loc6_ += 2;
         }
         return false;
      }
      
      public function getPhaseTimeVec(param1:uint) : Vector.<String>
      {
         var _loc2_:int = this.getPhaseIndex(param1);
         if(_loc2_ != -1)
         {
            return this.slicePhaseTimeVec(_loc2_);
         }
         return null;
      }
      
      private function slicePhaseTimeVec(param1:uint) : Vector.<String>
      {
         var _loc4_:* = undefined;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         var _loc7_:String = this.phaseTimeVec[param1 * 2];
         var _loc3_:String = this.phaseTimeVec[param1 * 2 + 1];
         var _loc2_:int = int(this.detailTimeVec.length);
         var _loc5_:uint = 0;
         while(_loc5_ < _loc2_)
         {
            if(this.detailTimeVec[_loc5_] == _loc7_)
            {
               _loc6_ = _loc5_;
            }
            if(this.detailTimeVec[_loc5_] == _loc3_)
            {
               _loc8_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         _loc4_ = this.detailTimeVec.slice(_loc6_,_loc8_);
         _loc4_.push(this.detailTimeVec[_loc8_]);
         return _loc4_;
      }
      
      public function getPhaseIndex(param1:uint) : int
      {
         var _loc3_:int = 0;
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         if(this.activityCircle.circleType == -1)
         {
            return -1;
         }
         var _loc5_:Date = new Date(param1 * 1000);
         var _loc7_:uint = uint(_loc5_.hours * 60) + uint(_loc5_.minutes);
         var _loc6_:uint = 0;
         while(_loc6_ < this.phaseTimeVec.length - 1)
         {
            _loc3_ = this.phaseTimeVec[_loc6_].indexOf(":");
            _loc2_ = uint(this.phaseTimeVec[_loc6_].substring(0,_loc3_)) * 60 + uint(this.phaseTimeVec[_loc6_].substring(_loc3_ + 1));
            _loc3_ = this.phaseTimeVec[_loc6_ + 1].indexOf(":");
            _loc4_ = uint(this.phaseTimeVec[_loc6_ + 1].substring(0,_loc3_)) * 60 + uint(this.phaseTimeVec[_loc6_ + 1].substring(_loc3_ + 1));
            if(_loc7_ >= _loc2_ && _loc7_ < _loc4_)
            {
               return _loc6_ / 2;
            }
            _loc6_ += 2;
         }
         return -1;
      }
   }
}

