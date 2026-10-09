package com.taomee.seer2.app.processor.quest.handler.branch.quest10043
{
   import com.taomee.seer2.app.actor.Actor;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.utils.IDataInput;
   
   public class ReplacePet
   {
      
      public function ReplacePet()
      {
         super();
      }
      
      public static function replacePet() : void
      {
         Connection.addCommandListener(CommandSet.REPLACE_PET_1185,onReplacePet);
      }
      
      private static function onReplacePet(param1:MessageEvent) : void
      {
         var _loc5_:SkillInfo = null;
         var _loc14_:Actor = null;
         var _loc15_:PetInfo = null;
         Connection.removeCommandListener(CommandSet.REPLACE_PET_1185,onReplacePet);
         var _loc7_:IDataInput = param1.message.getRawData();
         var _loc9_:uint = _loc7_.readUnsignedInt();
         var _loc8_:uint = _loc7_.readUnsignedInt();
         var _loc4_:uint = _loc7_.readUnsignedInt();
         var _loc3_:uint = _loc7_.readUnsignedInt();
         var _loc6_:Vector.<SkillInfo> = Vector.<SkillInfo>([]);
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new SkillInfo(_loc7_.readUnsignedInt());
            _loc6_.push(_loc5_);
            _loc2_++;
         }
         var _loc12_:uint = _loc7_.readUnsignedInt();
         var _loc13_:Vector.<SkillInfo> = Vector.<SkillInfo>([]);
         var _loc10_:int = 0;
         while(_loc10_ < _loc12_)
         {
            _loc5_ = new SkillInfo(_loc7_.readUnsignedInt());
            _loc13_.push(_loc5_);
            _loc10_++;
         }
         var _loc11_:PetDefinition = PetConfig.getPetDefinition(_loc4_);
         if(_loc9_ == ActorManager.actorInfo.id)
         {
            _loc14_ = ActorManager.getActor();
            if(Boolean(_loc14_.getFollowingPet()) && _loc14_.getFollowingPet().getInfo().resourceId == 45)
            {
               _loc14_.getFollowingPet().getInfo().petDefinition = _loc11_;
               _loc14_.getFollowingPet().getInfo().resourceId = _loc4_;
               _loc14_.getFollowingPet().resourceUrl = URLUtil.getPetSwf(_loc4_);
               _loc14_.getFollowingPet().getInfo().replacePetSkill(_loc6_,_loc13_);
            }
            else
            {
               _loc15_ = PetInfoManager.getFirstPetInfo();
               if(_loc15_.resourceId == 45)
               {
                  _loc15_.petDefinition = _loc11_;
                  _loc15_.resourceId = _loc4_;
                  _loc14_.getFollowingPet().getInfo().replacePetSkill(_loc6_,_loc13_);
               }
            }
            if(_loc14_.getFollowingPet().getInfo().isStarting)
            {
               PetInfoManager.setFirst(_loc8_);
            }
         }
         else
         {
            _loc14_ = ActorManager.getRemoteActor(_loc9_);
            if(Boolean(_loc14_.getFollowingPet()) && _loc14_.getFollowingPet().getInfo().resourceId == 45)
            {
               _loc14_.getFollowingPet().getInfo().petDefinition = _loc11_;
               _loc14_.getFollowingPet().getInfo().resourceId = _loc4_;
               _loc14_.getFollowingPet().resourceUrl = URLUtil.getPetSwf(_loc4_);
            }
         }
      }
   }
}

