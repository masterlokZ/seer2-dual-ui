package com.taomee.seer2.core.scene
{
   import com.taomee.seer2.core.entity.AnimateElement;
   import com.taomee.seer2.core.entity.AnimateElementManager;
   import com.taomee.seer2.core.entity.IExtendedEntity;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.entity.definition.AnimationDefinition;
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.utils.Util;
   import org.taomee.utils.DomainUtil;
   
   public class MapConfigurator
   {
      
      public static const EXTENDED_ENTITY_BASE:String = "com.taomee.seer2.app.entity.";
      
      public static const DREAM_ENTITY_BASE:String = "com.taomee.seer2.app.dream.";
      
      private var _mapModel:MapModel;
      
      private var _configXml:XML;
      
      public function MapConfigurator(param1:MapModel)
      {
         super();
         this._mapModel = param1;
         this._configXml = this._mapModel.configXml;
      }
      
      public function config() : void
      {
         this.parseEntities();
      }
      
      private function parseEntities() : void
      {
         var _loc1_:XML = null;
         var _loc3_:String = null;
         var _loc2_:XMLList = this._configXml.elements("entities").elements("*");
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = String(_loc1_.name().toString());
            switch(_loc3_)
            {
               case "animation":
                  this.parseAnimation(_loc1_);
                  break;
               case "npc":
                  this.parseNpc(_loc1_);
                  break;
               default:
                  this.parseExtendEntity(_loc3_,_loc1_);
            }
         }
      }
      
      private function parseAnimation(param1:XML) : void
      {
         var _loc2_:AnimationDefinition = new AnimationDefinition(param1);
         AnimateElementManager.createElement(this._mapModel.libManager,_loc2_);
      }
      
      private function parseNpc(param1:XML) : void
      {
         var _loc2_:NpcDefinition = new NpcDefinition(param1);
         MobileManager.createNpc(_loc2_);
      }
      
      private function parseExtendEntity(param1:String, param2:XML) : void
      {
         var _loc6_:AnimateElement = null;
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:AnimateElement = null;
         var _loc7_:Class = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.entity." + Util.capitalizeFirstLetter(param1));
         if(_loc7_)
         {
            _loc6_ = new _loc7_() as AnimateElement;
            _loc6_.id = uint(param2.attribute("id").toString());
            if(_loc6_ is IExtendedEntity)
            {
               (_loc6_ as IExtendedEntity).setData(param2);
            }
            AnimateElementManager.addElement(_loc6_);
            if(MapLoader.isDream)
            {
               if(Util.capitalizeFirstLetter(param1) == "Teleport" || Util.capitalizeFirstLetter(param1) == "teleport")
               {
                  _loc6_.visible = false;
                  if(_loc6_.id == 1)
                  {
                     _loc4_ = _loc6_.x;
                     _loc3_ = _loc6_.y;
                     _loc7_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.dream." + Util.capitalizeFirstLetter("DreamSystemTeleport"));
                     _loc5_ = new _loc7_() as AnimateElement;
                     (_loc5_ as IExtendedEntity).setData(<teleport name="离开梦境"
                                                                                                         pos="1,1"
                                                                                                         targetMapId="70"/>);
                     _loc5_.x = _loc4_;
                     _loc5_.y = _loc3_;
                     AnimateElementManager.addElement(_loc5_);
                  }
               }
            }
         }
      }
      
      public function dispose() : void
      {
         this._mapModel = null;
         this._configXml = null;
      }
   }
}

