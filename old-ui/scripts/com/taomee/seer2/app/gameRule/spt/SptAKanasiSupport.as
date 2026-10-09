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
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SptAKanasiSupport extends BaseSptSupport
   {
      
      private static var _instance:SptAKanasiSupport;
      
      private const LABEL_NEVERWIN:String = "labelNeverWin";
      
      private const LABEL_UNLEVEL:String = "labelUnLevel";
      
      private const LABEL_WINBEFORE:String = "labelWinBefore";
      
      private var _akns_MC:MovieClip;
      
      public function SptAKanasiSupport(param1:Block)
      {
         super();
         if(param1 == null)
         {
            throw new Error("get By getInstance()");
         }
      }
      
      public static function getInstance() : SptAKanasiSupport
      {
         if(!_instance)
         {
            _instance = new SptAKanasiSupport(new Block());
         }
         return _instance;
      }
      
      override public function init(param1:MapModel) : void
      {
         _sptBossId = 31;
         _petMaxLevelLimit = SptConfigInfoManager.getSptBossLevel(_sptBossId);
         _sptBufferPosition = 1;
         super.init(param1);
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
            _animationPlayer = new ProgressiveAnimationPlayer(URLUtil.getQuestAnimation("spt/map_193_fullmovie"));
            _animationPlayer.addEventListener("end",this.onChairAnimationEnd);
            LayerManager.topLayer.addChild(_animationPlayer);
         }
         else
         {
            this.showSPT("labelWinBefore");
         }
      }
      
      override protected function hideSPT() : void
      {
         if(this._akns_MC)
         {
            this._akns_MC.visible = false;
         }
      }
      
      override protected function initSPTNPC() : void
      {
         this._akns_MC = _map.content["akns"];
         _sptNPC = this._akns_MC["aknsInstance"];
         _sptNPC.buttonMode = true;
         _sptNPC.useHandCursor = true;
         super.initSPTNPC();
      }
      
      override public function dispose() : void
      {
         this._akns_MC.gotoAndStop(this._akns_MC.totalFrames);
         super.dispose();
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
      
      override protected function showSPT(param1:String = null) : void
      {
         if(this._akns_MC)
         {
            this._akns_MC.visible = true;
            if(param1 != null)
            {
               (this._akns_MC as MovieClip).gotoAndPlay(param1);
            }
         }
      }
      
      private function checkServerBufferHandler(param1:ServerBuffer) : void
      {
         var checkSptBossInfoHandler:Function = null;
         var startFighter:Function = null;
         var dataXML:XML = null;
         var dialogDefinition:DialogDefinition = null;
         var serverBuffer:ServerBuffer = param1;
         checkSptBossInfoHandler = function(param1:LittleEndianByteArray):void
         {
            var _loc2_:uint = SptBossInfoManager.resolveSpt(17,param1);
            if(_loc2_ < 1)
            {
               unConfigDialloge();
            }
            else
            {
               _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
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
               dataXML = new XML(SptDialogConfig.getSptDialog(_sptBossId,2));
               dialogDefinition = new DialogDefinition(dataXML);
               DialogPanel.showForCommon(dialogDefinition,startFighter);
            }
         }
         else
         {
            checkSptBossInfo(checkSptBossInfoHandler);
         }
      }
      
      private function onChairAnimationEnd(param1:Event) : void
      {
         _animationPlayer.removeEventListener("end",this.onChairAnimationEnd);
         DisplayObjectUtil.removeFromParent(_animationPlayer);
         _animationPlayer = null;
         this.showSPT("labelWinBefore");
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,3));
         var _loc3_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc3_);
      }
      
      private function unConfigDialloge() : void
      {
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,4,[_petMaxLevelLimit]));
         var _loc1_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc1_);
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
