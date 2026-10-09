package com.taomee.seer2.app.dialog
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.events.DialogBoxEvent;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.quest.animation.QuestAnimationPresenter;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.Quest;
   import com.taomee.seer2.core.quest.data.DialogDefinition;
   import com.taomee.seer2.core.quest.data.dialog.BranchDefinition;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.core.utils.Util;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.taomee.utils.DisplayUtil;
   
   public class DialogBox extends Sprite
   {
      
      private var _contentTxt:TextField;
      
      private var _npcPreview:NpcPreview;
      
      private var _nextNodeBtn:SimpleButton;
      
      private var _labelFormat:TextFormat;
      
      private var _labelBtnVec:Vector.<SimpleButton>;
      
      private var _createClickRec:Sprite;
      
      private var _npcName:String;
      
      private var _definition:DialogDefinition;
      
      private var _branchIndex:int = 0;
      
      private var _branch:BranchDefinition;
      
      private var _nodeIndex:int = 0;
      
      private var _contentFormat:TextFormat;
      
      private var _emotionList:Vector.<MovieClip>;
      
      private var _numLines:int;
      
      private var _quest:Quest;
      
      private var _stepId:int;
      
      public function DialogBox()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.mouseEnabled = false;
         this._labelBtnVec = new Vector.<SimpleButton>();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this.createNpcPreview();
         this.createContentTxt();
      }
      
      private function createNpcPreview() : void
      {
         this._npcPreview = new NpcPreview();
         this._npcPreview.x = 170;
         this._npcPreview.y = 562;
         addChild(this._npcPreview);
      }
      
      private function createContentTxt() : void
      {
         this._contentFormat = new TextFormat();
         this._contentFormat.size = 14;
         this._contentFormat.color = 5432825;
         this._contentFormat.font = "_sans";
         this._contentFormat.leading = 9;
         this._contentTxt = new TextField();
         this._contentTxt.multiline = true;
         this._contentTxt.wordWrap = true;
         this._contentTxt.width = 470;
         this._contentTxt.height = 60;
         this._contentTxt.selectable = false;
         this._contentTxt.defaultTextFormat = this._contentFormat;
         addChild(this._contentTxt);
         this._contentTxt.x = 280;
         this._contentTxt.y = 440;
      }
      
      private function createReplyBtn(param1:String) : SimpleButton
      {
         var _loc3_:Sprite = this.createBtnState(param1,16777113);
         var _loc5_:Sprite = this.createBtnState(param1,9696572);
         var _loc4_:Sprite = this.createBtnState(param1,16777113);
         var _loc2_:Shape = this.createBtnHitState(_loc4_.width);
         return new SimpleButton(_loc3_,_loc5_,_loc4_,_loc2_);
      }
      
      private function createBtnState(param1:String, param2:uint) : Sprite
      {
         var _loc3_:TextField = null;
         if(this._labelFormat == null)
         {
            this._labelFormat = new TextFormat();
            this._labelFormat.size = 18;
            this._labelFormat.underline = true;
            this._labelFormat.bold = true;
         }
         this._labelFormat.color = param2;
         var _loc4_:Sprite = new Sprite();
         _loc3_ = new TextField();
         _loc3_.defaultTextFormat = this._labelFormat;
         _loc3_.type = "dynamic";
         _loc3_.selectable = false;
         _loc3_.autoSize = "left";
         _loc3_.htmlText = param1;
         _loc4_.addChild(_loc3_);
         return _loc4_;
      }
      
      private function createClickRec() : void
      {
         this._createClickRec = new Sprite();
         this._createClickRec.graphics.beginFill(16777215,0);
         this._createClickRec.graphics.drawRect(0,0,600,145);
         this._createClickRec.graphics.endFill();
         this._createClickRec.buttonMode = true;
         this._createClickRec.x = 200;
         this._createClickRec.y = 410;
         addChild(this._createClickRec);
         this._createClickRec.addEventListener("click",this.onRecClick);
      }
      
      private function onRecClick(param1:MouseEvent) : void
      {
         this.processReplyAction(0);
         param1.stopImmediatePropagation();
      }
      
      private function createBtnHitState(param1:int) : Shape
      {
         var _loc2_:Shape = new Shape();
         var _loc3_:Graphics = _loc2_.graphics;
         _loc3_.beginFill(16777215,0);
         _loc3_.drawRect(0,0,param1,25);
         _loc3_.endFill();
         return _loc2_;
      }
      
      public function setQuestInfo(param1:Quest, param2:int, param3:DialogDefinition) : void
      {
         this._quest = param1;
         this._stepId = param2;
         this.setDialogDefinition(param3);
      }
      
      public function setDialogDefinition(param1:DialogDefinition) : void
      {
         this._definition = param1;
         this.changeBranch(0);
      }
      
      private function changeBranch(param1:int) : void
      {
         this._branchIndex = param1;
         this._nodeIndex = 0;
         this.update();
      }
      
      private function update() : void
      {
         this._branch = this._definition.branchVec[this._branchIndex];
         this.updateNpcPreview();
         this.updateContent();
         if(this._nodeIndex == this._branch.contentVec.length - 1)
         {
            this.showLabelBtn();
         }
         else
         {
            this.showNextNodeBtn();
         }
      }
      
      private function updateNpcPreview() : void
      {
         var _loc1_:int = int(this._branch.emotionVec[this._nodeIndex]);
         this._npcPreview.update(this._branch.npcName,this._branch.npcId,_loc1_);
      }
      
      private function updateContent() : void
      {
         var _loc2_:Object = {};
         _loc2_["name"] = "<font color=\'#FFFF99\' size=\'14\'>" + ActorManager.actorInfo.nick + "</font>";
         var _loc1_:String = this._branch.contentVec[this._nodeIndex];
         _loc1_ = Util.replaceVariables(_loc1_,_loc2_);
         _loc1_ = "<font color=\'#52E5F9\' size=\'14\'>" + _loc1_ + "</font>";
         this._contentTxt.htmlText = _loc1_;
         if(this._contentTxt.numLines >= 2)
         {
            this._contentTxt.y = 427;
         }
         else
         {
            this._contentTxt.y = 440;
         }
         this._numLines = this._contentTxt.numLines;
         this._contentTxt.defaultTextFormat = this._contentFormat;
         this.checkFaces(this._contentTxt);
      }
      
      public function checkFaces(param1:TextField) : void
      {
         var _loc7_:String = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:MovieClip = null;
         var _loc8_:Array = [];
         var _loc4_:Array = [];
         var _loc3_:Array = [];
         _loc7_ = param1.htmlText;
         var _loc6_:RegExp = /\/:[0-9]{2}/g;
         _loc3_ = _loc7_.match(_loc6_);
         if(_loc3_.length == 0)
         {
            return;
         }
         param1.htmlText = _loc7_.replace(_loc6_,"    ");
         var _loc5_:uint = 0;
         _loc9_ = param1.text;
         while(true)
         {
            _loc8_.push(_loc9_.indexOf("    ",_loc5_));
            if(_loc8_[_loc8_.length - 1] == -1)
            {
               break;
            }
            _loc5_ = _loc8_[_loc8_.length - 1] + 1;
         }
         _loc8_.pop();
         var _loc2_:uint = 0;
         var _loc12_:Number = param1.height;
         while(_loc2_ < _loc8_.length)
         {
            _loc4_.push(param1.getCharBoundaries(_loc8_[_loc2_]));
            _loc2_++;
         }
         _loc3_ = _loc3_.reverse();
         _loc4_ = _loc4_.reverse();
         this._emotionList = Vector.<MovieClip>([]);
         var _loc13_:uint = 0;
         while(_loc13_ < _loc3_.length)
         {
            if(_loc4_[_loc13_] != null)
            {
               _loc10_ = uint(_loc3_[_loc13_].substr(2,2));
               _loc11_ = UIManager.getMovieClip("UI_Emotion" + _loc10_);
               _loc11_.name = "UI_Emotion" + _loc10_;
               _loc11_.scaleX = _loc11_.scaleY = 0.7;
               _loc11_.x = _loc4_[_loc13_].x + 294;
               _loc11_.y = _loc4_[_loc13_].y + 436;
               if(_loc4_[_loc13_].y > 20)
               {
                  this.createFormat(11,_loc11_);
               }
               else
               {
                  this.createFormat(5,_loc11_);
               }
               this.parent.addChild(_loc11_);
               this._emotionList.push(_loc11_);
               _loc11_ = null;
               _loc13_++;
            }
         }
         _loc6_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc7_ = null;
      }
      
      private function createFormat(param1:uint, param2:MovieClip) : void
      {
         if(param1 == 11)
         {
            this._contentTxt.y = 427;
         }
         else if(this._numLines == 1)
         {
            param2.y += 13;
         }
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.size = 14;
         _loc3_.color = 5432825;
         _loc3_.font = "_sans";
         _loc3_.leading = param1;
         this._contentTxt.defaultTextFormat = _loc3_;
      }
      
      private function showLabelBtn() : void
      {
         var _loc4_:String = null;
         var _loc3_:SimpleButton = null;
         this.clearBtn();
         var _loc2_:int = int(this._branch.replyLabelVec.length);
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this._branch.replyLabelVec[_loc1_];
            _loc3_ = this.createReplyBtn(_loc4_);
            _loc3_.addEventListener("click",this.onLabelBtnClick);
            this._labelBtnVec.push(_loc3_);
            _loc1_++;
         }
         if(_loc2_ == 1)
         {
            this.createClickRec();
         }
         this.layoutLabelBtn();
      }
      
      private function clearBtn() : void
      {
         var _loc1_:SimpleButton = null;
         DisplayUtil.removeForParent(this._createClickRec);
         for each(_loc1_ in this._labelBtnVec)
         {
            removeChild(_loc1_);
         }
         this._labelBtnVec = new Vector.<SimpleButton>();
         if(Boolean(this._nextNodeBtn) && Boolean(this._nextNodeBtn.parent))
         {
            removeChild(this._nextNodeBtn);
         }
      }
      
      private function layoutLabelBtn() : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 790;
         var _loc2_:int = 520;
         var _loc5_:Vector.<int> = new Vector.<int>();
         _loc4_ = int(this._labelBtnVec.length);
         var _loc1_:int = _loc4_ - 1;
         while(_loc1_ >= 0)
         {
            _loc5_.push(_loc3_ - this._labelBtnVec[_loc1_].width);
            _loc3_ -= this._labelBtnVec[_loc1_].width + 10;
            _loc1_--;
         }
         _loc5_.reverse();
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            this._labelBtnVec[_loc1_].x = _loc5_[_loc1_];
            this._labelBtnVec[_loc1_].y = _loc2_;
            addChild(this._labelBtnVec[_loc1_]);
            _loc1_++;
         }
      }
      
      private function onLabelBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.findBtnIndex(param1.currentTarget as SimpleButton);
         this.processReplyAction(_loc2_);
         param1.stopImmediatePropagation();
      }
      
      private function processReplyAction(param1:int) : void
      {
         var _loc2_:String = this._branch.replyActionVec[param1];
         var _loc3_:String = this._branch.replyParamVec[param1];
         switch(_loc2_)
         {
            case "goToBranch":
               this.changeBranch(this.findBranchIndex(_loc3_));
               dispatchEvent(new DialogBoxEvent("updateContent",null));
               break;
            case "close":
               this.closeDialogPanel(_loc3_);
               break;
            case "accept":
               this.acceptQuest();
               this.closeDialogPanel(_loc3_);
               break;
            case "completeStep":
               this.completeQuestStep();
               this.closeDialogPanel(_loc3_);
               break;
            case "fightBoss":
               this.startFightBoss(_loc3_);
               this.closeDialogPanel(_loc3_);
               break;
            case "playAnimation":
               this.playAnimation(_loc3_);
               this.closeDialogPanel(_loc3_);
               break;
            case "openModule":
               this.openModule(_loc3_);
               this.closeDialogPanel(_loc3_);
               break;
            case "changeScene":
               this.changeScene(_loc3_);
               this.closeDialogPanel(_loc3_);
               break;
            default:
               this.closeDialogPanel(_loc3_);
               dispatchEvent(new DialogBoxEvent("customReplayClick",new DialogPanelEventData(_loc2_,_loc3_)));
         }
      }
      
      private function closeDialogPanel(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         for each(_loc2_ in this._emotionList)
         {
            DisplayUtil.removeForParent(_loc2_);
         }
         this._emotionList = null;
         DialogPanel.hide(param1);
      }
      
      private function startFightBoss(param1:String) : void
      {
         var _loc2_:uint = uint(param1);
         FightManager.startFightWithSPTBoss(_loc2_);
      }
      
      private function playAnimation(param1:String) : void
      {
         QuestAnimationPresenter.playQuestAnimation(param1);
      }
      
      private function openModule(param1:String) : void
      {
         var _loc2_:Array = param1.split(" ");
         if(_loc2_.length >= 3)
         {
            ModuleManager.showModule(URLUtil.getAppModule(_loc2_[0]),_loc2_[1],_loc2_[2]);
         }
         else
         {
            ModuleManager.showModule(URLUtil.getAppModule(_loc2_[0]),_loc2_[1]);
         }
      }
      
      private function changeScene(param1:String) : void
      {
         ActsHelperUtil.goHandle(int(param1));
      }
      
      private function acceptQuest() : void
      {
         QuestManager.accept(this._quest.id);
         if(this._definition.transport != "")
         {
            SceneManager.changeScene(1,uint(this._definition.transport));
         }
      }
      
      private function completeQuestStep() : void
      {
         QuestManager.completeStep(this._quest.id,this._stepId);
      }
      
      private function findBtnIndex(param1:SimpleButton) : int
      {
         var _loc2_:int = int(this._labelBtnVec.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._labelBtnVec[_loc3_] == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function findBranchIndex(param1:String) : int
      {
         var _loc3_:BranchDefinition = null;
         var _loc2_:int = int(this._definition.branchVec.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._definition.branchVec[_loc4_];
            if(_loc3_.id == param1)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      private function showNextNodeBtn() : void
      {
         this.clearBtn();
         if(this._nextNodeBtn == null)
         {
            this._nextNodeBtn = UIManager.getButton("UI_DialogNextNode");
            this._nextNodeBtn.addEventListener("click",this.onNextNode);
         }
         this._nextNodeBtn.x = 760;
         this._nextNodeBtn.y = 530;
         addChild(this._nextNodeBtn);
      }
      
      private function onNextNode(param1:MouseEvent) : void
      {
         ++this._nodeIndex;
         this.update();
      }
   }
}

