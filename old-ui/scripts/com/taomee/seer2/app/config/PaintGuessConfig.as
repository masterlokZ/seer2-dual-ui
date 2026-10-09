package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.PaintGuessGroupInfo;
   import com.taomee.seer2.app.config.info.PaintGuessInfo;
   import com.taomee.seer2.app.config.info.PaintGuessItemInfo;
   
   public class PaintGuessConfig
   {
      
      private static var _xml:XML;
      
      private static var _list:Vector.<PaintGuessInfo>;
      
      private static var _xmlClass:Class = PaintGuessConfig__xmlClass;
      
      setup();
      
      public function PaintGuessConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc6_:XML = null;
         var _loc9_:String = null;
         var _loc8_:uint = 0;
         var _loc3_:Vector.<PaintGuessGroupInfo> = null;
         var _loc2_:PaintGuessGroupInfo = null;
         var _loc5_:XML = null;
         var _loc4_:PaintGuessInfo = null;
         var _loc1_:Vector.<PaintGuessItemInfo> = null;
         var _loc12_:XML = null;
         var _loc13_:uint = 0;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:PaintGuessItemInfo = null;
         _list = Vector.<PaintGuessInfo>([]);
         _xml = XML(new _xmlClass());
         var _loc7_:XMLList = _xml.descendants("paint");
         for each(_loc6_ in _loc7_)
         {
            _loc9_ = String(_loc6_.attribute("type"));
            _loc8_ = uint(_loc6_.attribute("sort"));
            _loc3_ = Vector.<PaintGuessGroupInfo>([]);
            for each(_loc5_ in _loc6_.descendants("group"))
            {
               _loc1_ = Vector.<PaintGuessItemInfo>([]);
               for each(_loc12_ in _loc5_.descendants("item"))
               {
                  _loc13_ = uint(_loc12_.attribute("id"));
                  _loc10_ = String(_loc12_.attribute("optionList")).split("|");
                  _loc11_ = String(_loc12_.attribute("yesOption"));
                  _loc14_ = uint(_loc12_.attribute("isOpen"));
                  _loc15_ = new PaintGuessItemInfo(_loc13_,_loc10_,_loc11_,_loc14_);
                  _loc1_.push(_loc15_);
               }
               _loc2_ = new PaintGuessGroupInfo(_loc1_);
               _loc3_.push(_loc2_);
            }
            _loc4_ = new PaintGuessInfo(_loc9_,_loc8_,_loc3_);
            _list.push(_loc4_);
         }
      }
      
      public static function getAll() : Vector.<PaintGuessInfo>
      {
         _list.sort(sortVec);
         return _list;
      }
      
      private static function sortVec(param1:PaintGuessInfo, param2:PaintGuessInfo) : int
      {
         if(param1.sort > param2.sort)
         {
            return 1;
         }
         if(param1.sort < param2.sort)
         {
            return -1;
         }
         return 0;
      }
   }
}

