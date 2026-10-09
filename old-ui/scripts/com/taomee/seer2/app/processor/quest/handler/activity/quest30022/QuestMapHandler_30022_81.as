package com.taomee.seer2.app.processor.quest.handler.activity.quest30022
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   import org.taomee.utils.DisplayUtil;
   
   public class QuestMapHandler_30022_81 extends QuestMapHandler
   {
      
      public static const DATE:Date = new Date(2012,6,20,13);
      
      private var _kaisaMc:MovieClip;
      
      private var _isFight:Boolean = false;
      
      public function QuestMapHandler_30022_81(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(QuestMapHandler_30022_820.isAppearNpc(DATE))
         {
            if(SceneManager.prevSceneType == 2)
            {
               this.afterFightHandler();
            }
            this.addChildKaisa();
         }
         SceneManager.addEventListener("switchStart",this.destory);
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
      
      private function destory(param1:Event = null) : void
      {
         DisplayUtil.removeForParent(this._kaisaMc);
         if(this._kaisaMc)
         {
            this._kaisaMc.removeEventListener("click",this.kaisaClickHandler);
         }
         SceneManager.removeEventListener("switchStart",this.destory);
      }
   }
}

