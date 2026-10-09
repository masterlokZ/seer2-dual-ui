package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.PetMeleeActivityInfo;
   import com.taomee.seer2.app.config.info.PetMeleeRankingInfo;
   import com.taomee.seer2.app.config.info.PetMeleeWinInfo;
   import org.taomee.ds.HashMap;
   
   public class PetMelee2Config
   {
      
      private static var _xml:XML;
      
      private static var _petMellRankingInfoList:Vector.<PetMeleeRankingInfo>;
      
      private static var _petMellWinInfoList:Vector.<PetMeleeWinInfo>;
      
      private static var _petMellActivityInfoList:Vector.<PetMeleeActivityInfo>;
      
      private static var _content:String;
      
      private static var _xmlClass:Class = PetMelee2Config__xmlClass;
      
      private static var _map:HashMap = new HashMap();
      
      setup();
      
      public function PetMelee2Config()
      {
         super();
      }
      
      public static function setup() : void
      {
         var _loc24_:PetMeleeRankingInfo = null;
         var _loc7_:XML = null;
         var _loc25_:PetMeleeWinInfo = null;
         var _loc4_:PetMeleeActivityInfo = null;
         var _loc22_:int = 0;
         var _loc5_:String = null;
         var _loc23_:String = null;
         var _loc2_:Array = null;
         var _loc30_:Vector.<uint> = null;
         var _loc14_:int = 0;
         var _loc27_:String = null;
         var _loc11_:Array = null;
         var _loc36_:Vector.<uint> = null;
         var _loc19_:int = 0;
         var _loc33_:int = 0;
         var _loc17_:String = null;
         var _loc26_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:String = null;
         var _loc13_:Array = null;
         var _loc32_:Vector.<uint> = null;
         var _loc10_:int = 0;
         var _loc29_:String = null;
         var _loc18_:Array = null;
         var _loc38_:Vector.<uint> = null;
         var _loc16_:int = 0;
         var _loc35_:int = 0;
         var _loc8_:String = null;
         var _loc1_:String = null;
         var _loc21_:String = null;
         var _loc31_:Array = null;
         var _loc15_:Vector.<uint> = null;
         var _loc28_:int = 0;
         var _loc12_:String = null;
         var _loc37_:Array = null;
         var _loc20_:Vector.<uint> = null;
         var _loc34_:int = 0;
         _xml = XML(new _xmlClass());
         _petMellRankingInfoList = Vector.<PetMeleeRankingInfo>([]);
         _petMellWinInfoList = Vector.<PetMeleeWinInfo>([]);
         _petMellActivityInfoList = Vector.<PetMeleeActivityInfo>([]);
         var _loc6_:XMLList = _xml.descendants("title");
         _content = String(_loc6_[0].attribute("content"));
         _loc6_ = _xml.descendants("ranking");
         for each(_loc7_ in _loc6_)
         {
            _loc24_ = new PetMeleeRankingInfo();
            _loc22_ = int(_loc7_.attribute("index"));
            _loc5_ = String(_loc7_.attribute("tip"));
            _loc23_ = String(_loc7_.attribute("itemList"));
            _loc2_ = _loc23_.split(",");
            _loc30_ = Vector.<uint>([]);
            _loc14_ = 0;
            while(_loc14_ < _loc2_.length)
            {
               _loc30_.push(uint(_loc2_[_loc14_]));
               _loc14_++;
            }
            _loc27_ = String(_loc7_.attribute("itemCount"));
            _loc11_ = _loc27_.split(",");
            _loc36_ = Vector.<uint>([]);
            _loc19_ = 0;
            while(_loc19_ < _loc11_.length)
            {
               _loc36_.push(uint(_loc11_[_loc19_]));
               _loc19_++;
            }
            _loc24_.ranking = _loc22_;
            _loc24_.itemList = _loc30_;
            _loc24_.countList = _loc36_;
            _map.add(_loc22_,_loc24_);
            _petMellRankingInfoList.push(_loc24_);
         }
         _loc6_ = _xml.descendants("win");
         for each(_loc7_ in _loc6_)
         {
            _loc25_ = new PetMeleeWinInfo();
            _loc33_ = int(_loc7_.attribute("index"));
            _loc17_ = String(_loc7_.attribute("tip"));
            _loc26_ = int(_loc7_.attribute("lastWin"));
            _loc9_ = int(_loc7_.attribute("totalWin"));
            _loc3_ = String(_loc7_.attribute("itemList"));
            _loc13_ = _loc3_.split(",");
            _loc32_ = Vector.<uint>([]);
            _loc10_ = 0;
            while(_loc10_ < _loc13_.length)
            {
               _loc32_.push(uint(_loc13_[_loc10_]));
               _loc10_++;
            }
            _loc29_ = String(_loc7_.attribute("itemCount"));
            _loc18_ = _loc29_.split(",");
            _loc38_ = Vector.<uint>([]);
            _loc16_ = 0;
            while(_loc16_ < _loc18_.length)
            {
               _loc38_.push(uint(_loc18_[_loc16_]));
               _loc16_++;
            }
            _loc25_.index = _loc33_;
            _loc25_.tip = _loc17_;
            _loc25_.lastWin = _loc26_;
            _loc25_.totalWin = _loc9_;
            _loc25_.countList = _loc38_;
            _loc25_.itemList = _loc32_;
            _petMellWinInfoList.push(_loc25_);
         }
         _loc6_ = _xml.descendants("activity");
         for each(_loc7_ in _loc6_)
         {
            _loc4_ = new PetMeleeActivityInfo();
            _loc35_ = int(_loc7_.attribute("index"));
            _loc8_ = String(_loc7_.attribute("title"));
            _loc1_ = String(_loc7_.attribute("content"));
            _loc21_ = String(_loc7_.attribute("itemList"));
            _loc31_ = _loc21_.split(",");
            _loc15_ = Vector.<uint>([]);
            _loc28_ = 0;
            while(_loc28_ < _loc31_.length)
            {
               _loc15_.push(uint(_loc31_[_loc28_]));
               _loc28_++;
            }
            _loc12_ = String(_loc7_.attribute("itemCount"));
            _loc37_ = _loc12_.split(",");
            _loc20_ = Vector.<uint>([]);
            _loc34_ = 0;
            while(_loc34_ < _loc37_.length)
            {
               _loc20_.push(uint(_loc37_[_loc34_]));
               _loc34_++;
            }
            _loc4_.index = _loc35_;
            _loc4_.title = _loc8_;
            _loc4_.content = _loc1_;
            _loc4_.itemList = _loc15_;
            _loc4_.itemCount = _loc20_;
            _petMellActivityInfoList.push(_loc4_);
         }
         _petMellRankingInfoList.sort(rankingSort);
         _petMellWinInfoList.sort(winSort);
         _petMellActivityInfoList.sort(activitySort);
      }
      
      private static function rankingSort(param1:PetMeleeRankingInfo, param2:PetMeleeRankingInfo) : int
      {
         if(param1.ranking > param2.ranking)
         {
            return 1;
         }
         if(param1.ranking < param2.ranking)
         {
            return -1;
         }
         return 0;
      }
      
      private static function activitySort(param1:PetMeleeActivityInfo, param2:PetMeleeActivityInfo) : int
      {
         if(param1.index > param2.index)
         {
            return 1;
         }
         if(param1.index < param2.index)
         {
            return -1;
         }
         return 0;
      }
      
      private static function winSort(param1:PetMeleeWinInfo, param2:PetMeleeWinInfo) : int
      {
         if(param1.index > param2.index)
         {
            return 1;
         }
         if(param1.index < param2.index)
         {
            return -1;
         }
         return 0;
      }
      
      public static function getRankingInfoVec() : Vector.<PetMeleeRankingInfo>
      {
         if(_petMellRankingInfoList.length < 1)
         {
            return null;
         }
         return _petMellRankingInfoList;
      }
      
      public static function getActivityInfoVec() : Vector.<PetMeleeActivityInfo>
      {
         if(_petMellActivityInfoList.length < 1)
         {
            return null;
         }
         return _petMellActivityInfoList;
      }
      
      public static function getWinInfoVec() : Vector.<PetMeleeWinInfo>
      {
         if(_petMellWinInfoList.length < 1)
         {
            return null;
         }
         return _petMellWinInfoList;
      }
      
      public static function getRankingInfo(param1:int) : PetMeleeRankingInfo
      {
         return _map.getValue(param1);
      }
      
      public static function getTitle() : String
      {
         return _content;
      }
   }
}

