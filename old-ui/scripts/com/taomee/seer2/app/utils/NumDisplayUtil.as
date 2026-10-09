package com.taomee.seer2.app.utils
{
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class NumDisplayUtil
   {
      
      public function NumDisplayUtil()
      {
         super();
      }
      
      public static function getNumDisplay(param1:int, param2:String, param3:int) : Sprite
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Sprite = new Sprite();
         var _loc5_:String = param1.toString();
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc6_ = UIManager.getMovieClip(param2 + _loc5_.charAt(_loc4_));
            _loc6_.x = _loc4_ * param3;
            _loc7_.addChild(_loc6_);
            _loc4_++;
         }
         return _loc7_;
      }
   }
}

