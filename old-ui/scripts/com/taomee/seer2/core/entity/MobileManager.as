package com.taomee.seer2.core.entity
{
   import com.taomee.seer2.core.entity.definition.NpcDefinition;
   import com.taomee.seer2.core.entity.handler.IEntityEventHandler;
   import com.taomee.seer2.core.log.Logger;
   import com.taomee.seer2.core.scene.BaseScene;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import org.taomee.ds.HashMap;
   
   public class MobileManager
   {
      
      private static var _scene:BaseScene;
      
      private static var _mobileTypeMap:HashMap;
      
      private static var _logger:Logger;
      
      public function MobileManager(param1:Blocker)
      {
         super();
      }
      
      public static function initialize(param1:BaseScene) : void
      {
         _scene = param1;
         _mobileTypeMap = new HashMap();
         _logger = Logger.getLogger("MobileManager");
      }
      
      public static function createNpc(param1:NpcDefinition) : Mobile
      {
         if(param1.path == null)
         {
            return createUnwalkableNpc(param1);
         }
         return createWalkableNpc(param1);
      }
      
      private static function createUnwalkableNpc(param1:NpcDefinition) : Mobile
      {
         var _loc2_:Mobile = new Mobile();
         processNpc(_loc2_,param1);
         return _loc2_;
      }
      
      private static function createWalkableNpc(param1:NpcDefinition) : Mobile
      {
         var _loc2_:PathMobile = new PathMobile();
         processNpc(_loc2_,param1);
         return _loc2_;
      }
      
      private static function processNpc(param1:Mobile, param2:NpcDefinition) : void
      {
         param1.id = param2.id;
         param1.resourceUrl = param2.getResourceUrl();
         param1.x = param2.x;
         param1.y = param2.y;
         param1.width = param2.width;
         param1.height = param2.height;
         param1.labelPosition = 1;
         param1.label = param2.name;
         param1.direction = param2.direction;
         if(param2.path != null)
         {
            (param1 as PathMobile).setPath(param2.path);
         }
         processEventHandler(param1,param2);
         addMobile(param1,"npc");
      }
      
      private static function processEventHandler(param1:Mobile, param2:NpcDefinition) : void
      {
         var _loc3_:IEntityEventHandler = null;
         if(param2.handlers)
         {
            param1.buttonMode = true;
            for each(_loc3_ in param2.handlers)
            {
               param1.addEventListener(_loc3_.type,_loc3_.onEvent);
            }
         }
      }
      
      public static function getMobile(param1:uint, param2:String) : Mobile
      {
         var _loc3_:Mobile = null;
         var _loc4_:Vector.<Mobile> = getMobileVec(param2);
         if(_loc4_ != null)
         {
            for each(_loc3_ in _loc4_)
            {
               if(_loc3_.id == param1)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public static function removeMobileById(param1:uint, param2:String) : void
      {
         var _loc5_:Vector.<Mobile> = null;
         var _loc4_:int = 0;
         var _loc3_:Mobile = null;
         if(_mobileTypeMap.containsKey(param2))
         {
            _loc5_ = _mobileTypeMap.getValue(param2) as Vector.<Mobile>;
            _loc4_ = getMobileIndex(_loc5_,param1);
            if(_loc4_ != -1)
            {
               _loc3_ = _loc5_[_loc4_];
               DisplayObjectUtil.removeFromParent(_loc3_);
               _loc3_.dispose();
               _loc5_.splice(_loc4_,1);
            }
            else
            {
               _logger.warn(param2 + "类型Mobile中不包含ID为 " + param1 + " 的Mobile");
            }
         }
         else
         {
            _logger.warn("不包含此类Mobile!");
         }
      }
      
      public static function removeMobile(param1:Mobile, param2:String) : void
      {
         var _loc4_:Vector.<Mobile> = null;
         var _loc3_:int = 0;
         if(_mobileTypeMap.containsKey(param2))
         {
            _loc4_ = _mobileTypeMap.getValue(param2) as Vector.<Mobile>;
            _loc3_ = _loc4_.indexOf(param1);
            if(_loc3_ != -1)
            {
               param1 = _loc4_[_loc3_];
               DisplayObjectUtil.removeFromParent(param1);
               param1.dispose();
               _loc4_.splice(_loc3_,1);
            }
            else
            {
               _logger.warn(param2 + "类型Mobile中不包含该Mobile");
            }
         }
         else
         {
            _logger.warn("不包含此类Mobile!");
         }
      }
      
      private static function getMobileIndex(param1:Vector.<Mobile>, param2:uint) : int
      {
         var _loc5_:* = -1;
         var _loc4_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1[_loc3_].id == param2)
            {
               _loc5_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public static function addMobile(param1:Mobile, param2:String) : void
      {
         if(_mobileTypeMap.containsKey(param2) == false)
         {
            _mobileTypeMap.add(param2,new Vector.<Mobile>());
         }
         var _loc3_:Vector.<Mobile> = _mobileTypeMap.getValue(param2) as Vector.<Mobile>;
         _loc3_.push(param1);
         _scene.mapModel.content.addChild(param1);
      }
      
      public static function update() : void
      {
         var _loc2_:Array = null;
         var _loc1_:Vector.<Mobile> = null;
         var _loc3_:Mobile = null;
         if(_mobileTypeMap.length > 0)
         {
            _loc2_ = _mobileTypeMap.getValues();
            for each(_loc1_ in _loc2_)
            {
               for each(_loc3_ in _loc1_)
               {
                  _loc3_.update();
               }
            }
         }
      }
      
      public static function clearAll() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = _mobileTypeMap.getKeys();
         for each(_loc1_ in _loc2_)
         {
            clearMobileVec(_loc1_);
         }
         _mobileTypeMap = new HashMap();
      }
      
      public static function clearMobileVec(param1:String) : void
      {
         var _loc2_:Vector.<Mobile> = null;
         var _loc3_:Mobile = null;
         if(_mobileTypeMap.containsKey(param1))
         {
            _loc2_ = _mobileTypeMap.getValue(param1) as Vector.<Mobile>;
            for each(_loc3_ in _loc2_)
            {
               DisplayObjectUtil.removeFromParent(_loc3_);
               _loc3_.dispose();
            }
            _mobileTypeMap.remove(param1);
         }
         else
         {
            _logger.warn("不包含类型为 " + param1 + " Mobile!");
         }
      }
      
      public static function hideMoileVec(param1:String) : void
      {
         var _loc2_:Vector.<Mobile> = null;
         var _loc3_:Mobile = null;
         if(_mobileTypeMap.containsKey(param1))
         {
            _loc2_ = _mobileTypeMap.getValue(param1) as Vector.<Mobile>;
            for each(_loc3_ in _loc2_)
            {
               _loc3_.visible = false;
            }
         }
         else
         {
            _logger.warn("不包含类型为 " + param1 + " Mobile!");
         }
      }
      
      public static function showMoileVec(param1:String) : void
      {
         var _loc2_:Vector.<Mobile> = null;
         var _loc3_:Mobile = null;
         if(_mobileTypeMap.containsKey(param1))
         {
            _loc2_ = _mobileTypeMap.getValue(param1) as Vector.<Mobile>;
            for each(_loc3_ in _loc2_)
            {
               _loc3_.visible = true;
            }
         }
         else
         {
            _logger.warn("不包含类型为 " + param1 + " Mobile!");
         }
      }
      
      public static function getMobileVec(param1:String) : Vector.<Mobile>
      {
         if(_mobileTypeMap.containsKey(param1))
         {
            return _mobileTypeMap.getValue(param1) as Vector.<Mobile>;
         }
         return null;
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
