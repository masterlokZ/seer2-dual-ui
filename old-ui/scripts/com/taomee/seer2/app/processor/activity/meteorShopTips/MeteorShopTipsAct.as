package com.taomee.seer2.app.processor.activity.meteorShopTips
{
   import com.taomee.seer2.app.controls.ToolBar;
   import com.taomee.seer2.app.controls.widget.BoxTipWidget;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MeteorShopTipsAct
   {
      
      public static var initTime:Number;
      
      public static var overTime:Number;
      
      private static var _mcTips:BoxTipWidget;
      
      private static var _timer:Timer = new Timer(5000);
      
      public function MeteorShopTipsAct()
      {
         super();
      }
      
      public static function setup() : void
      {
         TimeManager.addEventListener("timeUpdate",onTreasureTimeUpdate);
         initTime = TimeManager.getServerTime();
         overTime = initTime + 680;
         _mcTips = ToolBar.getWidget("boxTip") as BoxTipWidget;
         _mcTips.visible = false;
         _mcTips.mainUI.gotoAndStop(18);
      }
      
      private static function onTreasureTimeUpdate(param1:Event) : void
      {
         var nowTime:uint = 0;
         var event:Event = param1;
         if(SceneManager.active.type != 2)
         {
            nowTime = TimeManager.getServerTime();
            if(nowTime >= initTime + 600)
            {
               initTime = TimeManager.getServerTime();
               _mcTips.visible = true;
               _timer.addEventListener("timer",showTips);
               _timer.start();
               overTime = nowTime + 60;
            }
            if(nowTime >= overTime)
            {
               _timer.stop();
               if(_mcTips.mainUI.currentFrame < 9)
               {
                  MovieClipUtil.playMc(_mcTips.mainUI,10,18,function():void
                  {
                     _mcTips.visible = false;
                  });
               }
               else
               {
                  _mcTips.visible = false;
               }
               overTime = nowTime + 680;
            }
         }
      }
      
      private static function showTips(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         _timer.removeEventListener("timer",showTips);
         MovieClipUtil.playMc(_mcTips.mainUI,1,8,function():void
         {
            _timer.addEventListener("timer",closeTips);
         });
      }
      
      private static function closeTips(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         _timer.removeEventListener("timer",closeTips);
         MovieClipUtil.playMc(_mcTips.mainUI,10,18,function():void
         {
            _timer.addEventListener("timer",showTips);
         });
      }
   }
}

