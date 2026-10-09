package com.taomee.seer2.app.quest
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.QuestConfig;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.utils.ItemCategoryUtil;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.ErrorMap;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.handler.main.quest112.QuestMapHandler_112_80575;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.QuestStep;
   import com.taomee.seer2.core.quest.data.QuestDefinition;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import flash.events.EventDispatcher;
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   
   public class QuestManager
   {
      
      private static var _questMap:HashMap;
      
      private static var _dependenceMap:DependenceMap;
      
      private static var _isInit:Boolean = false;
      
      private static var _inProgressQuestIdVec:Vector.<int>;
      
      private static var _questBufferUpdateType:String;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public function QuestManager()
      {
         super();
      }
      
      public static function setup(param1:Vector.<int>, param2:Vector.<int>, param3:Vector.<int>) : void
      {
         QuestNpcManager.setup();
         QuestProcessManager.setup();
         parseConfig();
         parseData(param1,param2,param3);
      }
      
      private static function parseConfig() : void
      {
         var _loc2_:QuestDefinition = null;
         var _loc1_:Quest = null;
         _questMap = new HashMap();
         for each(_loc2_ in QuestConfig.getAllDefinition())
         {
            _loc1_ = new Quest(_loc2_);
            _questMap.add(_loc1_.id,_loc1_);
            dependenceMap.addPreviousDepend(_loc2_.id,_loc2_.prerequisiteDefinition.preQuestIdVec);
         }
      }
      
      private static function parseData(param1:Vector.<int>, param2:Vector.<int>, param3:Vector.<int>) : void
      {
         var _loc7_:Quest = null;
         var _loc5_:int = 0;
         var _loc4_:int = int(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1[_loc6_];
            getQuest(_loc5_).status = 3;
            _loc6_++;
         }
         _loc4_ = int(param3.length);
         _inProgressQuestIdVec = param3;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param3[_loc6_];
            if(!isQuestNew(_loc5_))
            {
               getQuest(_loc5_).status = 1;
            }
            _loc6_++;
         }
         _loc4_ = int(param2.length);
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param2[_loc6_];
            if(!isQuestNew(_loc5_))
            {
               getQuest(_loc5_).isLastComplete = true;
            }
            _loc6_++;
         }
         getQuestBufferServer(param3);
      }
      
      private static function init() : void
      {
         registerTarget();
         openNextQuests();
         _isInit = true;
         dispatchEvent("init");
      }
      
      private static function registerTarget() : void
      {
         var _loc2_:Quest = null;
         var _loc4_:int = 0;
         var _loc1_:QuestStep = null;
         var _loc3_:uint = _inProgressQuestIdVec.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _inProgressQuestIdVec[_loc5_];
            if(!isQuestNew(_loc4_))
            {
               _loc2_ = getQuest(_loc4_);
               _loc1_ = _loc2_.getCurrentOrNextStep();
               if(_loc2_.getCurrentOrNextStep().target != null)
               {
                  QuestTargetManager.initTarget(_loc2_);
               }
            }
            _loc5_++;
         }
      }
      
      public static function get isInit() : Boolean
      {
         return _isInit;
      }
      
      public static function openNextQuests() : void
      {
         var _loc2_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc4_:int = 0;
         var _loc1_:Quest = null;
         var _loc3_:Vector.<int> = getQuestIdList(3);
         _loc3_.unshift(0);
         for each(_loc2_ in _loc3_)
         {
            _loc5_ = _dependenceMap.completeDependent(_loc2_);
            for each(_loc4_ in _loc5_)
            {
               _loc1_ = getQuest(_loc4_);
               if(_loc1_.status == -1 && _loc1_.verifyPrerequisite())
               {
                  _loc1_.status = 0;
               }
            }
         }
      }
      
      public static function isCanAccepted(param1:int) : Boolean
      {
         var _loc2_:Quest = getQuest(param1);
         if(_loc2_)
         {
            return _loc2_.status == 0;
         }
         return false;
      }
      
      public static function isAccepted(param1:int) : Boolean
      {
         var _loc2_:Quest = getQuest(param1);
         if(_loc2_)
         {
            return _loc2_.status == 1;
         }
         return false;
      }
      
      public static function isCompletable(param1:int) : Boolean
      {
         var _loc2_:Quest = getQuest(param1);
         return _loc2_.isStepCompletable(_loc2_.getStepVec().length);
      }
      
      public static function isComplete(param1:int) : Boolean
      {
         var _loc2_:Quest = getQuest(param1);
         if(_loc2_)
         {
            return _loc2_.status == 3;
         }
         return false;
      }
      
      public static function isCompleteList(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(getQuest(param1[_loc3_]).status == 3)
            {
               _loc2_.push(true);
            }
            else
            {
               _loc2_.push(false);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function isFreshQuestComplete() : Boolean
      {
         return QuestManager.isComplete(1);
      }
      
      public static function isCompleteGudieTask() : Boolean
      {
         var _loc1_:Boolean = true;
         if(QuestManager.isComplete(68))
         {
            _loc1_ = true;
         }
         else if(QuestManager.isAccepted(31) || Boolean(QuestManager.isComplete(31)))
         {
            _loc1_ = true;
         }
         else if(QuestManager.isCanAccepted(53) || Boolean(QuestManager.isAccepted(53)))
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public static function isStepComplete(param1:int, param2:int) : Boolean
      {
         var _loc3_:Quest = null;
         if(isComplete(param1))
         {
            return true;
         }
         _loc3_ = getQuest(param1);
         if(Boolean(_loc3_) && _loc3_.status == 1)
         {
            return _loc3_.isStepCompete(param2);
         }
         return false;
      }
      
      public static function getQuestListByType(param1:int) : Vector.<Quest>
      {
         var _loc3_:Quest = null;
         var _loc2_:Vector.<Quest> = new Vector.<Quest>();
         var _loc4_:Array = _questMap.getValues();
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.type == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getQuestListByStatus(param1:int) : Vector.<Quest>
      {
         var _loc3_:Quest = null;
         var _loc2_:Vector.<Quest> = new Vector.<Quest>();
         var _loc4_:Array = _questMap.getValues();
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.status == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getQuestList() : Vector.<Quest>
      {
         return Vector.<Quest>(_questMap.getValues());
      }
      
      public static function getQuestIdList(param1:int) : Vector.<int>
      {
         var _loc3_:Quest = null;
         var _loc2_:Vector.<Quest> = getQuestListByStatus(param1);
         var _loc4_:Vector.<int> = new Vector.<int>();
         for each(_loc3_ in _loc2_)
         {
            _loc4_.push(_loc3_.id);
         }
         return _loc4_;
      }
      
      public static function getQuest(param1:int) : Quest
      {
         return _questMap.getValue(param1) as Quest;
      }
      
      public static function acceptQuestLocal(param1:int) : void
      {
         var _loc2_:Quest = getQuest(param1);
         _loc2_.status = 1;
         _loc2_.setBuffer(null);
         if(_loc2_.getCurrentOrNextStep().target != null)
         {
            QuestTargetManager.initTarget(_loc2_);
         }
         dispatchEvent("accept",param1);
      }
      
      private static function getQuestBufferServer(param1:Vector.<int>) : void
      {
         var _loc4_:LittleEndianByteArray = null;
         var _loc3_:int = 0;
         var _loc2_:int = int(param1.length);
         if(_loc2_ > 0)
         {
            _loc4_ = new LittleEndianByteArray();
            _loc4_.writeUnsignedInt(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_.writeUnsignedInt(param1[_loc3_]);
               _loc3_++;
            }
            Connection.addCommandListener(CommandSet.QUEST_GET_BUFFER_1014,onGetQuestBuffer);
            Connection.send(CommandSet.QUEST_GET_BUFFER_1014,_loc4_);
         }
         else
         {
            init();
         }
      }
      
      private static function onGetQuestBuffer(param1:MessageEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:LittleEndianByteArray = null;
         Connection.removeCommandListener(CommandSet.QUEST_GET_BUFFER_1014,onGetQuestBuffer);
         var _loc4_:IDataInput = param1.message.getRawData();
         var _loc6_:int = int(_loc4_.readUnsignedInt());
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = int(_loc4_.readUnsignedInt());
            _loc2_ = new LittleEndianByteArray();
            _loc4_.readBytes(_loc2_,0,64);
            getQuest(_loc3_).setBuffer(_loc2_);
            _loc5_++;
         }
         init();
      }
      
      public static function accept(param1:int) : void
      {
         if(!isQuestNew(param1) && getQuest(param1).status != 0)
         {
            return;
         }
         Connection.addCommandListener(CommandSet.QUEST_ACCEPT_1011,onAcceptQuest);
         Connection.send(CommandSet.QUEST_ACCEPT_1011,param1);
      }
      
      private static function onAcceptQuest(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.QUEST_ACCEPT_1011,onAcceptQuest);
         var _loc2_:int = int(param1.message.getRawData().readUnsignedInt());
         acceptQuestLocal(_loc2_);
      }
      
      public static function abortQuest(param1:int) : void
      {
         if(!isQuestNew(param1) && getQuest(param1).status != 1)
         {
            return;
         }
         Connection.addCommandListener(CommandSet.QUEST_ABORT_1013,onAbortQuest);
         Connection.send(CommandSet.QUEST_ABORT_1013,param1);
      }
      
      private static function onAbortQuest(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.QUEST_ABORT_1013,onAbortQuest);
         var _loc2_:int = int(param1.message.getRawData().readUnsignedInt());
         getQuest(_loc2_).status = 0;
         dispatchEvent("abort",_loc2_);
      }
      
      public static function completeStep(param1:int, param2:int) : void
      {
         var quest:Quest = null;
         var questId:int = param1;
         var stepId:int = param2;
         quest = getQuest(questId);
         if(quest.status == 1)
         {
            ItemManager.requestItemList(function():void
            {
               var id:int = 0;
               var data:LittleEndianByteArray = null;
               if(questId == 112 && quest.isStepCompletable(stepId))
               {
                  id = QuestMapHandler_112_80575._allRight ? 4611 : 4612;
                  SwapManager.swapItem(id,1,(function():*
                  {
                     var success:Function;
                     return success = function(param1:IDataInput):void
                     {
                        new SwapInfo(param1);
                     };
                  })());
               }
               if(stepId == quest.getStepCount())
               {
                  if(isQuestStepOutComeMax(questId,stepId))
                  {
                     return;
                  }
               }
               if(questId == 1 || questId == 2 || quest.isStepCompletable(stepId))
               {
                  data = new LittleEndianByteArray();
                  data.writeUnsignedInt(questId);
                  data.writeByte(stepId);
                  data.writeBytes(quest.generateStepBuffer(stepId,true));
                  updateQuestBuffer(data,"completeOld");
               }
            });
         }
      }
      
      private static function isQuestStepOutComeMax(param1:uint, param2:uint) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc4_:uint = 0;
         var _loc7_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc9_:Quest = getQuest(param1);
         if(_loc9_.getStep(param2).outcome == null || _loc9_.getStep(param2).outcome.getReferenceIdVec() == null)
         {
            return false;
         }
         var _loc8_:uint = _loc9_.getStep(param2).outcome.getReferenceIdVec().length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc8_)
         {
            _loc5_ = uint(_loc9_.getStep(param2).outcome.getReferenceIdVec()[_loc3_]);
            _loc7_ = _loc9_.getStep(param2).outcome.getIsPetVec()[_loc3_];
            _loc4_ = uint(_loc9_.getStep(param2).outcome.getQuantityVec()[_loc3_]);
            if(!(_loc5_ == 1 || _loc7_))
            {
               _loc6_ = uint(ItemConfig.getItemDefinition(_loc5_).quantityLimit);
               if(ItemManager.getItemQuantityByReferenceId(_loc5_) + _loc4_ > _loc6_)
               {
                  AlertManager.showItemMaxAlert(_loc5_);
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function setStepBufferServer(param1:int, param2:int) : void
      {
         var _loc3_:LittleEndianByteArray = null;
         var _loc4_:Quest = getQuest(param1);
         if(_loc4_.status == 1)
         {
            if(_loc4_.isStepCompletable(param2))
            {
               _loc3_ = new LittleEndianByteArray();
               _loc3_.writeUnsignedInt(param1);
               _loc3_.writeByte(param2);
               _loc3_.writeBytes(_loc4_.generateStepBuffer(param2,false));
               updateQuestBuffer(_loc3_,"updateOld");
            }
         }
      }
      
      public static function updateQuestBuffer(param1:LittleEndianByteArray, param2:String) : void
      {
         _questBufferUpdateType = param2;
         Connection.addCommandListener(CommandSet.QUEST_SUBMIT_STEP_BUFFER_1015,onUpdateQuestBufferSuc);
         Connection.addErrorHandler(CommandSet.QUEST_SUBMIT_STEP_BUFFER_1015,onUpdateQuestBufferErr);
         Connection.send(CommandSet.QUEST_SUBMIT_STEP_BUFFER_1015,param1);
      }
      
      public static function listenerQuestBufferUpdate() : void
      {
         _questBufferUpdateType = "completeOld";
         Connection.addCommandListener(CommandSet.QUEST_SUBMIT_STEP_BUFFER_1015,onUpdateQuestBufferSuc);
         Connection.addErrorHandler(CommandSet.QUEST_SUBMIT_STEP_BUFFER_1015,onUpdateQuestBufferErr);
      }
      
      public static function onUpdateQuestBufferSuc(param1:MessageEvent) : void
      {
         clearHandler1015();
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc4_:int = int(_loc2_.readUnsignedInt());
         var _loc3_:int = _loc2_.readByte();
         parseOutput(_loc2_,_loc4_);
         switch(_questBufferUpdateType)
         {
            case "completeOld":
               processCompleteOld(_loc4_,_loc3_);
               break;
            case "updateOld":
               processUpdateOld(_loc4_,_loc3_);
               break;
            case "updateNew":
               processUpdateNew(_loc4_,_loc3_);
         }
      }
      
      private static function processCompleteOld(param1:int, param2:int) : void
      {
         var _loc3_:Quest = null;
         var _loc5_:Quest = getQuest(param1);
         if(!_loc5_.clientBuffer)
         {
            _loc5_.setBuffer(null);
         }
         if(_loc5_.getCurrentOrNextStep().target != null)
         {
            QuestTargetManager.disposeTarget(_loc5_);
         }
         var _loc4_:int = 1;
         while(_loc4_ < param2 + 1)
         {
            _loc5_.updateStepStatus(_loc4_,true);
            _loc4_++;
         }
         if(param2 == _loc5_.getStepVec().length)
         {
            _loc5_.status = 3;
            _loc5_.isLastComplete = true;
            openNextQuests();
            if(_loc5_.autoNext && getQuest(param1 + 1) != null)
            {
               _loc3_ = getQuest(param1 + 1);
               _loc3_.status = 1;
               _loc3_.setBuffer(null);
            }
            dispatchEvent("complete",param1);
         }
         else
         {
            _loc5_.status = 1;
            dispatchEvent("stepComplete",param1,param2);
         }
      }
      
      private static function processUpdateOld(param1:int, param2:int) : void
      {
         QuestManager.dispatchEvent("stepUpdateBuffer",param1,param2);
      }
      
      private static function processUpdateNew(param1:int, param2:int) : void
      {
         QuestManager.dispatchEvent("stepUpdateBuffer",param1,param2);
      }
      
      private static function parseOutput(param1:IDataInput, param2:int = 0) : void
      {
         var _loc10_:uint = 0;
         var _loc9_:int = 0;
         var _loc5_:uint = 0;
         var _loc4_:int = int(param1.readUnsignedInt());
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_)
         {
            _loc10_ = param1.readUnsignedInt();
            _loc9_ = param1.readShort();
            _loc5_ = param1.readUnsignedInt();
            if(_loc10_ == 1)
            {
               ActorManager.actorInfo.coins += _loc9_;
               if(param2 != 1)
               {
                  AlertManager.showCoinsGainedAlert(_loc9_);
               }
            }
            else if(_loc10_ != 14)
            {
               if(ItemConfig.getItemDefinition(_loc10_) == null || ItemConfig.getItemDefinition(_loc10_).isHide)
               {
                  return;
               }
               ItemManager.addItem(_loc10_,_loc9_,_loc5_);
               if(ItemCategoryUtil.isMedal(_loc10_))
               {
                  AlertManager.showMedalGainedAlert(_loc10_);
                  if(ItemConfig.getMedalDefinition(_loc10_).title != "")
                  {
                     ServerMessager.addMessage("恭喜你获得了[" + ItemConfig.getMedalDefinition(_loc10_).title + "称号]");
                  }
               }
               else if(_loc10_ == 601545)
               {
                  ServerMessager.addMessage("恭喜你获得了20个竹叶");
               }
               else if(ItemCategoryUtil.findItemCategoryByReferenceId(_loc10_) != 101)
               {
                  if(_loc10_ != 27 && param2 != 1)
                  {
                     AlertManager.showItemGainedAlert(_loc10_,_loc9_);
                  }
               }
            }
            _loc8_++;
         }
         _loc4_ = int(param1.readUnsignedInt());
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc10_ = param1.readUnsignedInt();
            _loc9_ = param1.readShort();
            _loc5_ = param1.readUnsignedInt();
            ItemManager.reduceItemQuantity(_loc10_,Math.abs(_loc9_));
            _loc6_++;
         }
         var _loc3_:uint = param1.readUnsignedInt();
         var _loc7_:uint = param1.readUnsignedInt();
         if(_loc3_ != 0)
         {
            PetInfoManager.requestAddToBagFromStorage(_loc7_,_loc3_);
         }
      }
      
      private static function onUpdateQuestBufferErr(param1:MessageEvent) : void
      {
         ErrorMap.parseStatusCode(param1.message.statusCode);
         clearHandler1015();
      }
      
      private static function clearHandler1015() : void
      {
         Connection.removeCommandListener(CommandSet.QUEST_SUBMIT_STEP_BUFFER_1015,onUpdateQuestBufferSuc);
         Connection.removeErrorHandler(CommandSet.QUEST_SUBMIT_STEP_BUFFER_1015,onUpdateQuestBufferErr);
      }
      
      public static function get dependenceMap() : DependenceMap
      {
         if(_dependenceMap == null)
         {
            _dependenceMap = new DependenceMap();
         }
         return _dependenceMap;
      }
      
      public static function isQuestNew(param1:int) : Boolean
      {
         return false;
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public static function dispatchEvent(param1:String, param2:int = -1, param3:int = -1) : void
      {
         if(_dispatcher.hasEventListener(param1))
         {
            _dispatcher.dispatchEvent(new QuestEvent(param1,param2,param3));
         }
      }
      
      public static function hasEventListener(param1:String) : Boolean
      {
         return _dispatcher.hasEventListener(param1);
      }
   }
}

