package com.taomee.seer2.core.entity.handler
{
   import com.taomee.seer2.core.entity.definition.EntityDefinition;
   import org.taomee.utils.DomainUtil;
   
   public class EntityEventHandlerParser
   {
      
      public function EntityEventHandlerParser(param1:Blocker)
      {
         super();
      }
      
      public static function parse(param1:EntityDefinition, param2:XMLList) : Vector.<IEntityEventHandler>
      {
         var _loc9_:Vector.<IEntityEventHandler> = null;
         var _loc8_:XML = null;
         var _loc5_:String = null;
         var _loc4_:XML = null;
         var _loc7_:String = null;
         var _loc6_:Class = null;
         var _loc3_:IEntityEventHandler = null;
         if(param2.length() > 0)
         {
            _loc9_ = new Vector.<IEntityEventHandler>();
            for each(_loc8_ in param2)
            {
               _loc5_ = String(_loc8_.name().toString());
               _loc4_ = _loc8_.child(0)[0];
               if(_loc4_ != null)
               {
                  _loc7_ = String(_loc4_.name().toString());
                  _loc6_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.entity.handler." + _loc7_);
                  if(_loc6_)
                  {
                     _loc3_ = new _loc6_();
                     _loc3_.setEntityDefinition(param1);
                     _loc3_.initData(_loc4_.valueOf());
                     _loc3_.type = _loc5_;
                     _loc9_.push(_loc3_);
                  }
               }
            }
         }
         return _loc9_;
      }
   }
}

class Blocker
{
   
   public function Blocker()
   {
      super();
   }
}
