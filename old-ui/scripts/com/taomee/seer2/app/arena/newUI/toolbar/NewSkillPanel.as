package com.taomee.seer2.app.arena.newUI.toolbar
{
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.events.OperateEvent;
   import com.taomee.seer2.app.arena.newUI.toolbar.sub.NewSkillButton;
   import com.taomee.seer2.app.arena.newUI.toolbar.sub.NewSuperSkillButton;
   import com.taomee.seer2.app.arena.processor.Processor_19;
   import com.taomee.seer2.app.arena.resource.FightUIManager;
   import com.taomee.seer2.app.arena.ui.toolbar.sub.ISkillButton;
   import com.taomee.seer2.app.arena.ui.toolbar.sub.SkillTip;
   import com.taomee.seer2.app.firstTeach.guide.controller.GudieFightTipContent;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.effects.SoundEffects;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   internal class NewSkillPanel extends Sprite
   {
      
      private static const SKILL_BTN_NUM:int = 4;
      
      private var _controlledFighter:Fighter;
      
      private var _usedSkillInfo:SkillInfo;
      
      private var _tip:SkillTip;
      
      private var _skillBtnLightRingVec:Vector.<MovieClip>;
      
      private var _skillBtnVec:Vector.<NewSkillButton>;
      
      private var _skillBtnLightRingEnabled:Boolean = false;
      
      private var _superSkillBtn:NewSuperSkillButton;
      
      private var _superSkillBtnLightRing:MovieClip;
      
      private var _fightSkillTitleMC:MovieClip;
      
      public function NewSkillPanel()
      {
         var offsetX:int;
         var offsetY:int;
         var btnWidth:int;
         var i:int = 0;
         var onSkillBtnOver:Function = null;
         var onSkillBtnOut:Function = null;
         var onSuperSkillBtnOver:Function = null;
         var skillBtn:NewSkillButton = null;
         super();
         onSkillBtnOver = function(param1:MouseEvent):void
         {
            var _loc2_:NewSkillButton = null;
            if(SceneManager.currentSceneType != 10 && SceneManager.currentSceneType != 11 && SceneManager.currentSceneType != 12 && SceneManager.currentSceneType != 13 && SceneManager.currentSceneType != 14 && SceneManager.currentSceneType != 15 && SceneManager.currentSceneType != 16)
            {
               _loc2_ = param1.currentTarget as NewSkillButton;
               _tip.setSkillInfo(_loc2_.getSkillInfo());
               _tip.x = _loc2_.x + 20;
               _tip.y = _loc2_.y + 10;
               addChild(_tip);
               param1.stopImmediatePropagation();
            }
         };
         onSkillBtnOut = function(param1:MouseEvent):void
         {
            if(SceneManager.currentSceneType != 10 && SceneManager.currentSceneType != 11 && SceneManager.currentSceneType != 12 && SceneManager.currentSceneType != 13 && SceneManager.currentSceneType != 14 && SceneManager.currentSceneType != 15 && SceneManager.currentSceneType != 16)
            {
               DisplayObjectUtil.removeFromParent(_tip);
               param1.stopImmediatePropagation();
            }
         };
         onSuperSkillBtnOver = function(param1:MouseEvent):void
         {
            if(_controlledFighter.fighterInfo.hasSuperSkill())
            {
               if(_superSkillBtn.getSkillInfo())
               {
                  _tip.setSuperSkillInfo(_superSkillBtn.getSkillInfo(),null);
               }
               else
               {
                  _tip.setSuperSkillInfo(null,"必杀技");
               }
            }
            else
            {
               _tip.setSuperSkillInfo(null,"60级领悟必杀技");
            }
            _tip.x = _superSkillBtn.x + 40;
            _tip.y = _superSkillBtn.y + 10;
            addChild(_tip);
            param1.stopImmediatePropagation();
         };
         this.mouseEnabled = false;
         this._superSkillBtn = new NewSuperSkillButton();
         this._superSkillBtn.x = 590;
         this._superSkillBtn.y = -60;
         this._superSkillBtn.buttonMode = true;
         this._superSkillBtn.useHandCursor = true;
         this._superSkillBtn.enabled = false;
         this._superSkillBtn.addEventListener("click",this.onSkillBtnClick);
         this._superSkillBtn.addEventListener("mouseOver",onSuperSkillBtnOver);
         this._superSkillBtn.addEventListener("mouseOut",onSkillBtnOut);
         offsetX = 30;
         offsetY = -60;
         btnWidth = 140;
         this._skillBtnVec = new Vector.<NewSkillButton>();
         for(i = 0; i < 4; )
         {
            skillBtn = new NewSkillButton();
            skillBtn.x = offsetX + i * btnWidth;
            skillBtn.y = offsetY;
            skillBtn.id = i;
            skillBtn.addEventListener("click",this.onSkillBtnClick);
            skillBtn.addEventListener("mouseOver",onSkillBtnOver);
            skillBtn.addEventListener("mouseOut",onSkillBtnOut);
            this._skillBtnVec.push(skillBtn);
            i++;
         }
         this._fightSkillTitleMC = FightUIManager.getMovieClip("New_UI_FightSkillTitleMC");
         this._fightSkillTitleMC.x = 12;
         this._fightSkillTitleMC.y = -22;
         addChild(this._fightSkillTitleMC);
         this._tip = new SkillTip();
         if(SceneManager.currentSceneType == 6)
         {
            this.addGudie();
         }
         else if(SceneManager.currentSceneType == 10)
         {
            this.addGudieNew();
         }
         else if(SceneManager.currentSceneType == 16)
         {
            this.addGudieNew1();
         }
         else if(SceneManager.currentSceneType == 11)
         {
            this.addGudieNew3();
         }
         else if(SceneManager.currentSceneType == 14)
         {
            this.addGudieNew5();
         }
         else if(SceneManager.currentSceneType == 12)
         {
            this.addGudieNew4();
         }
         else if(SceneManager.currentSceneType == 15)
         {
            this.addNewGudieNew4();
         }
      }
      
      private function addGudieNew() : void
      {
         GudieFightTipContent.pushTar(this._skillBtnVec[0],0);
         GudieFightTipContent.pushTar(this._superSkillBtn,1);
      }
      
      private function addGudieNew1() : void
      {
         GudieFightTipContent.pushTar(this._skillBtnVec[0],0);
         GudieFightTipContent.pushTar(this._superSkillBtn,1);
      }
      
      private function addGudieNew5() : void
      {
         GudieFightTipContent.pushTar(this._skillBtnVec[0],5);
      }
      
      private function addGudie() : void
      {
         GudieFightTipContent.pushTar(this._skillBtnVec[0],0);
         GudieFightTipContent.pushTar(this._superSkillBtn,3);
      }
      
      private function addGudieNew3() : void
      {
         GudieFightTipContent.pushTar(this._skillBtnVec[0],5);
      }
      
      private function addGudieNew4() : void
      {
      }
      
      private function addNewGudieNew4() : void
      {
      }
      
      public function active() : void
      {
         var _loc1_:NewSkillButton = null;
         this.mouseEnabled = true;
         this._superSkillBtn.mouseEnabled = true;
         this._superSkillBtn.mouseChildren = true;
         for each(_loc1_ in this._skillBtnVec)
         {
            _loc1_.enabled = true;
         }
      }
      
      public function deactive() : void
      {
         var _loc1_:NewSkillButton = null;
         this.mouseEnabled = false;
         this._superSkillBtn.mouseEnabled = false;
         this._superSkillBtn.mouseChildren = false;
         for each(_loc1_ in this._skillBtnVec)
         {
            _loc1_.enabled = false;
         }
      }
      
      public function setFighter(param1:Fighter) : void
      {
         this._controlledFighter = param1;
         var _loc2_:Vector.<SkillInfo> = this._controlledFighter.fighterInfo.skillInfoVec;
         this.showNormalSkillBtn(_loc2_);
         this.showSuperSkillBtn(_loc2_);
         this.updateSkillBtn();
      }
      
      private function showNormalSkillBtn(param1:Vector.<SkillInfo>) : void
      {
         var _loc2_:SkillInfo = null;
         var _loc4_:NewSkillButton = null;
         this.clearSkillBtnVec();
         var _loc5_:int = int(param1.length);
         var _loc7_:int = int(this._skillBtnVec.length);
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = param1[_loc3_];
            if(_loc2_.id != 0)
            {
               if(_loc2_.category != "必杀")
               {
                  if(_loc6_ > _loc7_ - 1)
                  {
                     break;
                  }
                  _loc4_ = this._skillBtnVec[_loc6_];
                  _loc4_.setSkillInfo(_loc2_);
                  addChild(_loc4_);
                  _loc6_++;
               }
            }
            _loc3_++;
         }
      }
      
      private function showSuperSkillBtn(param1:Vector.<SkillInfo>) : void
      {
         var _loc3_:SkillInfo = null;
         this.resetSuperSkillBtn();
         var _loc2_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1[_loc4_];
            if(_loc3_.id != 0)
            {
               if(_loc3_.category == "必杀")
               {
                  this._superSkillBtn.setSkillInfo(_loc3_);
                  addChild(this._superSkillBtn);
                  break;
               }
            }
            _loc4_++;
         }
      }
      
      public function updateSkillBtn() : void
      {
         var _loc6_:NewSkillButton = null;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:SkillInfo = null;
         var _loc3_:String = null;
         for each(_loc6_ in this._skillBtnVec)
         {
            _loc4_ = _loc6_.getSkillInfo();
            if(!(_loc4_ == null || _loc4_.id == 0))
            {
               if(_loc4_ != null)
               {
                  _loc6_.updateScale(this._controlledFighter.fighterInfo.fightAnger,_loc4_.anger);
                  if(this._controlledFighter.fighterInfo.checkSkillAnger(_loc4_))
                  {
                     _loc6_.enabled = true;
                  }
                  else
                  {
                     _loc6_.enabled = false;
                  }
               }
            }
         }
         if(this._superSkillBtn.getSkillInfo() != null)
         {
            this._superSkillBtn.updateScale(this._controlledFighter.fighterInfo.fightAnger,this._superSkillBtn.getSkillInfo().anger);
            if(this._controlledFighter.fighterInfo.checkSkillAnger(this._superSkillBtn.getSkillInfo()))
            {
               this._superSkillBtn.enabled = true;
            }
            else
            {
               this._superSkillBtn.enabled = false;
            }
         }
         var _loc5_:Boolean = this._controlledFighter.fighterInfo.hasSuperSkill();
         if(_loc5_)
         {
         }
         var _loc2_:int = 30;
         var _loc1_:int = -60;
         if(this._superSkillBtn.getSkillInfo() == null)
         {
            DisplayUtil.removeForParent(this._superSkillBtn);
            _loc8_ = 190;
            _loc7_ = 0;
            while(_loc7_ < 4)
            {
               this._skillBtnVec[_loc7_].x = _loc2_ + _loc7_ * _loc8_;
               _loc7_++;
            }
         }
         else
         {
            addChild(this._superSkillBtn);
            _loc8_ = 140;
            _loc7_ = 0;
            while(_loc7_ < 4)
            {
               this._skillBtnVec[_loc7_].x = _loc2_ + _loc7_ * _loc8_;
               _loc7_++;
            }
         }
      }
      
      public function set skillBtnLightRingEnabled(param1:Boolean) : void
      {
         this._skillBtnLightRingEnabled = param1;
         if(this._skillBtnLightRingEnabled == true)
         {
            this.addSkillBtnLightRing();
         }
      }
      
      public function get skillBtnLightRingEnabled() : Boolean
      {
         return this._skillBtnLightRingEnabled;
      }
      
      private function onSkillBtnClick(param1:MouseEvent) : void
      {
         if(Processor_19.isChangeIng)
         {
            return;
         }
         var _loc2_:ISkillButton = param1.currentTarget as ISkillButton;
         if(_loc2_.enabled)
         {
            this._usedSkillInfo = _loc2_.getSkillInfo();
            dispatchEvent(new OperateEvent(1,this._usedSkillInfo.id,"operateEnd"));
            if(this._skillBtnLightRingEnabled)
            {
               this.removeSkillBtnLightRing();
            }
         }
         SoundEffects.playFightSound("Sound_Skill",0.35);
      }
      
      private function addSkillBtnLightRing() : void
      {
         var _loc1_:uint = 0;
         var _loc4_:NewSkillButton = null;
         var _loc3_:MovieClip = null;
         this.removeSkillBtnLightRing();
         this._skillBtnLightRingVec = new Vector.<MovieClip>();
         var _loc2_:uint = this._skillBtnVec.length;
         if(_loc2_ > 0)
         {
            _loc1_ = _loc2_ - 1;
            while(_loc1_ > 0)
            {
               _loc4_ = this._skillBtnVec[_loc1_];
               if(_loc4_.enabled == true && Boolean(_loc4_.getSkillInfo()))
               {
                  _loc3_ = FightUIManager.getMovieClip("UI_FightSkillBtnLightRing");
                  _loc3_.x = _loc4_.x;
                  _loc3_.y = _loc4_.y;
                  _loc3_.mouseEnabled = false;
                  _loc3_.mouseChildren = false;
                  addChild(_loc3_);
                  this._skillBtnLightRingVec.push(_loc3_);
                  break;
               }
               _loc1_--;
            }
         }
         if(this._superSkillBtn.enabled == true)
         {
            this._superSkillBtnLightRing = FightUIManager.getMovieClip("UI_FightSuperSkillBtnLightRing");
            this._superSkillBtnLightRing.x = this._superSkillBtn.x;
            this._superSkillBtnLightRing.y = this._superSkillBtn.y;
            addChild(this._superSkillBtnLightRing);
         }
      }
      
      private function removeSkillBtnLightRing() : void
      {
         if(this._superSkillBtnLightRing)
         {
            DisplayObjectUtil.removeFromParent(this._superSkillBtnLightRing);
            this._superSkillBtnLightRing = null;
         }
         if(this._skillBtnLightRingVec == null)
         {
            return;
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this._skillBtnLightRingVec.length)
         {
            DisplayObjectUtil.removeFromParent(this._skillBtnLightRingVec[_loc1_]);
            this._skillBtnLightRingVec[_loc1_] = null;
            _loc1_++;
         }
         this._skillBtnLightRingVec = null;
      }
      
      private function resetSuperSkillBtn() : void
      {
         this._superSkillBtn.enabled = false;
         this._superSkillBtn.clearSkillInfo();
      }
      
      private function clearSkillBtnVec() : void
      {
         var _loc1_:NewSkillButton = null;
         for each(_loc1_ in this._skillBtnVec)
         {
            DisplayObjectUtil.removeFromParent(_loc1_);
         }
         if(this._superSkillBtn)
         {
            TooltipManager.remove(this._superSkillBtn);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:NewSkillButton = null;
         if(this._superSkillBtn)
         {
            TooltipManager.remove(this._superSkillBtn);
         }
         DisplayObjectUtil.removeAllChildren(this);
         this._controlledFighter = null;
         this._tip = null;
         this._usedSkillInfo = null;
         for each(_loc1_ in this._skillBtnVec)
         {
            _loc1_.dispose();
            DisplayObjectUtil.removeFromParent(_loc1_);
         }
         this._skillBtnVec = null;
         this._superSkillBtn.dispose();
         this._superSkillBtn = null;
         this.removeSkillBtnLightRing();
      }
   }
}

