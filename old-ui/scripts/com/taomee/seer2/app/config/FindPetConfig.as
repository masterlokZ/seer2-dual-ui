package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.FindPetInfo;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import org.taomee.ds.HashMap;
   
   public class FindPetConfig
   {
      
      private static var _configXML:XML;
      
      private static var infoMap:HashMap;
      
      private static var mapPetMap:HashMap;
      
      public static var startTime:uint;
      
      public static var endTime:uint;
      
      private static var _xmlClass:Class = FindPetConfig__xmlClass;
      
      initialize();
      
      public function FindPetConfig()
      {
         super();
      }
      
      public static function getCreateInfo(param1:int) : FindPetInfo
      {
         var _loc4_:String = null;
         var _loc10_:Date = null;
         var _loc7_:FindPetInfo = null;
         var _loc2_:String = null;
         var _loc5_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Array = mapPetMap.getValue(param1) as Array;
         if(!_loc9_)
         {
            return null;
         }
         var _loc11_:uint = TimeManager.getPrecisionServerTime();
         _loc10_ = new Date(_loc11_ * 1000);
         _loc4_ = _loc10_.minutes.toString();
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         var _loc3_:int = int(String(_loc10_.hours) + _loc4_);
         var _loc6_:int = 0;
         while(_loc6_ < _loc9_.length)
         {
            _loc2_ = param1 + "_" + _loc9_[_loc6_];
            _loc7_ = infoMap.getValue(_loc2_) as FindPetInfo;
            if(_loc11_ < _loc7_.end && _loc11_ > _loc7_.start)
            {
               _loc5_ = _loc7_.timeList[_loc10_.day];
               _loc8_ = 0;
               while(_loc8_ < _loc5_.length)
               {
                  if(_loc3_ > _loc5_[_loc8_]["start"] && _loc3_ < _loc5_[_loc8_]["end"])
                  {
                     return _loc7_;
                  }
                  _loc8_++;
               }
            }
            _loc6_++;
         }
         return null;
      }
      
      private static function initialize() : void
      {
         var _loc9_:FindPetInfo = null;
         var _loc2_:XML = null;
         var _loc7_:Array = null;
         var _loc5_:XMLList = null;
         var _loc1_:uint = 0;
         var _loc6_:uint = 0;
         var _loc8_:int = 0;
         var _loc3_:Object = null;
         _configXML = XML(new _xmlClass());
         var _loc10_:XMLList = _configXML.descendants("act");
         infoMap = new HashMap();
         mapPetMap = new HashMap();
         var _loc12_:Date = new Date();
         var _loc11_:Array = String(_configXML.@start).split("_");
         _loc12_.fullYear = int(_loc11_[0]);
         _loc12_.month = int(_loc11_[1]) - 1;
         _loc12_.date = int(_loc11_[2]);
         _loc12_.hours = int(_loc11_[3]);
         _loc12_.minutes = int(_loc11_[4]);
         startTime = _loc12_.getTime() / 1000;
         var _loc4_:Array = String(_configXML.@end).split("_");
         _loc12_.fullYear = int(_loc4_[0]);
         _loc12_.month = int(_loc4_[1]) - 1;
         _loc12_.date = int(_loc4_[2]);
         _loc12_.hours = int(_loc4_[3]);
         _loc12_.minutes = int(_loc4_[4]);
         endTime = _loc12_.getTime() / 1000;
         for each(_loc2_ in _loc10_)
         {
            _loc9_ = new FindPetInfo();
            _loc9_.petId = int(_loc2_.@petId);
            _loc9_.fightId = int(_loc2_.@fightId);
            _loc9_.probabilityId = int(_loc2_.@probabilityId);
            _loc9_.mapId = int(_loc2_.@mapId);
            _loc9_.lev = int(_loc2_.@lev);
            _loc11_ = String(_loc2_.@start).split("_");
            _loc12_.fullYear = int(_loc11_[0]);
            _loc12_.month = int(_loc11_[1]) - 1;
            _loc12_.date = int(_loc11_[2]);
            _loc12_.hours = int(_loc11_[3]);
            _loc12_.minutes = int(_loc11_[4]);
            _loc9_.start = _loc12_.getTime() / 1000;
            _loc4_ = String(_loc2_.@end).split("_");
            _loc12_.fullYear = int(_loc4_[0]);
            _loc12_.month = int(_loc4_[1]) - 1;
            _loc12_.date = int(_loc4_[2]);
            _loc12_.hours = int(_loc4_[3]);
            _loc12_.minutes = int(_loc4_[4]);
            _loc9_.end = _loc12_.getTime() / 1000;
            _loc7_ = mapPetMap.getKey(_loc9_.mapId) as Array;
            if(!_loc7_)
            {
               _loc7_ = [];
               mapPetMap.add(_loc9_.mapId,_loc7_);
            }
            if(_loc7_.indexOf(_loc9_.petId) == -1)
            {
               _loc7_.push(_loc9_.petId);
            }
            _loc9_.timeList = new Array(7);
            _loc5_ = _loc2_.descendants("time");
            for each(_loc2_ in _loc5_)
            {
               _loc1_ = uint(_loc2_.@start);
               _loc6_ = uint(_loc2_.@end);
               _loc8_ = int(_loc2_.@day);
               if(!_loc9_.timeList[_loc8_])
               {
                  _loc9_.timeList[_loc8_] = [];
               }
               _loc3_ = {};
               _loc3_.start = _loc1_;
               _loc3_.end = _loc6_;
               _loc9_.timeList[_loc8_].push(_loc3_);
            }
            infoMap.add(_loc9_.mapId + "_" + _loc9_.petId,_loc9_);
         }
      }
      
      public static function getMapFindPetinfo() : FindPetInfo
      {
         return infoMap.getValue(SceneManager.active.mapID) as FindPetInfo;
      }
   }
}

