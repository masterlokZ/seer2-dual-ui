package com.taomee.seer2.app.controls.widget
{
   import com.taomee.seer2.app.controls.widget.core.IWidgetable;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.newPlayerGuideVerOne.NewPlayerGuideTimeManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.manager.GlobalsManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.ui.toolTip.tipSkins.CommonTipSkin;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.Tick;
   
   public class BatteryTimeWidget extends Sprite implements IWidgetable
   {
      
      public static const TIME:String = "time";
      
      private static var isShowBattery:Boolean = false;
      
      private const FRESH_RATE:uint = 5000;
      
      private var _mainUI:MovieClip;
      
      private var _hourNumMc:MovieClip;
      
      private var _minDecadeNumMc:MovieClip;
      
      private var _minUnitMc:MovieClip;
      
      private var _hour:uint;
      
      private var _min:uint;
      
      private var _capacityVec:Vector.<MovieClip>;
      
      private var _batteryPanelProcessor:Boolean;
      
      private var _isReturnFromFight:Boolean;
      
      private var _isReturnFromGame:Boolean;
      
      private var _isAllowOpenBatteryPanel:Boolean;
      
      private var _hasShowBatteryCompletePanel:Boolean;
      
      private var _ball:MovieClip;
      
      private var _shopBtn:SimpleButton;
      
      private var _timeTip:SimpleButton;
      
      private var _chpherMC:MovieClip;
      
      private var _baoxiang:MovieClip;
      
      public var isPause:Boolean = false;
      
      private var _lastShowTime:Number = 0;
      
      private var _onlineTip:CommonTipSkin;
      
      public function BatteryTimeWidget(param1:MovieClip)
      {
         super();
         buttonMode = true;
         this._mainUI = param1;
         addChild(this._mainUI);
         this.initialize();
         this._timeTip.addEventListener("click",this.onClick);
      }
      
      private function initialize() : void
      {
         this._hourNumMc = this._mainUI["mcHour"];
         this._minDecadeNumMc = this._mainUI["mcMinDecade"];
         this._minUnitMc = this._mainUI["mcMinUnit"];
         this._ball = this._mainUI["batteryFrame"]["ball"];
         this._shopBtn = this._mainUI["shopBtn"];
         this._timeTip = this._mainUI["timeTip"];
         this._chpherMC = this._mainUI["chpherMC"];
         this._baoxiang = this._mainUI["baoxiang"];
         this._baoxiang.mouseChildren = false;
         this._baoxiang.mouseEnabled = false;
         if(NewPlayerGuideTimeManager.timeCheckNewGuide() && !QuestManager.isComplete(99))
         {
            this._baoxiang.gotoAndStop(1);
         }
         this._chpherMC.buttonMode = true;
         TooltipManager.addCommonTip(this._chpherMC,"设置支付密码");
         this._chpherMC.addEventListener("click",this.onChpher);
         TooltipManager.addCommonTip(this._shopBtn,"商城");
         this._shopBtn.addEventListener("click",this.onShop);
         this._capacityVec = new Vector.<MovieClip>();
         this._capacityVec = Vector.<MovieClip>([this._mainUI["capacity0"],this._mainUI["capacity1"],this._mainUI["capacity2"],this._mainUI["capacity3"]]);
         this.setNormalBattery();
         this.updateDoubleEXPStatus();
         Tick.instance.addRender(this.onTimer,5000);
         this.updateTime();
         this.initOnlineTip();
      }
      
      private function onChpher(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("ChpherPanel"),"正在打开...");
      }
      
      private function onShop(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("ShopPanel"),"正在打开...");
         this._baoxiang.gotoAndStop(1);
         StatisticsManager.sendNovice("0x10033610");
      }
      
      private function setNormalBattery() : void
      {
         var _loc1_:MovieClip = null;
         TooltipManager.addCommonTip(this._timeTip,"双倍经验时间收集器");
         (this._mainUI["timeContainerMC"] as MovieClip).gotoAndStop(1);
         for each(_loc1_ in this._capacityVec)
         {
            _loc1_.gotoAndStop(1);
         }
      }
      
      private function setDoubleExpBattery() : void
      {
         var _loc1_:MovieClip = null;
         (this._mainUI["timeContainerMC"] as MovieClip).gotoAndStop(2);
         for each(_loc1_ in this._capacityVec)
         {
            _loc1_.gotoAndStop(2);
         }
      }
      
      private function updateDoubleExpBatteryTips() : void
      {
         TooltipManager.remove(this._timeTip);
         var _loc1_:uint = TimeManager.getAvailableDoubleExpTime();
         if(_loc1_ >= 60)
         {
            TooltipManager.addCommonTip(this._timeTip,"双倍经验时间还剩：" + uint(_loc1_ / 60) + "分钟");
         }
         else
         {
            TooltipManager.addCommonTip(this._timeTip,"双倍经验时间还剩：" + _loc1_ + "秒");
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         StatisticsManager.sendNovice("0x10033611");
         param1.stopImmediatePropagation();
         ModuleManager.toggleModule(URLUtil.getAppModule("DoubleExpTimePanel"),"正在打开双倍经验时间收集器…");
      }
      
      private function updateDoubleEXPStatus() : void
      {
         if(TimeManager.getAvailableDoubleExpTime())
         {
            this.updateDoubleExpBatteryTips();
            if((this._mainUI["timeContainerMC"] as MovieClip).currentFrame != 2)
            {
               this.setDoubleExpBattery();
            }
         }
         else if(TimeManager.getAvailableDoubleExpTime() == 0 && (this._mainUI["timeContainerMC"] as MovieClip).currentFrame != 1)
         {
            TooltipManager.remove(this._timeTip);
            this.setNormalBattery();
         }
      }
      
      private function onTimer(param1:int) : void
      {
         if(!this.isPause)
         {
            this.updateTime();
            this.showBatteryCompletePanel();
            this.battery();
         }
      }
      
      private function updateTime() : void
      {
         var _loc2_:uint = TimeManager.getAvailableTime();
         this._hour = _loc2_ / 3600;
         this._min = _loc2_ % 3600 / 60;
         var _loc1_:uint = this._min / 10;
         var _loc3_:uint = this._min % 10;
         this._hourNumMc.gotoAndStop(this._hour + 1);
         this._minDecadeNumMc.gotoAndStop(_loc1_ + 1);
         this._minUnitMc.gotoAndStop(_loc3_ + 1);
         this.updateDoubleEXPStatus();
         this.updateCapacityDisplay();
         this.updateDoubleExpBall();
      }
      
      private function updateCapacityDisplay() : void
      {
         var _loc6_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc5_:int = int(TimeManager.getAvailableTime());
         var _loc4_:int = int(TimeManager.getMaxAvailableTime());
         var _loc7_:int = _loc5_ / _loc4_ * 100;
         _loc6_ = int(_loc7_ / 20);
         _loc6_ = int(_loc6_ > 4 ? 4 : _loc6_);
         var _loc2_:int = int(this._capacityVec.length);
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this._capacityVec[_loc1_];
            if(_loc1_ < _loc6_)
            {
               _loc3_.visible = true;
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc1_++;
         }
      }
      
      private function updateDoubleExpBall() : void
      {
         if(TimeManager.getAvailableDoubleExpTime() == 0 && TimeManager.getAvailableTime() > 0)
         {
            if(this._mainUI["batteryFrame"].contains(this._ball) == false)
            {
               this._mainUI["batteryFrame"].addChild(this._ball);
            }
         }
         else
         {
            DisplayObjectUtil.removeFromParent(this._ball);
         }
      }
      
      private function showBatteryCompletePanel() : void
      {
         var _loc1_:uint = TimeManager.getAvailableTime();
         this.batteryNext(_loc1_);
         if(TimeManager.isLoginAfterTimeComplete == false && _loc1_ <= 0 && this._hasShowBatteryCompletePanel == false)
         {
            this._hasShowBatteryCompletePanel = true;
            ModuleManager.showModule(URLUtil.getAppModule("BatteryCompletePanel"),"电池耗尽");
         }
      }
      
      private function batteryNext(param1:uint) : void
      {
         var _loc2_:uint = 18000 - param1;
         if(_loc2_ >= 18000)
         {
            if(new Date().time - this._lastShowTime >= 900000)
            {
               AlertManager.showIndulgeAlert("您已进入不健康游戏时间，为了您的健康，请您立即下线休息。如不下线，您的身体将受到损害，您的收益已降为零，第二天将恢复正常。");
               this._lastShowTime = new Date().time;
            }
            return;
         }
         if(_loc2_ > 3660 && _loc2_ < 3690)
         {
            isShowBattery = false;
         }
         else if(_loc2_ > 7260 && _loc2_ < 7290)
         {
            isShowBattery = false;
         }
         else if(_loc2_ > 10860 && _loc2_ < 10890)
         {
            isShowBattery = false;
         }
         else if(_loc2_ > 12660 && _loc2_ < 12690)
         {
            isShowBattery = false;
         }
         else if(_loc2_ > 14460 && _loc2_ < 14490)
         {
            isShowBattery = false;
         }
         else if(_loc2_ > 16260 && _loc2_ < 16290)
         {
            isShowBattery = false;
         }
         if(isShowBattery)
         {
            return;
         }
         if(_loc2_ >= 3600 && _loc2_ <= 3660)
         {
            isShowBattery = true;
            AlertManager.showIndulgeAlert("您累计在线时间已满1小时");
         }
         else if(_loc2_ >= 7200 && _loc2_ <= 7260)
         {
            isShowBattery = true;
            AlertManager.showIndulgeAlert("您累计在线时间已满2小时");
         }
         else if(_loc2_ >= 10800 && _loc2_ <= 10860)
         {
            isShowBattery = true;
            AlertManager.showIndulgeAlert("您累计在线时间已满3小时,您已经进入疲劳游戏时间，您的游戏收益将降为正常值的50%，为了您的健康，请尽快下线休息，做适当身体活动，合理安排学习生活。");
         }
         else if(_loc2_ >= 12600 && _loc2_ <= 12660)
         {
            isShowBattery = true;
            AlertManager.showIndulgeAlert("您已经进入疲劳游戏时间，您的游戏收益将降为正常值的50%，为了您的健康，请尽快下线休息，做适当身体活动，合理安排学习生活。");
         }
         else if(_loc2_ >= 14400 && _loc2_ <= 14460)
         {
            isShowBattery = true;
            AlertManager.showIndulgeAlert("您已经进入疲劳游戏时间，您的游戏收益将降为正常值的50%，为了您的健康，请尽快下线休息，做适当身体活动，合理安排学习生活。");
         }
         else if(_loc2_ >= 16200 && _loc2_ <= 16260)
         {
            isShowBattery = true;
            AlertManager.showIndulgeAlert("您已经进入疲劳游戏时间，您的游戏收益将降为正常值的50%，为了您的健康，请尽快下线休息，做适当身体活动，合理安排学习生活。");
         }
      }
      
      private function battery() : void
      {
         var _loc1_:uint = TimeManager.getHasBeenUsedTime();
         if(TimeManager.getAvailableTime() > 0)
         {
            this.timeWithin(_loc1_);
         }
         else
         {
            this.timeOutside(_loc1_);
         }
      }
      
      private function timeWithin(param1:uint) : void
      {
         this.fightAfterShowBatteryPanel();
         this.gameAfterShowBatteryPanel();
         this.openBatteryPanel();
         if(param1 / 2700 >= 1 && param1 % 2700 <= 8)
         {
            if(this._batteryPanelProcessor == false && SceneManager.active.type != 2 && GlobalsManager.isPlayingGame == false && TimeManager.isAllowOpenBatteryPanel)
            {
               this.showBatteryPanel();
            }
            else if(SceneManager.active.type == 2)
            {
               this._isReturnFromFight = true;
            }
            else if(GlobalsManager.isPlayingGame)
            {
               this._isReturnFromGame = true;
            }
            else if(TimeManager.isAllowOpenBatteryPanel == false)
            {
               this._isAllowOpenBatteryPanel = true;
            }
         }
      }
      
      private function timeOutside(param1:uint) : void
      {
         this.fightAfterShowBatteryPanel();
         this.gameAfterShowBatteryPanel();
         this.openBatteryPanel();
         if(param1 / 900 >= 1 && param1 % 900 <= 8)
         {
            if(this._batteryPanelProcessor == false && SceneManager.active.type != 2 && GlobalsManager.isPlayingGame == false && TimeManager.isAllowOpenBatteryPanel)
            {
               this.showBatteryPanel();
            }
            else if(SceneManager.active.type == 2)
            {
               this._isReturnFromFight = true;
            }
            else if(GlobalsManager.isPlayingGame)
            {
               this._isReturnFromGame = true;
            }
            else if(TimeManager.isAllowOpenBatteryPanel == false)
            {
               this._isAllowOpenBatteryPanel = true;
            }
         }
      }
      
      private function showBatteryPanel() : void
      {
         this._batteryPanelProcessor = true;
         ModuleManager.addEventListener("BatteryPanel","dispose",this.onBatteryPanelDispose);
         ModuleManager.toggleModule(URLUtil.getAppModule("BatteryPanel"),"正在打开每日休息面板...");
      }
      
      private function fightAfterShowBatteryPanel() : void
      {
         if(this._isReturnFromFight && SceneManager.active.type != 2)
         {
            this._isReturnFromFight = false;
            this.showBatteryPanel();
            return;
         }
      }
      
      private function gameAfterShowBatteryPanel() : void
      {
         if(this._isReturnFromGame && GlobalsManager.isPlayingGame == false)
         {
            this._isReturnFromGame = false;
            this.showBatteryPanel();
            return;
         }
      }
      
      private function openBatteryPanel() : void
      {
         if(this._isAllowOpenBatteryPanel == true && TimeManager.isAllowOpenBatteryPanel == true && SceneManager.active.type != 2 && GlobalsManager.isPlayingGame == false)
         {
            this._isAllowOpenBatteryPanel = false;
            this.showBatteryPanel();
            return;
         }
      }
      
      private function onBatteryPanelDispose(param1:Event) : void
      {
         this._batteryPanelProcessor = false;
      }
      
      private function initOnlineTip() : void
      {
         if(TimeManager.getAvailableDoubleExpTime() > 0 && TimeManager.getAvailableDoubleExpTime() < 3600)
         {
            this._timeTip.addEventListener("rollOver",this.onOnlineTipRollOver);
            Tick.instance.addTimeout(5 * 1000,this.onOnlineTipTimeOver);
            this._onlineTip = new CommonTipSkin();
            this._onlineTip.isFlip = false;
            this._onlineTip.x = 710;
            this._onlineTip.y = 495;
            this._onlineTip.show("你有1小时双倍经验时间可以领取哦！");
         }
      }
      
      private function onOnlineTipRollOver(param1:MouseEvent) : void
      {
         this.disposeOnlineTip();
      }
      
      private function onOnlineTipTimeOver() : void
      {
         this.disposeOnlineTip();
      }
      
      private function disposeOnlineTip() : void
      {
         DisplayObjectUtil.removeFromParent(this._onlineTip);
         removeEventListener("rollOver",this.onOnlineTipRollOver);
         Tick.instance.removeTimeout(this.onOnlineTipTimeOver);
      }
   }
}

