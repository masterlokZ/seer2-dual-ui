package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.config.FindPetConfig;
   import com.taomee.seer2.app.config.info.FindPetInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1140;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import flash.events.MouseEvent;
   
   public class FindPetAct
   {
      
      private static var _instance:FindPetAct;
      
      private var info:FindPetInfo;
      
      private var pet:SpawnedPet;
      
      public function FindPetAct()
      {
         super();
      }
      
      public static function get instance() : FindPetAct
      {
         if(!_instance)
         {
            _instance = new FindPetAct();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SceneManager.addEventListener("switchComplete",this.onSwitchComplete);
      }
      
      private function onSwitchComplete(param1:SceneEvent) : void
      {
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,this.getCreateState);
         Connection.removeCommandListener(CommandSet.PET_SPAWN_1103,this.createPet);
         if(this.pet)
         {
            this.pet.removeEventListener("click",this.fightCheck);
         }
         if(TimeManager.getServerTime() > FindPetConfig.endTime)
         {
            SceneManager.removeEventListener("switchComplete",this.onSwitchComplete);
            return;
         }
         var _loc2_:int = SceneManager.active.mapID;
         this.info = FindPetConfig.getCreateInfo(_loc2_);
         if(this.info)
         {
            Connection.addCommandListener(CommandSet.RANDOM_EVENT_1140,this.getCreateState);
            Connection.send(CommandSet.RANDOM_EVENT_1140,this.info.probabilityId,0);
         }
      }
      
      private function getCreateState(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,this.getCreateState);
         var _loc2_:Parser_1140 = new Parser_1140(param1.message.getRawDataCopy());
         if(_loc2_.id != 0 && _loc2_.index == this.info.probabilityId)
         {
            Connection.addCommandListener(CommandSet.PET_SPAWN_1103,this.createPet);
         }
      }
      
      private function createPet(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_SPAWN_1103,this.createPet);
         this.pet = new SpawnedPet(this.info.petId,this.info.fightId,this.info.lev);
         this.pet.mouseChildren = false;
         this.pet.addEventListener("click",this.fightCheck,false,1000);
         MobileManager.addMobile(this.pet,"spawnedPet");
      }
      
      private function fightCheck(param1:MouseEvent) : void
      {
         var _loc8_:Date = null;
         var _loc4_:String = null;
         var _loc3_:int = 0;
         var _loc6_:Array = null;
         var _loc5_:Boolean = false;
         var _loc2_:int = 0;
         var _loc7_:SpawnedPet = param1.target as SpawnedPet;
         var _loc9_:Boolean = false;
         if(TimeManager.getServerTime() > FindPetConfig.endTime)
         {
            _loc9_ = true;
            SceneManager.removeEventListener("switchComplete",this.onSwitchComplete);
         }
         else if(TimeManager.getServerTime() > this.info.end)
         {
            _loc9_ = true;
         }
         if(!_loc9_)
         {
            _loc8_ = new Date(TimeManager.getServerTime() * 1000);
            _loc4_ = _loc8_.minutes.toString();
            if(_loc4_.length == 1)
            {
               _loc4_ = "0" + _loc4_;
            }
            _loc3_ = int(String(_loc8_.hours) + _loc4_);
            _loc6_ = this.info.timeList[_loc8_.day];
            _loc5_ = false;
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length)
            {
               if(_loc3_ > _loc6_[_loc2_]["start"] && _loc3_ < _loc6_[_loc2_]["end"])
               {
                  _loc5_ = true;
               }
               _loc2_++;
            }
            _loc9_ = !_loc5_;
         }
         if(_loc9_)
         {
            _loc7_.removeEventListener("click",this.fightCheck);
            MobileManager.removeMobile(_loc7_,"spawnedPet");
            param1.stopImmediatePropagation();
         }
      }
   }
}

