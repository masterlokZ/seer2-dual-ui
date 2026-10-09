package com.taomee.seer2.core.entity
{
   import com.taomee.seer2.core.animation.FramePlayer;
   import com.taomee.seer2.core.animation.frame.FrameSequence;
   import com.taomee.seer2.core.entity.definition.AnimationDefinition;
   import com.taomee.seer2.core.entity.handler.IEntityEventHandler;
   import com.taomee.seer2.core.map.ResourceLibrary;
   import com.taomee.seer2.core.scene.BaseScene;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.utils.ByteArray;
   
   public class AnimateElementManager
   {
      
      private static var _scene:BaseScene;
      
      private static var _animationVec:Vector.<AnimateElement>;
      
      public function AnimateElementManager()
      {
         super();
      }
      
      public static function initialize(param1:BaseScene) : void
      {
         _scene = param1;
         _animationVec = new Vector.<AnimateElement>();
      }
      
      public static function createElement(param1:ResourceLibrary, param2:AnimationDefinition) : void
      {
         var _loc5_:FrameSequence = null;
         var _loc4_:FramePlayer = null;
         var _loc3_:AnimateElement = null;
         var _loc6_:Class = param1.getClass(param2.linkage);
         if(_loc6_ != null)
         {
            _loc5_ = new FrameSequence();
            _loc5_.setData(new _loc6_() as ByteArray);
            _loc5_.isFromPool = false;
            _loc4_ = new FramePlayer();
            _loc4_.frameSequence = _loc5_;
            _loc3_ = new AnimateElement();
            _loc3_.animation = _loc4_;
            _loc3_.x = param2.x;
            _loc3_.y = param2.y;
            processEventHandler(_loc3_,param2);
            addElement(_loc3_);
         }
      }
      
      private static function processEventHandler(param1:AnimateElement, param2:AnimationDefinition) : void
      {
         var _loc3_:IEntityEventHandler = null;
         if(param2.handlers)
         {
            for each(_loc3_ in param2.handlers)
            {
               param1.addEventListener(_loc3_.type,_loc3_.onEvent);
            }
         }
      }
      
      public static function addElement(param1:AnimateElement) : void
      {
         _scene.mapModel.content.addChild(param1);
         addToAnimationVec(param1);
      }
      
      public static function getElement(param1:uint) : AnimateElement
      {
         var _loc2_:AnimateElement = null;
         for each(_loc2_ in _animationVec)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private static function addToAnimationVec(param1:AnimateElement) : void
      {
         var _loc2_:AnimateElement = null;
         for each(_loc2_ in _animationVec)
         {
            if(_loc2_ == param1)
            {
               return;
            }
         }
         _animationVec.push(param1);
      }
      
      public static function update() : void
      {
         var _loc1_:AnimateElement = null;
         if(_animationVec.length > 0)
         {
            for each(_loc1_ in _animationVec)
            {
               _loc1_.update();
            }
         }
      }
      
      public static function clearAll() : void
      {
         var _loc1_:AnimateElement = null;
         for each(_loc1_ in _animationVec)
         {
            DisplayObjectUtil.removeFromParent(_loc1_);
            _loc1_.dispose();
         }
         _animationVec = new Vector.<AnimateElement>();
      }
      
      public static function dispose() : void
      {
         clearAll();
         _animationVec = null;
      }
   }
}

