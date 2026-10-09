package ui
{
   import flash.display.Sprite;
   import ui.number.UI_NumberAngerN;
   import ui.number.UI_NumberAngerSlash;
   import ui.number.UI_NumberHpN;
   import ui.number.UI_NumberHpSlash;
   import ui.number.UI_NumberItemN;
   import ui.number.UI_NumberPetLevelN;
   import utils.NumberUtil;
   import utils.an.DisplayObjectUtil;
   
   public class UINumberGenerator
   {
      
      public function UINumberGenerator()
      {
         super();
      }
      
      public static function generateItemNumber(param1:int) : Sprite
      {
         return generateNumberSprite(param1,UI_NumberItemN.find,7);
      }
      
      public static function generateFighterLevelNumber(param1:int, param2:uint = 11) : Sprite
      {
         return generateNumberSprite(param1,UI_NumberPetLevelN.find,param2);
      }
      
      public static function generateHpNumber(param1:int, param2:int) : Sprite
      {
         var _loc3_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc6_:Sprite = createDisableSprite();
         var _loc4_:Sprite = generateNumberSprite(param1,UI_NumberHpN.find,11);
         _loc4_.x = -_loc4_.width - 6;
         _loc6_.addChild(_loc4_);
         _loc3_ = new UI_NumberHpSlash();
         _loc3_.x = -6;
         _loc6_.addChild(_loc3_);
         _loc5_ = generateNumberSprite(param2,UI_NumberHpN.find,11);
         _loc5_.x = 6;
         _loc6_.addChild(_loc5_);
         return _loc6_;
      }
      
      public static function generateAngerNumber(param1:int, param2:int) : Sprite
      {
         var _loc3_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc6_:Sprite = createDisableSprite();
         var _loc4_:Sprite = generateNumberSprite(param1,UI_NumberAngerN.find,11);
         _loc4_.x = -_loc4_.width - 6;
         _loc6_.addChild(_loc4_);
         _loc3_ = new UI_NumberAngerSlash();
         _loc3_.x = -6;
         _loc6_.addChild(_loc3_);
         _loc5_ = generateNumberSprite(param2,UI_NumberAngerN.find,11);
         _loc5_.x = 6;
         _loc6_.addChild(_loc5_);
         return _loc6_;
      }
      
      private static function generateNumberSprite(param1:int, param2:Function, param3:int) : Sprite
      {
         var _loc5_:* = undefined;
         var _loc9_:Sprite = null;
         var _loc7_:int = 0;
         var _loc6_:Sprite = createDisableSprite();
         _loc5_ = NumberUtil.parseNumberToDigitVec(param1);
         var _loc8_:int = int(_loc5_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc8_)
         {
            _loc7_ = _loc5_[_loc4_];
            _loc9_ = new (param2(_loc7_))();
            _loc9_.x = _loc4_ * param3;
            _loc6_.addChild(_loc9_);
            _loc4_++;
         }
         return _loc6_;
      }
      
      private static function createDisableSprite() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         DisplayObjectUtil.disableSprite(_loc1_);
         return _loc1_;
      }
   }
}

