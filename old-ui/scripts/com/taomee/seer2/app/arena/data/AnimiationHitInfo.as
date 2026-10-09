package com.taomee.seer2.app.arena.data
{
   public class AnimiationHitInfo
   {
      
      public var id:uint;
      
      public var physics:uint;
      
      public var attribute:uint;
      
      public var special:uint;
      
      public var critical:uint;
      
      public var fit:uint;
      
      public var physicsArray:Array;
      
      public var attributeArray:Array;
      
      public var specialArray:Array;
      
      public var criticalArray:Array;
      
      public var fitArray:Array;
      
      public var hasArray:Boolean;
      
      public function AnimiationHitInfo()
      {
         super();
      }
      
      public function getHitValue(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case "物理攻击":
               _loc2_ = int(this.physics);
               break;
            case "属性攻击":
               _loc2_ = int(this.attribute);
               break;
            case "特殊攻击":
               _loc2_ = int(this.special);
               break;
            case "必杀":
               _loc2_ = int(this.critical);
               break;
            case "合体攻击":
               _loc2_ = int(this.fit);
         }
         return int(_loc2_ / 1.07);
      }
      
      public function getHitArray(param1:String) : Array
      {
         var _loc3_:Array = null;
         var hit:int = 0;
         if(!hasArray)
         {
            hit = getHitValue(param1);
            hit = int(hit == 0 ? 1 : hit);
            return [hit];
         }
         switch(param1)
         {
            case "物理攻击":
               _loc3_ = this.physicsArray;
               break;
            case "属性攻击":
               _loc3_ = this.attributeArray;
               break;
            case "特殊攻击":
               _loc3_ = this.specialArray;
               break;
            case "必杀":
               _loc3_ = this.criticalArray;
               break;
            case "合体攻击":
               _loc3_ = this.fitArray;
         }
         return _loc3_;
      }
   }
}

