package animation.status
{
   import data.pet.BuffData;
   import data.pet.ItemData;
   import data.pet.PetData;
   import flash.display.Sprite;
   import utils.an.DisplayObjectUtil;
   import utils.ds.HashMap;
   
   internal class BuffIconBar extends Sprite
   {
      
      private static const ICON_WIDTH:int = 32;
      
      private var _side:int;
      
      private var _maxLine:uint;
      
      private var _direction:int;
      
      private var _iconMap:HashMap;
      
      private var _iconMap2:HashMap;
      
      private var _iconMap3:HashMap;
      
      public function BuffIconBar(param1:int, param2:uint = 10)
      {
         super();
         this._side = param1;
         this._maxLine = param2;
         this._iconMap = new HashMap();
         this._iconMap2 = new HashMap();
         this._iconMap3 = new HashMap();
         if(this._side == 1)
         {
            this._direction = 1;
         }
         else
         {
            this._direction = -1;
         }
      }
      
      public function initData(param1:PetData) : void
      {
         var _loc6_:int = 0;
         var _loc7_:BuffData = null;
         var _loc4_:BuffIcon = null;
         DisplayObjectUtil.removeAllChildren(this);
         var _loc5_:Vector.<BuffData> = param1.buffs;
         var _loc3_:Vector.<BuffData> = buildItemBuffs(param1.items);
         var _loc2_:Vector.<BuffData> = buildLvBuffs(param1);
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length + _loc3_.length + _loc2_.length)
         {
            if(_loc6_ < _loc2_.length)
            {
               _loc7_ = _loc2_[_loc6_];
               if(!_iconMap2.containsKey(_loc7_.id))
               {
                  _iconMap2.add(_loc7_.id,new BuffIcon());
               }
               _loc4_ = _iconMap2.getValue(_loc7_.id);
               _loc4_.setShowNumMin(1);
            }
            else if(_loc6_ < _loc3_.length + _loc2_.length)
            {
               _loc7_ = _loc3_[_loc6_ - _loc2_.length];
               if(!_iconMap3.containsKey(_loc7_.id))
               {
                  _iconMap3.add(_loc7_.id,new BuffIcon());
               }
               _loc4_ = _iconMap3.getValue(_loc7_.id);
            }
            else
            {
               _loc7_ = _loc5_[_loc6_ - _loc3_.length - _loc2_.length];
               if(!_iconMap.containsKey(_loc7_.id))
               {
                  _iconMap.add(_loc7_.id,new BuffIcon());
               }
               _loc4_ = _iconMap.getValue(_loc7_.id);
            }
            if(_loc6_ >= this._maxLine)
            {
               _loc4_.x = _loc6_ % this._maxLine * this._direction * 32;
               _loc4_.y = int(_loc6_ / this._maxLine) * (32 + 2);
            }
            else
            {
               _loc4_.x = _loc6_ * this._direction * 32;
               _loc4_.y = 0;
            }
            _loc4_.initData(_loc7_);
            addChild(_loc4_);
            _loc6_++;
         }
      }
      
      private function buildLvBuffs(param1:PetData) : Vector.<BuffData>
      {
         var TRAIT_ATK:uint;
         var TRAIT_DEFENCE:uint;
         var TRAIT_SPECIAL_ATK:uint;
         var TRAIT_SPECIAL_DEFENCE:uint;
         var TRAIT_SPEED:uint;
         var add:* = function(param1:int, param2:String, param3:String, param4:int):void
         {
            var _loc5_:BuffData = null;
            if(param4 !== 0)
            {
               _loc5_ = new BuffData();
               _loc5_.id = param1;
               _loc5_.name = param2 + (param4 > 0 ? "强化" : "弱化");
               _loc5_.icon = "internal://UI_FightFighterTrait" + (param4 > 0 ? "Increase" : "Decrease") + "_" + param3;
               _loc5_.count = param4 > 0 ? param4 : -param4;
               _loc5_.tips = _loc5_.name + "[" + _loc5_.count + "]";
               buffs.push(_loc5_);
            }
         };
         var buffs:Vector.<BuffData> = new Vector.<BuffData>();
         add(10001,"物攻","Atk",param1.atk);
         add(10002,"物防","Defense",param1.def);
         add(10003,"特攻","SpecialAtk",param1.spa);
         add(10004,"特防","SpecialDefense",param1.spd);
         add(10005,"速度","Speed",param1.spe);
         return buffs;
      }
      
      private function buildItemBuffs(param1:Vector.<ItemData>) : Vector.<BuffData>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<BuffData> = new Vector.<BuffData>();
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(buildItemBuff(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function buildItemBuff(param1:ItemData) : BuffData
      {
         var _loc2_:BuffData = new BuffData();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.icon = param1.icon;
         _loc2_.tips = param1.tips;
         _loc2_.count = param1.count;
         return _loc2_;
      }
   }
}

