package animation.hub
{
   import animation.event.OperateEvent;
   import data.pet.TeamData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import ui.hub.New_UI_DepositTxt;
   import ui.hub.UI_FightBarBack;
   
   public class FightControlPanel extends Sprite
   {
      
      private var _back:MovieClip;
      
      private var _fightPointPanel:FightPointPanel;
      
      private var _hubButtonPanel:HubButtonPanel;
      
      private var _skillPanel:SkillPanel;
      
      private var _itemPanel:ItemPanel;
      
      private var _capsulePanel:ItemPanel;
      
      private var _fighterPanel:FighterPanel;
      
      private var _currentPanel:Sprite;
      
      private var _depositMc:MovieClip;
      
      public function FightControlPanel()
      {
         super();
         this.y = 550;
         this._back = new UI_FightBarBack();
         addChild(this._back);
         this._depositMc = new New_UI_DepositTxt();
         this._depositMc.x = 445;
         this._depositMc.y = -350;
         this._depositMc.stop();
         addChild(this._depositMc);
         this._depositMc.visible = this._depositMc.mouseChildren = this._depositMc.mouseEnabled = false;
         this._fightPointPanel = new FightPointPanel(this._back["history"]);
         this._skillPanel = new SkillPanel();
         this._skillPanel.x = 242;
         addChild(this._skillPanel);
         this._skillPanel.visible = this._skillPanel.mouseChildren = this._skillPanel.mouseEnabled = false;
         this._fighterPanel = new FighterPanel();
         this._fighterPanel.x = 311;
         this._fighterPanel.y = 13;
         addChild(this._fighterPanel);
         this._fighterPanel.visible = this._fighterPanel.mouseChildren = this._fighterPanel.mouseEnabled = false;
         this._itemPanel = new ItemPanel(false);
         this._capsulePanel = new ItemPanel(true);
         this._capsulePanel.x = this._itemPanel.x = 311;
         this._capsulePanel.y = this._itemPanel.y = 13;
         addChild(this._itemPanel);
         addChild(this._capsulePanel);
         this._itemPanel.visible = this._itemPanel.mouseChildren = this._itemPanel.mouseEnabled = false;
         this._capsulePanel.visible = this._capsulePanel.mouseChildren = this._capsulePanel.mouseEnabled = false;
         this._hubButtonPanel = new HubButtonPanel();
         addChild(this._hubButtonPanel);
         this._hubButtonPanel.x = 1010;
         this._hubButtonPanel.addEventListener("fight",this.onFightClick);
         this._hubButtonPanel.addEventListener("item",this.onItemClick);
         this._hubButtonPanel.addEventListener("pet",this.onPetClick);
         this._hubButtonPanel.addEventListener("escape",this.onEscapeClick);
         this._hubButtonPanel.addEventListener("catch",this.onCatchClick);
         this._hubButtonPanel.addEventListener("btnAutoClick",this.onAutoClick);
         this._hubButtonPanel.addEventListener("btnSettingClick",this.onSettingClick);
         this.addEventListener("operateEnd",function(param1:OperateEvent):void
         {
            reset();
         });
      }
      
      public function initData(param1:TeamData) : void
      {
         this._skillPanel.initData(param1.master.skills);
         this._fighterPanel.initData(param1.pets);
         this._itemPanel.initData(param1.items);
         this._capsulePanel.initData(param1.capsules);
         reset();
      }
      
      public function reset() : void
      {
         setCurrentPanel(this._skillPanel);
         this._hubButtonPanel.reset();
      }
      
      public function showPetPanel() : void
      {
         setCurrentPanel(this._fighterPanel);
      }
      
      public function appendLogs(param1:Vector.<String>) : void
      {
         this._fightPointPanel.entryValue(param1);
      }
      
      public function updateAutoFightStatus(param1:Boolean) : void
      {
         if(this._depositMc.visible === param1)
         {
            return;
         }
         this._depositMc.visible = param1;
         if(param1)
         {
            this._depositMc.gotoAndPlay(1);
         }
         else
         {
            this._depositMc.gotoAndStop(1);
         }
      }
      
      private function onFightClick(param1:Event) : void
      {
         setCurrentPanel(this._skillPanel);
      }
      
      private function onItemClick(param1:Event) : void
      {
         setCurrentPanel(this._itemPanel);
      }
      
      private function onPetClick(param1:Event) : void
      {
         setCurrentPanel(this._fighterPanel);
      }
      
      private function onCatchClick(param1:Event) : void
      {
         setCurrentPanel(this._capsulePanel);
      }
      
      private function onEscapeClick(param1:Event) : void
      {
         dispatchEvent(OperateEvent.escape(1));
      }
      
      private function onAutoClick(param1:Event) : void
      {
         dispatchEvent(OperateEvent.autoFight());
      }
      
      private function onSettingClick(param1:Event) : void
      {
         dispatchEvent(OperateEvent.setting());
      }
      
      private function setCurrentPanel(param1:Sprite) : void
      {
         if(param1 === this._currentPanel)
         {
            return;
         }
         if(this._currentPanel)
         {
            this._currentPanel.visible = this._currentPanel.mouseEnabled = this._currentPanel.mouseChildren = false;
         }
         this._currentPanel = param1;
         if(this._currentPanel)
         {
            this._currentPanel.visible = this._currentPanel.mouseEnabled = this._currentPanel.mouseChildren = true;
         }
      }
      
      public function enableFightControlPanel(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         _loc2_ = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ == this._hubButtonPanel)
            {
               this._hubButtonPanel.enableHubPanel(param1);
            }
            else if(_loc3_ != this._back)
            {
               if(_loc3_ == this._skillPanel)
               {
                  Sprite(_loc3_).mouseEnabled = param1;
                  Sprite(_loc3_).mouseChildren = param1;
               }
            }
            _loc2_++;
         }
      }
   }
}

