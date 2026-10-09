package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.starMagic.StarInfo;
   
   public class ItemDictionaryConfig
   {
      
      private static var _itemDictionaryConfigXML:XML;
      
      private static var _starInfoVec:Vector.<StarInfo>;
      
      private static var _xmlClass:Class = ItemDictionaryConfig__xmlClass;
      
      initialize();
      
      public function ItemDictionaryConfig()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _itemDictionaryConfigXML = XML(new _xmlClass());
         _starInfoVec = new Vector.<StarInfo>();
         var star:StarInfo = null;
         var xml:XML = null;
         var list:XMLList = _itemDictionaryConfigXML.descendants("star");
         var _loc8_:String = null;
         var _loc4_:uint = 0;
         var _loc3_:String = null;
         var _loc6_:String = null;
         var _loc5_:String = null;
         var _loc2_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc11_:String = null;
         var _loc16_:String = null;
         var _loc17_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc9_:String = null;
         for each(xml in list)
         {
            star = new StarInfo();
            _loc8_ = String(xml.attribute("type"));
            _loc4_ = uint(xml.attribute("max_lvl"));
            _loc3_ = String(xml.attribute("name"));
            _loc6_ = String(xml.attribute("value"));
            _loc5_ = String(xml.attribute("lvl_cof"));
            _loc2_ = String(xml.attribute("index"));
            _loc12_ = String(xml.attribute("desc"));
            _loc13_ = String(xml.attribute("needExp"));
            _loc11_ = String(xml.attribute("effdesc"));
            _loc16_ = String(xml.attribute("effv"));
            _loc9_ = String(xml.attribute("itemIcon"));
            _loc17_ = _loc13_.split(",");
            star.id = int(_loc2_);
            star.buffId = int(_loc2_);
            star.level_cof = int(_loc5_);
            star.maxLevel = int(_loc4_);
            star.sell_exp = int(_loc6_);
            star.type = int(_loc8_);
            star.nameT = _loc3_;
            star.nextExpArr = _loc17_;
            star.effdesc = _loc11_;
            star.desc = _loc12_.split(";");
            star.itemIcon = int(_loc9_);
            _loc17_ = _loc16_.split(";");
            _loc14_ = [];
            _loc15_ = 0;
            while(_loc15_ < _loc17_.length)
            {
               _loc14_.push(_loc17_[_loc15_].split(","));
               _loc15_++;
            }
            star.effvalue = _loc14_;
            _starInfoVec.push(star);
         }
      }
      
      public static function getStarInfoVec() : Vector.<StarInfo>
      {
         if(_starInfoVec.length < 1)
         {
            return null;
         }
         return _starInfoVec;
      }
   }
}

