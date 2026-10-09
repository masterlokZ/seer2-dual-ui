package com.taomee.seer2.app.net.parser
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import flash.utils.IDataInput;
   
   public class Parser_1507
   {
      
      public function Parser_1507(param1:IDataInput)
      {
         var _loc3_:PetInfo = null;
         var _loc2_:uint = 0;
         var _loc4_:PetInfo = null;
         super();
         var _loc6_:uint = param1.readUnsignedByte();
         var _loc8_:uint = param1.readUnsignedByte();
         var _loc7_:int = int(param1.readUnsignedInt());
         var _loc5_:int = 0;
         while(_loc5_ < _loc7_)
         {
            _loc2_ = param1.readUnsignedInt();
            for each(_loc4_ in PetInfoManager.getAllBagPetInfo())
            {
               if(_loc4_.catchTime == _loc2_)
               {
                  _loc3_ = _loc4_;
               }
            }
            PetInfo.readBaseBaseInfo(_loc3_,param1);
            PetInfo.readSkillInfo(_loc3_,param1);
            PetInfo.readGainedSkillInfo(_loc3_,param1);
            _loc3_.learningInfo.pointUnused = param1.readUnsignedShort();
            _loc3_.twoExp = param1.readUnsignedInt();
            _loc3_.threeExp = param1.readUnsignedInt();
            _loc3_.twoStudy = param1.readUnsignedInt();
            _loc5_++;
         }
      }
   }
}

