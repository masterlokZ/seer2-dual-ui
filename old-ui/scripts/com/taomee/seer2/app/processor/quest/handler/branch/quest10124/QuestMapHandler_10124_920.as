package com.taomee.seer2.app.processor.quest.handler.branch.quest10124
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_10124_920 extends QuestMapHandler
   {
      
      public static const FIGHT_INDEX:int = 159;
      
      private var _haikuiTyphoon:MovieClip;
      
      private var _haikuiShadow:MovieClip;
      
      private var _clickTarget:MovieClip;
      
      private var _questionFeedback:MovieClip;
      
      public function QuestMapHandler_10124_920(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         var fightIndex:int;
         super.processMapComplete();
         fightIndex = int(FightManager.currentFightRecord.initData.positionIndex);
         if(QuestManager.isAccepted(_quest.id) && 159 == fightIndex && SceneManager.prevSceneType == 2)
         {
            if(FightManager.fightWinnerSide == 1)
            {
               this.cartoonMovie();
            }
            else
            {
               MovieClipUtil.playFullScreen(URLUtil.getRes("active/fullScreen/10124_1.swf"),function():void
               {
                  SceneManager.changeScene(1,900,779,443);
               });
            }
         }
         else
         {
            this.initUI();
         }
      }
      
      private function cartoonMovie() : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getRes("active/fullScreen/10124_3.swf"),function():void
         {
            MovieClipUtil.playNpcTalkNew(URLUtil.getQuestNpcTalkAnimation("10124_0"),5,[[1,0]],function():void
            {
               MovieClipUtil.playFullScreen(URLUtil.getRes("active/fullScreen/10124_4.swf"),function():void
               {
                  QuestManager.addEventListener("complete",questComplete);
                  QuestManager.completeStep(_quest.id,1);
               });
            });
         });
      }
      
      private function requestServerBuffer() : void
      {
         ServerBufferManager.getServerBuffer(43,this.onGetQuestIndex);
      }
      
      private function updateServerBuffer() : void
      {
         var name:String;
         var positionIndex:int;
         this._questionFeedback.x = this._clickTarget.x;
         this._questionFeedback.y = this._clickTarget.y;
         this._questionFeedback.visible = true;
         this._questionFeedback.gotoAndPlay(1);
         name = this._clickTarget.name;
         positionIndex = parseInt(name.charAt(name.length - 1));
         DisplayUtil.removeForParent(this._clickTarget);
         ServerBufferManager.updateServerBuffer(43,positionIndex,1);
         ServerBufferManager.getServerBuffer(43,function(param1:ServerBuffer):void
         {
            var _loc2_:uint = uint(culQuestionCompleteNum(param1));
            if(_loc2_ == 5 && !QuestManager.isComplete(_quest.id))
            {
               completeQuestionHandler();
            }
         });
      }
      
      private function culQuestionCompleteNum(param1:ServerBuffer) : int
      {
         var _loc3_:uint = 0;
         var _loc2_:int = 0;
         var _loc4_:int = 1;
         while(_loc4_ <= 5)
         {
            _loc3_ = uint(param1.readDataAtPostion(_loc4_));
            if(_loc3_ == 1)
            {
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function onGetQuestIndex(param1:ServerBuffer) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:int = 0;
         var _loc3_:int = 1;
         while(_loc3_ <= 5)
         {
            _loc2_ = uint(param1.readDataAtPostion(_loc3_));
            if(_loc2_ == 1)
            {
               _loc4_++;
               (this._haikuiTyphoon["mc" + _loc3_] as MovieClip).stop();
               (this._haikuiTyphoon["mc" + _loc3_] as MovieClip).visible = false;
            }
            else
            {
               (this._haikuiTyphoon["mc" + _loc3_] as MovieClip).addEventListener("click",this.questAcceptHandler);
            }
            _loc3_++;
         }
         if(_loc4_ < 5)
         {
            LayerManager.uiLayer.addChild(this._haikuiTyphoon);
         }
         else
         {
            this.addHaikuiShadow();
         }
      }
      
      private function questComplete(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.questComplete);
      }
      
      private function initUI() : void
      {
         this._haikuiTyphoon = _processor.resLib.getMovieClip("haikuiTyphoon_10123");
         this._questionFeedback = _processor.resLib.getMovieClip("questionFeedback");
         LayerManager.topLayer.addChild(this._questionFeedback);
         this._questionFeedback.stop();
         this._questionFeedback.visible = false;
         this._haikuiTyphoon.buttonMode = true;
         this.requestServerBuffer();
      }
      
      private function questAcceptHandler(param1:MouseEvent) : void
      {
         this._clickTarget = param1.currentTarget as MovieClip;
         if(QuestManager.isAccepted(_quest.id))
         {
            this.startQuestion();
         }
         else
         {
            QuestManager.addEventListener("accept",this.acceptedhandler);
            QuestManager.accept(_quest.id);
         }
      }
      
      private function acceptedhandler(param1:QuestEvent) : void
      {
         QuestManager.removeEventListener("accept",this.acceptedhandler);
         this.startQuestion();
      }
      
      private function startQuestion() : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("HaikuiTyphoonPanel"),"正在海葵问答面板...",this.updateServerBuffer);
      }
      
      private function completeQuestionHandler() : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getRes("active/fullScreen/10124_2.swf"),function():void
         {
            addHaikuiShadow();
         });
      }
      
      private function addHaikuiShadow() : void
      {
         DisplayUtil.removeForParent(this._haikuiTyphoon);
         this._haikuiShadow = _processor.resLib.getMovieClip("haikuiShadow_10123");
         _processor.mapModel.content.addChild(this._haikuiShadow);
         _processor.mapModel.content.addChild(_processor.mouseHint);
         this._haikuiShadow.buttonMode = true;
         _processor.showMouseHintAt(850,147);
         this._haikuiShadow.addEventListener("click",this.startFight);
      }
      
      private function startFight(param1:MouseEvent) : void
      {
         _processor.hideMouseClickHint();
         FightManager.startFightWithWild(159);
      }
      
      override public function processMapDispose() : void
      {
         DisplayUtil.removeForParent(this._questionFeedback);
         DisplayUtil.removeForParent(_processor.mouseHint);
         if(this._haikuiTyphoon)
         {
            this._haikuiTyphoon.removeEventListener("click",this.startQuestion);
         }
         if(this._haikuiShadow)
         {
            this._haikuiShadow.removeEventListener("click",this.startFight);
         }
         DisplayUtil.removeForParent(this._haikuiTyphoon);
         DisplayUtil.removeForParent(this._haikuiShadow);
      }
   }
}

