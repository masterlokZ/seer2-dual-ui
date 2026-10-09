package com.taomee.seer2.app.arena.processor
{
   import com.taomee.seer2.app.arena.data.FighterBuffInfo;
   import flash.utils.IDataInput;
   
   public class Parser_8
   {
      
      public var userId:uint;
      
      public var fighterId:uint;
      
      public var angerValue:uint;
      
      public function Parser_8(param1:IDataInput)
      {
         super();
         this.userId = param1.readUnsignedInt();
         this.fighterId = param1.readUnsignedInt();
         this.angerValue = param1.readUnsignedInt();
      }
      
      public function parserFighterBuffInfo(param1:IDataInput) : Vector.<FighterBuffInfo>
      {
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc4_:Vector.<FighterBuffInfo> = new Vector.<FighterBuffInfo>();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_.push(new FighterBuffInfo(param1));
            _loc3_++;
         }
         return _loc4_;
      }
   }
}

