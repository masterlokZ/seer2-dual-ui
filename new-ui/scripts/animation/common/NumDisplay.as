package animation.common
{
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class NumDisplay extends MovieClip
   {
      
      private var _textField:TextField;
      
      private var _num:int;
      
      public function NumDisplay()
      {
         super();
         var _loc2_:TextField = new TextField();
         var _loc3_:TextFormat = new TextFormat("_sans",12);
         _loc3_.align = "right";
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.textColor = 16777215;
         _loc2_.text = _num + "";
         _loc2_.width = 32;
         _loc2_.height = 17;
         var _loc1_:GlowFilter = new GlowFilter();
         _loc1_.color = 3342336;
         _loc1_.alpha = 1;
         _loc1_.blurX = 2;
         _loc1_.blurY = 2;
         _loc1_.strength = 100;
         _loc1_.quality = 3;
         _loc1_.inner = false;
         _loc1_.knockout = false;
         _loc2_.filters = [_loc1_];
         addChild(_loc2_);
         this._textField = _loc2_;
      }
      
      public function initData(param1:int) : void
      {
         if(this._num === param1)
         {
            return;
         }
         this._num = param1;
         if(_num > 9999)
         {
            this._textField.text = "1w+";
         }
         else
         {
            this._textField.text = _num + "";
         }
      }
   }
}

