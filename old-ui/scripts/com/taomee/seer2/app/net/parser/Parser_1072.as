package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.net.parser.baseData.VoteInfo;
   import flash.utils.IDataInput;
   
   public class Parser_1072
   {
      
      public var vote_id:uint;
      
      public var result_list:Vector.<VoteInfo>;
      
      public function Parser_1072(param1:IDataInput)
      {
         var _loc3_:VoteInfo = null;
         super();
         this.result_list = new Vector.<VoteInfo>();
         this.vote_id = param1.readUnsignedInt();
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new VoteInfo();
            _loc3_.subject_id = param1.readUnsignedInt();
            _loc3_.option_id = param1.readUnsignedInt();
            _loc3_.selected_count = param1.readUnsignedInt();
            this.result_list.push(_loc3_);
            _loc4_++;
         }
      }
   }
}

