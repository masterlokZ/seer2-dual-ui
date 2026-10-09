package com.taomee.seer2.app.home.dailyQuest
{
   import com.taomee.seer2.app.config.HomeDailyQuestConfig;
   import com.taomee.seer2.app.config.ItemGroupConfig;
   import com.taomee.seer2.app.inventory.ItemDescription;
   import com.taomee.seer2.app.inventory.ItemUtil;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class HomeDailyQuestManager
   {
      
      private static var _onQuerySuccess:Function;
      
      private static var _onCompleteSuccess:Function;
      
      initialize();
      
      public function HomeDailyQuestManager()
      {
         super();
      }
      
      private static function initialize() : void
      {
      }
      
      private static function onNotify(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc3_:HomeDailyQuest = HomeDailyQuestConfig.getDailyQuest(_loc2_.readUnsignedInt());
         _loc3_.status = _loc2_.readUnsignedByte();
         _loc3_.completeCount = _loc2_.readUnsignedByte();
         if(_loc3_.completeCount < _loc3_.count)
         {
            ServerMessager.addMessage(_loc3_.des + ": " + _loc3_.completeCount + "/" + (_loc3_.count - 1));
         }
         else if(_onCompleteSuccess != null)
         {
            _onCompleteSuccess(_loc3_);
            _onCompleteSuccess = null;
         }
      }
      
      public static function query(param1:Function) : void
      {
         _onQuerySuccess = param1;
      }
      
      private static function onQuery(param1:MessageEvent) : void
      {
         var _loc5_:int = 0;
         var _loc4_:HomeDailyQuest = null;
         var _loc6_:IDataInput = param1.message.getRawData();
         var _loc8_:int = int(_loc6_.readUnsignedInt());
         var _loc7_:Vector.<HomeDailyQuest> = new Vector.<HomeDailyQuest>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc8_)
         {
            _loc5_ = int(_loc6_.readUnsignedInt());
            _loc4_ = HomeDailyQuestConfig.getDailyQuest(_loc5_);
            _loc4_.status = _loc6_.readUnsignedByte();
            _loc4_.completeCount = _loc6_.readUnsignedByte();
            _loc7_.push(_loc4_);
            _loc3_++;
         }
         var _loc2_:int = int(_loc6_.readUnsignedInt());
         if(_onQuerySuccess != null)
         {
            _onQuerySuccess(_loc7_,_loc2_);
            _onQuerySuccess = null;
         }
      }
      
      public static function complete(param1:int, param2:Function) : void
      {
         _onCompleteSuccess = param2;
      }
      
      private static function onComplete(param1:MessageEvent) : void
      {
         var _loc7_:ItemDescription = null;
         var _loc6_:IDataInput = param1.message.getRawData();
         var _loc8_:Vector.<ItemDescription> = new Vector.<ItemDescription>();
         var _loc3_:int = int(_loc6_.readUnsignedInt());
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new ItemDescription(_loc6_.readUnsignedInt(),_loc6_.readUnsignedShort(),_loc6_.readUnsignedInt(),false,true);
            _loc8_.push(_loc7_);
            _loc2_++;
         }
         _loc3_ = int(_loc6_.readUnsignedInt());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new ItemDescription(_loc6_.readUnsignedInt(),_loc6_.readUnsignedShort(),_loc6_.readUnsignedInt(),false,false);
            _loc8_.push(_loc7_);
            _loc2_++;
         }
         var _loc5_:uint = _loc6_.readUnsignedInt();
         var _loc4_:uint = _loc6_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            _loc7_ = new ItemDescription(_loc5_,1,_loc4_,true,true);
            _loc8_.push(_loc7_);
         }
         ItemUtil.updateLocal(_loc8_);
         ItemUtil.showItemVec(_loc8_);
      }
      
      public static function reward() : void
      {
      }
      
      private static function onReward(param1:MessageEvent) : void
      {
         var _loc5_:ItemDescription = null;
         var _loc4_:IDataInput = param1.message.getRawData();
         var _loc6_:Vector.<ItemDescription> = new Vector.<ItemDescription>();
         var _loc3_:int = int(_loc4_.readUnsignedInt());
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new ItemDescription(_loc4_.readUnsignedInt(),_loc4_.readUnsignedShort(),_loc4_.readUnsignedInt(),false);
            _loc6_.push(_loc5_);
            _loc2_++;
         }
         _loc3_ = int(_loc4_.readUnsignedInt());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new ItemDescription(_loc4_.readUnsignedInt(),1,_loc4_.readUnsignedInt(),true);
            _loc6_.push(_loc5_);
            _loc2_++;
         }
         ItemUtil.showRandomReward("dailyQuest",ItemGroupConfig.getGroup("dailyQuest",_loc6_));
      }
      
      public static function cancelCallBack() : void
      {
         _onQuerySuccess = null;
         _onCompleteSuccess = null;
      }
   }
}

