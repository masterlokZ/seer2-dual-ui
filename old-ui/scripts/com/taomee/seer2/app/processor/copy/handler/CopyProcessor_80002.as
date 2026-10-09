package com.taomee.seer2.app.processor.copy.handler
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.config.info.CopyItemInfo;
   import com.taomee.seer2.app.copySystem.CopyEvent;
   import com.taomee.seer2.app.copySystem.CopyManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.copy.CopyProcessor;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class CopyProcessor_80002 extends CopyProcessor
   {
      
      private const SINGLE_INDEX:int = 260;
      
      private const DOUBLE_ONE_INDEX:int = 258;
      
      private const DOUBLE_TWO_INDEX:int = 259;
      
      private const GOLE_KILL_NUM:int = 10;
      
      private const POS_LIST:Array = [[208,254],[310,280],[270,280],[490,280]];
      
      private var _singleBoss:MovieClip;
      
      private var _doubleOneBoss:MovieClip;
      
      private var _doubleTwoBoss:MovieClip;
      
      private var _singleBossStart:Boolean;
      
      private var _killNum:int;
      
      public function CopyProcessor_80002(param1:CopyItemInfo)
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
         this._singleBoss = getResFromDomain("npc");
         this._singleBoss.x = this.POS_LIST[1][0];
         this._singleBoss.y = this.POS_LIST[1][1];
         this._singleBoss.buttonMode = true;
         _mapModel.content.addChild(this._singleBoss);
         this._singleBoss.addEventListener("click",this.onSingleBossClick);
         SceneManager.addEventListener("switchComplete",this.onComplete);
      }
      
      private function onSingleBossClick(param1:MouseEvent) : void
      {
         if(this._singleBossStart)
         {
            FightManager.startFightWithWild(260);
         }
         else
         {
            AlertManager.showAlert("需要击败10个场地内的精灵才能够和莫利亚对战！");
         }
      }
      
      private function onComplete(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && FightManager.currentFightRecord.initData.positionIndex <= 9)
         {
            ++this._killNum;
            if(this._killNum < 10)
            {
               ServerMessager.addMessage("你还需要击败" + (10 - this._killNum) + "只精灵就可以和莫利亚对战！");
            }
            else
            {
               this._singleBossStart = true;
               SceneManager.removeEventListener("switchComplete",this.onComplete);
               SceneManager.addEventListener("switchComplete",this.onComplete1);
            }
         }
      }
      
      private function onComplete1(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && FightManager.currentFightRecord.initData.positionIndex == 260)
         {
            DisplayUtil.removeForParent(this._singleBoss);
            this._singleBoss = null;
            this._doubleOneBoss = getResFromDomain("npc");
            this._doubleOneBoss.x = this.POS_LIST[2][0];
            this._doubleOneBoss.y = this.POS_LIST[2][1];
            this._doubleOneBoss.buttonMode = true;
            _mapModel.content.addChild(this._doubleOneBoss);
            this._doubleTwoBoss = getResFromDomain("npc");
            this._doubleTwoBoss.scaleX = -1;
            this._doubleTwoBoss.x = this.POS_LIST[3][0];
            this._doubleTwoBoss.y = this.POS_LIST[3][1];
            this._doubleTwoBoss.buttonMode = true;
            _mapModel.content.addChild(this._doubleTwoBoss);
            this._doubleOneBoss.addEventListener("click",this.onDoubleBossClick);
            this._doubleTwoBoss.addEventListener("click",this.onDoubleBossClick);
            SceneManager.removeEventListener("switchComplete",this.onComplete1);
            SceneManager.addEventListener("switchComplete",this.onComplete2);
         }
      }
      
      private function onDoubleBossClick(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget == this._doubleOneBoss ? 258 : 259;
         FightManager.startFightWithWild(_loc2_);
      }
      
      private function onComplete2(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1 && (FightManager.currentFightRecord.initData.positionIndex == 258 || FightManager.currentFightRecord.initData.positionIndex == 259))
         {
            if(FightManager.currentFightRecord.initData.positionIndex == 258)
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
               SceneManager.removeEventListener("switchComplete",this.onComplete2);
               CopyManager.instance().addEventListener("complete",this.onCopyComplete);
               CopyManager.instance().completeCopyItem(_copyItem.mapId);
            }
         }
      }
      
      private function onCopyComplete(param1:CopyEvent) : void
      {
         ServerMessager.addMessage("完成副本，获得30个炼狱粉末!");
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

