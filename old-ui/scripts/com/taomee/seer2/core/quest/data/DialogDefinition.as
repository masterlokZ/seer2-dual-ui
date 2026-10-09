package com.taomee.seer2.core.quest.data
{
   import com.taomee.seer2.core.quest.data.dialog.BranchDefinition;
   import flash.utils.getDefinitionByName;
   
   public class DialogDefinition
   {
      
      public var npcId:int;
      
      public var npcName:String;
      
      public var transport:String;
      
      public var branchVec:Vector.<BranchDefinition>;
      
      public function DialogDefinition(param1:XML = null)
      {
         super();
         if(param1 != null)
         {
            this.parseData(param1);
         }
      }
      
      public static function generateDefinition(param1:int, param2:String, param3:Array, param4:String) : DialogDefinition
      {
         var _loc6_:String = "<dialog npcId=\"" + param1 + "\" npcName=\"" + param2 + "\"><branch id=\"default\">";
         var _loc5_:int = 0;
         while(_loc5_ < param3.length)
         {
            _loc6_ += "<node emotion=\"" + param3[_loc5_][0] + "\"><![CDATA[" + param3[_loc5_][1] + "]]></node>";
            _loc5_++;
         }
         _loc6_ += "<reply action=\"close\"><![CDATA[" + param4 + "]]></reply>";
         _loc6_ = _loc6_ + "</branch></dialog>";
         return new DialogDefinition(XML(_loc6_));
      }
      
      public static function generatQuestDefinition(param1:int, param2:int, param3:String, param4:Vector.<String>, param5:String) : DialogDefinition
      {
         var _loc6_:* = undefined;
         _loc6_ = "<dialog npcId=\"" + param1 + "\" npcName=\"" + "asdf" + "\"><branch id=\"default\">";
         _loc6_ = _loc6_ + ("<node emotion=\"" + param2 + "\"><![CDATA[" + param3 + "]]></node>");
         var _loc8_:int = int(param4.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ += "<reply action=\"" + param5 + "_" + _loc7_ + "\"><![CDATA[" + param4[_loc7_] + "]]></reply>";
            _loc7_++;
         }
         _loc6_ += "</branch></dialog>";
         return new DialogDefinition(XML(_loc6_));
      }
      
      private function parseData(param1:XML) : void
      {
         var _loc8_:XML = null;
         var _loc4_:BranchDefinition = null;
         var _loc3_:Vector.<String> = null;
         var _loc6_:Vector.<String> = null;
         var _loc5_:XMLList = null;
         var _loc2_:XML = null;
         var _loc12_:Vector.<String> = null;
         var _loc13_:Vector.<String> = null;
         var _loc10_:Vector.<String> = null;
         var _loc11_:XMLList = null;
         var _loc15_:XML = null;
         var _loc16_:* = undefined;
         var _loc14_:int = 0;
         this.npcId = int(param1.attribute("npcId").toString());
         this.npcName = param1.attribute("npcName").toString();
         this.transport = param1.attribute("transport").toString();
         this.branchVec = new Vector.<BranchDefinition>();
         var _loc7_:XMLList = param1.elements("branch");
         var _loc9_:int = _loc7_.length();
         for each(_loc8_ in _loc7_)
         {
            _loc4_ = new BranchDefinition();
            _loc4_.id = _loc8_.attribute("id").toString();
            if(int(_loc8_.attribute("npcId").toString()) == 9999)
            {
               _loc16_ = getDefinitionByName("com.taomee.seer2.app.actor.ActorManager");
               if(_loc16_.getActor().getInfo().sex == 0)
               {
                  _loc4_.npcId = 502;
               }
               else
               {
                  _loc4_.npcId = 501;
               }
               _loc4_.npcName = "我";
            }
            else
            {
               _loc14_ = int(_loc8_.attribute("npcId").toString());
               if(_loc14_ == 0)
               {
                  _loc4_.npcId = this.npcId;
                  _loc4_.npcName = this.npcName;
               }
               else
               {
                  _loc4_.npcId = int(_loc8_.attribute("npcId").toString());
                  _loc4_.npcName = _loc8_.attribute("npcName").toString();
               }
            }
            _loc3_ = new Vector.<String>();
            _loc6_ = new Vector.<String>();
            _loc5_ = _loc8_.elements("node");
            for each(_loc2_ in _loc5_)
            {
               _loc3_.push(_loc2_.toString());
               _loc6_.push(_loc2_.attribute("emotion").toString());
            }
            _loc4_.contentVec = _loc3_;
            _loc4_.emotionVec = _loc6_;
            _loc12_ = new Vector.<String>();
            _loc13_ = new Vector.<String>();
            _loc10_ = new Vector.<String>();
            _loc11_ = _loc8_.elements("reply");
            for each(_loc15_ in _loc11_)
            {
               _loc12_.push(_loc15_.toString());
               _loc13_.push(_loc15_.attribute("action").toString());
               _loc10_.push(_loc15_.attribute("params").toString());
            }
            _loc4_.replyLabelVec = _loc12_;
            _loc4_.replyActionVec = _loc13_;
            _loc4_.replyParamVec = _loc10_;
            this.branchVec.push(_loc4_);
         }
      }
      
      public function updateNpcName(param1:String) : void
      {
         var _loc2_:BranchDefinition = null;
         this.npcName = param1;
         for each(_loc2_ in this.branchVec)
         {
            if(_loc2_.npcName == "")
            {
               _loc2_.npcName = param1;
            }
         }
      }
   }
}

