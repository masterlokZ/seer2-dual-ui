package com.taomee.seer2.app.processor.activity.pandaMan
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.manager.InteractiveRewardManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1060;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   
   public class PandaManager
   {
      
      private const questIdArr:Array = [[10165,10167,10169],[10166,10169,10168],[10165,10169,10166],[10168,10165,10167],[10165,10166,10167],[10168,10169,10165],[10165,10166,10169]];
      
      private const initQuestIdArr:Array = [[10166,10168],[10165,10167],[10167,10168],[10166,10169],[10168,10169],[10166,10167],[10167,10168]];
      
      private var _fishingPP:MovieClip;
      
      private var _mapmodel:MapModel;
      
      private var _pandaMan:Mobile;
      
      private var _pandaWanVec:Vector.<Mobile>;
      
      private var _currDayArr:Array;
      
      private var _zhuVec:Vector.<MovieClip>;
      
      private var _war:MovieClip;
      
      public function PandaManager()
      {
         super();
      }
      
      public function setup() : void
      {
         var i:int;
         ServerBufferManager.getServerBuffer(66,this.onPandaFight);
         this._mapmodel = SceneManager.active.mapModel;
         this._fishingPP = this._mapmodel.content["fishing"];
         TooltipManager.addCommonTip(this._fishingPP,"钓鱼点");
         this._war = this._mapmodel.content["war"];
         this._pandaMan = MobileManager.getMobile(193,"npc");
         this._pandaWanVec = Vector.<Mobile>([]);
         this._zhuVec = Vector.<MovieClip>([]);
         this._pandaWanVec.push(MobileManager.getMobile(548,"npc"));
         this._pandaWanVec.push(MobileManager.getMobile(549,"npc"));
         this._pandaWanVec.push(MobileManager.getMobile(554,"npc"));
         for(i = 0; i < 3; )
         {
            this._zhuVec.push(this._mapmodel.content["zhu" + i]);
            i++;
         }
         this.initEvent();
         DayLimitManager.getDoCount(600,function(param1:uint):void
         {
            if(param1 == 0)
            {
               _war.visible = true;
            }
            else
            {
               _war.visible = false;
            }
         });
      }
      
      private function onPandaFight(param1:ServerBuffer) : void
      {
         var ser:ServerBuffer = param1;
         if(ser.readDataAtPostion(1) == 0)
         {
            MovieClipUtil.playFullScreen(URLUtil.getActivityAnimation("panda/pandaScreen1"),function():void
            {
               ServerBufferManager.updateServerBuffer(66,1,1);
            },true,false,2);
         }
      }
      
      private function initEvent() : void
      {
         var _loc2_:Mobile = null;
         var _loc1_:MovieClip = null;
         this._fishingPP.buttonMode = true;
         this._fishingPP.addEventListener("click",this.onFishing);
         for each(_loc2_ in this._pandaWanVec)
         {
            _loc2_.addEventListener("click",this.onPandaWan,false,1);
         }
         DialogPanel.addEventListener("dialogShow",this.onDialog);
         for each(_loc1_ in this._zhuVec)
         {
            _loc1_.buttonMode = true;
            _loc1_.addEventListener("click",this.onZhu);
         }
         this._war.buttonMode = true;
         this._war.addEventListener("click",this.onWar);
      }
      
      private function onWar(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         SwapManager.swapItem(973,1,function(param1:IDataInput):void
         {
            new SwapInfo(param1,false);
            _war.visible = false;
            ServerMessager.addMessage("获得5个竹叶");
         });
      }
      
      private function onZhu(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         DayLimitManager.getDoCount(599,function(param1:uint):void
         {
            var count:uint = param1;
            if(count == 0)
            {
               InteractiveRewardManager.requestReward(193,function(param1:Parser_1060):void
               {
                  if(param1.addItemVec[0].id == 500503)
                  {
                     param1.showResult(true,null,false);
                     ServerMessager.addMessage("恭喜你获得了7折优惠卷！");
                  }
                  else
                  {
                     param1.showResult();
                  }
               });
            }
         });
      }
      
      private function onDialog(param1:DialogPanelEvent) : void
      {
         var _loc3_:int = new Date(TimeManager.getServerTime() * 1000).getDay();
         this._currDayArr = this.questIdArr[_loc3_];
         var _loc5_:Array = this.initQuestIdArr[_loc3_];
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            if(QuestManager.isComplete(this._currDayArr[_loc4_]))
            {
               _loc5_.push(this._currDayArr[_loc4_]);
            }
            _loc4_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_.length)
         {
            DialogPanel.functionalityBox.removeQuestUnit(_loc5_[_loc2_]);
            _loc2_++;
         }
      }
      
      private function onPandaWan(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         Connection.addCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
         Connection.send(CommandSet.RANDOM_EVENT_1140,40,0);
      }
      
      private function onRandomStatus(param1:MessageEvent) : void
      {
         var _loc3_:* = 0;
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,this.onRandomStatus);
         var _loc2_:IDataInput = param1.message.getRawDataCopy();
         var _loc4_:uint = _loc2_.readUnsignedInt();
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ == 1)
         {
            FightManager.startFightWithWild(272);
         }
         else
         {
            FightManager.startFightWithWild(271);
         }
      }
      
      private function onFishing(param1:MouseEvent) : void
      {
         ModuleManager.showModule(URLUtil.getAppModule("FishToolPanel"),"正在打开选择鱼竿鱼饵面板!",{"sceneStyle":1});
      }
   }
}

