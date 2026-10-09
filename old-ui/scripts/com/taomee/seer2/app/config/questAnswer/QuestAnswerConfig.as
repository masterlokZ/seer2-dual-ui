package com.taomee.seer2.app.config.questAnswer
{
   public class QuestAnswerConfig
   {
      
      private static var _allItems:Vector.<QuestInfo>;
      
      private static var _xmlClass:Class = QuestAnswerConfig__xmlClass;
      
      setup();
      
      public function QuestAnswerConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc7_:QuestInfo = null;
         var _loc6_:Vector.<String> = null;
         var _loc2_:int = 0;
         var _loc1_:Array = null;
         var _loc3_:XML = null;
         _allItems = new Vector.<QuestInfo>();
         var _loc5_:XML = XML(new _xmlClass());
         var _loc4_:XMLList = _loc5_.elements();
         for each(_loc3_ in _loc4_)
         {
            _loc7_ = new QuestInfo();
            _loc7_.id = int(_loc3_.@id);
            _loc7_.ask = String(_loc3_.@ask);
            _loc6_ = new Vector.<String>();
            _loc1_ = String(_loc3_.@selectItems).split(";");
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc6_.push(_loc1_[_loc2_]);
               _loc2_++;
            }
            _loc7_.selectItems = _loc6_;
            _loc7_.answer = int(_loc3_.@answer);
            _allItems.push(_loc7_);
         }
      }
      
      public static function getItemByType(param1:int) : Vector.<QuestInfo>
      {
         var _loc3_:QuestInfo = null;
         var _loc2_:Vector.<QuestInfo> = new Vector.<QuestInfo>();
         for each(_loc3_ in _allItems)
         {
            if(int(_loc3_.id / 1000) == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getItemBuyTypeArr(param1:Vector.<int>) : Vector.<QuestInfo>
      {
         var _loc3_:QuestInfo = null;
         var _loc2_:Vector.<QuestInfo> = new Vector.<QuestInfo>();
         for each(_loc3_ in _allItems)
         {
            if(param1.indexOf(int(_loc3_.id / 1000)) != -1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

