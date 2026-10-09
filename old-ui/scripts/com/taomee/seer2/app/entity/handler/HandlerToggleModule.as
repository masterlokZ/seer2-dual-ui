package com.taomee.seer2.app.entity.handler
{
   import com.taomee.seer2.app.processor.activity.npcPosHandle.NpcPosHandle;
   import com.taomee.seer2.core.entity.definition.EntityDefinition;
   import com.taomee.seer2.core.entity.handler.IEntityEventHandler;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.Event;
   
   public class HandlerToggleModule implements IEntityEventHandler
   {
      
      private var _type:String;
      
      private var _moduleName:String;
      
      private var _entityDefinition:EntityDefinition;
      
      public function HandlerToggleModule()
      {
         super();
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function setEntityDefinition(param1:EntityDefinition) : void
      {
         this._entityDefinition = param1;
      }
      
      public function initData(param1:XML) : void
      {
         this._moduleName = param1.toString();
      }
      
      public function onEvent(param1:Event) : void
      {
         var _loc7_:String = null;
         var _loc6_:Object = null;
         var _loc3_:Array = null;
         var _loc2_:int = 0;
         var _loc4_:Array = null;
         if(NpcPosHandle.isMove)
         {
            NpcPosHandle.isMove = false;
            return;
         }
         var _loc5_:Array = this._moduleName.split("|");
         if(_loc5_.length < 2)
         {
            ModuleManager.toggleModule(URLUtil.getAppModule(_loc5_[0]),"");
         }
         else
         {
            _loc7_ = String(_loc5_[1]);
            _loc6_ = {};
            _loc3_ = _loc7_.split(";");
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc2_].split(":");
               _loc6_[_loc4_[0]] = _loc4_[1];
               _loc2_++;
            }
            ModuleManager.toggleModule(URLUtil.getAppModule(_loc5_[0]),"",_loc6_);
         }
      }
   }
}

