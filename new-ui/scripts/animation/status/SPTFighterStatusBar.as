package animation.status
{
   import ui.status.UI_FightSPTFighterStatusBarBack;
   import utils.an.DisplayUtil;
   
   internal class SPTFighterStatusBar extends BaseFighterStatusBar
   {
      
      public function SPTFighterStatusBar(param1:int)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._back = new UI_FightSPTFighterStatusBarBack();
         addChild(this._back);
         super.createChildren();
      }
      
      override protected function layout(param1:int) : void
      {
         super.layout(param1);
         var _loc2_:Function = DisplayUtil.setChildPosition;
         _loc2_(_hpSign,200,34);
         _loc2_(_angerSign,200,51);
      }
   }
}

