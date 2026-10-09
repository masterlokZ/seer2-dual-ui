package com.taomee.seer2.app.gameRule.spt
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.component.ProgressiveAnimationPlayer;
   import com.taomee.seer2.app.config.TimeLimitConfig;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.gameRule.spt.support.BaseSptSupport;
   import com.taomee.seer2.app.gameRule.spt.support.SptConfigInfoManager;
   import com.taomee.seer2.app.gameRule.spt.support.SptDialogConfig;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SptAilixisiSupport extends BaseSptSupport
   {
      
      private static var _instance:SptAilixisiSupport;
      
      private const CAN_BATTLE:String = "canbattle";
      
      private const CANT_BATTLE:String = "cantbattle";
      
      private var _bluto_mc:MovieClip;
      
      public function SptAilixisiSupport(param1:Block)
      {
         super();
         if(param1 == null)
         {
            throw new Error("get By  getInstance()");
         }
      }
      
      public static function getInstance() : SptAilixisiSupport
      {
         if(!_instance)
         {
            _instance = new SptAilixisiSupport(new Block());
         }
         return _instance;
      }
      
      override public function init(param1:MapModel) : void
      {
         _sptBossId = 215;
         _petMaxLevelLimit = SptConfigInfoManager.getSptBossLevel(_sptBossId);
         _sptBufferPosition = 9;
         super.init(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      protected function dealWithNpcStats() : void
      {
         if(TimeLimitConfig.InLimitTime(5))
         {
            showSPT("canbattle");
         }
         else
         {
            showSPT("cantbattle");
         }
      }
      
      override protected function dealWithMapInit() : void
      {
         this.dealWithNpcStats();
      }
      
      override protected function fightFailure(param1:LittleEndianByteArray) : void
      {
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,3,[SptDialogConfig.getTalkContent(_sptBossId)]));
         var _loc3_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc3_);
         this.dealWithNpcStats();
      }
      
      override protected function fightWin() : void
      {
         if(!_winHistory)
         {
            ServerBufferManager.updateServerBuffer(1,_sptBufferPosition,1);
            hideSPT();
            _animationPlayer = new ProgressiveAnimationPlayer(URLUtil.getQuestAnimation("spt/win_ailixisi_movie"));
            _animationPlayer.addEventListener("end",this.onChairAnimationEnd);
            LayerManager.uiLayer.addChild(_animationPlayer);
         }
         else
         {
            this.dealWithNpcStats();
         }
      }
      
      override protected function initSPTNPC() : void
      {
         _sptNPC = MobileManager.getMobile(209,"npc");
         _sptNPC.buttonMode = true;
         _sptNPC.useHandCursor = true;
         showSPT("cantbattle");
         super.initSPTNPC();
      }
      
      override protected function onSPTClickHandler(param1:MouseEvent) : void
      {
         var _loc5_:UserInfo = null;
         var _loc7_:uint = 0;
         var _loc6_:XML = null;
         var _loc3_:DialogDefinition = null;
         var _loc2_:XML = null;
         var _loc4_:DialogDefinition = null;
         if(TimeLimitConfig.InLimitTime(5))
         {
            _loc5_ = ActorManager.actorInfo;
            _loc7_ = _loc5_.highestPetLevel;
            if(_loc7_ >= _petMaxLevelLimit)
            {
               ServerBufferManager.getServerBuffer(1,this.checkServerBufferHandler);
            }
            else
            {
               _loc6_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,1,[_petMaxLevelLimit]));
               _loc3_ = new DialogDefinition(_loc6_);
               DialogPanel.showForCommon(_loc3_);
            }
         }
         else
         {
            _loc2_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,7));
            _loc4_ = new DialogDefinition(_loc2_);
            DialogPanel.showForCommon(_loc4_);
         }
      }
      
      private function checkServerBufferHandler(param1:ServerBuffer) : void
      {
         _winHistory = param1.readDataAtPostion(_sptBufferPosition) == 1;
         if(_winHistory)
         {
            _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
         }
         else
         {
            this.doWhenNeverWinBefore();
         }
      }
      
      private function doWhenNeverWinBefore() : void
      {
         var startFighter:Function = null;
         var onClose_1:Function = null;
         var onClose_2:Function = null;
         startFighter = function(param1:String = ""):void
         {
            if("fight" == param1)
            {
               _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
            }
         };
         onClose_1 = function(param1:String = ""):void
         {
            var _loc2_:XML = null;
            var _loc3_:DialogDefinition = null;
            if(param1 == "next")
            {
               _loc2_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,5));
               _loc3_ = new DialogDefinition(_loc2_);
               DialogPanel.showForCommon(_loc3_,onClose_2);
            }
         };
         onClose_2 = function(param1:String = ""):void
         {
            var _loc2_:XML = null;
            var _loc3_:DialogDefinition = null;
            if(param1 == "next")
            {
               _loc2_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,6));
               _loc3_ = new DialogDefinition(_loc2_);
               DialogPanel.showForCommon(_loc3_,startFighter);
            }
         };
         var data:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,4));
         var dialogDefinition:DialogDefinition = new DialogDefinition(data);
         DialogPanel.showForCommon(dialogDefinition,onClose_1);
      }
      
      private function onChairAnimationEnd(param1:Event) : void
      {
         _animationPlayer.removeEventListener("end",this.onChairAnimationEnd);
         DisplayObjectUtil.removeFromParent(_animationPlayer);
         _animationPlayer = null;
         this.dealWithNpcStats();
      }
   }
}

class Block
{
   
   public function Block()
   {
      super();
   }
}
