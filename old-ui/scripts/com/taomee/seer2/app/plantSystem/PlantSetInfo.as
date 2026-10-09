package com.taomee.seer2.app.plantSystem
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.plant.event.PlantEventControl;
   import flash.utils.IDataInput;
   
   public class PlantSetInfo
   {
      
      public var swapCoins:uint;
      
      public var itemID:uint;
      
      public var itemCount:uint;
      
      public var addSwapIdList:Vector.<uint>;
      
      public var addSwapCountList:Vector.<uint>;
      
      public function PlantSetInfo(param1:IDataInput)
      {
         super();
         if(param1 != null)
         {
            this.deleteItem(param1);
            this.addItem(param1);
            PlantEventControl.dispatchEvent("libraryChange",null);
         }
      }
      
      private function deleteItem(param1:IDataInput) : void
      {
         var _loc5_:uint = 0;
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedShort();
            _loc2_ = param1.readUnsignedInt();
            if(_loc5_ == 1)
            {
               ActorManager.actorInfo.coins -= _loc3_;
            }
            else
            {
               ItemManager.reduceItemQuantity(_loc5_,_loc3_);
            }
            _loc6_++;
         }
      }
      
      private function addItem(param1:IDataInput) : void
      {
         var _loc5_:uint = 0;
         var _loc3_:uint = 0;
         var _loc2_:uint = 0;
         var _loc4_:uint = param1.readUnsignedInt();
         this.swapCoins = 0;
         this.addSwapIdList = Vector.<uint>([]);
         this.addSwapCountList = Vector.<uint>([]);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedShort();
            _loc2_ = param1.readUnsignedInt();
            this.addSwapIdList.push(_loc5_);
            this.addSwapCountList.push(_loc3_);
            this.itemID = _loc5_;
            this.itemCount = _loc3_;
            if(ItemConfig.getItemDefinition(_loc5_) != null)
            {
               if(_loc5_ == 1)
               {
                  ActorManager.actorInfo.coins += _loc3_;
                  this.swapCoins = _loc3_;
               }
               else if(!ItemConfig.getItemDefinition(_loc5_).isHide)
               {
                  ItemManager.addItem(_loc5_,_loc3_,_loc2_);
               }
            }
            _loc6_++;
         }
      }
   }
}

