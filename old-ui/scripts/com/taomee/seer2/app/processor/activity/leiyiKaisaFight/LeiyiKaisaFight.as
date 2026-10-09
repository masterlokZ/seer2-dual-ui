package com.taomee.seer2.app.processor.activity.leiyiKaisaFight
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.DialogPanelEventData;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.dialog.functionality.CustomUnit;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   import flash.utils.setTimeout;
   
   public class LeiyiKaisaFight
   {
      
      private var _kaisaDefinition:NpcDefinition;
      
      private var _leiyiDefinition:NpcDefinition;
      
      private var _kaisaNpc:Mobile;
      
      private var _leiyiNpc:Mobile;
      
      public function LeiyiKaisaFight()
      {
         super();
         this.initNpc();
      }
      
      private function initNpc() : void
      {
         if(SceneManager.prevSceneType == 2)
         {
            if(FightManager.fightWinnerSide == 1)
            {
               this.win();
            }
         }
         var _loc2_:XML = <npc id="499" resId="499" name="凯萨" dir="1" width="75" height="135" pos="140,384"
                              actorPos="320,150" path="">
            <dialog npcId="499" npcName="凯萨" transport="1,300,400">
                <branch id="default">
                    <node emotion="0"><![CDATA[让我来告诉你什么是强者吧。]]></node>
                    <reply action="close"><![CDATA[飘过……]]></reply>
                </branch>
            </dialog>
        </npc>;
         this._kaisaDefinition = new NpcDefinition(_loc2_);
         this._kaisaNpc = MobileManager.createNpc(this._kaisaDefinition);
         this._kaisaNpc.buttonMode = true;
         this._kaisaNpc.addEventListener("click",this.onKaisa);
         var _loc1_:XML = <npc id="477" resId="477" name="雷伊" dir="1" width="75" height="135" pos="285,384"
                              actorPos="320,150" path="">
            <dialog npcId="477" npcName="雷伊" transport="1,300,400">
                <branch id="default">
                    <node emotion="0"><![CDATA[让我来告诉你什么是强者吧。]]></node>
                    <reply action="close"><![CDATA[飘过……]]></reply>
                </branch>
            </dialog>
        </npc>;
         this._leiyiDefinition = new NpcDefinition(_loc1_);
         this._leiyiNpc = MobileManager.createNpc(this._leiyiDefinition);
         this._leiyiNpc.buttonMode = true;
         this._leiyiNpc.addEventListener("click",this.onLeiyi);
         DialogPanel.addEventListener("dialogShow",this.onDialogShow);
      }
      
      private function onDialogShow(param1:DialogPanelEvent) : void
      {
         var _loc2_:CustomUnit = null;
         if(param1.content == 499 || param1.content == 477)
         {
            _loc2_ = new CustomUnit("active","雷鸣炎破之战","fight");
            DialogPanel.functionalityBox.addUnit(_loc2_);
            _loc2_ = new CustomUnit("active","强者的战利品","panel");
            DialogPanel.functionalityBox.addUnit(_loc2_);
            _loc2_ = new CustomUnit("active","领悟雷鸣炎破斩","skill");
            DialogPanel.functionalityBox.addUnit(_loc2_);
            DialogPanel.addEventListener("customUnitClick",this.onCustomUnitClick);
         }
      }
      
      private function win() : void
      {
         setTimeout(function():void
         {
            ItemManager.addEventListener1("requestSpecialItemSuccess",onSeer);
            ItemManager.requestSpecialItemList();
         },1000);
      }
      
      private function onSeer(param1:ItemEvent) : void
      {
         var _loc6_:PetInfo = null;
         var _loc5_:PetInfo = null;
         var _loc3_:PetInfo = null;
         var _loc2_:LittleEndianByteArray = null;
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.onSeer);
         var _loc4_:uint = 0;
         if(ItemManager.getSpecialItem(500513) != null)
         {
            _loc4_ = ItemManager.getSpecialItem(500513).quantity;
         }
         if(_loc4_ != 0 && _loc4_ % 10 == 0)
         {
            for each(_loc3_ in PetInfoManager.getAllBagPetInfo())
            {
               if(_loc3_.resourceId == 90)
               {
                  _loc6_ = _loc3_;
               }
               if(_loc3_.resourceId == 234)
               {
                  _loc5_ = _loc3_;
               }
            }
            if(_loc6_.hp <= 0 || _loc5_.hp <= 0)
            {
               AlertManager.showAlert("很抱歉，您的出战精灵血量为0，所以无法参战");
               return;
            }
            _loc2_ = new LittleEndianByteArray();
            _loc2_.writeUnsignedInt(2);
            _loc2_.writeUnsignedInt(_loc6_.catchTime);
            _loc2_.writeUnsignedInt(_loc5_.catchTime);
            Connection.addCommandListener(CommandSet.SELECT_FIGHT_MONS_1192,this.on1192);
            Connection.send(CommandSet.SELECT_FIGHT_MONS_1192,_loc2_);
         }
      }
      
      private function on1192(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.SELECT_FIGHT_MONS_1192,this.on1192);
         FightManager.startFightWithWild(154);
      }
      
      private function onCustomUnitClick(param1:DialogPanelEvent) : void
      {
         var _loc2_:String = DialogPanelEventData(param1.content).params;
         if(_loc2_ == "fight")
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("LeiyiKaisaFightSelectPanel"),"正在面板...");
         }
         else if(_loc2_ == "panel")
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("LeiyiKaisaFightPanel"),"正在面板...");
         }
         else if(_loc2_ == "skill")
         {
            ItemManager.addEventListener1("requestSpecialItemSuccess",this.onGetCount);
            ItemManager.requestSpecialItemList();
         }
         else if(_loc2_ == "KSBattleSptPanel")
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("KSBattleSptPanel"),"正在面板...");
         }
         else if(_loc2_ == "KSWarTrophiesPanel")
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("KSWarTrophiesPanel"),"正在面板...");
         }
      }
      
      private function onGetCount(param1:ItemEvent) : void
      {
         var count:uint;
         var leiyiInfo:PetInfo = null;
         var kaisaInfo:PetInfo = null;
         var info:PetInfo = null;
         var event:ItemEvent = param1;
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.onGetCount);
         count = 0;
         for each(info in PetInfoManager.getAllBagPetInfo())
         {
            if(info.resourceId == 90)
            {
               count++;
               leiyiInfo = info;
            }
            if(info.resourceId == 234)
            {
               count++;
               kaisaInfo = info;
            }
         }
         if(count < 2)
         {
            AlertManager.showAlert("背包里没有雷伊或者凯萨");
            return;
         }
         count = 0;
         if(ItemManager.getSpecialItem(500513) != null)
         {
            count = ItemManager.getSpecialItem(500513).quantity;
         }
         if(count < 10)
         {
            AlertManager.showAlert("连胜次数不足30场");
            return;
         }
         SwapManager.swapItem(549,1,function(param1:IDataInput):void
         {
            var _loc2_:Vector.<SkillInfo> = null;
            var _loc3_:Vector.<SkillInfo> = null;
            if(kaisaInfo.skillInfo.skillInfoVec.length >= 5)
            {
               _loc2_ = kaisaInfo.skillInfo.candidateSkillInfoVec.concat();
               _loc2_.push(new SkillInfo(11618));
               kaisaInfo.skillInfo.addGainedSkillInfoVec(_loc2_);
            }
            else
            {
               _loc2_ = kaisaInfo.skillInfo.skillInfoVec.concat();
               _loc2_.push(new SkillInfo(11618));
               kaisaInfo.skillInfo.updateSkillInfoVec(_loc2_);
            }
            if(leiyiInfo.skillInfo.skillInfoVec.length >= 5)
            {
               _loc3_ = leiyiInfo.skillInfo.candidateSkillInfoVec.concat();
               _loc3_.push(new SkillInfo(11619));
               leiyiInfo.skillInfo.addGainedSkillInfoVec(_loc3_);
            }
            else
            {
               _loc3_ = leiyiInfo.skillInfo.skillInfoVec.concat();
               _loc3_.push(new SkillInfo(11619));
               leiyiInfo.skillInfo.updateSkillInfoVec(_loc3_);
            }
            AlertManager.showAlert("已经习得雷鸣炎破斩");
         });
      }
      
      private function onKaisa(param1:MouseEvent) : void
      {
         DialogPanel.showForNpc(this._kaisaDefinition);
      }
      
      private function onLeiyi(param1:MouseEvent) : void
      {
         DialogPanel.showForNpc(this._leiyiDefinition);
      }
      
      public function dispose() : void
      {
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.onGetCount);
         Connection.removeCommandListener(CommandSet.SELECT_FIGHT_MONS_1192,this.on1192);
         DialogPanel.removeEventListener("customUnitClick",this.onCustomUnitClick);
         DialogPanel.removeEventListener("dialogShow",this.onDialogShow);
         this._kaisaNpc.dispose();
         this._kaisaNpc = null;
         this._leiyiNpc.dispose();
         this._leiyiNpc = null;
      }
   }
}

