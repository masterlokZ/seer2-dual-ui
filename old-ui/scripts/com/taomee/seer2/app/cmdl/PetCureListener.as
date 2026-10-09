package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.ByteArray;
   import org.taomee.bean.BaseBean;
   
   public class PetCureListener extends BaseBean
   {
      
      public function PetCureListener()
      {
         super();
      }
      
      override public function start() : void
      {
         Connection.addCommandListener(CommandSet.PET_CURE_1037,this.onData);
         finish();
      }
      
      private function onData(param1:MessageEvent) : void
      {
         var _loc3_:PetInfo = null;
         var _loc4_:ByteArray = param1.message.getRawDataCopy();
         var _loc6_:uint = _loc4_.readUnsignedInt();
         var _loc5_:int = int(_loc4_.readUnsignedInt());
         _loc3_ = PetInfoManager.getPetInfoFromBag(_loc6_);
         if(_loc3_ != null)
         {
            _loc3_.hp = _loc3_.maxHp;
            PetInfoManager.dispatchEvent("petCure",_loc3_);
         }
         var _loc2_:int = ActorManager.actorInfo.coins - _loc5_;
         ActorManager.actorInfo.coins = _loc5_;
         if(_loc2_ > 0)
         {
            if(VipManager.vipInfo.isVip())
            {
               ServerMessager.addMessage("恢复精灵体力消耗了" + _loc2_ + "赛尔豆(VIP五折哦)");
            }
            else
            {
               ServerMessager.addMessage("恢复精灵体力消耗了" + _loc2_);
            }
         }
         if(ActorManager.actorInfo.highestPetLevel <= 10)
         {
            ServerMessager.addMessage("最高等级低于10级时恢复功能是免费的");
         }
      }
   }
}

