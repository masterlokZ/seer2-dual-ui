package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.IDataInput;
   
   public class PetKingRankMsgManager
   {
      
      private static var _instance:PetKingRankMsgManager;
      
      public static const RED_TEAM:int = 1;
      
      public static const BLUE_TEAM:int = 2;
      
      public static const GREEN_TEAM:int = 3;
      
      private var _teamName:String;
      
      private var _curtTeam:uint = 0;
      
      private var _teamNameList:Array = [null,"热辣队","冰沁队","丛林队"];
      
      private var _teamList:Array = [];
      
      private var _curtHours:uint;
      
      public function PetKingRankMsgManager(param1:PrivateClass)
      {
         super();
      }
      
      public static function instance() : PetKingRankMsgManager
      {
         if(_instance == null)
         {
            _instance = new PetKingRankMsgManager(new PrivateClass());
         }
         return _instance;
      }
      
      public function update() : void
      {
         if(QuestManager.isCompleteGudieTask() == false)
         {
            return;
         }
         if(SceneManager.currentSceneType == 2)
         {
            return;
         }
         var _loc2_:uint = TimeManager.getServerTime();
         var _loc1_:Date = new Date(_loc2_ * 1000);
         if(_loc1_.getMinutes() == 30 && _loc1_.getHours() != this._curtHours)
         {
            this.setTeam();
            Connection.addCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,this.onGetTotalVote);
            Connection.send(CommandSet.GET_TOTAL_VOTE_INFO_1219,1,1,3);
            this._curtHours = _loc1_.getHours();
         }
      }
      
      private function onGetTotalVote(param1:MessageEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         var _loc5_:Object = null;
         Connection.removeCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,this.onGetTotalVote);
         var _loc6_:IDataInput = param1.message.getRawData();
         var _loc8_:uint = _loc6_.readUnsignedInt();
         var _loc7_:uint = _loc6_.readUnsignedInt();
         this._teamList.length = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc7_)
         {
            _loc3_ = _loc6_.readUnsignedInt();
            _loc2_ = _loc6_.readUnsignedInt();
            _loc5_ = {
               "name":this._teamNameList[_loc3_],
               "count":_loc2_
            };
            this._teamList.push(_loc5_);
            _loc4_++;
         }
         this.sortTeam();
         this.showTxt();
      }
      
      private function sortTeam() : void
      {
         this._teamList.sortOn("count",16);
      }
      
      private function showTxt() : void
      {
         ServerMessager.addMessage(this.checkColor(this._teamList[2]["name"]) + "精灵王争霸赛总积分为" + this._teamList[2]["count"] + "，现在排名第一|查看详情|PetKingFightIntegralPanel|正在努力加载中...");
         ServerMessager.addMessage(this.checkColor(this._teamList[1]["name"]) + "精灵王争霸赛总积分为" + this._teamList[1]["count"] + "，现在排名第二|查看详情|PetKingFightIntegralPanel|正在努力加载中...");
         ServerMessager.addMessage(this.checkColor(this._teamList[0]["name"]) + "精灵王争霸赛总积分为" + this._teamList[0]["count"] + "，现在排名第三|查看详情|PetKingFightIntegralPanel|正在努力加载中...");
      }
      
      private function checkColor(param1:String) : String
      {
         var _loc2_:String = param1;
         if(param1 == this._teamName)
         {
            _loc2_ = "<font color=\'#ff0000\'>" + this._teamName + "</font>";
         }
         return _loc2_;
      }
      
      private function setTeam() : void
      {
         switch(int(ActorManager.actorInfo.activityData[1]) - 500508)
         {
            case 0:
               this._curtTeam = 1;
               this._teamName = "热辣队";
               break;
            case 1:
               this._teamName = "冰沁队";
               this._curtTeam = 2;
               break;
            case 2:
               this._teamName = "丛林队";
               this._curtTeam = 3;
               break;
            default:
               this._curtTeam = 0;
         }
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
