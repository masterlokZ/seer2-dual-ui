package com.taomee.seer2.app.processor.quest.handler.branch.quest10114
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_10114_820 extends QuestMapHandler
   {
      
      public static const SECONDS_ONE_DAY:Number = 86400;
      
      public static const SECONDS_HALF_HOUR:Number = 1800;
      
      public static const MILI_SECONDS:Number = 1000;
      
      public static const SECONDS_ONE_HOUR:Number = 3600;
      
      public static const DATE:Date = new Date(2012,6,20,15);
      
      private var _kaisaMc:MovieClip;
      
      private var _isFight:Boolean = false;
      
      public function QuestMapHandler_10114_820(param1:QuestProcessor)
      {
         super(param1);
      }
      
      public static function isAppearNpc(param1:Date) : Boolean
      {
         var _loc2_:Number = TimeManager.getServerTime();
         _loc2_ %= 86400;
         var _loc4_:Number = param1.getTime() / 1000 % 86400;
         var _loc3_:Number = _loc4_ + 3600;
         if(_loc2_ >= _loc4_ && _loc2_ < _loc3_)
         {
            return true;
         }
         return false;
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
      }
      
      private function addChildKaisa() : void
      {
         this._kaisaMc = _processor.resLib.getMovieClip("kaisa");
         this._kaisaMc.x = 200;
         this._kaisaMc.y = 200;
         this._kaisaMc.buttonMode = true;
         LayerManager.uiLayer.addChild(this._kaisaMc);
         this._kaisaMc.addEventListener("click",this.kaisaClickHandler);
      }
      
      private function kaisaClickHandler(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         var data:XML = <dialog npcId="499" npcName="凯萨" transport=""><branch id="default"><node emotion="0"><![CDATA[哼，我能给你的，只有失败！不过，如果你能战胜我，就额外赐予你高额的积分！]]></node><reply action="close" params="yes"><![CDATA[高额的积分？我收下了！]]></reply><reply action="close" params="no"><![CDATA[还是算了]]></reply></branch></dialog>;
         var dialogDefinition:DialogDefinition = new DialogDefinition(data);
         DialogPanel.showForCommon(dialogDefinition,function(param1:String):void
         {
            if(param1 == "yes")
            {
               startFight();
            }
         });
      }
      
      private function startFight() : void
      {
         FightManager.startFightWithWild(120);
         FightManager.addEventListener("START_ERROR",this.startError);
      }
      
      private function startError(param1:Event) : void
      {
         FightManager.removeEventListener("START_ERROR",this.startError);
      }
      
      private function afterFightHandler() : void
      {
         var data:XML = null;
         var dialogDefinition:DialogDefinition = null;
         var position:int = int(FightManager.currentFightRecord.initData.positionIndex);
         if(position == 120)
         {
            if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1)
            {
               SwapManager.swapItem(465,1,function(param1:IDataInput):void
               {
                  new SwapInfo(param1);
               });
            }
            else
            {
               data = <dialog npcId="499" npcName="凯萨" transport=""><branch id="default"><node emotion="0"><![CDATA[看来，只有夺取争霸赛的胜利才能和更强的对手切磋了。]]></node><reply action="close" params="yes"><![CDATA[再来一次！]]></reply><reply action="close" params="no"><![CDATA[还是算了]]></reply></branch></dialog>;
               dialogDefinition = new DialogDefinition(data);
               DialogPanel.showForCommon(dialogDefinition,function(param1:String):void
               {
                  if(param1 == "yes")
                  {
                     startFight();
                  }
               });
            }
         }
      }
      
      private function destory(param1:Event = null) : void
      {
         DisplayUtil.removeForParent(this._kaisaMc);
         if(this._kaisaMc)
         {
            this._kaisaMc.removeEventListener("click",this.kaisaClickHandler);
         }
         SceneManager.removeEventListener("switchStart",this.destory);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

