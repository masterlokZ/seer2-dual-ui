package animation.status
{
   import animation.common.IconDisplay;
   import animation.common.PetIconDisplay;
   import data.pet.PetData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import ui.UINumberGenerator;
   import ui.status.UI_FighterLevelSign;
   import utils.an.DisplayObjectUtil;
   import utils.an.DisplayUtil;
   
   public class BaseFighterStatusBar extends MovieClip
   {
      
      protected var _fighter:PetData;
      
      protected var _back:Sprite;
      
      protected var _iconDisplayer:IconDisplay;
      
      protected var _sign:MovieClip;
      
      protected var _healthBar:ShrinkBar;
      
      protected var _healthShadowBar:ShrinkBar;
      
      protected var _hpSign:Sprite;
      
      protected var _angerBar:ShrinkBar;
      
      protected var _angerSign:Sprite;
      
      protected var _levelSprite:Sprite;
      
      protected var _nameTxt:TextField;
      
      protected var _typeIcon:IconDisplay;
      
      protected var _iconCover:MovieClip;
      
      protected var _preeMc:MovieClip;
      
      protected var _levelBg:MovieClip;
      
      public function BaseFighterStatusBar(param1:int)
      {
         super();
         DisplayObjectUtil.disableSprite(this);
         this.createChildren();
         this.layout(param1);
         this.visible = false;
      }
      
      protected function createChildren() : void
      {
         if(!this._back)
         {
            throw new Error("New BarBack first before super.createChildren()");
         }
         this._iconDisplayer = new PetIconDisplay();
         addChild(this._iconDisplayer);
         this._typeIcon = new IconDisplay();
         this._typeIcon.setScale(0.425,0.425);
         addChild(this._typeIcon);
         this._sign = this._back["barSign"];
         this._nameTxt = this._back["nameTxt"];
         this._preeMc = this._back["preeMC"];
         this._iconCover = this._back["cover"];
         this._levelBg = this._back["levelBg"];
         DisplayObjectUtil.removeFromParent(this._levelBg);
         this._healthBar = new ShrinkBar(this._back["healthBar"],true);
         this._angerBar = new ShrinkBar(this._back["angerBar"],true);
         this._healthShadowBar = new ShrinkBar(this._back["shadowBar"],true);
         addChild(this._healthShadowBar);
         this._hpSign = new Sprite();
         addChild(this._hpSign);
         this._angerSign = new Sprite();
         addChild(this._angerSign);
         this._levelSprite = new Sprite();
         this._levelSprite.addChild(new UI_FighterLevelSign());
         addChild(this._levelBg);
         addChild(this._levelSprite);
         this._iconDisplayer.mask = _iconCover;
         this._iconDisplayer.setSize(this._iconCover.width);
      }
      
      protected function layout(param1:int) : void
      {
         var _loc2_:int = 0;
         DisplayUtil.setChildPosition(this._iconDisplayer,this._iconCover.x,this._iconCover.y);
         DisplayUtil.setChildPosition(this._levelSprite,this._levelBg.x + 1,this._levelBg.y + 2);
         DisplayUtil.setChildPosition(this._typeIcon,this._levelBg.x + this._levelBg.width + 1,this._levelBg.y);
         if(param1 == 2)
         {
            this._sign.scaleX *= -1;
            this._sign.x += this._sign.width;
            _loc2_ = 2 * this._levelBg.x + this._levelBg.width - this._levelSprite.x;
            this._levelSprite.scaleX *= -1;
            this._levelSprite.x = _loc2_;
            _loc2_ = this._nameTxt.x + this._nameTxt.width;
            this._nameTxt.scaleX *= -1;
            this._nameTxt.x = _loc2_;
            this._hpSign.scaleX *= -1;
            this._angerSign.scaleX *= -1;
            this._typeIcon.scaleX *= -1;
            this._typeIcon.x += 16;
            this.scaleX = -1;
         }
      }
      
      public function initData(param1:PetData, param2:int) : void
      {
         if(!param1)
         {
            this.visible = false;
            this._fighter = null;
            return;
         }
         this.visible = true;
         this._fighter = param1;
         this._iconDisplayer.initData(param1.petIcon);
         this.updatePressStatus(param1.rate);
         if(this._hpSign.numChildren > 0)
         {
            this._hpSign.removeChildAt(0);
         }
         this._hpSign.addChild(UINumberGenerator.generateHpNumber(Math.max(param1.hp,0),param1.maxHp));
         if(this._angerSign.numChildren > 0)
         {
            this._angerSign.removeChildAt(0);
         }
         this._angerSign.addChild(UINumberGenerator.generateAngerNumber(Math.max(param1.anger,0),param1.maxAnger));
         var _loc5_:Number = Math.max(param1.anger / param1.maxAnger,0);
         var _loc3_:Number = Math.max(param1.hp / param1.maxHp,0);
         if(param2 !== 1)
         {
            this._angerBar.initAtPercent(_loc5_);
            this._healthBar.initAtPercent(_loc3_);
            this._healthShadowBar.initAtPercent(_loc3_);
         }
         else
         {
            this._angerBar.playToPercent(_loc5_);
            this._healthBar.playToPercent(_loc3_);
            this._healthShadowBar.playToPercent(_loc3_);
         }
         if(this._levelSprite.numChildren > 1)
         {
            this._levelSprite.removeChildAt(1);
         }
         var _loc4_:Sprite = UINumberGenerator.generateFighterLevelNumber(param1.level);
         _loc4_.x = 30;
         this._levelSprite.addChild(_loc4_);
         this._nameTxt.text = param1.name;
         this._typeIcon.initData(param1.typeIcon);
      }
      
      private function updatePressStatus(param1:uint) : void
      {
         var _loc2_:int = 1;
         if(param1 <= 0)
         {
            _loc2_ = 4;
         }
         else if(param1 < 100)
         {
            _loc2_ = 3;
         }
         else if(param1 === 100)
         {
            _loc2_ = 1;
         }
         else if(param1 > 100)
         {
            _loc2_ = 2;
         }
         if(this._preeMc)
         {
            this._preeMc.gotoAndStop(_loc2_);
         }
      }
   }
}

