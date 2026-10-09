package animation.status
{
   import utils.an.DisplayUtil;
   
   public class SPTFightStatusPanel extends FightStatusPanel
   {
      
      public function SPTFightStatusPanel()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:Function = DisplayUtil.replaceChild;
         _leftMainFighterBar = _loc1_(_leftMainFighterBar,new SPTFighterStatusBar(1));
         _rightMainFighterBar = _loc1_(_rightMainFighterBar,new SPTBossStatusBar(2));
      }
      
      override protected function layout() : void
      {
         _rightCapsuleBar.scaleX *= -1;
         this._title.y = 35;
         this._weatherDisplay.y = 74;
         var _loc1_:Function = DisplayUtil.setChildPosition;
         _loc1_(_leftMainFighterBar,0,20);
         _loc1_(_rightMainFighterBar,410,0);
         _loc1_(_leftCapsuleBar,4,130);
         _loc1_(_leftBuffIconBar,106,92);
         _loc1_(_rightCapsuleBar,1194,130);
         _loc1_(_rightBuffIconBar,978,54);
      }
   }
}

