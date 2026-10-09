package animation.status
{
   import ui.status.UI_FightStatusBarBack;
   import utils.an.DisplayUtil;
   
   public class FighterStatusBar extends BaseFighterStatusBar
   {
      
      public function FighterStatusBar(param1:int)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._back = new UI_FightStatusBarBack();
         addChild(this._back);
         super.createChildren();
      }
      
      override protected function layout(param1:int) : void
      {
         super.layout(param1);
         this._healthShadowBar.visible = false;
         var _loc2_:Function = DisplayUtil.setChildPosition;
         _loc2_(this._hpSign,220,11);
         _loc2_(this._angerSign,220,32);
      }
   }
}

