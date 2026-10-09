package com.taomee.seer2.app.gameRule.door.constant
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   
   public class Door21LevelConstant
   {
      
      public static var _GUARD_NPCS:Array;
      
      private static var _DoorMonData:Class = Door21LevelConstant__DoorMonData;
      
      public function Door21LevelConstant()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _loc3_:Array = null;
         var _loc2_:XML = null;
         var _loc5_:XMLList = null;
         var _loc4_:XML = null;
         var _loc1_:uint = 0;
         var _loc12_:XMLList = null;
         var _loc13_:XML = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc14_:String = null;
         var _loc15_:PetDefinition = null;
         var _loc7_:XML = XML(new _DoorMonData());
         var _loc6_:XMLList = _loc7_.child("Method");
         var _loc9_:uint = uint(_loc6_.length());
         var _loc8_:uint = 0;
         while(_loc8_ < _loc9_)
         {
            _loc3_ = [];
            _loc2_ = _loc6_[_loc8_];
            _loc5_ = _loc2_.child("Gate");
            _loc1_ = 0;
            while(_loc1_ < _loc5_.length())
            {
               _loc4_ = _loc5_[_loc1_];
               _loc12_ = _loc4_["Mons"].child("Mon");
               _loc10_ = 0;
               while(_loc10_ < _loc12_.length())
               {
                  _loc13_ = _loc12_[_loc10_];
                  _loc11_ = uint(_loc4_.attribute("ID"));
                  _loc16_ = uint(_loc13_.attribute("ID"));
                  _loc17_ = uint(_loc13_.attribute("LV"));
                  _loc14_ = " ** ";
                  _loc15_ = PetConfig.getPetDefinition(_loc16_);
                  if(_loc15_ != null)
                  {
                     _loc14_ = _loc15_.name;
                  }
                  _loc3_.push({
                     "level":_loc11_,
                     "id":_loc16_,
                     "petName":_loc14_,
                     "petLevel":_loc17_
                  });
                  _loc10_++;
               }
               _loc1_++;
            }
            _GUARD_NPCS.push(_loc3_);
            _loc8_++;
         }
      }
      
      public static function get GUARD_NPCS() : Array
      {
         if(_GUARD_NPCS == null)
         {
            _GUARD_NPCS = [];
            setup();
         }
         return _GUARD_NPCS;
      }
   }
}

