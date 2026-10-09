package com.taomee.seer2.app.arena.ui.toolbar
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.controller.ArenaUIIsNew;
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.data.FighterInfo;
   import com.taomee.seer2.app.arena.data.FighterTeam;
   import com.taomee.seer2.app.arena.events.OperateEvent;
   import com.taomee.seer2.app.arena.resource.FightUIManager;
   import com.taomee.seer2.app.arena.ui.ButtonPanelData;
   import com.taomee.seer2.app.arena.util.ControlPanelUtil;
   import com.taomee.seer2.app.config.FitConfig;
   import com.taomee.seer2.app.gameRule.door.DoorArenaRule;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import seer2.next.entry.DynSwitch;
   import seer2.next.fight.auto.AutoFightPanel;
   
   public class FightControlPanel extends Sprite
   {
      
      private var _arenaData:ArenaDataInfo;
      
      private var _controlledTeam:FighterTeam;
      
      private var _oppositeTeam:FighterTeam;
      
      private var _controlledFighter:Fighter;
      
      private var _back:Sprite;
      
      private var _hubButtonPanel:HubButtonPanel;
      
      private var _skillPanel:SkillPanel;
      
      private var _itemPanel:ItemPanel;
      
      private var _capsulePanel:ItemPanel;
      
      private var _fighterPanel:FighterPanel;
      
      private var _changFightUIBtn:SimpleButton;
      
      public function FightControlPanel()
      {
         super();
         this._back = FightUIManager.getSprite("UI_FightBarBack");
         addChild(this._back);
         this._skillPanel = new SkillPanel();
         this._skillPanel.y = 41;
         this._fighterPanel = new FighterPanel();
         this._itemPanel = new ItemPanel(2);
         this._capsulePanel = new ItemPanel(1);
         this._hubButtonPanel = new HubButtonPanel();
         addChild(this._hubButtonPanel);
         this._changFightUIBtn = this._back["changFightUIBtn"];
         this._hubButtonPanel.addEventListener("fight",this.onFightClick);
         this._hubButtonPanel.addEventListener("item",this.onItemClick);
         this._hubButtonPanel.addEventListener("pet",this.onPetClick);
         this._hubButtonPanel.addEventListener("escape",this.onEscapeClick);
         this._hubButtonPanel.addEventListener("catch",this.onCatchClick);
         this._skillPanel.addEventListener("operateEnd",this.onOperateEnd);
         this._fighterPanel.addEventListener("operateEnd",this.onOperateEnd);
         this._fighterPanel.addEventListener("fightSelectSkill",this.onFightSelectSkill);
         this._itemPanel.addEventListener("operateEnd",this.onOperateEnd);
         this._itemPanel.addEventListener("error",this.onItemPanelTurnError);
         this._itemPanel.addEventListener("fightSelectItem",this.onFightSelectItem);
         this._capsulePanel.addEventListener("operateEnd",this.onOperateEnd);
         this._changFightUIBtn.addEventListener("click",this.onChangFight);
      }
      
      private function onChangFight(param1:MouseEvent) : void
      {
         ArenaUIIsNew.isNewUI = !ArenaUIIsNew.isNewUI;
         var _loc2_:String = ArenaUIIsNew.isNewUI ? "新" : "旧";
         ServerMessager.addMessage("下场战斗切换至" + _loc2_ + "UI");
      }
      
      public function active() : void
      {
         this._skillPanel.active();
         this._hubButtonPanel.active();
         this._itemPanel.active();
         this._capsulePanel.active();
         this._fighterPanel.active();
         this.updateHubButtonPanel();
         this.update();
      }
      
      public function deactive() : void
      {
         this._hubButtonPanel.deactive();
         this._skillPanel.deactive();
         this._itemPanel.deactive();
         this._capsulePanel.deactive();
         this._fighterPanel.deactive();
      }
      
      public function initPanelInfo(param1:ArenaDataInfo) : void
      {
         this._arenaData = param1;
         this._controlledTeam = param1.leftTeam;
         this._oppositeTeam = param1.rightTeam;
         this.updateOppositeFighter();
         var _loc2_:ButtonPanelData = ControlPanelUtil.getSettingData(this._arenaData.fightMode);
         this._arenaData.btnPanelData.merge(_loc2_);
      }
      
      public function updateControlledFighter(param1:Fighter) : void
      {
         this._controlledFighter = param1;
         this._itemPanel.setControlledFighter(this._controlledFighter);
         this._capsulePanel.setControlledFighter(this._controlledFighter);
         this._skillPanel.setFighter(this._controlledFighter);
         this.updateOppositeFighter();
      }
      
      public function updateOppositeFighter() : void
      {
         this._itemPanel.setOppositeFighter(this._oppositeTeam.mainFighter);
         this._capsulePanel.setOppositeFighter(this._oppositeTeam.mainFighter);
      }
      
      public function update() : void
      {
         this._skillPanel.updateSkillBtn();
         this._fighterPanel.update();
         this.showSkillBtnLightRingByQuest1();
      }
      
      public function showSkillPanel() : void
      {
         this.hideAll();
         addChild(this._skillPanel);
         this._skillPanel.setFighter(this._controlledFighter);
         this._hubButtonPanel.highlightFightBtn();
      }
      
      public function showFighterPanel(param1:uint = 0) : void
      {
         this.hideAll();
         this._fighterPanel.setFighterTeam(this._controlledTeam,param1);
         addChild(this._fighterPanel);
         this._hubButtonPanel.highlightPetBtn();
         if(!this._arenaData.isDoubleMode)
         {
            this._fighterPanel.updatePetPress(this._oppositeTeam.mainFighter.fighterInfo.typeId);
         }
      }
      
      public function changeTeam(param1:String, param2:uint, param3:uint) : void
      {
         var _loc9_:Fighter = null;
         var _loc6_:Fighter = null;
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Fighter> = this._controlledTeam.fighterVec;
         var _loc8_:Vector.<Fighter> = this._controlledTeam.changeFighterVec;
         _loc6_ = this._controlledTeam.getFighter(ActorManager.actorInfo.id,param2);
         _loc9_ = this._controlledTeam.getChangeFighter(ActorManager.actorInfo.id,param3);
         _loc7_ = this._controlledTeam.fighterVec.indexOf(_loc6_);
         _loc4_ = this._controlledTeam.changeFighterVec.indexOf(_loc9_);
         this._controlledTeam.fighterVec[_loc7_] = _loc9_;
         this._controlledTeam.changeFighterVec[_loc4_] = _loc6_;
         if(param1 == "changePet")
         {
            _loc9_.fighterInfo.fightAnger = 20;
         }
         else if(param1 == "die")
         {
            _loc9_.fighterInfo.hp = 0;
         }
      }
      
      private function onFightSelectSkill(param1:OperateEvent) : void
      {
         this.showSkillPanel();
      }
      
      public function automate() : void
      {
         var _loc5_:OperateEvent = null;
         var _loc4_:int = 0;
         var _loc7_:Vector.<SkillInfo> = null;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc1_:SkillInfo = null;
         var _loc3_:FighterInfo = null;
         if(this._controlledFighter.fighterInfo.hp > 0)
         {
            this.showSkillPanel();
            _loc4_ = -1;
            if(this._controlledFighter.fighterInfo.hasSuperSkill())
            {
               _loc1_ = this._controlledFighter.fighterInfo.getSuperSkill();
               if(_loc1_ != null && this._controlledFighter.fighterInfo.checkSkillAnger(_loc1_) && DynSwitch.autobsMode)
               {
                  _loc4_ = int(_loc1_.id);
                  _loc5_ = new OperateEvent(1,_loc4_,"operateEnd");
                  this.endInput(_loc5_);
                  return;
               }
            }
            _loc7_ = this._controlledFighter.fighterInfo.skillInfoVec;
            _loc6_ = int(_loc7_.length);
            _loc2_ = 0;
            while(_loc2_ < _loc6_)
            {
               _loc1_ = _loc7_[_loc2_];
               if(this._controlledFighter.fighterInfo.checkSkillAnger(_loc1_))
               {
                  _loc4_ = int(_loc1_.id);
                  break;
               }
               _loc2_++;
            }
            if(_loc4_ == -1)
            {
               _loc4_ = int(_loc7_[0].id);
            }
            _loc5_ = new OperateEvent(1,_loc4_,"operateEnd");
         }
         else
         {
            this.showFighterPanel();
            _loc3_ = this._controlledTeam.getRandomAliveFighterInfo();
            if(_loc3_ != null)
            {
               _loc5_ = new OperateEvent(4,_loc3_.catchTime,"operateEnd");
            }
         }
         this.endInput(_loc5_);
      }
      
      public function automate2() : void
      {
         var op:int = AutoFightPanel.instance().getOperation();
         showSkillPanel();
         if(op < 6)
         {
            this.skillOp(op);
         }
         else if(op == 6)
         {
            this.runOp();
         }
         else if(op == 7)
         {
            this.cure();
         }
         else if(op == 8)
         {
            this.capture();
         }
         else if(op > 20 && op < 30)
         {
            angerSupplement(op);
         }
         else if(op > 10 && op < 20)
         {
            changeOp(op);
         }
      }
      
      private function skillOp(skillIndex:int) : void
      {
         var skillId:int = 0;
         if(this._controlledFighter.fighterInfo.hp > 0)
         {
            skillId = 0;
            if(skillIndex < 5)
            {
               skillId = int(this._controlledFighter.fighterInfo.skillInfoVec[skillIndex].id);
            }
            else
            {
               skillId = int(this._controlledFighter.fighterInfo.getSuperSkill().id);
            }
            this.endInput(new OperateEvent(1,skillId,"operateEnd"));
            return;
         }
         showFighterPanel();
         var p:FighterInfo = null;
         p = this._controlledTeam.getRandomAliveFighterInfo();
         if(p != null)
         {
            this.endInput(new OperateEvent(4,p.catchTime,"operateEnd"));
         }
      }
      
      private function cure() : void
      {
         var oe:OperateEvent = new OperateEvent(2,200019,"operateEnd");
         oe.fighterId = this._controlledFighter.id;
         endInput(oe);
      }
      
      private function capture() : void
      {
         endInput(new OperateEvent(3,200003,"operateEnd"));
      }
      
      private function angerSupplement(param:uint) : void
      {
         var oe:OperateEvent = new OperateEvent(2,200000 + param,"operateEnd");
         oe.fighterId = this._controlledFighter.id;
         endInput(oe);
      }
      
      private function changeOp(petIndex:int) : void
      {
         var oe:OperateEvent = null;
         this.showFighterPanel();
         var o:FighterInfo = this._controlledTeam.fighterVec[petIndex - 11].fighterInfo;
         if(o.position != 0)
         {
            skillOp(0);
         }
         else if(o.hp > 0)
         {
            endInput(new OperateEvent(4,o.catchTime,"operateEnd"));
         }
         else if(o.hp == 0)
         {
            oe = new OperateEvent(6,200064,"operateEnd");
            oe.fighterId = o.catchTime;
            endInput(oe);
         }
      }
      
      public function runOp() : void
      {
         endInput(new OperateEvent(5,0,"operateEnd"));
      }
      
      private function hideAll() : void
      {
         DisplayObjectUtil.removeFromParent(this._capsulePanel);
         DisplayObjectUtil.removeFromParent(this._fighterPanel);
         DisplayObjectUtil.removeFromParent(this._itemPanel);
         DisplayObjectUtil.removeFromParent(this._skillPanel);
      }
      
      private function updateHubButtonPanel() : void
      {
         this._hubButtonPanel.unhighlightAll();
         this._hubButtonPanel.catchBtnLightRingEnabled = false;
         var _loc2_:ButtonPanelData = new ButtonPanelData();
         if(this._controlledFighter.fighterInfo.hp == 0)
         {
            _loc2_.setDeadFightConfig();
         }
         else
         {
            _loc2_.merge(this._arenaData.btnPanelData);
         }
         if(this._arenaData.isDoubleMode)
         {
            _loc2_.catchEnabled = false;
         }
         else if(this._oppositeTeam.mainFighter.fighterInfo.isCatchable == false)
         {
            _loc2_.catchEnabled = false;
         }
         _loc2_.catchEnabled &&= this._arenaData.canCatch;
         if(this._arenaData.canCatchAfterSptDeadNow)
         {
            _loc2_.catchEnabled = true;
         }
         var _loc1_:int = int(this._arenaData.fightMode);
         if(_loc1_ == 102 || _loc1_ == 103)
         {
            if(DoorArenaRule.current_arena_rule == 3)
            {
               _loc2_.petEnabled = false;
            }
         }
         this._hubButtonPanel.fightEnabled = _loc2_.fightEnabled;
         this._hubButtonPanel.catchEnabled = _loc2_.catchEnabled;
         this._hubButtonPanel.itemEnabled = _loc2_.itemEnabled;
         this._hubButtonPanel.petEnabled = _loc2_.petEnabled;
         this._hubButtonPanel.escapeEnabled = _loc2_.escapeEnabled;
         this.disableEscapeButtonByQuest1();
         this.showCatchLightRingByQuest3();
      }
      
      private function onOperateEnd(param1:OperateEvent) : void
      {
         this.endInput(param1);
      }
      
      private function onItemPanelTurnError(param1:OperateEvent) : void
      {
         this.showSkillPanel();
      }
      
      private function onFightClick(param1:Event) : void
      {
         this.showSkillPanel();
      }
      
      public function itemPanelUpdate() : void
      {
         this._itemPanel.resetData();
      }
      
      private function onItemClick(param1:Event) : void
      {
         this.hideAll();
         this._itemPanel.reset();
         addChild(this._itemPanel);
      }
      
      private function onFightSelectItem(param1:OperateEvent) : void
      {
         this.showFighterPanel(param1.id);
      }
      
      private function onPetClick(param1:Event) : void
      {
         if(FitConfig.isPetFit(this._controlledFighter.fighterInfo.bunchId))
         {
            AlertManager.showAlert("合体中不可更换精灵！");
            return;
         }
         this.showFighterPanel();
      }
      
      private function onEscapeClick(param1:Event) : void
      {
         if(this._arenaData.isFightEnd == false)
         {
            this.endInput(new OperateEvent(5,0,"operateEnd"));
         }
      }
      
      private function onCatchClick(param1:Event) : void
      {
         this.hideAll();
         this._capsulePanel.reset();
         addChild(this._capsulePanel);
      }
      
      private function endInput(param1:OperateEvent) : void
      {
         this.deactive();
         dispatchEvent(param1);
      }
      
      public function getHubButtonPanel() : HubButtonPanel
      {
         return this._hubButtonPanel;
      }
      
      public function dispose() : void
      {
         DisplayObjectUtil.removeAllChildren(this);
         this._hubButtonPanel.removeEventListener("fight",this.onFightClick);
         this._hubButtonPanel.removeEventListener("item",this.onItemClick);
         this._hubButtonPanel.removeEventListener("pet",this.onPetClick);
         this._hubButtonPanel.removeEventListener("escape",this.onEscapeClick);
         this._hubButtonPanel.removeEventListener("catch",this.onCatchClick);
         this._skillPanel.removeEventListener("operateEnd",this.onOperateEnd);
         this._fighterPanel.removeEventListener("operateEnd",this.onOperateEnd);
         this._itemPanel.removeEventListener("operateEnd",this.onOperateEnd);
         this._itemPanel.removeEventListener("error",this.onItemPanelTurnError);
         this._capsulePanel.removeEventListener("operateEnd",this.onOperateEnd);
         this._back = null;
         this._skillPanel.dispose();
         this._skillPanel = null;
         this._itemPanel.dispose();
         this._itemPanel = null;
         this._capsulePanel.dispose();
         this._capsulePanel = null;
         this._fighterPanel.dispose();
         this._fighterPanel = null;
         this._controlledTeam = null;
         this._controlledFighter = null;
         this._oppositeTeam = null;
         this._hubButtonPanel.dispose();
         this._hubButtonPanel = null;
      }
      
      private function disableEscapeButtonByQuest1() : void
      {
         if(QuestManager.isComplete(1) == false)
         {
            this._hubButtonPanel.escapeEnabled = false;
         }
      }
      
      private function showCatchLightRingByQuest3() : void
      {
         var _loc1_:Fighter = this._oppositeTeam.mainFighter;
         if(QuestManager.isStepComplete(3,2) && QuestManager.isStepComplete(3,3) == false && _loc1_.fighterInfo.resourceId == 10)
         {
            this._hubButtonPanel.catchBtnLightRingEnabled = true;
         }
      }
      
      private function showSkillBtnLightRingByQuest1() : void
      {
         if(QuestManager.isStepComplete(1,3) && QuestManager.isStepComplete(1,4) == false)
         {
            this._skillPanel.skillBtnLightRingEnabled = true;
         }
      }
   }
}

