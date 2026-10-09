package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.manager.SeatTipsManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.ResourceLibrary;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.BitUtil;
   import org.taomee.utils.Tick;
   
   public class TwelveTurnFight
   {
      
      private static var _instance:TwelveTurnFight;
      
      private var _frontMc:Sprite;
      
      private var _stateId:uint;
      
      private var _timeDate:Date = new Date();
      
      private var _allXml:XML;
      
      private var _actXml:XML;
      
      private var _mapId:uint;
      
      private var _currentTurn:uint;
      
      private var _fightState:uint;
      
      private var _sceneMcUrl:String;
      
      private var _currentMcUrl:String;
      
      private var resLib:ResourceLibrary;
      
      private var rewardTipsMc:MovieClip;
      
      private var sceneMc:MovieClip;
      
      private var currentNpc:MovieClip;
      
      private var seatPoint:Point = new Point();
      
      private var npcNum:uint;
      
      private var turnXml:XML;
      
      private var startDate:Date;
      
      public function TwelveTurnFight()
      {
         super();
      }
      
      public static function getInstance() : TwelveTurnFight
      {
         if(!_instance)
         {
            _instance = new TwelveTurnFight();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         ActorManager.showRemoteActor = false;
         this._frontMc = SceneManager.active.mapModel.front;
         this._mapId = SceneManager.active.mapID;
         if(!this._allXml)
         {
            QueueLoader.load(URLUtil.getActivityXML("TwelveTurnConfig"),"text",this.onComplete);
         }
         else
         {
            this.setActXml();
         }
         Tick.instance.addRender(this.updateTime,10000);
      }
      
      public function dispose() : void
      {
         Tick.instance.removeRender(this.updateTime);
         DialogPanel.removeEventListener("customReplyClick",this.replyClick);
         if(this.currentNpc)
         {
            this.currentNpc.removeEventListener("click",this.toFight);
         }
         SeatTipsManager.removeSeat(this.seatPoint,this._mapId);
         DialogPanel.functionalityBox.visible = true;
         if(this.rewardTipsMc)
         {
            DisplayObjectUtil.removeFromParent(this.rewardTipsMc);
         }
      }
      
      private function updateTime(param1:int) : void
      {
         var m:* = 0;
         var turn:* = 0;
         var n:int = param1;
         this._timeDate.setTime(TimeManager.getPrecisionServerTime() * 1000);
         m = uint(this._timeDate.minutes);
         turn = uint(Math.floor(m / 5) + 1);
         if(this._timeDate.hours != this.startDate.hours)
         {
            SceneManager.changeScene(1,70);
            return;
         }
         if(this._currentTurn != turn)
         {
            this._currentTurn = turn;
            SeatTipsManager.removeSeat(this.seatPoint,this._mapId);
            this.turnXml = XML(this._actXml.turn.(@id == _currentTurn));
            DayLimitManager.getDoCount(this._stateId,this.getState);
         }
      }
      
      private function setActXml() : void
      {
         var dateList:Array = null;
         var i:int = 0;
         var list:Array = null;
         var overTime:Number = NaN;
         this._actXml = XML(this._allXml.act.(@id == _mapId));
         if(!this._actXml)
         {
            return;
         }
         this.npcNum = uint(this._actXml.@npcNum);
         this._stateId = uint(this._actXml.@stateId);
         this._sceneMcUrl = String(this._actXml.@res);
         this._timeDate.setTime(TimeManager.getPrecisionServerTime() * 1000);
         this.startDate = new Date();
         dateList = String(this._actXml.@time).split(",");
         this._currentTurn = 0;
         i = 0;
         while(i < dateList.length)
         {
            list = dateList[i].toString().split("-");
            this.startDate.fullYear = uint(list[0]);
            this.startDate.month = uint(list[1]) - 1;
            this.startDate.date = uint(list[2]);
            this.startDate.hours = uint(list[3]);
            this.startDate.minutes = uint(list[4]);
            overTime = (this._timeDate.getTime() - this.startDate.getTime()) / 1000;
            if(overTime >= 0)
            {
               this._currentTurn = Math.ceil(overTime / 300);
               if(this._currentTurn <= 12)
               {
                  break;
               }
            }
            i++;
         }
         if(this._currentTurn == 0 || this._currentTurn > 12)
         {
            NpcDialog.hide();
            SceneManager.changeScene(1,70);
            return;
         }
         this.turnXml = XML(this._actXml.turn.(@id == _currentTurn));
         DayLimitManager.getDoCount(this._stateId,this.getState);
      }
      
      private function getState(param1:uint) : void
      {
         this._fightState = param1;
         if(this._currentMcUrl != this._sceneMcUrl)
         {
            this._currentMcUrl = this._sceneMcUrl;
            QueueLoader.load(URLUtil.getActivityAnimation("twelveturn/" + this._currentMcUrl),"domain",this.onLoadComplete);
         }
         else
         {
            this.updateMc();
         }
      }
      
      private function onLoadComplete(param1:ContentInfo) : void
      {
         this.resLib = new ResourceLibrary(param1.content);
         this.updateMc();
      }
      
      private function updateMc() : void
      {
         var xml:XML = null;
         var def:NpcDefinition = null;
         DialogPanel.hide();
         if(!this.rewardTipsMc)
         {
            this.rewardTipsMc = this.resLib.getMovieClip("RewardTipsMc");
         }
         SceneManager.active.mapModel.front.addChild(this.rewardTipsMc);
         this.rewardTipsMc.y = 150;
         this.rewardTipsMc.turnTxt.text = "第" + this._currentTurn + "轮对战开始";
         this.rewardTipsMc.rewardTxt.text = "当前奖励:\n" + this.turnXml.@rewardDes;
         if(this.sceneMc)
         {
            this.sceneMc.stop();
            DisplayObjectUtil.removeFromParent(this.sceneMc);
         }
         if(!BitUtil.getBit(this._fightState,this._currentTurn - 1))
         {
            this.sceneMc = this.resLib.getMovieClip(this.turnXml.@animationName);
            this._frontMc.addChild(this.sceneMc);
            MovieClipUtil.playMc(this.sceneMc,1,this.sceneMc.totalFrames,function():void
            {
               var xml:XML = null;
               var def:NpcDefinition = null;
               xml = XML(turnXml.npc.(@type == "prewar"));
               def = new NpcDefinition(xml);
               DialogPanel.functionalityBox.visible = false;
               DialogPanel.addEventListener("customReplyClick",replyClick);
               DialogPanel.showForNpc(def);
            },true);
         }
         else
         {
            if(SceneManager.prevSceneType == 2)
            {
               xml = XML(this.turnXml.npc.(@type == "postwar"));
               def = new NpcDefinition(xml);
               DialogPanel.addEventListener("customReplyClick",this.replyClick);
               DialogPanel.showForNpc(def);
            }
            this.sceneMc = this.resLib.getMovieClip(this.turnXml.@animationName);
            this.sceneMc.gotoAndStop(this.sceneMc.totalFrames);
            this._frontMc.addChild(this.sceneMc);
            this.getCurrentNpc();
         }
      }
      
      private function replyClick(param1:DialogPanelEvent) : void
      {
         var params:String;
         var event:DialogPanelEvent = param1;
         DialogPanel.removeEventListener("customReplyClick",this.replyClick);
         params = (event.content as DialogPanelEventData).params;
         if(params == "showNpcSeatTips")
         {
            SeatTipsManager.removeSeat(this.seatPoint,this._mapId);
            this.getCurrentNpc();
            this.seatPoint.x = this.currentNpc.x;
            this.seatPoint.y = this.currentNpc.y - 10;
            SeatTipsManager.registerSeat(this.seatPoint,this._mapId);
         }
         else if(params == "playFull")
         {
            MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("twelveTurn/" + this._actXml.@res),function():void
            {
               SceneManager.changeScene(1,70);
            });
         }
         else if((event.content as DialogPanelEventData).type == "playSceneMc")
         {
         }
      }
      
      private function getCurrentNpc() : void
      {
         if(this.currentNpc)
         {
            this.currentNpc.removeEventListener("click",this.toFight);
         }
         LayerManager.resetOperation();
         var _loc1_:int = 0;
         while(_loc1_ < this.npcNum)
         {
            if(this.sceneMc["Npc" + _loc1_] != null)
            {
               this.sceneMc["Npc" + _loc1_].mouseChildren = this.sceneMc["Npc" + _loc1_].mouseEnabled = false;
            }
            _loc1_++;
         }
         this.currentNpc = this.sceneMc["Npc" + this.turnXml.@npcIndex];
         this.currentNpc.buttonMode = true;
         this.currentNpc.mouseChildren = false;
         this.currentNpc.mouseEnabled = true;
         this.currentNpc.addEventListener("click",this.toFight);
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         var xml:XML = null;
         var def:NpcDefinition = null;
         var event:MouseEvent = param1;
         if(this._timeDate.hours != this.startDate.hours)
         {
            SceneManager.changeScene(1,70);
            return;
         }
         if(BitUtil.getBit(this._fightState,this._currentTurn - 1))
         {
            xml = XML(this._actXml.waitDia.npc.(@index == turnXml.@npcIndex));
            def = new NpcDefinition(xml);
            DialogPanel.showForNpc(def);
         }
         else
         {
            SeatTipsManager.removeSeat(this.seatPoint,this._mapId);
            FightManager.startFightWithWild(this.turnXml.@fightId);
         }
      }
      
      private function onComplete(param1:ContentInfo) : void
      {
         this._allXml = XML(param1.content);
         this.setActXml();
      }
   }
}

