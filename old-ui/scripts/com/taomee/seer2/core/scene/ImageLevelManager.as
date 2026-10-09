package com.taomee.seer2.core.scene
{
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import com.taomee.seer2.core.ui.ImagePanel;
   import flash.display.Stage;
   import flash.net.SharedObject;
   
   public class ImageLevelManager
   {
      
      private static var _stage:Stage;
      
      public static var _isShow:Boolean = false;
      
      public function ImageLevelManager()
      {
         super();
      }
      
      public static function setStage(param1:Stage) : void
      {
         _stage = param1;
      }
      
      public static function showImagePanel() : void
      {
         if(!_isShow)
         {
            ImagePanel.showImage(_stage);
            _isShow = true;
         }
      }
      
      public static function setFightImageLevel(param1:String) : void
      {
         if(_stage.quality == param1)
         {
            return;
         }
         setSo("imageFightLevelIndex","image_fight_level_index",param1);
         _stage.quality = param1;
      }
      
      public static function setImageLevel(param1:String) : void
      {
         if(_stage.quality == param1)
         {
            return;
         }
         setSo("imageLevelIndex","image_level_index",param1);
         _stage.quality = param1;
      }
      
      public static function getImageQuality() : String
      {
         return getImageSoLevel("imageLevelIndex","image_level_index");
      }
      
      public static function getFightImageQuality() : String
      {
         return getImageSoLevel("imageFightLevelIndex","image_fight_level_index");
      }
      
      private static function getImageSoLevel(param1:String, param2:String) : String
      {
         var _loc4_:SharedObject = null;
         var _loc3_:Object = null;
         if(isActivityAnimationPlayed(param1,param2))
         {
            _loc4_ = SharedObjectManager.getUserSharedObject(param1);
            _loc3_ = _loc4_.data[param2];
            return _loc3_.imageLevel;
         }
         return "";
      }
      
      private static function setSo(param1:String, param2:String, param3:String) : void
      {
         var _loc5_:SharedObject = null;
         _loc5_ = SharedObjectManager.getUserSharedObject(param1);
         _loc5_.clear();
         param2 = param2;
         var _loc4_:Object = {};
         _loc5_.data[param2] = _loc4_;
         _loc4_.imageLevel = param3;
         SharedObjectManager.flush(_loc5_);
      }
      
      private static function isActivityAnimationPlayed(param1:String, param2:String) : Boolean
      {
         var _loc3_:SharedObject = SharedObjectManager.getUserSharedObject(param1);
         param2 = param2;
         if(_loc3_.data[param2] == null)
         {
            return false;
         }
         return true;
      }
   }
}

