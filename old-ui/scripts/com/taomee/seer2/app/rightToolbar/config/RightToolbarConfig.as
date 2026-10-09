package com.taomee.seer2.app.rightToolbar.config
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.newPlayerGuideVerOne.NewPlayerGuideTimeManager;
   import seer2.next.entry.DynConfig;
   
   public class RightToolbarConfig
   {
      
      private static var _xml:XML;
      
      private static var _rightToolbarInfoVec:Vector.<RightToolbarInfo>;
      
      private static var _upToolbarInfoVec:Vector.<RightToolbarInfo>;
      
      private static var _leftToolbarInfoVec:Vector.<RightToolbarInfo>;
      
      private static var _rightRollToolbarInfoVec:Vector.<String>;
      
      private static var _leftRollToolbarInfoVec:Vector.<String>;
      
      private static var _xmlClass:Class = RightToolbarConfig__xmlClass;
      
      setup();
      
      public function RightToolbarConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         loadConfig(DynConfig.rightToolbarConfigXML || XML(new _xmlClass()));
      }
      
      public static function loadConfig(xml:XML) : void
      {
         var _loc9_:RightToolbarInfo = null;
         var _loc4_:XMLList = null;
         var _loc3_:RightToolbarInfo = null;
         var _loc7_:XML = null;
         var _loc5_:String = null;
         var _loc2_:XML = null;
         var _loc6_:uint = 0;
         _xml = xml;
         _rightToolbarInfoVec = Vector.<RightToolbarInfo>([]);
         _upToolbarInfoVec = Vector.<RightToolbarInfo>([]);
         _leftToolbarInfoVec = Vector.<RightToolbarInfo>([]);
         var _loc8_:XMLList = _xml.descendants("downIconList");
         var _loc11_:Array = String(_loc8_[0].@list).split(",");
         _loc8_ = _xml.descendants("toolbar");
         var _loc10_:XMLList = _xml.descendants("rightRollIconList");
         _rightRollToolbarInfoVec = Vector.<String>(String(_loc10_[0].@list).split(","));
         _loc10_ = _xml.descendants("leftRollIconList");
         _leftRollToolbarInfoVec = Vector.<String>(String(_loc10_[0].@list).split(","));
         for each(_loc7_ in _loc8_)
         {
            _loc9_ = new RightToolbarInfo();
            _loc5_ = String(_loc7_.attribute("type"));
            updateInfo(_loc7_,_loc9_);
            if(_loc5_ == "right" || _loc11_.indexOf(String(_loc9_.sort)) != -1)
            {
               _rightToolbarInfoVec.push(_loc9_);
            }
            else if(_loc5_ == "up" && _loc11_.indexOf(String(_loc9_.sort)) == -1)
            {
               _upToolbarInfoVec.push(_loc9_);
            }
            else if(_loc5_ == "left" && _loc11_.indexOf(String(_loc9_.sort)) == -1)
            {
               _loc6_ = new Date(2014,8,19).getTime() / 1000;
               if(_loc9_.sort == 16 || _loc9_.sort == 23 || _loc9_.sort == 24)
               {
                  if(ActorManager.actorInfo.createTime > _loc6_)
                  {
                     if(_loc9_.sort == 23)
                     {
                        if(!NewPlayerGuideTimeManager.curTimeCheck())
                        {
                           _leftToolbarInfoVec.push(_loc9_);
                        }
                     }
                     else
                     {
                        _leftToolbarInfoVec.push(_loc9_);
                     }
                  }
               }
               else if(_loc9_.sort == 38)
               {
                  if(NewPlayerGuideTimeManager.curTimeCheck())
                  {
                     _leftToolbarInfoVec.push(_loc9_);
                  }
               }
               else
               {
                  _leftToolbarInfoVec.push(_loc9_);
               }
            }
            _loc9_.type = _loc5_;
            _loc9_.toolbarInfoList = Vector.<RightToolbarInfo>([]);
            _loc4_ = _loc7_.descendants("toolbar");
            for each(_loc2_ in _loc4_)
            {
               _loc3_ = new RightToolbarInfo();
               _loc3_.type = _loc5_;
               updateInfo(_loc2_,_loc3_);
               _loc9_.toolbarInfoList.push(_loc3_);
            }
         }
      }
      
      private static function updateInfo(param1:XML, param2:RightToolbarInfo) : void
      {
         var _loc14_:int = 0;
         var _loc9_:uint = uint(param1.attribute("sort"));
         var _loc8_:String = String(param1.attribute("startTime"));
         var _loc5_:String = String(param1.attribute("endTime"));
         var _loc4_:String = String(param1.attribute("class"));
         var _loc7_:String = String(param1.attribute("clickType"));
         var _loc6_:String = String(param1.attribute("clickParams"));
         var _loc3_:String = String(param1.attribute("tip"));
         var _loc12_:String = String(param1.attribute("lightStartTime"));
         var _loc13_:String = String(param1.attribute("dayList"));
         var _loc10_:uint = uint(param1.attribute("weekLimit"));
         var _loc11_:uint = uint(param1.attribute("swapId"));
         var _loc15_:int = int(param1.attribute("lightIndex"));
         var _loc16_:int = int(param1.attribute("isShowPoint"));
         if(String(param1.attribute("bufIndex")) == "")
         {
            _loc14_ = -1;
         }
         else
         {
            _loc14_ = int(param1.attribute("bufIndex"));
         }
         param2.sort = _loc9_;
         param2.startTime = _loc8_;
         param2.endTime = _loc5_;
         param2.classStr = _loc4_;
         param2.clickType = _loc7_;
         param2.clickParams = _loc6_;
         param2.weekLimit = _loc10_;
         param2.swapId = _loc11_;
         param2.tip = _loc3_;
         param2.isShowPoint = _loc16_;
         param2.dayList = _loc13_;
         param2.lightStartTime = _loc12_;
         param2.bufIndex = _loc14_;
         param2.lightIndex = _loc15_;
      }
      
      public static function getInfoVec() : Vector.<RightToolbarInfo>
      {
         if(_rightToolbarInfoVec.length < 1)
         {
            return null;
         }
         return _rightToolbarInfoVec;
      }
      
      public static function getUpVec() : Vector.<RightToolbarInfo>
      {
         if(_upToolbarInfoVec.length < 1)
         {
            return null;
         }
         return _upToolbarInfoVec;
      }
      
      public static function getLeftVec() : Vector.<RightToolbarInfo>
      {
         if(_leftToolbarInfoVec.length < 1)
         {
            return null;
         }
         return _leftToolbarInfoVec;
      }
      
      public static function getRightRollList() : Vector.<String>
      {
         return _rightRollToolbarInfoVec;
      }
      
      public static function getLeftRollList() : Vector.<String>
      {
         return _leftRollToolbarInfoVec;
      }
   }
}

