package com.taomee.seer2.core.utils
{
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class LabelRenderer
   {
      
      private static var _tf:TextField;
      
      private static var _tfFormat:TextFormat;
      
      private static var _top:Matrix = new Matrix(1,0,0,1,1,0);
      
      private static var _left:Matrix = new Matrix(1,0,0,1,0,1);
      
      private static var _right:Matrix = new Matrix(1,0,0,1,2,1);
      
      private static var _bottom:Matrix = new Matrix(1,0,0,1,1,2);
      
      private static var _center:Matrix = new Matrix(1,0,0,1,1,1);
      
      initialize();
      
      public function LabelRenderer(param1:Blocker)
      {
         super();
      }
      
      private static function initialize() : void
      {
         _tf = new TextField();
         _tfFormat = new TextFormat("_sans",12);
         _tf.defaultTextFormat = _tfFormat;
      }
      
      public static function getLabelImage(param1:String, param2:uint = 255, param3:uint = 16777215, param4:uint = 12) : Bitmap
      {
         var _loc5_:TextField = null;
         var _loc7_:BitmapData = null;
         var _loc6_:Bitmap = new Bitmap();
         if(param4 != 12)
         {
            _tf.defaultTextFormat = new TextFormat("_sans",param4);
         }
         _loc5_ = changeTextField(param1,param2);
         _loc5_.defaultTextFormat = _tfFormat;
         _loc7_ = new BitmapData(_loc5_.width + 2,_loc5_.height + 2,true,16777215);
         _loc7_.draw(changeTextField(param1,param3),_top);
         _loc7_.draw(changeTextField(param1,param3),_left);
         _loc7_.draw(changeTextField(param1,param3),_right);
         _loc7_.draw(changeTextField(param1,param3),_bottom);
         _loc7_.draw(changeTextField(param1,param2),_center);
         _loc6_.bitmapData = _loc7_;
         return _loc6_;
      }
      
      public static function getYearVipImage(param1:String, param2:uint = 255, param3:uint = 16777215, param4:uint = 12) : Bitmap
      {
         var _loc6_:TextField = null;
         var _loc5_:Sprite = null;
         var _loc7_:Bitmap = new Bitmap();
         if(param4 != 12)
         {
            _tf.defaultTextFormat = new TextFormat("_sans",param4);
         }
         _loc6_ = changeTextField(param1,param2);
         _loc6_.defaultTextFormat = _tfFormat;
         var _loc10_:Number = _loc6_.textWidth + 2;
         var _loc8_:Sprite = UIManager.getMovieClip("YearVipIconBg") as Sprite;
         _loc5_ = new Sprite();
         _loc5_.addChild(_loc8_);
         if(_loc10_ / 40 > 1)
         {
            _loc8_.scaleX = _loc10_ / 40;
         }
         _loc5_.addChild(_loc6_);
         _loc6_.x = _loc8_.x + (_loc8_.width - _loc6_.width) / 2;
         _loc6_.y = _loc8_.y + (_loc8_.height - _loc6_.height) / 2 + 3;
         var _loc9_:BitmapData = new BitmapData(_loc5_.width + 2,_loc5_.height + 2,true,16777215);
         changeTextField(param1,param3);
         _loc9_.draw(_loc5_,_top);
         changeTextField(param1,param3);
         _loc9_.draw(_loc5_,_left);
         changeTextField(param1,param3);
         _loc9_.draw(_loc5_,_right);
         changeTextField(param1,param3);
         _loc9_.draw(_loc5_,_bottom);
         changeTextField(param1,param2);
         _loc9_.draw(_loc5_,_center);
         _loc7_.bitmapData = _loc9_;
         return _loc7_;
      }
      
      private static function changeTextField(param1:String, param2:uint) : TextField
      {
         _tf.autoSize = "left";
         _tf.textColor = param2;
         _tf.text = param1;
         return _tf;
      }
   }
}

class Blocker
{
   
   public function Blocker()
   {
      super();
   }
}
