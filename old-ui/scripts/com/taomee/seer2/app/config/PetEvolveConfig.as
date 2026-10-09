package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.PetEvolveInfo;
   import com.taomee.seer2.app.config.info.PetEvolveNeedInfo;
   import com.taomee.seer2.app.config.info.PetEvolveStarInfo;
   import com.taomee.seer2.core.map.grids.HashMap;
   
   public class PetEvolveConfig
   {
      
      private static var _xml:XML;
      
      private static var _xmlClass:Class = PetEvolveConfig__xmlClass;
      
      private static var _starClass:Class = PetEvolveConfig__starClass;
      
      private static var _conditionMap:HashMap = new HashMap();
      
      private static var _addMap:HashMap = new HashMap();
      
      setup();
      
      public function PetEvolveConfig()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc9_:XML = null;
         var _loc12_:XMLList = null;
         var _loc11_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc2_:XMLList = null;
         var _loc7_:PetEvolveInfo = null;
         var _loc5_:Vector.<PetEvolveNeedInfo> = null;
         var _loc1_:Vector.<PetEvolveNeedInfo> = null;
         var _loc6_:XMLList = null;
         var _loc8_:PetEvolveNeedInfo = null;
         var _loc3_:PetEvolveStarInfo = null;
         _xml = XML(new _xmlClass());
         var _loc10_:XMLList = _xml.descendants("Monster");
         for each(_loc9_ in _loc10_)
         {
            _loc11_ = uint(_loc9_.@ID);
            _loc4_ = false;
            _loc2_ = _loc9_.descendants("Star");
            for each(_loc9_ in _loc2_)
            {
               _loc7_ = new PetEvolveInfo();
               _conditionMap.put(_loc11_ + "_" + uint(_loc9_.@ID),_loc7_);
               _loc6_ = _loc9_.descendants("Condition");
               for each(_loc9_ in _loc6_)
               {
                  _loc8_ = new PetEvolveNeedInfo();
                  _loc8_.id = uint(_loc9_.@ID);
                  _loc8_.level = uint(_loc9_.@Level);
                  _loc8_.count = uint(_loc9_.@Count);
                  _loc8_.evolveLevel = uint(_loc9_.@Star);
                  if(uint(_loc9_.@Flag) == 0)
                  {
                     if(!_loc5_)
                     {
                        _loc5_ = new Vector.<PetEvolveNeedInfo>();
                     }
                     _loc8_.name = ItemConfig.getItemName(_loc8_.id);
                     _loc5_.push(_loc8_);
                  }
                  else
                  {
                     if(!_loc1_)
                     {
                        _loc1_ = new Vector.<PetEvolveNeedInfo>();
                     }
                     _loc8_.name = getPrefix(_loc8_.evolveLevel) + PetConfig.getPetDefinition(_loc8_.id).name;
                     _loc1_.push(_loc8_);
                  }
               }
               if(_loc5_)
               {
                  _loc7_.itemList = _loc5_;
                  _loc5_ = null;
               }
               if(_loc1_)
               {
                  _loc7_.petList = _loc1_;
                  _loc1_ = null;
               }
            }
         }
         _xml = XML(new _starClass());
         _loc12_ = _xml.descendants("Star");
         for each(_loc9_ in _loc12_)
         {
            _loc3_ = new PetEvolveStarInfo();
            _loc3_.ID = uint(_loc9_.@ID);
            _loc3_.Name = String(_loc9_.@Name);
            _loc3_.Atk = uint(_loc9_.@Atk);
            _loc3_.SpAtk = uint(_loc9_.@SpAtk);
            _loc3_.Def = uint(_loc9_.@Def);
            _loc3_.SpDef = uint(_loc9_.@SpDef);
            _loc3_.Spd = uint(_loc9_.@Spd);
            _loc3_.Hp = uint(_loc9_.@Hp);
            _loc3_.All = uint(_loc9_.@All);
            _loc3_.Crystal = uint(_loc9_.@Crystal);
            _loc3_.border = uint(_loc9_.@border);
            _loc3_.bg = uint(_loc9_.@bg);
            _addMap.put(_loc3_.ID,_loc3_);
         }
      }
      
      public static function canEvolve(param1:String) : Boolean
      {
         return _conditionMap.containsKey(param1);
      }
      
      public static function getStarInfo(param1:uint) : PetEvolveStarInfo
      {
         var _loc2_:PetEvolveStarInfo = null;
         var _loc3_:Object = _addMap.getValue(param1);
         if(_loc3_ == null)
         {
            _loc2_ = null;
         }
         else
         {
            _loc2_ = _loc3_ as PetEvolveStarInfo;
         }
         return _loc2_;
      }
      
      public static function getCondition(param1:String) : PetEvolveInfo
      {
         return _conditionMap.getValue(param1) as PetEvolveInfo;
      }
      
      public static function getPrefix(param1:uint) : String
      {
         var _loc2_:String = "";
         if(param1 != 0)
         {
            if(param1 <= 4)
            {
               _loc2_ = "神·";
            }
            else if(param1 <= 5)
            {
               _loc2_ = "圣1·";
            }
            else if(param1 <= 6)
            {
               _loc2_ = "圣2·";
            }
            else if(param1 <= 7)
            {
               _loc2_ = "圣3·";
            }
            else if(param1 <= 8)
            {
               _loc2_ = "圣·";
            }
            else if(param1 <= 1004)
            {
               _loc2_ = "魔·";
            }
            else if(param1 <= 1005)
            {
               _loc2_ = "冥1·";
            }
            else if(param1 <= 1006)
            {
               _loc2_ = "冥2·";
            }
            else if(param1 <= 1007)
            {
               _loc2_ = "冥3·";
            }
            else
            {
               _loc2_ = "冥·";
            }
         }
         return _loc2_;
      }
      
      public static function getStarNum(param1:int) : int
      {
         var _loc2_:uint = uint(param1);
         if(_loc2_ > 1000)
         {
            _loc2_ -= 1000;
         }
         if(_loc2_ != 0 && _loc2_ % 4 == 0 && _loc2_ != 1000)
         {
            _loc2_ = 4;
         }
         else
         {
            _loc2_ %= 4;
         }
         return _loc2_;
      }
   }
}

