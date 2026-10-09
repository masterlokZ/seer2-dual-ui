package animation.status
{
   import ui.status.UI_DoubleFightStatusBarBack;
   import utils.an.DisplayUtil;
   
   public class DoubleFighterStatusBar extends BaseFighterStatusBar
   {
      
      public function DoubleFighterStatusBar(param1:int)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._back = new UI_DoubleFightStatusBarBack();
         addChild(this._back);
         super.createChildren();
      }
      
      override protected function layout(param1:int) : void
      {
         super.layout(param1);
         var _loc2_:Function = DisplayUtil.setChildPosition;
         _loc2_(this._hpSign,173,12);
         _loc2_(this._angerSign,173,32);
         this._typeIcon.x = this._iconCover.x + this._iconCover.width - 30;
         this._typeIcon.y = 0;
         this._typeIcon.setScale(1,1);
         if(param1 == 2)
         {
            this._typeIcon.x += 40;
         }
      }
   }
}

