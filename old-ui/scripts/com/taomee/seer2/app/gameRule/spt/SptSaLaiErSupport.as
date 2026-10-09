package com.taomee.seer2.app.gameRule.spt
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.gameRule.spt.support.BaseSptSupport;
   import com.taomee.seer2.app.gameRule.spt.support.SptBossInfoManager;
   import com.taomee.seer2.app.gameRule.spt.support.SptConfigInfoManager;
   import com.taomee.seer2.app.gameRule.spt.support.SptDialogConfig;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SptSaLaiErSupport extends BaseSptSupport
   {
      
      private static var _instance:SptSaLaiErSupport;
      
      private const LABEL_NEVERWIN:String = "normal";
      
      private const LABEL_UNLEVEL:String = "normal";
      
      private const LABEL_WINBEFORE:String = "normal";
      
      private var _temiti_MC:MovieClip;
      
      public function SptSaLaiErSupport()
      {
         super();
      }
      
      public static function getInstance() : SptSaLaiErSupport
      {
         if(!_instance)
         {
            _instance = new SptSaLaiErSupport();
         }
         return _instance;
      }
      
      override public function init(param1:MapModel) : void
      {
         _sptBossId = 997;
         _petMaxLevelLimit = SptConfigInfoManager.getSptBossLevel(_sptBossId);
         _sptBufferPosition = 13;
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
               this.showSPT("normal");
            }
            else
            {
               this.showSPT("normal");
            }
         }
         else
         {
            this.showSPT("normal");
         }
      }
      
      override protected function fightFailure(param1:LittleEndianByteArray) : void
      {
         var _loc4_:XML = null;
         var _loc3_:DialogDefinition = null;
         var _loc2_:uint = SptBossInfoManager.resolveSpt(_sptBossId,param1);
         if(_loc2_ < 2)
         {
            this.showSPT("normal");
            _loc4_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,6,[SptDialogConfig.getTalkContent(_sptBossId)]));
            _loc3_ = new DialogDefinition(_loc4_);
            DialogPanel.showForCommon(_loc3_);
         }
         else
         {
            this.showSPT("normal");
         }
      }
      
      override protected function fightWin() : void
      {
         var data:XML = null;
         var dialogDefinition:DialogDefinition = null;
         var onClose_3:Function = null;
         if(!_winHistory)
         {
            onClose_3 = function(param1:String = ""):void
            {
               var _loc2_:XML = null;
               var _loc3_:DialogDefinition = null;
               if(param1 == "next2")
               {
                  _loc2_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,5));
                  _loc3_ = new DialogDefinition(_loc2_);
                  DialogPanel.showForCommon(_loc3_,onClose_3);
               }
            };
            ServerBufferManager.updateServerBuffer(1,_sptBufferPosition,1);
            this.showSPT("normal");
            data = new XML(SptDialogConfig.getSptDialog(_sptBossId,4));
            dialogDefinition = new DialogDefinition(data);
            DialogPanel.showForCommon(dialogDefinition,onClose_3);
         }
         else
         {
            this.showSPT("normal");
         }
      }
      
      override protected function initSPTNPC() : void
      {
         _sptNPC = _map.content["sptSaLaiEr"];
         if(SceneManager.prevSceneType == 2)
         {
            MovieClip(_sptNPC).gotoAndStop(MovieClip(_sptNPC).totalFrames);
            _sptNPC.buttonMode = true;
            _sptNPC.useHandCursor = true;
         }
         else
         {
            MovieClip(_sptNPC).gotoAndStop(1);
            _sptNPC.mouseChildren = false;
            _sptNPC.mouseEnabled = false;
            MovieClipUtil.playMc(_sptNPC as MovieClip,2,MovieClip(_sptNPC).totalFrames,function():void
            {
               _sptNPC.buttonMode = true;
               _sptNPC.useHandCursor = true;
               _sptNPC.mouseChildren = true;
               _sptNPC.mouseEnabled = true;
            });
         }
         super.initSPTNPC();
      }
      
      override protected function showSPT(param1:String = null) : void
      {
         if(this._temiti_MC)
         {
            this._temiti_MC.visible = true;
            if(param1 != null)
            {
               (this._temiti_MC as MovieClip).gotoAndPlay(param1);
            }
         }
      }
      
      override protected function hideSPT() : void
      {
         if(this._temiti_MC)
         {
            this._temiti_MC.visible = false;
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
         var beforeSPTWin:Boolean;
         var checkSptBossInfoHandler:Function = null;
         var onClose_1:Function = null;
         var onClose_2:Function = null;
         var data:XML = null;
         var dialogDefinition:DialogDefinition = null;
         var serverBuffer:ServerBuffer = param1;
         checkSptBossInfoHandler = function(param1:LittleEndianByteArray):void
         {
            var _loc2_:uint = SptBossInfoManager.resolveSpt(248,param1);
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
            if(param1 == "prepareFight")
            {
               _loc2_ = new XML(SptDialogConfig.getSptDialog(_sptBossId,3));
               _loc3_ = new DialogDefinition(_loc2_);
               DialogPanel.showForCommon(_loc3_,onClose_2);
            }
         };
         onClose_2 = function(param1:String = ""):void
         {
            if(param1 == "fight")
            {
               _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
            }
         };
         serverBuffer.printDataInfo();
         beforeSPTWin = serverBuffer.readDataAtPostion(_sptBufferPosition - 1) == 1;
         if(beforeSPTWin)
         {
            _winHistory = serverBuffer.readDataAtPostion(_sptBufferPosition) == 1;
            if(_winHistory)
            {
               _fighterID = FightManager.startFightWithSPTBoss(_sptBossId);
            }
            else
            {
               data = new XML(SptDialogConfig.getSptDialog(_sptBossId,2));
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
         var _loc2_:XML = new XML(SptDialogConfig.getSptDialog(_sptBossId,1,[_petMaxLevelLimit]));
         var _loc1_:DialogDefinition = new DialogDefinition(_loc2_);
         DialogPanel.showForCommon(_loc1_);
      }
      
      private function onChairAnimationEnd(param1:Event) : void
      {
         _animationPlayer.removeEventListener("end",this.onChairAnimationEnd);
         DisplayObjectUtil.removeFromParent(_animationPlayer);
         _animationPlayer = null;
      }
      
      override public function dispose() : void
      {
         if(this._temiti_MC)
         {
            this._temiti_MC.gotoAndStop(this._temiti_MC.totalFrames);
         }
         this._temiti_MC = null;
         super.dispose();
      }
   }
}

