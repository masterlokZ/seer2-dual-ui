package com.taomee.seer2.app.arena.ui.status
{
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.data.FighterBuffInfo;
   import com.taomee.seer2.app.arena.resource.FightUIManager;
   import com.taomee.seer2.app.config.SkillSideEffectConfig;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.LabelRenderer;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   
   public class BuffIconBar extends Sprite
   {
      
      private static const TRAIT_ATK:uint = 10001;
      
      private static const TRAIT_DEFENCE:uint = 10002;
      
      private static const TRAIT_SPECIAL_ATK:uint = 10003;
      
      private static const TRAIT_SPECIAL_DEFENCE:uint = 10004;
      
      private static const TRAIT_SPEED:uint = 10005;
      
      private static const ICON_WIDTH:int = 32;
      
      private var _side:int;
      
      private var _maxLine:uint = 4;
      
      private var _back:Sprite;
      
      private var _anchor:Point;
      
      private var _direction:int;
      
      private var _fighter:Fighter;
      
      private var _iconMap:HashMap = new HashMap();
      
      private var _specialList:Array = [0,3363,3364,3365,3366,3367,3368];
      
      private var _baoziList:Array = ["111","222","333","444","555","666"];
      
      private var _shunziList:Array = ["123","234","345","456"];
      
      private var _yiduiList:Array = ["211","225","433","442","551","663"];
      
      private var _wuduiList:Array = ["124","125","126","134","135","136"];
      
      public function BuffIconBar(param1:int, param2:uint = 8)
      {
         super();
         this._side = param1;
         this._maxLine = param2;
         this._iconMap = new HashMap();
         if(this._side == 1)
         {
            this._direction = 1;
         }
         else
         {
            this._direction = -1;
         }
      }
      
      public function setFighter(param1:Fighter) : void
      {
         this._fighter = param1;
      }
      
      public function update() : void
      {
         var _loc1_:FighterBuffInfo = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         this.clearIcon();
         var _loc2_:Vector.<FighterBuffInfo> = new Vector.<FighterBuffInfo>();
         for each(_loc1_ in this._fighter.fighterInfo.fightBuffInfoVec)
         {
            if(_loc1_.round > 0)
            {
               _loc2_.push(_loc1_);
            }
         }
         this.replaceBuff(_loc2_);
         _loc3_ = this.showTraitChangedIcon(0);
         _loc4_ = int(_loc2_.length);
         if(_loc4_ > 0)
         {
            this.showBuffIcon(_loc2_,_loc3_);
         }
      }
      
      private function replaceBuff(param1:Vector.<FighterBuffInfo>) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].buffId == 3353)
            {
               _loc2_ = this.getBufferList(this._baoziList);
               param1.splice(_loc3_,1,_loc2_[0],_loc2_[1],_loc2_[2]);
            }
            else if(param1[_loc3_].buffId == 3354)
            {
               _loc2_ = this.getBufferList(this._shunziList);
               param1.splice(_loc3_,1,_loc2_[0],_loc2_[1],_loc2_[2]);
            }
            else if(param1[_loc3_].buffId == 3355)
            {
               _loc2_ = this.getBufferList(this._yiduiList);
               param1.splice(_loc3_,1,_loc2_[0],_loc2_[1],_loc2_[2]);
            }
            else if(param1[_loc3_].buffId == 3356)
            {
               _loc2_ = this.getBufferList(this._wuduiList);
               param1.splice(_loc3_,1,_loc2_[0],_loc2_[1],_loc2_[2]);
            }
            _loc3_++;
         }
      }
      
      private function getBufferList(param1:Array) : Array
      {
         var _loc3_:Array = null;
         var _loc5_:FighterBuffInfo = null;
         var _loc4_:LittleEndianByteArray = null;
         _loc3_ = (param1[uint(Math.random() * param1.length)] as String).split("");
         var _loc2_:uint = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = new LittleEndianByteArray();
            _loc4_.writeUnsignedInt(this._specialList[uint(_loc3_[_loc2_])]);
            _loc4_.writeInt(1);
            _loc4_.writeInt(0);
            _loc4_.writeInt(0);
            _loc4_.writeInt(0);
            _loc4_.position = 0;
            _loc5_ = new FighterBuffInfo(_loc4_);
            _loc3_[_loc2_] = _loc5_;
            _loc2_++;
         }
         return _loc3_;
      }
      
      private function showTraitChangedIcon(param1:uint) : int
      {
         if(this._fighter.fighterTurnResultInfo == null)
         {
            return 0;
         }
         var _loc5_:int = int(param1);
         var _loc7_:int = this._fighter.fighterTurnResultInfo.changedAtk;
         var _loc6_:int = this._fighter.fighterTurnResultInfo.changedDefence;
         var _loc3_:int = this._fighter.fighterTurnResultInfo.changedSpecialAtk;
         var _loc2_:int = this._fighter.fighterTurnResultInfo.changedSpecialDefence;
         var _loc4_:int = this._fighter.fighterTurnResultInfo.changedSpeed;
         if(_loc7_ != 0)
         {
            this.addTraitIcon(10001,_loc5_,_loc7_);
            _loc5_++;
         }
         if(_loc6_ != 0)
         {
            this.addTraitIcon(10002,_loc5_,_loc6_);
            _loc5_++;
         }
         if(_loc3_ != 0)
         {
            this.addTraitIcon(10003,_loc5_,_loc3_);
            _loc5_++;
         }
         if(_loc2_ != 0)
         {
            this.addTraitIcon(10004,_loc5_,_loc2_);
            _loc5_++;
         }
         if(_loc4_ != 0)
         {
            this.addTraitIcon(10005,_loc5_,_loc4_);
            _loc5_++;
         }
         return _loc5_;
      }
      
      private function addTraitIcon(param1:int, param2:int, param3:int) : void
      {
         var iconLinkage:String = null;
         var icon:Sprite = null;
         var traitIndex:int = param1;
         var iconIndex:int = param2;
         var changedValue:int = param3;
         var updateBuffStatus:Function = function(param1:int):void
         {
            var _loc2_:Bitmap = null;
            param1 = Math.abs(param1);
            if(param1 < 100 && param1 != 0)
            {
               _loc2_ = LabelRenderer.getLabelImage(param1 + "",16777215,3342336,18);
               _loc2_.x = 20;
               _loc2_.y = 14;
               icon.addChild(_loc2_);
            }
         };
         var tip:String = this.getTraitTip(traitIndex);
         if(changedValue > 0)
         {
            tip += "强化";
            iconLinkage = "UI_FightFighterTraitIncrease_" + this.getPropIconResLink(traitIndex);
         }
         else
         {
            tip += "弱化";
            iconLinkage = "UI_FightFighterTraitDecrease_" + this.getPropIconResLink(traitIndex);
         }
         tip += Math.abs(changedValue);
         if(this._iconMap.containsKey(traitIndex) == false)
         {
            icon = FightUIManager.getSprite(iconLinkage);
            this._iconMap.add(traitIndex,icon);
         }
         icon = this._iconMap.getValue(traitIndex) as Sprite;
         updateBuffStatus(changedValue);
         icon.x = iconIndex % this._maxLine * this._direction * 32;
         icon.y = int(iconIndex / this._maxLine) * (32 + 2);
         TooltipManager.addCommonTip(icon,tip);
         addChild(icon);
      }
      
      private function getPropIconResLink(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1 - 10001)
         {
            case 0:
               _loc2_ = "Atk";
               break;
            case 1:
               _loc2_ = "Defense";
               break;
            case 2:
               _loc2_ = "SpecialAtk";
               break;
            case 3:
               _loc2_ = "SpecialDefense";
               break;
            case 4:
               _loc2_ = "Speed";
         }
         return _loc2_;
      }
      
      private function getTraitTip(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1 - 10001)
         {
            case 0:
               _loc2_ = "物攻";
               break;
            case 1:
               _loc2_ = "物防";
               break;
            case 2:
               _loc2_ = "特攻";
               break;
            case 3:
               _loc2_ = "特防";
               break;
            case 4:
               _loc2_ = "速度";
         }
         return _loc2_;
      }
      
      private function clearIcon() : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:Array = this._iconMap.getValues();
         var _loc1_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = _loc2_[_loc4_] as Sprite;
            if(_loc3_ is BuffIcon)
            {
               (_loc3_ as BuffIcon).dispose();
            }
            DisplayObjectUtil.removeFromParent(_loc3_);
            TooltipManager.remove(_loc3_);
            _loc4_++;
         }
         this._iconMap = new HashMap();
      }
      
      private function showBuffIcon(param1:Vector.<FighterBuffInfo>, param2:int = 0) : void
      {
         var _loc8_:FighterBuffInfo = null;
         var _loc4_:int = 0;
         var _loc3_:BuffIcon = null;
         var _loc6_:Sprite = null;
         var _loc5_:String = null;
         var _loc7_:int = int(param1.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc8_ = param1[_loc9_];
            _loc4_ = int(_loc8_.buffId);
            if(SkillSideEffectConfig.contains(_loc4_))
            {
               if(!this._iconMap.containsKey(_loc4_))
               {
                  _loc3_ = new BuffIcon();
                  _loc3_.setBuffId(_loc4_);
                  _loc3_.updateBuffStatus(_loc8_.dummy2);
                  if(this._specialList.indexOf(_loc4_) == -1)
                  {
                     this._iconMap.add(_loc4_,_loc3_);
                     _loc6_ = this._iconMap.getValue(_loc4_) as Sprite;
                  }
                  else
                  {
                     _loc5_ = "s_" + Math.random() * 100;
                     this._iconMap.add(_loc5_,_loc3_);
                     _loc6_ = this._iconMap.getValue(_loc5_) as Sprite;
                  }
               }
               if(_loc9_ + param2 >= this._maxLine)
               {
                  _loc6_.x = (_loc9_ + param2) % this._maxLine * this._direction * 32;
                  _loc6_.y = int((_loc9_ + param2) / this._maxLine) * (32 + 2);
               }
               else
               {
                  _loc6_.x = (_loc9_ + param2) * this._direction * 32;
                  _loc6_.y = 0;
               }
               TooltipManager.addMultipleTip(_loc6_,_loc8_.tip);
               addChild(_loc6_);
            }
            _loc9_++;
         }
      }
      
      public function dispose() : void
      {
         this.clearIcon();
         this._fighter = null;
      }
   }
}

