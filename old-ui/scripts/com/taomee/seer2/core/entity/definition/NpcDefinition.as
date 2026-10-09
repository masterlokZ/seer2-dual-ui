package com.taomee.seer2.core.entity.definition
{
   import com.taomee.seer2.core.entity.handler.EntityEventHandlerParser;
   import com.taomee.seer2.core.entity.handler.IEntityEventHandler;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.core.utils.Util;
   import flash.geom.Point;
   
   public class NpcDefinition extends EntityDefinition
   {
      
      public var resourceId:uint;
      
      public var name:String;
      
      public var direction:uint;
      
      public var path:Vector.<Point>;
      
      public var dialogData:XML;
      
      public var handlers:Vector.<IEntityEventHandler>;
      
      private var _sourcefunctionalityData:XML;
      
      private var _resultFunctionalityData:XML;
      
      private var _node:XML;
      
      public function NpcDefinition(param1:XML)
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         super();
         this._node = param1;
         this.id = param1.attribute("id").toString();
         this.resourceId = param1.attribute("resId").toString();
         this.direction = param1.attribute("dir").toString();
         this.name = param1.attribute("name").toString();
         this.width = int(param1.attribute("width").toString());
         this.height = int(param1.attribute("height").toString());
         var _loc7_:String = param1.attribute("pos").toString();
         var _loc9_:Array = _loc7_.split(",");
         this.x = _loc9_[0];
         this.y = _loc9_[1];
         var _loc8_:String = param1.attribute("actorPos").toString();
         this.actorPos = Util.parsePositionStr(_loc8_);
         _loc4_ = param1.@path;
         _loc3_ = _loc4_.split(",");
         if(_loc3_.length > 2)
         {
            this.path = new Vector.<Point>();
            _loc5_ = int(_loc3_.length);
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               this.path.push(new Point(_loc3_[_loc2_],_loc3_[_loc2_ + 1]));
               _loc2_ += 2;
            }
         }
         this.dialogData = param1.elements("dialog")[0];
         this.functionalityData = param1.elements("functionality")[0];
         var _loc6_:XMLList = param1.elements("eventHandler").elements("*");
         this.handlers = EntityEventHandlerParser.parse(this,_loc6_);
      }
      
      public function getResourceUrl() : String
      {
         return URLUtil.getNpcSwf(this.resourceId);
      }
      
      public function addFunctionalityUnitAt(param1:XML, param2:int) : Boolean
      {
         var _loc3_:XMLList = this._resultFunctionalityData.child("node");
         if(param2 < 0)
         {
            param2 = 0;
         }
         if(param2 > _loc3_.length())
         {
            param2 = _loc3_.length();
         }
         if(param2 < _loc3_.length())
         {
            this._resultFunctionalityData.insertChildBefore(param1,_loc3_[param2]);
         }
         else
         {
            this._resultFunctionalityData.appendChild(param1);
         }
         return true;
      }
      
      public function removeFunctionalityUnit(param1:String) : XML
      {
         var _loc5_:XML = null;
         var _loc2_:XML = null;
         var _loc3_:XML = <functionality></functionality>;
         var _loc4_:int = 0;
         while(_loc4_ < this._resultFunctionalityData.elements("node").length())
         {
            _loc2_ = this._resultFunctionalityData.elements("node")[_loc4_];
            if(String(_loc2_.attribute("name")) == param1)
            {
               _loc5_ = _loc2_;
            }
            else
            {
               _loc3_.appendChild(_loc2_);
            }
            _loc4_++;
         }
         this._resultFunctionalityData = _loc3_;
         return _loc5_;
      }
      
      public function resetFunctionalityData() : void
      {
         this._sourcefunctionalityData = this._node.copy().elements("functionality")[0];
         this._resultFunctionalityData = this._sourcefunctionalityData;
      }
      
      public function set functionalityData(param1:XML) : void
      {
         this._sourcefunctionalityData = param1;
         this._resultFunctionalityData = this._sourcefunctionalityData;
      }
      
      public function get functionalityData() : XML
      {
         return this._resultFunctionalityData;
      }
   }
}

