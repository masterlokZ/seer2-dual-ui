package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.starMagic.StarInfo;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class Parser_1263
   {
      
      public var starInfo:Vector.<StarInfo>;
      
      public function Parser_1263(param1:IDataInput)
      {
         var _loc2_:int = 0;
         var _loc4_:StarInfo = null;
         var _loc3_:int = 0;
         this.starInfo = new Vector.<StarInfo>();
         super();
         (param1 as ByteArray).position = 0;
         _loc2_ = int(param1.readUnsignedInt());
         if(_loc2_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new StarInfo();
               _loc4_.user_id = param1.readUnsignedInt();
               _loc4_.id = param1.readUnsignedInt();
               _loc4_.buffId = param1.readUnsignedInt();
               _loc4_.time = param1.readUnsignedInt();
               _loc4_.level = param1.readUnsignedInt();
               _loc4_.exp = param1.readUnsignedInt();
               _loc4_.nextExp = param1.readUnsignedInt();
               _loc4_.maxLevel = param1.readUnsignedInt();
               _loc4_.level_cof = param1.readUnsignedInt();
               _loc4_.pos = param1.readUnsignedInt();
               _loc4_.petCatchTime = param1.readUnsignedInt();
               _loc4_.sell_exp = param1.readUnsignedInt();
               _loc4_.type = param1.readUnsignedInt();
               _loc4_.buffSwf = param1.readUnsignedInt();
               this.starInfo.push(_loc4_);
               _loc3_++;
            }
         }
      }
   }
}

