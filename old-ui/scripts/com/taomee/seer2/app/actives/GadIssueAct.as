package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class GadIssueAct
   {
      
      private static var _instance:GadIssueAct;
      
      private var swapid:uint = 1493;
      
      private var limit1142:uint = 202299;
      
      private var petIds:Array = [365,366,388];
      
      private var fightIds:Array = [459,460,461];
      
      public function GadIssueAct()
      {
         super();
      }
      
      public static function getInstance() : GadIssueAct
      {
         if(!_instance)
         {
            _instance = new GadIssueAct();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         Connection.addCommandListener(CommandSet.PET_SPAWN_1103,this.spawnPet);
      }
      
      private function spawnPet(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_SPAWN_1103,this.spawnPet);
         SwapManager.swapItem(this.swapid,1,this.swapComplete);
      }
      
      private function swapComplete(param1:IDataInput) : void
      {
         ActiveCountManager.requestActiveCount(this.limit1142,this.getPetState);
      }
      
      private function getPetState(param1:int, param2:int) : void
      {
         param2 = param2;
         if(param2 == 0 || param2 > 3)
         {
            return;
         }
         var _loc5_:int = int(this.petIds[param2 - 1]);
         var _loc4_:int = int(this.fightIds[param2 - 1]);
         var _loc3_:SpawnedPet = new SpawnedPet(_loc5_,_loc4_,0);
         MobileManager.addMobile(_loc3_,"spawnedPet");
      }
   }
}

