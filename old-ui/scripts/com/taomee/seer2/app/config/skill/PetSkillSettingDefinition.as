package com.taomee.seer2.app.config.skill
{
   public class PetSkillSettingDefinition
   {
      
      public var id:uint;
      
      public var learningLv:uint;
      
      public var effectId:String;
      
      private var sounds:Vector.<SoundCondition> = new Vector.<SoundCondition>();
      
      public function PetSkillSettingDefinition(param1:uint, param2:uint, param3:String, param4:String)
      {
         super();
         this.id = param1;
         this.learningLv = param2;
         this.effectId = param4;
         this.parserSoundId(param3);
      }
      
      public function getSoundId(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc4_:uint = this.sounds.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.sounds[_loc3_].id == param1)
            {
               _loc2_ = this.sounds[_loc3_].soundId;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ == null)
         {
            return this.getSoundId(-1);
         }
         return _loc2_;
      }
      
      private function parserSoundId(param1:String) : void
      {
         var _loc3_:Array = null;
         var _loc2_:int = 0;
         var _loc4_:Array = param1.split(";");
         var _loc6_:uint = _loc4_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = String(_loc4_[_loc5_]).split(":");
            param1 = _loc3_.shift();
            _loc2_ = -1;
            if(_loc3_.length > 0)
            {
               _loc2_ = _loc3_.shift();
            }
            this.sounds.push(new SoundCondition(param1,_loc2_));
            _loc5_++;
         }
      }
   }
}

class SoundCondition
{
   
   public var soundId:String;
   
   public var id:int = -1;
   
   public function SoundCondition(param1:String, param2:int = -1)
   {
      this.soundId = param1;
      this.id = param2;
      super();
   }
}
