package com.taomee.seer2.app.processor.copy.handler
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.config.info.CopyItemInfo;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.copy.CopyProcessor;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class CopyProcessor_80014 extends CopyProcessor
   {
      
      private const BOSS_INDEX:Vector.<int> = Vector.<int>([376,377,378]);
      
      private const MONSTER_INDEX:int = 375;
      
      private const GOLE_KILL_NUM:int = 1;
      
      private const POS_LIST:Array = [508,204];
      
      private var _stateOneBoss:MovieClip;
      
      private var _stateTwoBoss:MovieClip;
      
      private var _stateThreeBoss:MovieClip;
      
      private var _stateOneBossStart:Boolean;
      
      private var _killNum:int;
      
      private var _stateOneIsOver:Boolean;
      
      public function CopyProcessor_80014(param1:CopyItemInfo)
      {
         super(param1);
      }
      
      override public function beforeAnimationHandle() : void
      {
      }
      
      override protected function tatisticsHandle() : void
      {
         StatisticsManager.sendNovice("0x1003379B");
      }
      
      override public function returnSceneHandle() : void
      {
         if(this._stateOneBoss)
         {
            this._stateOneBoss.play();
            _mapModel.content.addChild(this._stateOneBoss);
         }
         if(this._stateTwoBoss)
         {
            this._stateTwoBoss.play();
            _mapModel.content.addChild(this._stateTwoBoss);
         }
         if(this._stateThreeBoss)
         {
            this._stateThreeBoss.play();
            _mapModel.content.addChild(this._stateThreeBoss);
         }
      }
      
      override public function onAnimationLoaded() : void
      {
         this.cartoonHandle("80014_1","sceneTalk_1",function():void
         {
            _stateOneBoss = getResFromDomain("npc_1");
            _stateOneBoss.x = POS_LIST[0];
            _stateOneBoss.y = POS_LIST[1];
            _stateOneBoss.buttonMode = true;
            _mapModel.content.addChild(_stateOneBoss);
            _stateOneBoss.addEventListener("click",onBossClick);
            updateMonster();
         },function():void
         {
            SceneManager.addEventListener("switchComplete",onComplete);
         });
      }
      
      private function onComplete(param1:SceneEvent) : void
      {
         var index:int = 0;
         var posIndex:int = 0;
         var evt:SceneEvent = param1;
         if(SceneManager.prevSceneType == 2)
         {
            if(FightManager.fightWinnerSide == 1)
            {
               index = int(FightManager.currentFightRecord.initData.positionIndex);
               if(index == 375)
               {
                  ++this._killNum;
                  this.updateMonster();
                  if(this._stateOneIsOver)
                  {
                     return;
                  }
                  if(this._killNum < 1)
                  {
                     ServerMessager.addMessage("你需要击败" + (1 - this._killNum) + "只精灵就可以和泰瑞纳斯对战！");
                  }
                  else
                  {
                     this._stateOneBoss.removeEventListener("click",this.onBossClick);
                     DisplayUtil.removeForParent(this._stateOneBoss);
                     this._stateOneBoss = null;
                     this._stateOneIsOver = true;
                     this.cartoonHandle("80014_2","sceneTalk_2",function():void
                     {
                        _stateTwoBoss = getResFromDomain("npc_2");
                        _stateTwoBoss.x = POS_LIST[0];
                        _stateTwoBoss.y = POS_LIST[1];
                        _stateTwoBoss.buttonMode = true;
                        _mapModel.content.addChild(_stateTwoBoss);
                     },function():void
                     {
                        _stateTwoBoss.addEventListener("click",onBossClick);
                     });
                  }
               }
               else if(this.BOSS_INDEX.indexOf(index) != -1)
               {
                  posIndex = this.BOSS_INDEX.indexOf(index);
                  this.updateMonster();
                  if(posIndex == 0)
                  {
                     this.cartoonHandle("80014_3","sceneTalk_3",function():void
                     {
                        _stateTwoBoss.removeEventListener("click",onBossClick);
                        DisplayUtil.removeForParent(_stateTwoBoss);
                        _stateTwoBoss = null;
                        _stateThreeBoss = getResFromDomain("npc_3");
                        _stateThreeBoss.x = POS_LIST[0];
                        _stateThreeBoss.y = POS_LIST[1];
                        _stateThreeBoss.buttonMode = true;
                        _mapModel.content.addChild(_stateThreeBoss);
                        _stateThreeBoss.addEventListener("click",onBossClick);
                     });
                  }
                  else if(posIndex == 1)
                  {
                     this.cartoonHandle("80014_4","sceneTalk_4",function():void
                     {
                        _stateThreeBoss.scaleX = _stateThreeBoss.scaleY = 1.5;
                     });
                  }
                  else if(posIndex == 2)
                  {
                     DisplayUtil.removeForParent(this._stateThreeBoss);
                     this._stateThreeBoss = null;
                     completeTipShow(10,50,"虚弱之尘");
                  }
               }
            }
            else
            {
               this.updateMonster();
            }
         }
      }
      
      private function cartoonHandle(param1:String, param2:String = "", param3:Function = null, param4:Function = null) : void
      {
         var fullScreenName:String = param1;
         var sceneTalkName:String = param2;
         var fun:Function = param3;
         var fun1:Function = param4;
         MovieClipUtil.playFullScreen(URLUtil.getCopyFullScreen(fullScreenName),function():void
         {
            var _scenMc:MovieClip = null;
            if(null != fun)
            {
               fun.call();
            }
            if(sceneTalkName != "")
            {
               _scenMc = getResFromDomain(sceneTalkName);
               _mapModel.front.addChild(_scenMc);
               MovieClipUtil.playMc(_scenMc,2,_scenMc.totalFrames,function():void
               {
                  DisplayUtil.removeForParent(_scenMc);
                  _scenMc = null;
                  if(null != fun1)
                  {
                     fun1.call();
                  }
               },true);
            }
         },true,true,2,false);
      }
      
      private function updateMonster() : void
      {
         var _loc3_:SpawnedPet = null;
         var _loc2_:int = 5 - this._killNum;
         var _loc1_:uint = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new SpawnedPet(170,375,0);
            MobileManager.addMobile(_loc3_,"spawnedPet");
            _loc1_++;
         }
      }
      
      private function clearEvent() : void
      {
         SceneManager.removeEventListener("switchComplete",this.onComplete);
         if(this._stateTwoBoss)
         {
            this._stateTwoBoss.removeEventListener("click",this.onBossClick);
         }
         if(this._stateThreeBoss)
         {
            this._stateThreeBoss.removeEventListener("click",this.onBossClick);
         }
         if(this._stateOneBoss)
         {
            this._stateOneBoss.removeEventListener("click",this.onBossClick);
         }
      }
      
      private function onBossClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         switch(param1.currentTarget)
         {
            case this._stateOneBoss:
               AlertManager.showAlert("你需要击败1只精灵就可以和泰瑞纳斯对战！");
               break;
            case this._stateTwoBoss:
               FightManager.startFightWithWild(this.BOSS_INDEX[0]);
               break;
            case this._stateThreeBoss:
               _loc2_ = this._stateThreeBoss.scaleX == 1.5 ? this.BOSS_INDEX[2] : this.BOSS_INDEX[1];
               FightManager.startFightWithWild(_loc2_);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.clearEvent();
         DisplayUtil.removeForParent(this._stateOneBoss);
         this._stateOneBoss = null;
         DisplayUtil.removeForParent(this._stateTwoBoss);
         this._stateTwoBoss = null;
         DisplayUtil.removeForParent(this._stateThreeBoss);
         this._stateThreeBoss = null;
      }
   }
}

