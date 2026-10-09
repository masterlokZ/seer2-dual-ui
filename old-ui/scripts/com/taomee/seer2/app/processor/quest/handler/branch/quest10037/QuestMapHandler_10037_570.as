package com.taomee.seer2.app.processor.quest.handler.branch.quest10037
{
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_10037_570 extends QuestMapHandler
   {
      
      private var _mcVec:Vector.<MovieClip>;
      
      private var _npc:MovieClip;
      
      private var _count:int;
      
      public function QuestMapHandler_10037_570(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestManager.isAccepted(_quest.id) && QuestManager.isStepComplete(_quest.id,1) == false)
         {
            this.initMC();
         }
      }
      
      private function initMC() : void
      {
         var _loc1_:MovieClip = null;
         this._count = 0;
         this._mcVec = Vector.<MovieClip>([]);
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = _processor.resLib.getMovieClip("mc" + _loc2_);
            this._mcVec.push(_loc1_);
            _loc1_.gotoAndStop(1);
            _loc1_.buttonMode = true;
            _map.front.addChild(_loc1_);
            _loc1_.addEventListener("click",this.onMC);
            _loc2_++;
         }
      }
      
      private function onMC(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:int = this._mcVec.indexOf(_loc2_);
         _loc2_.gotoAndStop(21);
         ++this._count;
         if(this._count >= 5)
         {
            this.showNpc();
         }
      }
      
      private function showNpc() : void
      {
         this._npc = _processor.resLib.getMovieClip("npc");
         _map.front.addChild(this._npc);
         MovieClipUtil.playMc(this._npc,2,this._npc.totalFrames,function():void
         {
            QuestManager.completeStep(_quest.id,1);
         },true);
      }
      
      override public function processMapDispose() : void
      {
         var _loc1_:MovieClip = null;
         DisplayUtil.removeForParent(this._npc);
         this._npc = null;
         if(this._mcVec)
         {
            for each(_loc1_ in this._mcVec)
            {
               DisplayUtil.removeForParent(_loc1_);
            }
         }
         this._mcVec = null;
      }
   }
}

