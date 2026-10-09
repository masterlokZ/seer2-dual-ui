package com.taomee.seer2.core.ui
{
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.NumberUtil;
   import flash.display.Sprite;
   import org.taomee.ds.HashMap;
   
   public class UINumberGenerator
   {
      
      private static var _poolMap:HashMap;
      
      initialize();
      
      public function UINumberGenerator()
      {
         super();
      }
      
      private static function initialize() : void
      {
         _poolMap = new HashMap();
      }
      
      public static function generateItemNumber(param1:int) : Sprite
      {
         return generateNumberSprite(param1,"UI_NumberItem",7);
      }
      
      public static function generateLoaderNumber(param1:int) : Sprite
      {
         return generateNumberSprite(param1,"UI_NumberLoader",13);
      }
      
      public static function generateFighterLevelNumber(param1:int, param2:uint = 11) : Sprite
      {
         var _loc3_:String = "UI_NumberPetLevel";
         return generateNumberSprite(param1,_loc3_,param2);
      }
      
      public static function generateAngerIncreaseNumber(param1:int) : Sprite
      {
         var _loc2_:String = "UI_NumberAngerIncrease";
         return generateNumberSprite(param1,_loc2_,36);
      }
      
      public static function generateHpNumber(param1:int, param2:int) : Sprite
      {
         var _loc3_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc7_:String = "UI_NumberHp";
         recyleDigitSprite(_loc7_);
         var _loc6_:Sprite = createDisableSprite();
         var _loc4_:Sprite = generateNumberSprite(param1,_loc7_,11);
         _loc6_.addChild(_loc4_);
         _loc3_ = UIManager.getSprite(_loc7_ + "Slash");
         _loc3_.x = _loc4_.width;
         _loc6_.addChild(_loc3_);
         _loc5_ = generateNumberSprite(param2,_loc7_,11);
         _loc5_.x = _loc3_.x + _loc3_.width;
         _loc6_.addChild(_loc5_);
         return _loc6_;
      }
      
      public static function generateAngerNumber(param1:int, param2:int) : Sprite
      {
         var _loc3_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc7_:String = "UI_NumberAnger";
         recyleDigitSprite(_loc7_);
         var _loc6_:Sprite = createDisableSprite();
         var _loc4_:Sprite = generateNumberSprite(param1,_loc7_,11);
         _loc6_.addChild(_loc4_);
         _loc3_ = UIManager.getSprite(_loc7_ + "Slash");
         _loc3_.x = _loc4_.width;
         _loc6_.addChild(_loc3_);
         _loc5_ = generateNumberSprite(param2,_loc7_,11);
         _loc5_.x = _loc3_.x + _loc3_.width;
         _loc6_.addChild(_loc5_);
         return _loc6_;
      }
      
      private static function recyleDigitSprite(param1:String) : void
      {
         var _loc2_:DigitSpritePool = getDigitSpritePool(param1);
         _loc2_.recycle();
      }
      
      private static function generateNumberSprite(param1:int, param2:String, param3:int) : Sprite
      {
         var _loc5_:* = undefined;
         var _loc9_:Sprite = null;
         var _loc7_:int = 0;
         var _loc10_:DigitSpritePool = getDigitSpritePool(param2);
         var _loc6_:Sprite = createDisableSprite();
         _loc5_ = NumberUtil.parseNumberToDigitVec(param1);
         var _loc8_:int = int(_loc5_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc8_)
         {
            _loc7_ = _loc5_[_loc4_];
            _loc9_ = _loc10_.checkOut(_loc7_);
            _loc9_.x = _loc4_ * param3;
            _loc6_.addChild(_loc9_);
            _loc4_++;
         }
         return _loc6_;
      }
      
      private static function getDigitSpritePool(param1:String) : DigitSpritePool
      {
         if(_poolMap.containsKey(param1) == false)
         {
            _poolMap.add(param1,new DigitSpritePool(param1));
         }
         return _poolMap.getValue(param1) as DigitSpritePool;
      }
      
      private static function createDisableSprite() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         DisplayObjectUtil.disableSprite(_loc1_);
         return _loc1_;
      }
   }
}

