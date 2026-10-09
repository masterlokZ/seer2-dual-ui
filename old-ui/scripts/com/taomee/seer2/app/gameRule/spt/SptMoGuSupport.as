package com.taomee.seer2.app.gameRule.spt
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.component.ProgressiveAnimationPlayer;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.gameRule.spt.support.BaseSptSupport;
   import com.taomee.seer2.app.gameRule.spt.support.SptBossInfoManager;
   import com.taomee.seer2.app.gameRule.spt.support.SptConfigInfoManager;
   import com.taomee.seer2.app.gameRule.spt.support.SptDialogConfig;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.sound.SoundManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SptMoGuSupport extends BaseSptSupport
   {
      
      private static var _instance:SptMoGuSupport;
      
      private const LABEL_NEVERWIN:String = "labelNeverWin";
      
      private const LABEL_UNLEVEL:String = "labelUnLevel";
      
      private const LABEL_WINBEFORE:String = "labelWinBefore";
      
      private var _mogu_MC:MovieClip;
      
      public function SptMoGuSupport()
      {
         super();
      }
      
      public static function getInstance() : SptMoGuSupport
      {
         if(!_instance)
         {
            _instance = new SptMoGuSupport();
         }
         return _instance;
      }
      
      override public function init(param1:MapModel) : void
      {
         _sptBossId = 80;
         _petMaxLevelLimit = SptConfigInfoManager.getSptBossLevel(_sptBossId);
         _sptBufferPosition = 4;
         super.init(param1);
      }
      
      override protected function initSPTNPC() : void
      {
         this._mogu_MC = _map.content["sptMoGu"];
         _sptNPC = this._mogu_MC["hotZone"];
         _sptNPC.buttonMode = true;
         _sptNPC.useHandCursor = true;
         super.initSPTNPC();
      }
      
      override protected function dealWithMapInit() : void
      {
         var _loc2_:UserInfo = ActorManager.actorInfo;
         var _loc1_:uint = _loc2_.highestPetLevel;
         if(_loc1_ >= _petMaxLevelLimit)
         {
            if(_winHistory)
            {
               this.showSPT("labelWinBefore");
            }
            else
            {
               this.showSPT("labelNeverWin");
            }
         }
         else
         {
            this.showSPT("labelUnLevel");
         }
      }
      
      override protected function fightFailure(param1:LittleEndianByteArray) : void
      {
         var _loc4_:XML = null;
         var _loc3_:DialogDefinition = null;
         var _loc2_:uint = SptBossInfoManager.resolveSpt(_sptBossId,param1);
         if(_loc2_ < 2)
         {
            this.showSPT("labelNeverWin");
            _loc4_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,1,[SptDialogConfig.getTalkContent(_sptBossId)]));
            _loc3_ = new DialogDefinition(_loc4_);
            DialogPanel.showForCommon(_loc3_);
         }
         else
         {
            this.showSPT("labelWinBefore");
         }
      }
      
      override protected function fightWin() : void
      {
         if(!_winHistory)
         {
            ServerBufferManager.updateServerBuffer(1,_sptBufferPosition,1);
            SoundManager.enabled = false;
            _animationPlayer = new ProgressiveAnimationPlayer(URLUtil.getQuestAnimation("spt/map_530_fullmovie"));
            _animationPlayer.addEventListener("end",this.onChairAnimationEnd);
            LayerManager.topLayer.addChild(_animationPlayer);
         }
         else
         {
            this.showSPT("labelWinBefore");
         }
      }
      
      private function onChairAnimationEnd(param1:Event) : void
      {
         _animationPlayer.removeEventListener("end",this.onChairAnimationEnd);
         DisplayObjectUtil.removeFromParent(_animationPlayer);
         _animationPlayer = null;
         SoundManager.enabled = true;
         this.showSPT("labelWinBefore");
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,2));
         var _loc3_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc3_);
      }
      
      override protected function showSPT(param1:String = null) : void
      {
         if(this._mogu_MC)
         {
            this._mogu_MC.visible = true;
            if(param1 != null)
            {
               (this._mogu_MC as MovieClip).gotoAndPlay(param1);
            }
         }
      }
      
      override protected function hideSPT() : void
      {
         if(this._mogu_MC)
         {
            this._mogu_MC.visible = false;
         }
      }
      
      override protected function onSPTClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:UserInfo = ActorManager.actorInfo;
         var _loc3_:uint = _loc2_.highestPetLevel;
         if(_loc3_ >= _petMaxLevelLimit)
         {
            ServerBufferManager.getServerBuffer(1,this.checkServerBufferHandler);
         }
         else
         {
            this.unConfigDialloge();
         }
      }
      
      private function checkServerBufferHandler(param1:ServerBuffer) : void
      {
         var checkSptBossInfoHandler:Function = null;
         var onClose_1:Function = null;
         var onClose_2:Function = null;
         var startFighter:Function = null;
         var data:XML = null;
         var dialogDefinition:DialogDefinition = null;
         var serverBuffer:ServerBuffer = param1;
         checkSptBossInfoHandler = function(param1:LittleEndianByteArray):void
         {
            var _loc2_:uint = SptBossInfoManager.resolveSpt(57,param1);
            if(_loc2_ < 1)
            {
               unConfigDialloge();
            }
            else
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
               _loc2_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,4));
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
               _loc2_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,5));
               _loc3_ = new DialogDefinition(_loc2_);
               DialogPanel.showForCommon(_loc3_,startFighter);
            }
         };
         startFighter = function(param1:String = ""):void
         {
            if("fight" == param1)
            {
               _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
            }
         };
         var beforeSPTWin:Boolean = serverBuffer.readDataAtPostion(_sptBufferPosition - 1) == 1;
         if(beforeSPTWin)
         {
            _winHistory = serverBuffer.readDataAtPostion(_sptBufferPosition) == 1;
            if(_winHistory)
            {
               _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
            }
            else
            {
               data = new XML(SptDialogConfig.getSptDialog(_sptBossId,3));
               dialogDefinition = new DialogDefinition(data);
               DialogPanel.showForCommon(dialogDefinition,onClose_1);
            }
         }
         else
         {
            checkSptBossInfo(checkSptBossInfoHandler);
         }
      }
      
      private function unConfigDialloge() : void
      {
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,6,[_petMaxLevelLimit]));
         var _loc1_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc1_);
      }
      
      override public function dispose() : void
      {
         this._mogu_MC.gotoAndStop(this._mogu_MC.totalFrames);
         super.dispose();
      }
   }
}

