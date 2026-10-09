package com.taomee.seer2.app.gameRule.door.support
{
   public class DoorSupportInfo
   {
      
      public var doorRule:int;
      
      public var doorType:int;
      
      public var doorStartPanel:String;
      
      public var currentDoorLevel:uint = 1;
      
      public var reset:Boolean = false;
      
      public var neverToMaxLevel:Boolean = true;
      
      private var _targetMapId:uint;
      
      public function DoorSupportInfo(param1:int, param2:int, param3:uint, param4:String)
      {
         this.doorRule = param1;
         this.doorType = param2;
         this._targetMapId = param3;
         this.doorStartPanel = param4;
         super();
      }
      
      public function get fightMode() : int
      {
         if(this.doorType == 0)
         {
            return 4;
         }
         if(this.doorType == 1)
         {
            return 5;
         }
         if(this.doorType == 3)
         {
            return 103;
         }
         if(this.doorType == 2)
         {
            return 102;
         }
         return 0;
      }
      
      public function get targetMapId() : uint
      {
         if(this.doorRule == 5 && this.doorType == 0)
         {
            if(this.currentDoorLevel <= 21)
            {
               this._targetMapId = 420;
            }
            else
            {
               this._targetMapId = 421;
            }
         }
         return this._targetMapId;
      }
      
      public function set targetMapId(param1:uint) : void
      {
         this._targetMapId = param1;
      }
   }
}

