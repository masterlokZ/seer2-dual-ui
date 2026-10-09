package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   
   public class StartTrainingPet extends BaseBean
   {
      
      public function StartTrainingPet()
      {
         super();
      }
      
      override public function start() : void
      {
         Connection.addCommandListener(CommandSet.PET_TRAINING_START_1039,this.onData);
         finish();
      }
      
      private function onData(param1:MessageEvent) : void
      {
         var _loc6_:PetInfo = null;
         var _loc5_:PetInfo = null;
         var _loc7_:PetDefinition = null;
         var _loc9_:ByteArray = param1.message.getRawDataCopy();
         var _loc8_:uint = _loc9_.readUnsignedInt();
         var _loc4_:uint = _loc9_.readUnsignedInt();
         var _loc3_:uint = _loc9_.readUnsignedInt();
         _loc6_ = PetInfoManager.getPetInfoFromMap(_loc3_);
         if(_loc6_ != null)
         {
            PetInfoManager.setFirst(_loc8_);
            if(_loc6_.isInBag && _loc6_.isSetBirth == false && _loc6_.isBirthIng == false)
            {
               PetInfoManager.removePetInfoFromBagById(_loc3_);
            }
            _loc6_.isTraining = true;
            _loc7_ = _loc6_.getPetDefinition();
         }
         else
         {
            _loc7_ = PetConfig.getPetDefinition(_loc4_);
         }
         _loc5_ = new PetInfo();
         _loc5_.catchTime = _loc3_;
         PetInfoManager.dispatchEvent("petStartTraining",_loc5_);
         var _loc2_:String = _loc7_.name + "已放回小屋训练";
         ServerMessager.addMessage(_loc2_);
      }
   }
}

