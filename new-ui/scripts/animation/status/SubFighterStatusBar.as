package animation.status
{
   import ui.status.UI_SubFightStatusBarBack;
   
   public class SubFighterStatusBar extends BaseFighterStatusBar
   {
      
      public function SubFighterStatusBar(param1:int)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._back = new UI_SubFightStatusBarBack();
         addChild(this._back);
         super.createChildren();
         this._healthShadowBar.visible = false;
         this._hpSign.visible = false;
         this._angerSign.visible = false;
      }
      
      override protected function layout(param1:int) : void
      {
         super.layout(param1);
         this._typeIcon.x = this._iconCover.x + this._iconCover.width - 23;
         this._typeIcon.y = 0;
         this._typeIcon.setScale(0.75,0.75);
         if(param1 == 2)
         {
            this._typeIcon.x += 30;
         }
      }
   }
}

