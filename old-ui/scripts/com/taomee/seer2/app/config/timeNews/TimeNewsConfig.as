package com.taomee.seer2.app.config.timeNews
{
   import com.taomee.seer2.core.manager.GlobalsManager;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class TimeNewsConfig
   {
      
      private static var _configXML:XML;
      
      public static var pageInfos:Array;
      
      private static var _version:String;
      
      private static var _xmlClass:Class = TimeNewsConfig__xmlClass;
      
      setup();
      
      public function TimeNewsConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         _configXML = XML(new _xmlClass());
         pageInfos = [];
         GlobalsManager.timeNewsPage = int(_configXML.@initPage);
         _version = _configXML.@version;
         for each(_loc1_ in _configXML["page"])
         {
            pageInfos.push(parsePage(_loc1_));
         }
      }
      
      private static function parsePage(param1:XML) : PageInfo
      {
         var _loc6_:XML = null;
         var _loc3_:Array = null;
         var _loc2_:String = null;
         var _loc4_:BtnInfo = null;
         var _loc5_:PageInfo = new PageInfo();
         _loc5_.id = param1.@id;
         _loc5_.title = param1.@title;
         _loc5_.type = param1.@title;
         _loc5_.isNew = Boolean(int(param1.@isNew));
         _loc5_.isPet = Boolean(int(param1.@isPet));
         _loc5_.petInfo = param1.@petInfo;
         _loc5_.name = param1.@name;
         _loc5_.getWay = param1.@getWay;
         _loc5_.txtColor = param1.@txtColor;
         if(_loc5_.name != "")
         {
            _loc5_.url = URLUtil.getTimeNews(_version,_loc5_.name + ".swf");
         }
         else
         {
            _loc5_.url = URLUtil.getTimeNews(_version,_loc5_.id.toString() + ".swf");
         }
         if(String(param1.@award) != "")
         {
            _loc5_.awardList = new Vector.<int>();
            _loc3_ = String(param1.@award).split(",");
            for each(_loc2_ in _loc3_)
            {
               _loc5_.awardList.push(int(_loc2_));
            }
         }
         var _loc7_:XMLList = param1.elements("btn");
         for each(_loc6_ in _loc7_)
         {
            _loc4_ = new BtnInfo();
            _loc4_.type = String(_loc6_.@type);
            _loc4_.tip = String(_loc6_.@tip);
            _loc4_.content = _loc6_.toString();
            _loc5_.btnInfos.push(_loc4_);
         }
         return _loc5_;
      }
      
      public static function get version() : String
      {
         return _version;
      }
      
      public static function getPageInfo(param1:uint = 0, param2:String = "") : PageInfo
      {
         var _loc3_:PageInfo = null;
         for each(_loc3_ in pageInfos)
         {
            if(param1 != 0)
            {
               if(_loc3_.id == param1)
               {
                  return _loc3_;
               }
            }
            if(param2 != "")
            {
               if(_loc3_.name == param2)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
   }
}

