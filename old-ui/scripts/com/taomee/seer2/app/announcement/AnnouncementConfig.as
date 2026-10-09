package com.taomee.seer2.app.announcement
{
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import org.taomee.ds.HashMap;
   
   public class AnnouncementConfig
   {
      
      private static var _announcementXML:XML;
      
      private static var _announcementMap:HashMap;
      
      private static var _xmlClass:Class = AnnouncementConfig__xmlClass;
      
      setup();
      
      public function AnnouncementConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:AnnouncementInfo = null;
         var _loc3_:XML = null;
         _announcementMap = new HashMap();
         _announcementXML = XML(new _xmlClass());
         var _loc2_:XMLList = _announcementXML.descendants("announcement");
         for each(_loc3_ in _loc2_)
         {
            _loc1_ = new AnnouncementInfo();
            _loc1_.serverId = int(_loc3_.attribute("id"));
            _loc1_.day = int(_loc3_.attribute("day"));
            _loc1_.content = String(_loc3_.attribute("content"));
            _loc1_.frequency = String(_loc3_.attribute("frequency"));
            _announcementMap.add(_loc1_.serverId,_loc1_);
         }
      }
      
      public static function getAnnouncementInfo(param1:int) : AnnouncementInfo
      {
         if(_announcementMap.containsKey(param1))
         {
            return _announcementMap.getValue(param1);
         }
         return null;
      }
      
      public static function getAnnouncementInfoList() : Array
      {
         var _loc3_:AnnouncementInfo = null;
         var _loc6_:uint = TimeManager.getServerTime();
         var _loc5_:String = DateUtil.formatCalendarWithWeekHourMinuteSecond(_loc6_);
         var _loc8_:Array = _loc5_.split("-");
         var _loc7_:Array = _announcementMap.getValues();
         var _loc2_:Array = [];
         var _loc1_:Array = [];
         var _loc4_:Array = [];
         for each(_loc3_ in _loc7_)
         {
            if(_loc3_.day == 5)
            {
               _loc2_.push(_loc3_);
            }
            else if(_loc3_.day == 6)
            {
               _loc1_.push(_loc3_);
            }
            else if(_loc3_.day == 7)
            {
               _loc4_.push(_loc3_);
            }
         }
         if(int(_loc8_[0]) == 5)
         {
            return _loc2_;
         }
         if(int(_loc8_[0]) == 6)
         {
            return _loc1_;
         }
         return _loc4_;
      }
   }
}

