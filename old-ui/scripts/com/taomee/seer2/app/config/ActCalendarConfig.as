package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.ActDetailInfo;
   import com.taomee.seer2.core.manager.TimeManager;
   import seer2.next.entry.DynConfig;
   
   public class ActCalendarConfig
   {
      
      private static var weekActList:Vector.<Vector.<ActDetailInfo>>;
      
      private static var _curActIndex:int = -1;
      
      private static var _xmlClass:Class = ActCalendarConfig__xmlClass;
      
      setup();
      
      public function ActCalendarConfig()
      {
         super();
      }
      
      public static function getActList(param1:int) : Vector.<ActDetailInfo>
      {
         return weekActList[param1];
      }
      
      private static function setup() : void
      {
         loadConfig(DynConfig.actCalendarConfigXML || XML(new _xmlClass()));
      }
      
      public static function loadConfig(xml:XML) : void
      {
         var _loc9_:Array = null;
         var _loc4_:XML = null;
         var _loc3_:XMLList = null;
         var _loc6_:Vector.<ActDetailInfo> = null;
         var _loc5_:XML = null;
         var _loc2_:ActDetailInfo = null;
         var _loc12_:XMLList = null;
         var _loc13_:XML = null;
         var _loc10_:XMLList = null;
         var _loc11_:XML = null;
         weekActList = new Vector.<Vector.<ActDetailInfo>>(3);
         var _loc8_:XML = xml;
         var _loc7_:XMLList = _loc8_.descendants("acts");
         for each(_loc4_ in _loc7_)
         {
            _loc3_ = _loc4_.descendants("act");
            _loc6_ = new Vector.<ActDetailInfo>();
            for each(_loc5_ in _loc3_)
            {
               _loc2_ = new ActDetailInfo();
               _loc2_.name = _loc5_.@name;
               _loc2_.isPet = Boolean(int(_loc5_.@isPet));
               _loc2_.willOver = Boolean(int(_loc5_.@willOver));
               _loc2_.detailDes = _loc5_.@detailDes;
               _loc2_.timeDes = _loc5_.@timeDes;
               _loc2_.go = String(_loc5_.@go);
               _loc2_.iconId = uint(_loc5_.@iconId);
               _loc12_ = _loc5_.descendants("item");
               for each(_loc13_ in _loc12_)
               {
                  _loc2_.itemReward.push(int(_loc13_.@id));
               }
               _loc10_ = _loc5_.descendants("pet");
               for each(_loc11_ in _loc10_)
               {
                  _loc2_.petReward.push(int(_loc11_.@id));
               }
               _loc6_.push(_loc2_);
            }
            weekActList[int(_loc4_.@day)] = _loc6_;
         }
      }
      
      public static function get curActIndex() : int
      {
         return _curActIndex;
      }
      
      public static function setCurActIndex() : void
      {
      }
   }
}

