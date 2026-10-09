package animation.status
{
   import animation.common.IconDisplay;
   import animation.common.NumDisplay;
   import animation.common.TipsDisplay;
   import data.pet.BuffData;
   import flash.display.Sprite;
   import utils.an.DisplayObjectUtil;
   
   internal class BuffIcon extends Sprite
   {
      
      private static const ICON_WIDTH:int = 32;
      
      private var _buff:BuffData;
      
      private var _icon:IconDisplay;
      
      private var _tips:TipsDisplay;
      
      private var _numDisplay:NumDisplay;
      
      private var _showNumMin:int;
      
      public function BuffIcon()
      {
         super();
         var _loc1_:Sprite = new Sprite();
         this._icon = new IconDisplay();
         _icon.setSize(32);
         _loc1_.addChild(this._icon);
         this._numDisplay = new NumDisplay();
         _numDisplay.x = 0;
         _numDisplay.y = 15;
         _numDisplay.visible = false;
         this._showNumMin = 2;
         _loc1_.addChild(this._numDisplay);
         this._tips = new TipsDisplay(_loc1_);
         addChild(this._tips);
         DisplayObjectUtil.disableSprite(_numDisplay);
      }
      
      public function initData(param1:BuffData) : void
      {
         this._buff = param1;
         this._icon.initData(param1.icon);
         this._tips.initData(param1.tips || "无");
         if(param1.count >= _showNumMin)
         {
            this._numDisplay.initData(param1.count);
            this._numDisplay.visible = true;
         }
         else
         {
            this._numDisplay.visible = false;
         }
      }
      
      public function setShowNumMin(param1:int) : void
      {
         this._showNumMin = param1;
      }
   }
}

