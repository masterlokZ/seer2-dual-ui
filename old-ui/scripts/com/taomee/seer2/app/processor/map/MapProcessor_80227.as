package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.controls.PetAvatarPanel;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.manager.RankManager;
   import com.taomee.seer2.app.net.parser.Parser_1521;
   import com.taomee.seer2.app.net.parser.baseData.RankServerInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.NumberPlayUtil;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.DateUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.utils.Tick;
   
   public class MapProcessor_80227 extends MapProcessor
   {
      
      private const RANK_TYPE:int = 19;
      
      private const MAX_COUNT:int = 204468;
      
      private const CURRENT_COUNT:int = 1247;
      
      private const HAS_GET_REWARD:int = 1250;
      
      private const ONE_PAGE_NUM:int = 10;
      
      private var currentPar:Parser_1521;
      
      private var maxPage:uint;
      
      private var myRankInfo:RankServerInfo;
      
      private var inTime:Boolean;
      
      private var currentCount:uint;
      
      private var maxCount:uint;
      
      private var currentMC:MovieClip;
      
      private var maxTxt:TextField;
      
      private var timeTxt:TextField;
      
      private var startBtn:SimpleButton;
      
      private var rankList:Vector.<MovieClip>;
      
      private var currentPage:int;
      
      private var changePage:MultipageComponents;
      
      private var leftTime:int;
      
      private var isToFight:Boolean;
      
      private var hasGetReward:Boolean;
      
      public function MapProcessor_80227(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.currentMC = _map.front["currentMC"];
         this.maxTxt = _map.front["maxTxt"];
         this.timeTxt = _map.front["timeTxt"];
         this.startBtn = _map.front["startBtn"];
         this.changePage = new MultipageComponents(_map.front["changePage"]);
         this.rankList = new Vector.<MovieClip>();
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            this.rankList.push(_map.front["Item" + _loc2_]);
            _loc2_++;
         }
         this.clearRankList();
         RankManager.getRankList(19,this.getRankList);
         (SceneManager.active as LobbyScene).hideToolbar();
         PetAvatarPanel.show();
         var _loc1_:Date = new Date(TimeManager.getServerTime() * 1000);
         var _loc4_:uint = _loc1_.getTime();
         _loc1_.hours = 19;
         _loc1_.minutes = 30;
         var _loc3_:uint = _loc1_.getTime();
         this.leftTime = _loc3_ - _loc4_;
         if(this.leftTime > 0)
         {
            this.leftTime /= 1000;
         }
         this.startBtn.addEventListener("click",this.showPanel);
         FightManager.addEventListener("START_SUCCESS",this.onStartFight);
         this.changePage.addEventListener("change_page",this.onChangePage);
      }
      
      protected function onStartFight(param1:Event) : void
      {
         this.isToFight = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.changePage.dispose();
         this.startBtn.removeEventListener("click",this.showPanel);
         FightManager.removeEventListener("START_SUCCESS",this.onStartFight);
         this.changePage.removeEventListener("change_page",this.onChangePage);
         if(!this.isToFight)
         {
            (SceneManager.active as LobbyScene).showToolbar();
         }
         this.isToFight = false;
      }
      
      private function onChangePage(param1:ChangePageEvent) : void
      {
         this.currentPage = param1.page - 1;
         this.updateDis();
      }
      
      private function clearRankList() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.rankList[_loc1_]["rankTxt"].text = "";
            this.rankList[_loc1_]["nameTxt"].text = "";
            this.rankList[_loc1_]["scoreTxt"].text = "";
            _loc1_++;
         }
      }
      
      protected function showPanel(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("PKRandomPetPanel");
      }
      
      private function getRankList(param1:Parser_1521) : void
      {
         this.currentPar = param1;
         var _loc2_:int = int(this.currentPar.rankInfoList.length);
         if(_loc2_ % 10 == 0)
         {
            this.changePage.maxPage = this.currentPar.rankInfoList.length / 10;
         }
         else
         {
            this.changePage.maxPage = Math.floor(this.currentPar.rankInfoList.length / 10) + 1;
         }
         RankManager.getActorRank(19,this.getMyRank);
      }
      
      private function getMyRank(param1:RankServerInfo) : void
      {
         this.myRankInfo = param1;
         DayLimitListManager.getDaylimitList([1247,1250],this.getCurrent);
      }
      
      private function getCurrent(param1:DayLimitListInfo) : void
      {
         this.currentCount = param1.getCount(1247);
         this.hasGetReward = Boolean(param1.getCount(1250));
         ActiveCountManager.requestActiveCount(204468,this.getMaxCount);
      }
      
      private function getMaxCount(param1:uint, param2:uint) : void
      {
         this.maxCount = param2;
         this.updateDis();
      }
      
      private function updateDis() : void
      {
         var list:Vector.<RankServerInfo>;
         var i:int;
         var index:int = 0;
         NumberPlayUtil.showArtNumber(this.currentCount,3,this.currentMC);
         this.maxTxt.text = this.maxCount.toString();
         this.clearRankList();
         list = this.currentPar.rankInfoList;
         for(i = 0; i < 10; )
         {
            index = this.currentPage * 10 + i;
            if(index >= list.length)
            {
               break;
            }
            if(this.currentPage == 0)
            {
               if(i == 0)
               {
                  this.rankList[i]["rankTxt"].textColor = this.rankList[i]["nameTxt"].textColor = this.rankList[i]["scoreTxt"].textColor = 16724736;
               }
               else if(i == 1)
               {
                  this.rankList[i]["rankTxt"].textColor = this.rankList[i]["nameTxt"].textColor = this.rankList[i]["scoreTxt"].textColor = 16750848;
               }
               else if(i == 2)
               {
                  this.rankList[i]["rankTxt"].textColor = this.rankList[i]["nameTxt"].textColor = this.rankList[i]["scoreTxt"].textColor = 3394611;
               }
            }
            else if(i < 3)
            {
               this.rankList[i]["rankTxt"].textColor = this.rankList[i]["nameTxt"].textColor = this.rankList[i]["scoreTxt"].textColor = 3394815;
            }
            this.rankList[i]["rankTxt"].text = list[index].currRank + 1;
            this.rankList[i]["nameTxt"].text = list[index].nick;
            this.rankList[i]["scoreTxt"].text = list[index].score;
            i++;
         }
         if(this.leftTime > 0 && !Tick.instance.hasRender(this.updateTime))
         {
            Tick.instance.addRender(this.updateTime,1000);
         }
         if(this.leftTime <= 0)
         {
            AlertManager.showAlert("活动已经结束！",function():void
            {
               SceneManager.addEventListener("switchComplete",onShow);
               SceneManager.changeScene(1,10);
            });
         }
      }
      
      private function onShow(param1:SceneEvent) : void
      {
         SceneManager.removeEventListener("switchComplete",this.onShow);
         ModuleManager.showAppModule("PKRewardExpAndXZPanel");
      }
      
      private function updateTime(param1:uint) : void
      {
         --this.leftTime;
         this.timeTxt.text = DateUtil.getHMS(this.leftTime);
         if(this.leftTime == 0)
         {
            this.updateDis();
            Tick.instance.removeRender(this.updateTime);
         }
      }
   }
}

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import org.taomee.filter.ColorFilter;

