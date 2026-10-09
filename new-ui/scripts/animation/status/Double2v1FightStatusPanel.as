package animation.status
{
   import data.pet.ArenaData;
   import utils.an.DisplayUtil;
   
   public class Double2v1FightStatusPanel extends FightStatusPanel
   {
      
      private var _leftSubFighterBar:SubFighterStatusBar;
      
      public function Double2v1FightStatusPanel()
      {
         super();
      }
      
      override public function initData(param1:ArenaData, param2:int) : void
      {
         super.initData(param1,param2);
         this._leftSubFighterBar.initData(param1.left.slave,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:Function = DisplayUtil.replaceChild;
         _leftMainFighterBar = _loc1_(_leftMainFighterBar,new DoubleFighterStatusBar(1));
         _rightMainFighterBar = _loc1_(_rightMainFighterBar,new FighterStatusBar(2));
         _leftBuffIconBar = _loc1_(_leftBuffIconBar,new BuffIconBar(1,5));
         _leftSubFighterBar = new SubFighterStatusBar(1);
         addChildAt(_leftSubFighterBar,getChildIndex(_rightMainFighterBar));
      }
      
      override protected function layout() : void
      {
         _rightCapsuleBar.scaleX *= -1;
         var _loc1_:Function = DisplayUtil.setChildPosition;
         _loc1_(_rightMainFighterBar,1200,0);
         _loc1_(_rightBuffIconBar,994,55);
         _loc1_(_leftBuffIconBar,85,55);
         _loc1_(_leftCapsuleBar,6,125);
         _loc1_(_rightCapsuleBar,1194,125);
         _loc1_(_leftSubFighterBar,260,2);
      }
   }
}

