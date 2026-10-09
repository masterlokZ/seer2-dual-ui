package com.taomee.seer2.app.gameRule.cavingNotice
{
   public class CavingNoticeData
   {
      
      private static var _recordActivities:Vector.<ActivityRecord> = new Vector.<ActivityRecord>();
      
      public static const ACTIVITY_DATAS:Vector.<CavingPageInfo> = Vector.<CavingPageInfo>([new CavingPageInfo(27,310,"“三八”双雄战！",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,6,15,0,16,0),new CavingTimeInfo(false,0,15,0,16,0)])),new CavingPageInfo(28,20,"资质修炼器",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,6,14,0,16,0),new CavingTimeInfo(false,0,14,0,16,0)]))]);
      
      public static const NOTIC_DATAS:Vector.<CavingPageInfo> = Vector.<CavingPageInfo>([new CavingPageInfo(0,90,"敌报！萨伦帝国入侵",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,5,14,0,15,0),new CavingTimeInfo(false,5,19,0,20,0)])),new CavingPageInfo(1,160,"重夺水源之心",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,6,14,0,15,0),new CavingTimeInfo(false,6,19,0,20,0)])),new CavingPageInfo(2,261,"火焰山激斗",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,0,14,0,15,0),new CavingTimeInfo(false,0,19,0,20,0)])),new CavingPageInfo(15,350,"“鸡”毛与沙",Vector.<CavingTimeInfo>([new CavingTimeInfo(true)])),new CavingPageInfo(3,81,"守擂达人",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,6,20,0,21,0),new CavingTimeInfo(false,0,20,0,21,0)])),new CavingPageInfo(4,81,"双倍荣誉",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,6,20,0,21,0),new CavingTimeInfo(false,0,20,0,21,0)])),new CavingPageInfo(16,262,"M5战书？我接受！",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,6,16,0,17,0),new CavingTimeInfo(false,0,16,0,17,0)]))]);
      
      public static const ALLACTIVITY:Vector.<CavingPageInfo> = ACTIVITY_DATAS.concat(NOTIC_DATAS);
      
      public static const RAREPET_DATAS:Vector.<CavingPageInfo> = Vector.<CavingPageInfo>([new CavingPageInfo(11,340,"摇滚天王：爆炸头！",Vector.<CavingTimeInfo>([new CavingTimeInfo(true)])),new CavingPageInfo(12,520,"闻笛起舞？！",Vector.<CavingTimeInfo>([new CavingTimeInfo(true)])),new CavingPageInfo(13,262,"谁敢打扰达达用餐？",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,0,13,0,14,0),new CavingTimeInfo(false,1,13,0,14,0),new CavingTimeInfo(false,2,13,0,14,0),new CavingTimeInfo(false,3,13,0,14,0),new CavingTimeInfo(false,4,13,0,14,0),new CavingTimeInfo(false,5,13,0,14,0),new CavingTimeInfo(false,6,13,0,14,0)])),new CavingPageInfo(14,125,"谁偷吃了我的料理？",Vector.<CavingTimeInfo>([new CavingTimeInfo(false,0,18,0,20,0),new CavingTimeInfo(false,1,18,0,20,0),new CavingTimeInfo(false,2,18,0,20,0),new CavingTimeInfo(false,3,18,0,20,0),new CavingTimeInfo(false,4,18,0,20,0),new CavingTimeInfo(false,5,18,0,20,0),new CavingTimeInfo(false,6,18,0,20,0)])),new CavingPageInfo(29,132,"爱之拂晓兔",Vector.<CavingTimeInfo>([new CavingTimeInfo(true)]))
      ,new CavingPageInfo(30,70,"回忆的鲁卜利娃娃",Vector.<CavingTimeInfo>([new CavingTimeInfo(true)]))]);
      
      public static const ONLYPET_DATAS:Vector.<CavingPageInfo> = Vector.<CavingPageInfo>([new CavingPageInfo(6,540,"万圣节精灵：阿布",Vector.<CavingTimeInfo>([new CavingTimeInfo(false)])),new CavingPageInfo(17,70,"埃卡维特的梦境奇遇",Vector.<CavingTimeInfo>([new CavingTimeInfo(false)])),new CavingPageInfo(19,20,"姜饼城不眠夜",Vector.<CavingTimeInfo>([new CavingTimeInfo(false)])),new CavingPageInfo(23,70,"提灯怪灵闹新春！",Vector.<CavingTimeInfo>([new CavingTimeInfo(false)]))]);
      
      public function CavingNoticeData()
      {
         super();
      }
      
      public static function hasNoticeActivity() : Boolean
      {
         var _loc1_:CavingPageInfo = null;
         var _loc2_:Boolean = false;
         for each(_loc1_ in ALLACTIVITY)
         {
            if(checkActivity(_loc1_))
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      private static function checkActivity(param1:CavingPageInfo) : Boolean
      {
         var _loc3_:CavingTimeInfo = null;
         var _loc2_:Boolean = false;
         var _loc4_:ActivityRecord = null;
         var _loc5_:Boolean = false;
         var _loc7_:Vector.<CavingTimeInfo> = param1.times;
         var _loc6_:uint = param1.pageId;
         for each(_loc3_ in _loc7_)
         {
            if(_loc3_.allTime == false)
            {
               if(_loc3_.isInTimeScope())
               {
                  _loc2_ = false;
                  for each(_loc4_ in _recordActivities)
                  {
                     if(_loc4_.pageId == _loc6_ && _loc4_.timeInfo.compare(_loc3_))
                     {
                        _loc2_ = true;
                        break;
                     }
                  }
                  if(_loc2_ == false)
                  {
                     _loc5_ = true;
                     _recordActivities.push(new ActivityRecord(_loc6_,_loc3_));
                  }
               }
            }
         }
         return _loc5_;
      }
      
      public static function addTagButton(param1:TagButton, param2:uint) : void
      {
         var _loc3_:Boolean = checkPageInfo(param1,param2,ALLACTIVITY);
         if(_loc3_ == false)
         {
            _loc3_ = checkPageInfo(param1,param2,RAREPET_DATAS);
         }
         if(_loc3_ == false)
         {
            _loc3_ = checkPageInfo(param1,param2,ONLYPET_DATAS);
         }
      }
      
      private static function checkPageInfo(param1:TagButton, param2:uint, param3:Vector.<CavingPageInfo>) : Boolean
      {
         var _loc4_:CavingPageInfo = null;
         var _loc5_:Boolean = false;
         for each(_loc4_ in param3)
         {
            if(_loc4_.pageId == param2)
            {
               _loc4_.btn = param1;
               _loc5_ = true;
               break;
            }
         }
         return _loc5_;
      }
   }
}

