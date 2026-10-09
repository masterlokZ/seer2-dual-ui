package com.taomee.seer2.app.processor.quest.handler.main.quest6
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.events.DialogCloseEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   
   public class QuestMapHandler_6_124 extends QuestMapHandler
   {
      
      private var _spawnPetIndexVec:Vector.<uint>;
      
      private var _s_npc:Mobile;
      
      private var _ss_npc:Mobile;
      
      public function QuestMapHandler_6_124(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(_quest.status == 1 && _quest.isStepCompete(6))
         {
            this.createNpc();
            if(!_quest.isStepCompete(7))
            {
               this.processStep7();
            }
            else if(!_quest.isStepCompete(8))
            {
               this.processStep8();
            }
            else if(!_quest.isStepCompete(9))
            {
               this.processStep9();
            }
         }
      }
      
      override public function processMapDispose() : void
      {
         super.processMapDispose();
         this.removePetSpawnCommmandListener();
         QuestManager.removeEventListener("stepComplete",this.onCompleteStep7);
         QuestManager.removeEventListener("stepComplete",this.onCompleteStep8);
         QuestManager.removeEventListener("stepComplete",this.onCompleteStep9);
         if(this._s_npc)
         {
            this._s_npc.removeEventListener("click",this.onStartFightHandler);
         }
         if(this._ss_npc)
         {
            this._ss_npc.removeEventListener("click",this.onClickSsNpc);
         }
      }
      
      private function processStep7() : void
      {
         var fightResult:uint = 0;
         this.addPetSpawnCommandListener();
         if(SceneManager.prevSceneType != 2)
         {
            MovieClipUtil.playFullScreen(URLUtil.getQuestAnimation("6/quest6Animation2"),function():void
            {
               var dialogCloseHandler:Function = null;
               dialogCloseHandler = function(param1:DialogCloseEvent):void
               {
                  DialogPanel.removeCloseEventListener(dialogCloseHandler);
                  if(param1.params == "6-7-1")
                  {
                     startFight(23);
                  }
                  else if(param1.params == "6-7-2")
                  {
                     addSFightListener();
                  }
               };
               var data:XML = <dialog npcId="14" npcName="S" transport=""><branch id="default"><node emotion="0"><![CDATA[嘿！中招了吧！合体技能可是我S的绝招哟！就是我变成假神兽来骗你们的！很气？那就来打我呀！]]></node><reply action="close" params="6-7-1"><![CDATA[看我不收拾你！]]></reply><reply action="close" params="6-7-2"><![CDATA[（先做一下战前准备）]]></reply></branch></dialog>;
               var dialogDefinition:DialogDefinition = new DialogDefinition(data);
               DialogPanel.addCloseEventListener(dialogCloseHandler);
               DialogPanel.showForCommon(dialogDefinition);
            },true,false,2);
         }
         else
         {
            fightResult = FightManager.fightWinnerSide;
            if(fightResult == 1)
            {
               QuestManager.addEventListener("stepComplete",this.onCompleteStep7);
               QuestManager.completeStep(_quest.id,7);
            }
            else
            {
               this.addSFightListener();
            }
         }
      }
      
      private function onCompleteStep7(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep7);
            this.processStep8();
         }
      }
      
      private function addSFightListener() : void
      {
         _processor.showMouseHintAt(400,180);
         this._s_npc.buttonMode = true;
         this._s_npc.addEventListener("click",this.onStartFightHandler);
      }
      
      private function onStartFightHandler(param1:MouseEvent) : void
      {
         this.startFight(23);
      }
      
      private function processStep8() : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getQuestAnimation("6/quest6Animation3"),function():void
         {
            _processor.showMouseHintAt(560,98);
            DisplayObjectUtil.removeFromParent(_s_npc);
            createSsNpc();
            _ss_npc.buttonMode = true;
            _ss_npc.addEventListener("click",onClickSsNpc);
         });
      }
      
      private function onClickSsNpc(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._ss_npc.buttonMode = false;
         this._ss_npc.removeEventListener("click",this.onClickSsNpc);
         DialogPanel.showForSimple(406,"神兽",[[0,"感谢你们保卫着草目氏族！我是这里的守护者：目灵兽！"]],"啊……真的有目灵兽！",function():void
         {
            QuestManager.addEventListener("stepComplete",onCompleteStep8);
            QuestManager.completeStep(_quest.id,8);
         });
      }
      
      private function onCompleteStep8(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep8);
            this.processStep9();
         }
      }
      
      private function processStep9() : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getQuestAnimation("6/quest6Animation4"),function():void
         {
            DialogPanel.showForSimple(400,"神兽",[[0,"原来……那尊雕像！是目灵兽！！！！"]],"啊啊！！目灵兽不要走……",function():void
            {
               DialogPanel.showForSimple(406,"我",[[0,"后会有期了朋友！我想我们会再见的！"]],"快去禀报酋长吧！",function():void
               {
                  QuestManager.addEventListener("stepComplete",onCompleteStep9);
                  QuestManager.completeStep(_quest.id,9);
               });
            });
         });
      }
      
      private function onCompleteStep9(param1:QuestEvent) : void
      {
         if(param1.questId == _quest.id)
         {
            QuestManager.removeEventListener("stepComplete",this.onCompleteStep9);
            SceneManager.changeScene(1,110,520,450);
         }
      }
      
      private function createNpc() : void
      {
         var _loc3_:NpcDefinition = new NpcDefinition(<npc id="14" resId="14" name="S" dir="0" width="25" height="90"
                                                          pos="560,340" actorPos="560,360" path=""/>);
         this._s_npc = MobileManager.createNpc(_loc3_);
         _map.content.addChild(this._s_npc);
         var _loc2_:NpcDefinition = new NpcDefinition(<npc id="10" resId="10" name="巴蒂" dir="1" width="25" height="90"
                                                          pos="680,240" actorPos="560,360" path=""/>);
         var _loc5_:Mobile = MobileManager.createNpc(_loc2_);
         _map.content.addChild(_loc5_);
         var _loc4_:NpcDefinition = new NpcDefinition(<npc id="11" resId="11" name="多罗" dir="1" width="25" height="90"
                                                          pos="740,240" actorPos="560,360" path=""/>);
         var _loc1_:Mobile = MobileManager.createNpc(_loc4_);
         _map.content.addChild(_loc1_);
      }
      
      private function createSsNpc() : void
      {
         var _loc1_:NpcDefinition = new NpcDefinition(<npc id="406" resId="406" name="神兽" dir="1" width="25"
                                                          height="185" pos="600,361" actorPos="399,320" path=""/>);
         this._ss_npc = MobileManager.createNpc(_loc1_);
         _map.content.addChild(this._ss_npc);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function addPetSpawnCommandListener() : void
      {
         Connection.addCommandListener(CommandSet.PET_SPAWN_1103,this.onPetSpawn);
      }
      
      private function onPetSpawn(param1:MessageEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         this._spawnPetIndexVec = new Vector.<uint>();
         var _loc5_:IDataInput = param1.message.getRawDataCopy();
         var _loc7_:int = int(_loc5_.readUnsignedInt());
         var _loc6_:int = 0;
         while(_loc6_ < _loc7_)
         {
            _loc3_ = int(_loc5_.readUnsignedByte());
            _loc2_ = int(_loc5_.readUnsignedInt());
            _loc4_ = int(_loc5_.readUnsignedShort());
            this._spawnPetIndexVec.push(_loc3_);
            _loc6_++;
         }
      }
      
      private function removePetSpawnCommmandListener() : void
      {
         Connection.removeCommandListener(CommandSet.PET_SPAWN_1103,this.onPetSpawn);
      }
      
      private function startFight(param1:uint) : void
      {
         FightManager.startFightWithWild(param1);
      }
   }
}

