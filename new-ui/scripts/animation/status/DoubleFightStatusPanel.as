package animation.status
{
   import data.pet.ArenaData;
   import utils.an.DisplayUtil;
   
   public class DoubleFightStatusPanel extends FightStatusPanel
   {
      
      private var _leftSubFighterBar:SubFighterStatusBar;
      
      private var _rightSubFighterBar:SubFighterStatusBar;
      
      public function DoubleFightStatusPanel()
      {
         super();
      }
      
      override public function initData(param1:ArenaData, param2:int) : void
      {
         super.initData(param1,param2);
         this._leftSubFighterBar.initData(param1.left.slave,param2);
         this._rightSubFighterBar.initData(param1.right.slave,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _leftSubFighterBar = new SubFighterStatusBar(1);
         addChild(_leftSubFighterBar);
         _rightSubFighterBar = new SubFighterStatusBar(2);
         addChild(_rightSubFighterBar);
         var _loc1_:Function = DisplayUtil.replaceChild;
         _leftMainFighterBar = _loc1_(_leftMainFighterBar,new DoubleFighterStatusBar(1));
         _rightMainFighterBar = _loc1_(_rightMainFighterBar,new DoubleFighterStatusBar(2));
         _leftBuffIconBar = _loc1_(_leftBuffIconBar,new BuffIconBar(1,5));
         _rightBuffIconBar = _loc1_(_rightBuffIconBar,new BuffIconBar(2,5));
      }
      
      override protected function layout() : void
      {
         _rightCapsuleBar.scaleX *= -1;
         var _loc1_:Function = DisplayUtil.setChildPosition;
         _loc1_(_rightMainFighterBar,1200,0);
         _loc1_(_leftBuffIconBar,85,55);
         _loc1_(_rightBuffIconBar,1083,55);
         _loc1_(_leftCapsuleBar,6,125);
         _loc1_(_rightCapsuleBar,1194,125);
         _loc1_(_leftSubFighterBar,260,2);
         _loc1_(_rightSubFighterBar,940,2);
      }
   }
}

