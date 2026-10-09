package com.taomee.seer2.app.processor.quest.handler.branch.quest10177
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.npc.NpcEvent;
   import com.taomee.seer2.app.npc.NpcManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.quest.QuestProcessor;
   import com.taomee.seer2.app.processor.quest.handler.QuestMapHandler;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.quest.mark.AcceptableMark;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.utils.setTimeout;
   
   public class BasicQuest10177 extends QuestMapHandler
   {
      
      private var itemsID:Array = [603032,603033,603034];
      
      private var npcName:String;
      
      protected var needItemId:int;
      
      protected var npcId:int;
      
      protected var fightIndex:uint;
      
      public function BasicQuest10177(param1:QuestProcessor)
      {
         super(param1);
      }
      
      override public function processMapComplete() : void
      {
         super.processMapComplete();
         if(isNeedCompleteStep(4))
         {
            if(FightManager.currentFightRecord.initData.positionIndex == this.fightIndex)
            {
               setTimeout(this.getItem,500);
            }
            else
            {
               ItemManager.addEventListener1("requestSpecialItemSuccess",this.getItem);
               ItemManager.requestSpecialItemList();
            }
         }
      }
      
      private function getItem(param1:ItemEvent = null) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:int = 0;
         var _loc3_:Mobile = null;
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.getItem);
         if(Boolean(ItemManager.getSpecialItem(this.needItemId)) && ItemManager.getSpecialItem(this.needItemId).quantity >= 7)
         {
            _loc2_ = true;
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               if(ItemManager.getSpecialItem(this.itemsID[_loc4_]))
               {
                  if(ItemManager.getSpecialItem(this.itemsID[_loc4_]).quantity < 7)
                  {
                     _loc2_ = false;
                  }
               }
               else
               {
                  _loc2_ = false;
               }
               _loc4_++;
            }
            if(_loc2_)
            {
               QuestManager.addEventListener("stepComplete",this.onStep);
               QuestManager.completeStep(10177,4);
            }
         }
         else
         {
            _loc3_ = MobileManager.getMobile(this.npcId,"npc");
            _loc3_.removeOverHeadMark();
            _loc3_.addOverHeadMark(new AcceptableMark());
            NpcManager.addEventListener("actorArrive",this.onActorArriveShow);
         }
      }
      
      private function onActorArriveShow(param1:NpcEvent) : void
      {
         var _loc2_:XML = null;
         if(param1.npcDefinition.id == this.npcId)
         {
            this.npcName = param1.npcDefinition.name;
            param1.npcDefinition.resetFunctionalityData();
            NpcManager.removeEventListener("actorArrive",this.onActorArriveShow);
            _loc2_ = new XML("<node type=\"quest\" name=\"幻灵兽第三章\" params=\"" + this.npcId + "\"/>");
            param1.npcDefinition.addFunctionalityUnitAt(_loc2_,1);
            DialogPanel.addEventListener("customUnitClick",this.onUnit);
         }
      }
      
      private function onUnit(param1:DialogPanelEvent) : void
      {
         var event:DialogPanelEvent = param1;
         if(event.content.params == this.npcId.toString())
         {
            NpcDialog.show(this.npcId,this.npcName,[[0,"你可以击败我的精灵来收集精灵多余的时间哟。准备好了吗？"]],[" 开始战斗吧。"," 我准备一下"],[function():void
            {
               FightManager.startFightWithWild(fightIndex);
            }]);
         }
      }
      
      private function onStep(param1:QuestEvent) : void
      {
         var event:QuestEvent = param1;
         if(event.questId == questID)
         {
            QuestManager.removeEventListener("stepComplete",this.onStep);
            AlertManager.showAlert("你已经收集到了足够的“时间”，可以去找吉吉导游了。",function():void
            {
               SceneManager.changeScene(1,470);
            });
         }
      }
   }
}

