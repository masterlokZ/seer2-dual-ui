package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.DiceThingInfo;
   import org.taomee.ds.HashMap;
   
   public class DiceMapThingMeeConfig
   {
      
      private static var _luckyThingNum:int;
      
      private static var _boxThingNum:int;
      
      private static var _chanceThingNum:int;
      
      private static var _addMoneyThingNum:int;
      
      private static var _subMoneyThingNum:int;
      
      private static var _petFightThingNum:int;
      
      private static var _reverseThingNum:int;
      
      private static var _xmlClass:Class = DiceMapThingMeeConfig__xmlClass;
      
      private static var _thingMap:HashMap = new HashMap();
      
      private static var _diceMapList:Array = [];
      
      initlize();
      
      public function DiceMapThingMeeConfig()
      {
         super();
      }
      
      public static function get diceMapList() : Array
      {
         return _diceMapList;
      }
      
      public static function get reverseThingNum() : int
      {
         return _reverseThingNum;
      }
      
      public static function get luckyThingNum() : int
      {
         return _luckyThingNum;
      }
      
      public static function get petFightThingNum() : int
      {
         return _petFightThingNum;
      }
      
      public static function get subMoneyThingNum() : int
      {
         return _subMoneyThingNum;
      }
      
      public static function get addMoneyThingNum() : int
      {
         return _addMoneyThingNum;
      }
      
      public static function get chanceThingNum() : int
      {
         return _chanceThingNum;
      }
      
      public static function get boxThingNum() : int
      {
         return _boxThingNum;
      }
      
      public static function get thingMap() : HashMap
      {
         return _thingMap;
      }
      
      private static function initlize() : void
      {
         var _loc8_:XML = XML(new _xmlClass());
         var _loc7_:XMLList = _loc8_.descendants("maps").descendants("map");
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_.length())
         {
            _diceMapList.push(uint(_loc7_[_loc10_]));
            _loc10_++;
         }
         var _loc9_:XMLList = _loc8_.descendants("lucky").descendants("thing");
         var _loc3_:XMLList = _loc8_.descendants("box").descendants("thing");
         var _loc2_:XMLList = _loc8_.descendants("chance").descendants("thing");
         var _loc6_:XMLList = _loc8_.descendants("addMoney").descendants("thing");
         var _loc4_:XMLList = _loc8_.descendants("subMoney").descendants("thing");
         var _loc1_:XMLList = _loc8_.descendants("fight").descendants("thing");
         var _loc5_:XMLList = _loc8_.descendants("reverse").descendants("thing");
         paseXml("lucky",_loc9_);
         paseXml("box",_loc3_);
         paseXml("chance",_loc2_);
         paseXml("addMoney",_loc6_);
         paseXml("subMoney",_loc4_);
         paseXml("fight",_loc1_);
         paseXml("reverse",_loc5_);
         _luckyThingNum = _loc9_.length();
         _boxThingNum = _loc3_.length();
         _chanceThingNum = _loc2_.length();
         _addMoneyThingNum = _loc6_.length();
         _subMoneyThingNum = _loc4_.length();
         _petFightThingNum = _loc1_.length();
         _reverseThingNum = _loc5_.length();
      }
      
      private static function paseXml(param1:String, param2:XMLList) : void
      {
         var _loc5_:XML = null;
         var _loc4_:DiceThingInfo = null;
         var _loc3_:String = null;
         for each(_loc5_ in param2)
         {
            _loc4_ = new DiceThingInfo();
            _loc4_.type = param1;
            _loc4_.id = int(_loc5_.@id);
            _loc4_.strikeId = int(_loc5_.@strikeId);
            _loc4_.des = String(_loc5_.@des);
            _loc4_.stopTime = int(_loc5_.@stopTime);
            _loc4_.className = String(_loc5_.@className);
            _loc4_.fightType = String(_loc5_.@fightType);
            _loc4_.moveTile = int(_loc5_.@moveTile);
            _loc4_.moneyNum = int(_loc5_.@moneyNum);
            _loc3_ = param1 + _loc4_.id.toString();
            _thingMap.add(_loc3_,_loc4_);
         }
      }
   }
}

