package com.taomee.seer2.app.controls
{
   import com.taomee.seer2.app.controls.righttoolbar.IShowable;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.Sprite;
   
   public class RightMinorToolBar extends Sprite
   {
      
      private static var _instance:RightMinorToolBar;
      
      private var _buttons:Array;
      
      public function RightMinorToolBar()
      {
         var _loc1_:Sprite = null;
         this._buttons = [];
         super();
         var _loc2_:uint = 0;
         for each(_loc1_ in this._buttons)
         {
            _loc1_.y += _loc2_;
            _loc2_ += 77;
            addChild(_loc1_);
         }
      }
      
      private static function get instance() : RightMinorToolBar
      {
         if(_instance == null)
         {
            _instance = new RightMinorToolBar();
            _instance.x = 899;
            _instance.y = 130;
         }
         return _instance;
      }
      
      public static function show() : void
      {
         instance._show();
      }
      
      public static function hide() : void
      {
         instance._hide();
      }
      
      private function _show() : void
      {
         var _loc1_:IShowable = null;
         LayerManager.uiLayer.addChild(this);
         for each(_loc1_ in this._buttons)
         {
            _loc1_.show();
         }
      }
      
      private function _hide() : void
      {
         DisplayObjectUtil.removeFromParent(this);
      }
   }
}

