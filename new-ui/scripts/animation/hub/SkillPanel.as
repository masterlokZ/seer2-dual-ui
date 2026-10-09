package animation.hub
{
   import animation.event.OperateEvent;
   import data.pet.SkillData;
   import enums.SkillCategoryName;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.an.DisplayObjectUtil;
   
   internal class SkillPanel extends Sprite
   {
      
      private static const SKILL_BTN_NUM:int = 4;
      
      private var _tip:SkillTip;
      
      private var _skillBtnVec:Vector.<SkillButton>;
      
      private var _superSkillBtn:SuperSkillButton;
      
      public function SkillPanel()
      {
         var offsetX:int;
         var offsetY:int;
         var btnWidth:int;
         var i:int;
         var onSkillBtnOver:Function;
         var onSkillBtnOut:Function;
         var skillBtn:SkillButton = null;
         super();
         onSkillBtnOver = function(param1:MouseEvent):void
         {
            var _loc2_:Sprite = null;
            _loc2_ = param1.currentTarget as Sprite;
            _tip.initData((param1.currentTarget as ISkillButton).skill());
            _tip.x = _loc2_.x + 20;
            _tip.y = _loc2_.y - 10;
            addChild(_tip);
            param1.stopImmediatePropagation();
         };
         onSkillBtnOut = function(param1:MouseEvent):void
         {
            DisplayObjectUtil.removeFromParent(_tip);
            param1.stopImmediatePropagation();
         };
         this.mouseEnabled = false;
         this._superSkillBtn = new SuperSkillButton();
         this._superSkillBtn.x = 3;
         this._superSkillBtn.y = 3;
         this._superSkillBtn.buttonMode = true;
         this._superSkillBtn.useHandCursor = true;
         addChild(this._superSkillBtn);
         this._superSkillBtn.addEventListener("click",this.onSkillBtnClick);
         this._superSkillBtn.addEventListener("mouseOver",onSkillBtnOver);
         this._superSkillBtn.addEventListener("mouseOut",onSkillBtnOut);
         offsetX = 84;
         offsetY = 20;
         btnWidth = 171;
         this._skillBtnVec = new Vector.<SkillButton>();
         i = 0;
         while(i < 4)
         {
            skillBtn = new SkillButton();
            skillBtn.x = offsetX + i * btnWidth;
            skillBtn.y = offsetY;
            skillBtn.addEventListener("click",this.onSkillBtnClick);
            skillBtn.addEventListener("mouseOver",onSkillBtnOver);
            skillBtn.addEventListener("mouseOut",onSkillBtnOut);
            this._skillBtnVec.push(skillBtn);
            i = i + 1;
         }
         this._tip = new SkillTip();
      }
      
      public function initData(param1:Vector.<SkillData>) : void
      {
         this.showNormalSkillBtn(param1);
         this.showSuperSkillBtn(param1);
      }
      
      private function showNormalSkillBtn(param1:Vector.<SkillData>) : void
      {
         var _loc6_:int = 0;
         var _loc4_:SkillData = null;
         var _loc3_:SkillButton = null;
         var _loc2_:Vector.<SkillData> = new Vector.<SkillData>();
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc4_ = param1[_loc6_];
            if(SkillCategoryName.pow().indexOf(_loc4_.category) < 0)
            {
               _loc2_.push(_loc4_);
            }
            _loc6_++;
         }
         var _loc5_:Number = Math.min(_loc2_.length,4);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = this._skillBtnVec[_loc6_];
            _loc3_.initData(_loc2_[_loc6_]);
            if(!_loc3_.parent)
            {
               addChild(_loc3_);
            }
            _loc6_++;
         }
         _loc6_ = _loc5_;
         while(_loc6_ < 4)
         {
            _loc3_ = this._skillBtnVec[_loc6_];
            DisplayObjectUtil.removeFromParent(_loc3_);
            _loc6_++;
         }
      }
      
      private function showSuperSkillBtn(param1:Vector.<SkillData>) : void
      {
         var _loc5_:int = 0;
         var _loc4_:SkillData = null;
         var _loc2_:SuperSkillButton = this._superSkillBtn;
         var _loc3_:Vector.<SkillData> = new Vector.<SkillData>();
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = param1[_loc5_];
            if(SkillCategoryName.pow().indexOf(_loc4_.category) >= 0)
            {
               _loc3_.push(_loc4_);
            }
            _loc5_++;
         }
         if(_loc3_.length > 0)
         {
            _loc2_.initData(_loc3_[0]);
            if(!_loc2_.parent)
            {
               addChild(_loc2_);
            }
         }
         else
         {
            DisplayObjectUtil.removeFromParent(_loc2_);
         }
      }
      
      private function onSkillBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:ISkillButton = param1.currentTarget as ISkillButton;
         dispatchEvent(OperateEvent.skill(_loc2_.skill().id));
      }
   }
}

