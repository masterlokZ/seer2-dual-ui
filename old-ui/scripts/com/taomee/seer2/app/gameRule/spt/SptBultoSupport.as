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
   import com.taomee.seer2.app.quest.QuestManager;
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
   
   public class SptBultoSupport extends BaseSptSupport
   {
      
      private static var _instance:SptBultoSupport;
      
      private const AFTER_WIN:String = "afterWin";
      
      private const BEFORE_WIN:String = "beforeWin";
      
      private var _bluto_mc:MovieClip;
      
      public function SptBultoSupport(param1:Block)
      {
         super();
         if(param1 == null)
         {
            throw new Error("get By  getInstance()");
         }
      }
      
      public static function getInstance() : SptBultoSupport
      {
         if(!_instance)
         {
            _instance = new SptBultoSupport(new Block());
         }
         return _instance;
      }
      
      override public function init(param1:MapModel) : void
      {
         _sptBossId = 17;
         _petMaxLevelLimit = SptConfigInfoManager.getSptBossLevel(_sptBossId);
         _sptBufferPosition = 0;
         super.init(param1);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._bluto_mc) && this._bluto_mc.hasEventListener("mc_play_over"))
         {
            this._bluto_mc.removeEventListener("mc_play_over",this.onBlutoMCPlayOverHandler);
         }
         this._bluto_mc = null;
         super.dispose();
      }
      
      override protected function dealWithMapInit() : void
      {
         if(_winHistory)
         {
            showSPT("afterWin");
         }
         else
         {
            this._bluto_mc = _map.libManager.getMovieClip("blueto_mc");
            this._bluto_mc.x = 535;
            this._bluto_mc.y = 156;
            this._bluto_mc.addEventListener("mc_play_over",this.onBlutoMCPlayOverHandler);
            _map.front.addChild(this._bluto_mc);
         }
      }
      
      override protected function fightFailure(param1:LittleEndianByteArray) : void
      {
         var _loc2_:uint = SptBossInfoManager.resolveSpt(_sptBossId,param1);
         if(_loc2_ < 2)
         {
            showSPT("beforeWin");
            _animationPlayer = new ProgressiveAnimationPlayer(URLUtil.getQuestAnimation("spt/blutoWin"));
            _animationPlayer.addEventListener("end",this.onBluToWinAnimationEnd);
            LayerManager.uiLayer.addChild(_animationPlayer);
         }
         else
         {
            showSPT("afterWin");
         }
      }
      
      override protected function fightWin() : void
      {
         if(!_winHistory)
         {
            ServerBufferManager.updateServerBuffer(1,_sptBufferPosition,1);
            hideSPT();
            _animationPlayer = new ProgressiveAnimationPlayer(URLUtil.getQuestAnimation("spt/chairEvolution"));
            _animationPlayer.addEventListener("end",this.onChairAnimationEnd);
            LayerManager.uiLayer.addChild(_animationPlayer);
         }
         else
         {
            showSPT("afterWin");
         }
         if(QuestManager.isAccepted(10041))
         {
            QuestManager.completeStep(10041,1);
         }
      }
      
      override protected function initSPTNPC() : void
      {
         _sptNPC = MobileManager.getMobile(201,"npc");
         _sptNPC.buttonMode = true;
         _sptNPC.useHandCursor = true;
         showSPT("beforeWin");
         super.initSPTNPC();
      }
      
      override protected function onSPTClickHandler(param1:MouseEvent) : void
      {
         var _loc4_:XML = null;
         var _loc2_:DialogDefinition = null;
         var _loc3_:UserInfo = ActorManager.actorInfo;
         var _loc5_:uint = _loc3_.highestPetLevel;
         if(_loc5_ >= _petMaxLevelLimit)
         {
            ServerBufferManager.getServerBuffer(1,this.checkServerBufferHandler);
         }
         else
         {
            _loc4_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,1,[_petMaxLevelLimit]));
            _loc2_ = new DialogDefinition(_loc4_);
            DialogPanel.showForCommon(_loc2_);
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
         startFighter = function(param1:String = ""):void
         {
            if("fight" == param1)
            {
               _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
            }
         };
         var data:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,2));
         var dialogDefinition:DialogDefinition = new DialogDefinition(data);
         DialogPanel.showForCommon(dialogDefinition,startFighter);
      }
      
      private function onBlutoMCPlayOverHandler(param1:Event) : void
      {
         this._bluto_mc.removeEventListener("mc_play_over",this.onBlutoMCPlayOverHandler);
         DisplayObjectUtil.removeFromParent(this._bluto_mc);
         this._bluto_mc = null;
         showSPT();
      }
      
      private function onBluToWinAnimationEnd(param1:Event) : void
      {
         _animationPlayer.removeEventListener("end",this.onBluToWinAnimationEnd);
         DisplayObjectUtil.removeFromParent(_animationPlayer);
         _animationPlayer = null;
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,3));
         var _loc3_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc3_);
      }
      
      private function onChairAnimationEnd(param1:Event) : void
      {
         _animationPlayer.removeEventListener("end",this.onChairAnimationEnd);
         DisplayObjectUtil.removeFromParent(_animationPlayer);
         _animationPlayer = null;
         showSPT("afterWin");
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,4));
         var _loc3_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc3_);
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