class MultipageComponents extends Sprite
{
   
   private var _maxPage:int;
   
   private var currentPage:int = 1;
   
   private var _ui:MovieClip;
   
   public function MultipageComponents(param1:MovieClip)
   {
      super();
      this._ui = param1;
      this._ui["pre"].addEventListener("click",this.changePage);
      this._ui["next"].addEventListener("click",this.changePage);
      this.checkPage();
   }
   
   public function dispose() : void
   {
      this._ui["pre"].removeEventListener("click",this.changePage);
      this._ui["next"].removeEventListener("click",this.changePage);
   }
   
   public function reset() : void
   {
      this.currentPage = 1;
      this.checkPage();
   }
   
   public function set maxPage(param1:int) : void
   {
      this._maxPage = param1;
      if(this._maxPage == 0)
      {
         this._maxPage = 1;
      }
      this.checkPage();
   }
   
   private function changePage(param1:MouseEvent) : void
   {
      if(param1.target == this._ui["next"])
      {
         ++this.currentPage;
      }
      else
      {
         --this.currentPage;
      }
      this.currentPage = this.currentPage < 1 ? 1 : int(this.currentPage);
      this.currentPage = this.currentPage > this._maxPage ? int(this._maxPage) : int(this.currentPage);
      this.dispatchEvent(new ChangePageEvent("change_page",this.currentPage));
      this.checkPage();
   }
   
   private function checkPage() : void
   {
      if(this.currentPage == 1)
      {
         ColorFilter.setGrayscale(this._ui["pre"]);
         this._ui["pre"].mouseEnabled = false;
      }
      else
      {
         this._ui["pre"].filters = [];
         this._ui["pre"].mouseEnabled = true;
      }
      if(this.currentPage == this._maxPage)
      {
         ColorFilter.setGrayscale(this._ui["next"]);
         this._ui["next"].mouseEnabled = false;
      }
      else
      {
         this._ui["next"].mouseEnabled = true;
         this._ui["next"].filters = [];
      }
      this._ui["pages"].text = this.currentPage + "/" + this._maxPage.toString();
   }
}

class ChangePageEvent extends Event
{
   
   public static const CHANGE_PAGE:String = "change_page";
   
   private var _page:int;
   
   public function ChangePageEvent(param1:String, param2:int)
   {
      this._page = param2;
      super(param1);
   }
   
   public function get page() : int
   {
      return this._page;
   }
}
