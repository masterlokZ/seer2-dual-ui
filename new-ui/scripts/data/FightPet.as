package data
{
   import data.location.FighterLocation;
   import flash.display.MovieClip;
   import ui.PetFallback;
   
   public class FightPet
   {
      
      public static const UNREACHABLE_URL:String = "unreachable";
      
      public var side:int;
      
      public var position:int;
      
      public var depth:int;
      
      public var x:Number;
      
      public var y:Number;
      
      public var scaleX:Number;
      
      public var scaleY:Number;
      
      public var url:String;
      
      public var pet:MovieClip;
      
      public function FightPet()
      {
         super();
      }
      
      public static function build(param1:int, param2:int) : FightPet
      {
         var _loc3_:FightPet = new FightPet();
         _loc3_.side = param1;
         _loc3_.position = param2;
         if(param1 === 2)
         {
            _loc3_.depth += 1;
         }
         if(param2 === 1)
         {
            _loc3_.depth += 2;
         }
         var _loc4_:FighterLocation = FighterLocation.build(param1,param2);
         _loc3_.x = _loc4_.targetX;
         _loc3_.y = _loc4_.targetY;
         _loc3_.scaleX = _loc4_.targetScaleX;
         _loc3_.scaleY = _loc4_.targetScaleY;
         _loc3_.url = "unreachable";
         _loc3_.pet = new PetFallback();
         _loc3_.pet.visible = false;
         return _loc3_;
      }
   }
}

