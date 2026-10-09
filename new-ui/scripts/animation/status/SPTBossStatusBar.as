package animation.status
{
   import ui.status.UI_FightSPTBossStatusBarBack;
   import utils.an.DisplayUtil;
   
   internal class SPTBossStatusBar extends BaseFighterStatusBar
   {
      
      public function SPTBossStatusBar(param1:int)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._back = new UI_FightSPTBossStatusBarBack();
         addChild(this._back);
         super.createChildren();
         this._iconDisplayer.scaleX = -1;
      }
      
      override protected function layout(param1:int) : void
      {
         var _loc2_:Function = DisplayUtil.setChildPosition;
         _loc2_(this._iconDisplayer,this._iconCover.x + this._iconCover.width,this._iconCover.y);
         _loc2_(this._levelSprite,this._levelBg.x + 1,this._levelBg.y + 2);
         _loc2_(this._typeIcon,this._levelBg.x - 16,this._levelBg.y);
         _loc2_(this._hpSign,520,12);
         _loc2_(this._angerSign,570,33);
      }
   }
}

