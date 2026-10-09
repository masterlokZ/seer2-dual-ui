package com.taomee.seer2.app.processor.copy.handler
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.config.info.CopyItemInfo;
   import com.taomee.seer2.app.copySystem.CopyEvent;
   import com.taomee.seer2.app.copySystem.CopyManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.copy.CopyProcessor;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class CopyProcessor_80001 extends CopyProcessor
   {
      
      private const SINGLE_INDEX:int = 263;
      
      private const DOUBLE_ONE_INDEX:int = 261;
      
      private const DOUBLE_TWO_INDEX:int = 262;
      
      private const GOLE_KILL_NUM:int = 10;
      
      private const POS_LIST:Array = [[208,254],[310,280],[270,280],[490,280]];
      
      private var _singleBoss:MovieClip;
      
      private var _doubleOneBoss:MovieClip;
      
      private var _doubleTwoBoss:MovieClip;
      
      private var _singleBossStart:Boolean;
      
      private var _killNum:int;
      
      public function CopyProcessor_80001(param1:CopyItemInfo)
      {
         super(param1);
      }
      
      override public function beforeAnimationHandle() : void
      {
      }
      
      override public function returnSceneHandle() : void
      {
         if(this._singleBoss)
         {
            this._singleBoss.play();
            _mapModel.content.addChild(this._singleBoss);
         }
         if(this._doubleOneBoss)
         {
            this._doubleOneBoss.play();
            _mapModel.content.addChild(this._doubleOneBoss);
         }
         if(this._doubleTwoBoss)
         {
            this._doubleTwoBoss.play();
            _mapModel.content.addChild(this._doubleTwoBoss);
         }
      }
      
      override public function onAnimationLoaded() : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getCopyFullScreen("80001_1"),function():void
         {
            var _scenMc:MovieClip = null;
            _singleBoss = getResFromDomain("npc");
            _singleBoss.x = POS_LIST[1][0];
            _singleBoss.y = POS_LIST[1][1];
            _singleBoss.buttonMode = true;
            _mapModel.content.addChild(_singleBoss);
            _singleBoss.addEventListener("click",onSingleBossClick);
            _scenMc = getResFromDomain("sceneTalk_1");
            _mapModel.front.addChild(_scenMc);
            MovieClipUtil.playMc(_scenMc,2,_scenMc.totalFrames,function():void
            {
               DisplayUtil.removeForParent(_scenMc);
               _scenMc = null;
               SceneManager.addEventListener("switchComplete",onComplete);
            },true);
         },true,true,2);
      }
      
      private function onSingleBossClick(param1:MouseEvent) : void
      {
         if(this._singleBossStart)
         {
            FightManager.startFightWithWild(263);
         }
         else
         {
            AlertManager.showAlert("需要击败10个场地内的精灵才能够和莫利亚对战！");
         }
      }
      
      private function onComplete(param1:SceneEvent) : void
      {
         var _scenMc:MovieClip = null;
         var evt:SceneEvent = param1;
         var obj1:Object = SceneManager.prevSceneType;
         var obj2:Object = FightManager.fightWinnerSide;
         var obj3:Object = FightManager.currentFightRecord.initData.positionIndex;
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && FightManager.currentFightRecord.initData.positionIndex <= 9)
         {
            ++this._killNum;
            if(this._killNum < 10)
            {
               ServerMessager.addMessage("你还需要击败" + (10 - this._killNum) + "只精灵就可以和莫利亚对战！");
            }
            else
            {
               _scenMc = getResFromDomain("sceneTalk_2");
               _mapModel.front.addChild(_scenMc);
               MovieClipUtil.playMc(_scenMc,2,_scenMc.totalFrames,function():void
               {
                  DisplayUtil.removeForParent(_scenMc);
                  _scenMc = null;
                  _singleBossStart = true;
                  SceneManager.removeEventListener("switchComplete",onComplete);
                  SceneManager.addEventListener("switchComplete",onComplete1);
               },true);
            }
         }
      }
      
      private function onComplete1(param1:SceneEvent) : void
      {
         var evt:SceneEvent = param1;
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && FightManager.currentFightRecord.initData.positionIndex == 263)
         {
            DisplayUtil.removeForParent(this._singleBoss);
            this._singleBoss = null;
            MovieClipUtil.playFullScreen(URLUtil.getCopyFullScreen("80001_2"),function():void
            {
               _doubleOneBoss = getResFromDomain("npc");
               _doubleOneBoss.x = POS_LIST[2][0];
               _doubleOneBoss.y = POS_LIST[2][1];
               _doubleOneBoss.buttonMode = true;
               _mapModel.content.addChild(_doubleOneBoss);
               _doubleTwoBoss = getResFromDomain("npc");
               _doubleTwoBoss.scaleX = -1;
               _doubleTwoBoss.x = POS_LIST[3][0];
               _doubleTwoBoss.y = POS_LIST[3][1];
               _doubleTwoBoss.buttonMode = true;
               _mapModel.content.addChild(_doubleTwoBoss);
               _doubleOneBoss.addEventListener("click",onDoubleBossClick);
               _doubleTwoBoss.addEventListener("click",onDoubleBossClick);
               SceneManager.removeEventListener("switchComplete",onComplete1);
               SceneManager.addEventListener("switchComplete",onComplete2);
            },true,true,2);
         }
      }
      
      private function onDoubleBossClick(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget == this._doubleOneBoss ? 261 : 262;
         FightManager.startFightWithWild(_loc2_);
      }
      
      private function onComplete2(param1:SceneEvent) : void
      {
         var obj:Object = null;
         var _scenMc:MovieClip = null;
         var evt:SceneEvent = param1;
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && (FightManager.currentFightRecord.initData.positionIndex == 261 || FightManager.currentFightRecord.initData.positionIndex == 262))
         {
            obj = FightManager.currentFightRecord.initData.positionIndex;
            if(FightManager.currentFightRecord.initData.positionIndex == 261)
            {
               DisplayUtil.removeForParent(this._doubleOneBoss);
               this._doubleOneBoss = null;
            }
            else
            {
               DisplayUtil.removeForParent(this._doubleTwoBoss);
               this._doubleTwoBoss = null;
            }
            if(!this._doubleOneBoss && !this._doubleTwoBoss)
            {
               _scenMc = getResFromDomain("sceneTalk_3");
               _mapModel.front.addChild(_scenMc);
               MovieClipUtil.playMc(_scenMc,2,_scenMc.totalFrames,function():void
               {
                  DisplayUtil.removeForParent(_scenMc);
                  _scenMc = null;
                  SceneManager.removeEventListener("switchComplete",onComplete2);
                  CopyManager.instance().addEventListener("complete",onCopyComplete);
                  CopyManager.instance().completeCopyItem(_copyItem.mapId);
               },true);
            }
         }
      }
      
      private function onCopyComplete(param1:CopyEvent) : void
      {
         ServerMessager.addMessage("完成副本，获得10个炼狱粉末!");
         CopyManager.instance().removeEventListener("complete",this.onCopyComplete);
         this.dispose();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._singleBoss)
         {
            this._singleBoss.removeEventListener("click",this.onSingleBossClick);
         }
         if(this._doubleOneBoss)
         {
            this._doubleOneBoss.removeEventListener("click",this.onDoubleBossClick);
         }
         if(this._doubleTwoBoss)
         {
            this._doubleTwoBoss.removeEventListener("click",this.onDoubleBossClick);
         }
         SceneManager.removeEventListener("switchComplete",this.onComplete);
         SceneManager.removeEventListener("switchComplete",this.onComplete1);
         SceneManager.removeEventListener("switchComplete",this.onComplete2);
         DisplayUtil.removeForParent(this._singleBoss);
         DisplayUtil.removeForParent(this._doubleOneBoss);
         DisplayUtil.removeForParent(this._doubleTwoBoss);
         CopyManager.instance().removeEventListener("complete",this.onCopyComplete);
      }
   }
}

