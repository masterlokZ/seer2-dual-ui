package com.taomee.seer2.app.activity.processor.PrizeCeremony
{
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class PetKingNumber
   {
      
      private static var _callBack:Function;
      
      private static var _rightCount:uint;
      
      public function PetKingNumber()
      {
         super();
      }
      
      public static function getNumber(param1:Function = null) : void
      {
         _callBack = param1;
         ItemManager.addEventListener1("requestSpecialItemSuccess",onSeer);
         ItemManager.requestSpecialItemList();
      }
      
      private static function onSeer(param1:ItemEvent) : void
      {
         ItemManager.removeEventListener1("requestSpecialItemSuccess",onSeer);
         Connection.addCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,onGetTotalVote);
         Connection.send(CommandSet.GET_TOTAL_VOTE_INFO_1219,1,1,3);
      }
      
      private static function onGetTotalVote(param1:MessageEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         var _loc7_:int = 0;
         Connection.removeCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,onGetTotalVote);
         var _loc9_:IDataInput = param1.message.getRawData();
         var _loc11_:uint = _loc9_.readUnsignedInt();
         var _loc10_:uint = _loc9_.readUnsignedInt();
         var _loc5_:Vector.<uint> = Vector.<uint>([]);
         var _loc2_:Vector.<uint> = Vector.<uint>([]);
         var _loc6_:int = 0;
         while(_loc6_ < _loc10_)
         {
            _loc4_ = _loc9_.readUnsignedInt();
            _loc3_ = _loc9_.readUnsignedInt();
            _loc5_.push(_loc4_);
            _loc2_.push(_loc3_);
            if(getItem() == _loc4_)
            {
               _loc7_ = _loc6_;
            }
            _loc6_++;
         }
         _rightCount = 1;
         var _loc8_:int = 0;
         while(_loc8_ < 3)
         {
            if(_loc2_[_loc8_] > _loc2_[_loc7_])
            {
               ++_rightCount;
            }
            _loc8_++;
         }
         if(_callBack != null)
         {
            _callBack();
         }
         _callBack = null;
      }
      
      public static function getTeam() : uint
      {
         return _rightCount;
      }
      
      public static function getItem() : uint
      {
         if(ItemManager.getSpecialItem(500508) != null)
         {
            return 1;
         }
         if(ItemManager.getSpecialItem(500509) != null)
         {
            return 2;
         }
         if(ItemManager.getSpecialItem(500510) != null)
         {
            return 3;
         }
         return 0;
      }
   }
}

