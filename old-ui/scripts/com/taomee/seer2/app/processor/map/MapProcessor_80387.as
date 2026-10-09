package com.taomee.seer2.app.processor.map
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.component.MouseClickHintSprite;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcessor_80387 extends MapProcessor
   {
      
      private static const FIGHT_NUM_DAY:int = 1572;
      
      private static const FIGHT_INDEX:int = 1455;
      
      private static const FIGHT_NUM_MI_BUY_FOR:int = 205480;
      
      private static var _isFirst:Boolean;
      
      private static const FIGHT_NUM_RULE:Vector.<int> = Vector.<int>([5,10]);
      
      private var _sceneMC:MovieClip;
      
      private var _mouseHint:MouseClickHintSprite;
      
      private var _fightTarget:MovieClip;
      
      public function MapProcessor_80387(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.onActInit();
      }
      
      private function onActInit() : void
      {
         this._sceneMC = _map.front["sceneMC"] as MovieClip;
         this._fightTarget = _map.content["fightTarget"] as MovieClip;
         this._fightTarget.visible = false;
         this._sceneMC.gotoAndStop(1);
         this._sceneMC.visible = false;
         if(SceneManager.prevSceneType == 2 && 1455 == FightManager.currentFightRecord.initData.positionIndex)
         {
            DayLimitManager.getDoCount(1572,function(param1:int):void
            {
               var val:int = param1;
               ActiveCountManager.requestActiveCount(205480,function(param1:uint, param2:uint):void
               {
                  var canFightNum:int = 0;
                  var type:uint = param1;
                  var count:uint = param2;
                  if(type == 205480)
                  {
                     if(VipManager.vipInfo.isVip())
                     {
                        if(val > FIGHT_NUM_RULE[1])
                        {
                           canFightNum = int(count);
                        }
                        else
                        {
                           canFightNum = FIGHT_NUM_RULE[1] - val + count;
                        }
                     }
                     else if(val > FIGHT_NUM_RULE[0])
                     {
                        canFightNum = int(count);
                     }
                     else
                     {
                        canFightNum = FIGHT_NUM_RULE[0] - val + count;
                     }
                     if(canFightNum > 0)
                     {
                        fightHandle();
                     }
                     else
                     {
                        TweenNano.delayedCall(3,function():void
                        {
                           ServerMessager.addMessage("今日免费挑战次数已用完，可花费星钻继续战斗！");
                           SceneManager.changeScene(1,70);
                           ModuleManager.showAppModule("KaDuoSiSuperProcessPanel");
                        });
                     }
                  }
               });
            });
         }
         else
         {
            this.fightHandle();
         }
      }
      
      private function fightHandle() : void
      {
         if(!_isFirst)
         {
            _isFirst = true;
            this._sceneMC.visible = true;
            MovieClipUtil.playMc(this._sceneMC,2,this._sceneMC.totalFrames,function():void
            {
               _sceneMC.gotoAndStop(_sceneMC.totalFrames);
               (_sceneMC["ok"] as SimpleButton).addEventListener("click",onOK);
            },true);
         }
         else
         {
            this.showMouseHint();
            this._fightTarget.visible = true;
            this._fightTarget.buttonMode = true;
            this._fightTarget.addEventListener("click",this.onTargetClick);
         }
      }
      
      private function onOK(param1:MouseEvent) : void
      {
         (this._sceneMC["ok"] as SimpleButton).removeEventListener("click",this.onOK);
         this._sceneMC.gotoAndStop(1);
         this._sceneMC.visible = false;
         this.showMouseHint();
         this._fightTarget.visible = true;
         this._fightTarget.buttonMode = true;
         this._fightTarget.addEventListener("click",this.onTargetClick);
      }
      
      private function onTargetClick(param1:MouseEvent) : void
      {
         FightManager.startFightWithWild(1455);
      }
      
      private function showMouseHint() : void
      {
         this._mouseHint = new MouseClickHintSprite();
         this._mouseHint.y = 296;
         this._mouseHint.x = 483;
         _map.content.addChild(this._mouseHint);
         this._mouseHint.mouseEnabled = this._mouseHint.mouseChildren = false;
      }
      
      private function removeMouseHint() : void
      {
         DisplayUtil.removeForParent(this._mouseHint);
         this._mouseHint = null;
      }
      
      private function onDispose() : void
      {
         this._sceneMC = null;
         this.removeMouseHint();
         if(this._fightTarget)
         {
            this._fightTarget.removeEventListener("click",this.onTargetClick);
            this._fightTarget = null;
         }
      }
      
      override public function dispose() : void
      {
         this.onDispose();
         super.dispose();
      }
   }
}

