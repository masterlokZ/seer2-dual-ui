package com.taomee.seer2.app.plant.data
{
   import com.taomee.seer2.app.config.SeedConfig;
   import com.taomee.seer2.core.manager.TimeManager;
   import flash.utils.IDataInput;
   
   public class PlantTotalInfo
   {
      
      public var userId:uint;
      
      public var infoList:Vector.<PlantInfo> = Vector.<PlantInfo>([]);
      
      public function PlantTotalInfo()
      {
         super();
      }
      
      public function parseInfo(param1:IDataInput) : void
      {
         var _loc5_:uint = 0;
         var _loc3_:uint = 0;
         var _loc2_:PlantInfo = null;
         this.userId = param1.readUnsignedInt();
         this.initInfo();
         var _loc4_:uint = param1.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc3_ = param1.readUnsignedInt();
            for each(_loc2_ in this.infoList)
            {
               if(_loc2_.plantId == _loc3_)
               {
                  _loc2_.userId = _loc5_;
                  _loc2_.parseInfo(param1);
                  _loc2_.seedInfo = SeedConfig.getSeedInfo(_loc2_.plantSeedId);
               }
            }
            _loc6_++;
         }
      }
      
      public function initInfo() : void
      {
         var _loc2_:PlantInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < 16)
         {
            _loc2_ = new PlantInfo();
            _loc2_.parseInit(_loc1_);
            this.infoList.push(_loc2_);
            _loc1_++;
         }
         _loc2_ = new PlantInfo();
         _loc2_.parseInit(1000);
         this.infoList.push(_loc2_);
      }
      
      public function initUpdateInfo() : void
      {
         var _loc1_:PlantInfo = null;
         for each(_loc1_ in this.infoList)
         {
            if(_loc1_.plantSeedId != 0)
            {
               _loc1_.serTime = TimeManager.getServerTime();
               _loc1_.updateInfo();
            }
         }
      }
      
      public function updateInfo() : void
      {
         var _loc1_:PlantInfo = null;
         for each(_loc1_ in this.infoList)
         {
            if(_loc1_.plantSeedId != 0)
            {
               _loc1_.updateInfo();
            }
         }
      }
   }
}

