package com.taomee.seer2.app.gameRule.spt.support
{
   public class SptDialogConfig
   {
      
      private static var _xml:XML;
      
      public static var infoVec:Vector.<SptDialogInfo>;
      
      private static var _xmlClass:Class = SptDialogConfig__xmlClass;
      
      setup();
      
      public function SptDialogConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc1_:XML = null;
         var _loc3_:SptDialogInfo = null;
         infoVec = new Vector.<SptDialogInfo>();
         _xml = XML(new _xmlClass());
         var _loc2_:XMLList = _xml.descendants("spt");
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = new SptDialogInfo();
            _loc3_.bossId = _loc1_.attribute("sptid");
            _loc3_.setUpTalks(_loc1_["talks"]);
            _loc3_.setUpContents(_loc1_["dialogs"]);
            infoVec.push(_loc3_);
         }
      }
      
      public static function getTalkContent(param1:uint) : String
      {
         var _loc2_:String = "";
         var _loc4_:uint = infoVec.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc4_)
         {
            if(infoVec[_loc3_].bossId == param1)
            {
               _loc2_ = infoVec[_loc3_].getTalkContent();
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getSptDialog(param1:uint, param2:uint, param3:Array = null) : String
      {
         var _loc6_:String = "";
         var _loc5_:uint = infoVec.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc5_)
         {
            if(infoVec[_loc4_].bossId == param1)
            {
               _loc6_ = infoVec[_loc4_].getDialogContent(param2,param3);
               break;
            }
            _loc4_++;
         }
         return _loc6_;
      }
   }
}

