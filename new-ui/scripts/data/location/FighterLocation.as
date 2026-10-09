package data.location
{
   public class FighterLocation
   {
      
      public static var MAIN_FIGHTER_Y:int = 50;
      
      public static var SUB_FIGHTER_Y:int = -5;
      
      public static var FIX_SCALE:Number = 0.55;
      
      public static var WIDTH:Number = 1200;
      
      public static var HEIGHT:Number = 660;
      
      public var targetX:Number = 0;
      
      public var targetY:Number = 0;
      
      public var targetScaleX:Number = 1;
      
      public var targetScaleY:Number = 1;
      
      public function FighterLocation()
      {
         super();
      }
      
      public static function build(param1:int, param2:int) : FighterLocation
      {
         var _loc3_:FighterLocation = new FighterLocation();
         if(param2 == 1)
         {
            if(param1 == 2)
            {
               _loc3_.targetScaleX = -1;
               _loc3_.targetX = WIDTH - 120;
            }
            else
            {
               _loc3_.targetScaleX = 1;
               _loc3_.targetX = 120;
            }
            _loc3_.targetScaleY = 1;
            _loc3_.targetY += MAIN_FIGHTER_Y;
         }
         else
         {
            if(param1 == 2)
            {
               _loc3_.targetScaleX = -1 * FIX_SCALE;
               _loc3_.targetX = ((1 - FIX_SCALE) / 2 + FIX_SCALE) * WIDTH - 120;
            }
            else
            {
               _loc3_.targetScaleX = FIX_SCALE;
               _loc3_.targetX = (1 - FIX_SCALE) * WIDTH / 2 + 120;
            }
            _loc3_.targetScaleY = FIX_SCALE;
            _loc3_.targetY = (1 - FIX_SCALE) * HEIGHT / 2;
            _loc3_.targetY += SUB_FIGHTER_Y * FIX_SCALE;
         }
         return _loc3_;
      }
   }
}

