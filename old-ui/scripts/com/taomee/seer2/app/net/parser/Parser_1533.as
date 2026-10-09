package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.net.parser.baseData.StarPetInfo;
   import flash.utils.IDataInput;
   
   public class Parser_1533
   {
      
      public var all_info:StarPetInfo;
      
      public var pet_list:Vector.<StarPetInfo>;
      
      public function Parser_1533(param1:IDataInput)
      {
         var _loc3_:StarPetInfo = null;
         super();
         this.all_info = new StarPetInfo();
         this.all_info.star_num = param1.readUnsignedInt();
         this.all_info.super_num = param1.readUnsignedInt();
         var _loc2_:uint = param1.readUnsignedInt();
         this.pet_list = new Vector.<StarPetInfo>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new StarPetInfo();
            _loc3_.monsterId = param1.readUnsignedInt();
            _loc3_.star_num = param1.readUnsignedInt();
            _loc3_.super_num = param1.readUnsignedInt();
            this.pet_list.push(_loc3_);
            _loc4_++;
         }
      }
   }
}

