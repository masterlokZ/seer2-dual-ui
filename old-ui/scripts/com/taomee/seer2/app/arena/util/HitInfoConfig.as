package com.taomee.seer2.app.arena.util
{
   import com.taomee.seer2.app.arena.data.AnimiationHitInfo;
   import com.taomee.seer2.app.config.PetConfig;
   import org.taomee.ds.HashMap;
   import seer2.next.entry.DynConfig;
   
   public class HitInfoConfig
   {
      
      private static var _hitDatas:HashMap;
      
      private static var _hitData:Class = HitInfoConfig__hitData;
      
      public function HitInfoConfig()
      {
         super();
      }
      
      public static function getHitData(param1:uint) : AnimiationHitInfo
      {
         param1 = PetConfig.getPetDefinition(param1).realId;
         if(_hitDatas == null)
         {
            _hitDatas = new HashMap();
            setup();
         }
         var _loc2_:AnimiationHitInfo = _hitDatas.getValue(param1);
         if(_loc2_ == null)
         {
            throw new Error("精灵" + param1 + "没有配置fighters.xml表!");
         }
         return _loc2_;
      }
      
      public static function initialize() : void
      {
         _hitDatas = new HashMap();
         setup();
      }
      
      private static function setup() : void
      {
         var id:* = 0;
         var _loc2_:XML = null;
         var _loc1_:AnimiationHitInfo = null;
         var _loc5_:XML = DynConfig.hitInfoConfigXML || XML(new _hitData());
         var _loc4_:XMLList = _loc5_.child("fighter");
         var _loc7_:uint = uint(_loc4_.length());
         var _loc6_:uint = 0;
         while(_loc6_ < _loc7_)
         {
            _loc2_ = _loc4_[_loc6_];
            _loc1_ = new AnimiationHitInfo();
            _loc1_.id = _loc2_.@id;
            _loc1_.attribute = _loc2_.@attribute;
            _loc1_.critical = _loc2_.@critical;
            _loc1_.fit = _loc2_.@fit;
            _loc1_.physics = _loc2_.@physics;
            _loc1_.special = _loc2_.@special;
            _loc1_.hasArray = false;
            _hitDatas.add(_loc1_.id,_loc1_);
            _loc6_++;
         }
         _loc4_ = _loc5_.child("fighterVec");
         _loc7_ = uint(_loc4_.length());
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc2_ = _loc4_[_loc6_];
            id = uint(_loc2_.@id);
            _loc1_ = _hitDatas.getValue(id);
            _loc1_.attributeArray = _loc2_.@attribute.toString().split(",");
            _loc1_.criticalArray = _loc2_.@critical.toString().split(",");
            _loc1_.fitArray = _loc2_.@fit.toString().split(",");
            _loc1_.physicsArray = _loc2_.@physics.toString().split(",");
            _loc1_.specialArray = _loc2_.@special.toString().split(",");
            _loc1_.hasArray = true;
            _hitDatas.remove(_loc1_.id);
            _hitDatas.add(_loc1_.id,_loc1_);
            _loc6_++;
         }
      }
   }
}

