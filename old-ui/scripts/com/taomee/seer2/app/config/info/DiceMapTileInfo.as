package com.taomee.seer2.app.config.info
{
   import com.taomee.seer2.app.config.DiceMapThingConfig;
   
   public class DiceMapTileInfo
   {
      
      public var seat:int;
      
      public var thingType:String;
      
      public var thingId:String;
      
      public var x:int;
      
      public var y:int;
      
      public function DiceMapTileInfo()
      {
         super();
      }
      
      public function get thingNum() : int
      {
         var _loc1_:int = 0;
         switch(this.thingType)
         {
            case "lucky":
               _loc1_ = DiceMapThingConfig.luckyThingNum;
               break;
            case "box":
               _loc1_ = DiceMapThingConfig.boxThingNum;
               break;
            case "chance":
               _loc1_ = DiceMapThingConfig.chanceThingNum;
               break;
            case "addMoney":
               _loc1_ = DiceMapThingConfig.addMoneyThingNum;
               break;
            case "subMoney":
               _loc1_ = DiceMapThingConfig.subMoneyThingNum;
               break;
            case "fight":
               _loc1_ = DiceMapThingConfig.petFightThingNum;
               break;
            case "reverse":
               _loc1_ = DiceMapThingConfig.reverseThingNum;
         }
         return _loc1_;
      }
   }
}

