package animation.common
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import ui.common.UI_multipleTooltip;
   import utils.an.DisplayObjectUtil;
   
   public class TipsDisplay extends Sprite
   {
      
      private var _tipSkin:MovieClip;
      
      private var _tipTxt:TextField;
      
      private var _back:MovieClip;
      
      private var _source:Sprite;
      
      private var _tips:String;
      
      private var _left:Boolean;
      
      public function TipsDisplay(param1:Sprite)
      {
         super();
         addChild(param1);
         _tipSkin = new UI_multipleTooltip();
         _tipTxt = _tipSkin["tipTxt"];
         _tipTxt.width = 160;
         _tipTxt.wordWrap = true;
         _tipTxt.autoSize = "left";
         _back = _tipSkin["backMC"];
         DisplayObjectUtil.disableSprite(_tipSkin);
         _source = param1;
         _source.addEventListener("rollOver",this.onTargetOver);
         _source.addEventListener("rollOut",this.onTargetOut);
      }
      
      public function initData(param1:String) : void
      {
         this._tips = param1;
      }
      
      private function onTargetOver(param1:MouseEvent) : void
      {
         if(!_tips)
         {
            return;
         }
         this._tipTxt.htmlText = _tips || "";
         _back.width = _tipTxt.textWidth + 20;
         _back.height = _tipTxt.textHeight + 20;
         this.deployTooltip();
         stage.addChild(_tipSkin);
      }
      
      private function onTargetOut(param1:MouseEvent) : void
      {
         DisplayObjectUtil.removeFromParent(_tipSkin);
      }
      
      private function deployTooltip() : void
      {
         var _loc1_:Point = _source.localToGlobal(new Point(0,0));
         if(_left)
         {
            this._tipSkin.x = _loc1_.x - this._tipSkin.width;
         }
         else
         {
            this._tipSkin.x = _loc1_.x + this._source.width;
         }
         this._tipSkin.y = _loc1_.y + this._source.height;
      }
      
      public function setLeft(param1:Boolean) : void
      {
         this._left = param1;
      }
   }
}

