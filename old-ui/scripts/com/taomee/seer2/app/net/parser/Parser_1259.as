package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import flash.utils.IDataInput;
   
   public class Parser_1259
   {
      
      public function Parser_1259(param1:IDataInput)
      {
         var _loc3_:uint = 0;
         super();
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1.readUnsignedInt();
            PetInfoManager.deletePet(_loc3_);
            _loc4_++;
         }
      }
   }
}

