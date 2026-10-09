package animation.layer
{
   import animation.hub.FightControlPanel;
   import animation.status.Double2v1FightStatusPanel;
   import animation.status.DoubleFightStatusPanel;
   import animation.status.FightStatusPanel;
   import animation.status.SPTFightStatusPanel;
   import animation.status.YuCunFightStatusPanel;
   import data.pet.ArenaData;
   import data.pet.MoveData;
   import flash.display.Sprite;
   import utils.an.DisplayUtil;
   
   public class UILayer extends Sprite
   {
      
      private var _uiStyle:int = 0;
      
      private var _controlPanel:FightControlPanel;
      
      private var _statusPanel:FightStatusPanel;
      
      private var _arenaData:ArenaData;
      
      public function UILayer()
      {
         super();
         this._controlPanel = new FightControlPanel();
         this._statusPanel = new FightStatusPanel();
         addChild(_controlPanel);
         addChild(_statusPanel);
      }
      
      public function initData(param1:ArenaData, param2:int) : void
      {
         this._arenaData = param1;
         this._controlPanel.initData(param1.left);
         this._statusPanel.initData(param1,param2);
      }
      
      public function showSkillBubble(param1:MoveData) : void
      {
         if(!param1 || !param1.skill)
         {
            return;
         }
         this._statusPanel.showSkillBubble(param1.side,param1.skill);
      }
      
      public function showPetPanel() : void
      {
         this._controlPanel.showPetPanel();
      }
      
      public function appendLogs(param1:Vector.<String>) : void
      {
         this._controlPanel.appendLogs(param1);
      }
      
      public function updateAutoFightStatus(param1:Boolean) : void
      {
         this._controlPanel.updateAutoFightStatus(param1);
      }
      
      public function updateUiStyle(param1:int) : void
      {
         if(_uiStyle === param1)
         {
            return;
         }
         _uiStyle = param1;
         if(_uiStyle === 1)
         {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel,new SPTFightStatusPanel());
         }
         else if(_uiStyle === 2)
         {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel,new DoubleFightStatusPanel());
         }
         else if(_uiStyle === 3)
         {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel,new Double2v1FightStatusPanel());
         }
         else if(_uiStyle === 4)
         {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel,new YuCunFightStatusPanel());
         }
         else
         {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel,new FightStatusPanel());
         }
         if(_arenaData)
         {
            this._statusPanel.initData(_arenaData,0);
         }
      }
      
      public function get controlPanel() : FightControlPanel
      {
         return _controlPanel;
      }
   }
}

