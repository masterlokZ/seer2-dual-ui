package com.taomee.seer2.app.config
{
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.quest.data.QuestDefinition;
   import com.taomee.seer2.core.quest.data.QuestPrerequisiteDefinition;
   import com.taomee.seer2.core.quest.data.QuestProductDefinition;
   import com.taomee.seer2.core.quest.data.QuestStepDefinition;
   import com.taomee.seer2.core.quest.data.TargetDefinition;
   import com.taomee.seer2.core.quest.data.dialog.BranchDefinition;
   import org.taomee.ds.HashMap;
   
   public class QuestConfig
   {
      
      private static var _xml:XML;
      
      private static var _xmlClass:Class = QuestConfig__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      initlize();
      
      public function QuestConfig()
      {
         super();
      }
      
      public static function initlize() : void
      {
         var _loc1_:XML = null;
         _xml = XML(new _xmlClass());
         var _loc2_:XMLList = _xml.descendants("quest");
         for each(_loc1_ in _loc2_)
         {
            parseQuest(_loc1_);
         }
      }
      
      private static function parseQuest(param1:XML) : void
      {
         var _loc20_:XMLList = null;
         var _loc8_:QuestDefinition = null;
         var _loc18_:XML = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc2_:XML = null;
         var _loc10_:uint = uint(param1.@id);
         var _loc9_:String = addStringPropertyToResult(param1.@name);
         var _loc5_:uint = addUintPropertyToResult(param1.@type);
         var _loc4_:uint = addUintPropertyToResult(param1.@autoNext);
         var _loc7_:uint = addUintPropertyToResult(param1.@track);
         var _loc6_:uint = addUintPropertyToResult(param1.@needAcceptMark);
         var _loc3_:uint = addUintPropertyToResult(param1.@acceptMapId);
         var _loc15_:uint = addUintPropertyToResult(param1.@acceptNpcId);
         var _loc16_:String = addStringPropertyToResult(param1.@onlineTime);
         var _loc13_:String = addStringPropertyToResult(param1.@monLvlUp);
         var _loc14_:uint = addUintPropertyToResult(param1.@isShow);
         var _loc19_:Vector.<int> = addMapIdsToResult(param1.@relatedMapIds);
         _loc8_ = new QuestDefinition(_loc10_,_loc9_,_loc5_,_loc4_,_loc7_,_loc6_,_loc3_,_loc15_,_loc16_,_loc13_,_loc14_,_loc19_);
         _loc20_ = param1.elements("prerequisite");
         if(_loc20_.length() > 0)
         {
            _loc18_ = _loc20_[0];
            _loc11_ = _loc18_.@questId;
            _loc12_ = _loc11_.split(",",_loc11_.length);
            _loc8_.prerequisiteDefinition = new QuestPrerequisiteDefinition(_loc12_,_loc18_.@level);
         }
         if(param1.elements("acceptDialog").length() > 0)
         {
            _loc2_ = param1.elements("acceptDialog")[0];
            _loc8_.acceptDialog = parseDialogXML(_loc2_);
         }
         var _loc17_:XML = param1.elements("steps")[0];
         parseStepList(_loc17_,_loc8_);
         if(param1.elements("doc").length() > 0)
         {
            _loc8_.des = param1.elements("doc").toString();
         }
         _map.add(_loc8_.id,_loc8_);
      }
      
      private static function parseStepList(param1:XML, param2:QuestDefinition) : void
      {
         var _loc3_:XML = null;
         param2.stepDefinitionVec = new Vector.<QuestStepDefinition>();
         var _loc4_:XMLList = param1.elements("step");
         for each(_loc3_ in _loc4_)
         {
            param2.stepDefinitionVec.push(parseStep(_loc3_));
         }
      }
      
      private static function parseStep(param1:XML) : QuestStepDefinition
      {
         var _loc2_:QuestStepDefinition = new QuestStepDefinition(int(param1.@id),int(param1.@relatedNpcId),param1.@name,param1.@sum,param1.@des,param1.@point,param1.@transport);
         if(param1.elements("target").length() > 0)
         {
            _loc2_.targetDefinition = parseTargetXML(param1.elements("target")[0]);
         }
         if(param1.elements("dialog").length() > 0)
         {
            _loc2_.dialogDefinition = parseDialogXML(param1.elements("dialog")[0]);
         }
         if(param1.elements("income").length() > 0)
         {
            _loc2_.income = parseProduct(param1.elements("income")[0]);
         }
         if(param1.elements("outcome").length() > 0)
         {
            _loc2_.outcome = parseProduct(param1.elements("outcome")[0]);
         }
         return _loc2_;
      }
      
      private static function parseTargetXML(param1:XML) : TargetDefinition
      {
         var _loc2_:TargetDefinition = new TargetDefinition();
         _loc2_.type = param1.@type;
         _loc2_.count = param1.@count;
         _loc2_.params = param1.@params;
         _loc2_.alert = param1.@alert;
         _loc2_.transport = param1.@transport;
         return _loc2_;
      }
      
      private static function parseProduct(param1:XML) : QuestProductDefinition
      {
         var _loc2_:XML = null;
         var _loc4_:QuestProductDefinition = null;
         var _loc5_:Array = [];
         var _loc7_:Array = [];
         var _loc6_:Array = [];
         var _loc3_:XMLList = param1.elements("item");
         for each(_loc2_ in _loc3_)
         {
            _loc5_.push(_loc2_.@giveId);
            _loc7_.push(_loc2_.@cnt);
            if(String(_loc2_.@isPet) == "true")
            {
               _loc6_.push(true);
            }
            else
            {
               _loc6_.push(false);
            }
         }
         _loc5_ = _loc5_.slice(0,_loc5_.length);
         _loc7_ = _loc7_.slice(0,_loc7_.length);
         _loc6_ = _loc6_.slice(0,_loc6_.length);
         return new QuestProductDefinition(_loc5_,_loc7_,_loc6_);
      }
      
      private static function parseDialogXML(param1:XML) : DialogDefinition
      {
         var _loc9_:DialogDefinition = null;
         var _loc11_:BranchDefinition = null;
         var _loc4_:XML = null;
         var _loc3_:int = 0;
         var _loc7_:String = null;
         var _loc5_:XMLList = null;
         var _loc2_:XML = null;
         var _loc6_:XMLList = null;
         var _loc8_:XML = null;
         _loc9_ = new DialogDefinition();
         _loc9_.npcId = param1.@npcId;
         _loc9_.npcName = param1.@npcName;
         _loc9_.transport = param1.@transport;
         _loc9_.branchVec = new Vector.<BranchDefinition>();
         var _loc10_:XMLList = param1.elements("branch");
         for each(_loc4_ in _loc10_)
         {
            _loc11_ = new BranchDefinition();
            _loc11_.id = _loc4_.@id;
            _loc3_ = int(_loc4_.@npcId.toString());
            if(_loc3_ == 0)
            {
               _loc3_ = int(param1.@npcId);
               _loc7_ = param1.@npcName;
            }
            else
            {
               _loc3_ = int(_loc4_.@npcId);
               _loc7_ = _loc4_.@npcName;
            }
            _loc11_.npcId = _loc3_;
            _loc11_.npcName = _loc7_;
            _loc11_.contentVec = new Vector.<String>();
            _loc11_.emotionVec = new Vector.<String>();
            _loc5_ = _loc4_.elements("node");
            for each(_loc2_ in _loc5_)
            {
               _loc11_.emotionVec.push(_loc2_.@emotion);
               _loc11_.contentVec.push(_loc2_.toString());
            }
            _loc6_ = _loc4_.elements("reply");
            _loc11_.replyLabelVec = new Vector.<String>();
            _loc11_.replyActionVec = new Vector.<String>();
            _loc11_.replyParamVec = new Vector.<String>();
            for each(_loc8_ in _loc6_)
            {
               _loc11_.replyLabelVec.push(_loc8_.toString());
               _loc11_.replyActionVec.push(_loc8_.@action);
               _loc11_.replyParamVec.push(_loc8_.@params);
            }
            _loc9_.branchVec.push(_loc11_);
         }
         return _loc9_;
      }
      
      private static function addMapIdsToResult(param1:String) : Vector.<int>
      {
         if(param1 == "")
         {
            return new Vector.<int>();
         }
         return Vector.<int>(param1.split(","));
      }
      
      private static function addStringPropertyToResult(param1:String) : String
      {
         if(param1 == "")
         {
            return "0";
         }
         return param1;
      }
      
      private static function addUintPropertyToResult(param1:String) : uint
      {
         if(param1 == "")
         {
            return 0;
         }
         return uint(param1);
      }
      
      public static function getQuestDefinition(param1:int) : QuestDefinition
      {
         if(_map.containsKey(param1))
         {
            return _map.getValue(param1) as QuestDefinition;
         }
         return null;
      }
      
      public static function getAllDefinition() : Vector.<QuestDefinition>
      {
         return Vector.<QuestDefinition>(_map.getValues());
      }
   }
}

