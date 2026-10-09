package com.taomee.seer2.app.team.data
{
   import com.taomee.seer2.app.common.dataList.DataList;
   import com.taomee.seer2.app.common.dataList.DataUnit;
   import com.taomee.seer2.app.net.CommandSet;
   
   public class TeamMemberDataList extends DataList
   {
      
      public function TeamMemberDataList()
      {
         super(TeamMemberDataUnit,CommandSet.TEAM_MEMBER_QUERY_1090);
      }
      
      public function updateServerInfo(param1:Vector.<int>, param2:Vector.<int>) : void
      {
         var _loc4_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            getDataUnit(param1[_loc3_]).data.svrId = param2[_loc3_];
            _loc3_++;
         }
         this.sortDataList();
      }
      
      override public function load(param1:int, param2:int, param3:Boolean = false) : void
      {
         super.load(param1,param2,true);
      }
      
      private function sortDataList() : void
      {
         var _loc3_:DataUnit = null;
         var _loc2_:Vector.<DataUnit> = getDataUnitVec();
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_.length)
         {
            if(_loc2_[_loc1_].data.svrId != 0)
            {
               _loc3_ = _loc2_[_loc1_];
               _loc2_.splice(_loc1_,1);
               _loc2_.unshift(_loc3_);
            }
            _loc1_++;
         }
      }
      
      public function getOnlineCount() : int
      {
         var _loc2_:int = 0;
         var _loc1_:Vector.<DataUnit> = getDataUnitVec();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_].data.svrId != 0)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

