package org.taomee.manager
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class DepthManager
   {
      
      private static var managers:Dictionary;
      
      private var depths:Dictionary;
      
      public function DepthManager()
      {
         super();
         depths = new Dictionary(true);
      }
      
      public static function swapDepth(param1:DisplayObject, param2:Number) : int
      {
         return getManager(param1.parent).swapChildDepth(param1,param2);
      }
      
      public static function swapDepthAll(param1:DisplayObjectContainer) : void
      {
         var dm:DepthManager = null;
         var child:DisplayObject = null;
         var i:int = 0;
         var doc:DisplayObjectContainer = param1;
         dm = getManager(doc);
         var len:int = doc.numChildren;
         var arr:Array = [];
         for(i = 0; i < len; )
         {
            child = doc.getChildAt(i);
            arr.push(child);
            i++;
         }
         arr.sortOn("y",16);
         arr.forEach(function(param1:DisplayObject, param2:int, param3:Array):void
         {
            doc.setChildIndex(param1,param2);
            dm.setDepth(param1,param1.y);
         });
         arr = null;
      }
      
      public static function clearAll() : void
      {
         managers = null;
      }
      
      public static function getManager(param1:DisplayObjectContainer) : DepthManager
      {
         if(!managers)
         {
            managers = new Dictionary(true);
         }
         var _loc2_:DepthManager = managers[param1];
         if(!_loc2_)
         {
            _loc2_ = new DepthManager();
            managers[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public static function bringToBottom(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = param1.parent;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.getChildIndex(param1) != 0)
         {
            _loc2_.setChildIndex(param1,0);
         }
      }
      
      public static function clear(param1:DisplayObjectContainer) : void
      {
         delete managers[param1];
      }
      
      public static function bringToTop(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = param1.parent;
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.addChild(param1);
      }
      
      public function setDepth(param1:DisplayObject, param2:Number) : void
      {
         depths[param1] = param2;
      }
      
      private function countDepth(param1:DisplayObject, param2:int, param3:Number = 0) : Number
      {
         if(depths[param1] == null)
         {
            if(param2 == 0)
            {
               return 0;
            }
            return countDepth(param1.parent.getChildAt(param2 - 1),param2 - 1,param3 + 1);
         }
         return depths[param1] + param3;
      }
      
      public function swapChildDepth(param1:DisplayObject, param2:Number) : int
      {
         var _loc4_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc9_:DisplayObjectContainer = param1.parent;
         if(_loc9_ == null)
         {
            throw new Error("child is not in a container!!");
         }
         var _loc8_:int = _loc9_.getChildIndex(param1);
         var _loc5_:Number = getDepth(param1);
         if(param2 == _loc5_)
         {
            setDepth(param1,param2);
            return _loc8_;
         }
         _loc4_ = _loc9_.numChildren;
         if(_loc4_ < 2)
         {
            setDepth(param1,param2);
            return _loc8_;
         }
         if(param2 < getDepth(_loc9_.getChildAt(0)))
         {
            _loc9_.setChildIndex(param1,0);
            setDepth(param1,param2);
            return 0;
         }
         if(param2 >= getDepth(_loc9_.getChildAt(_loc4_ - 1)))
         {
            _loc9_.setChildIndex(param1,_loc4_ - 1);
            setDepth(param1,param2);
            return _loc4_ - 1;
         }
         var _loc7_:int = 0;
         var _loc6_:int = _loc4_ - 1;
         if(param2 > _loc5_)
         {
            _loc7_ = _loc8_;
            _loc6_ = _loc4_ - 1;
         }
         else
         {
            _loc7_ = 0;
            _loc6_ = _loc8_;
         }
         while(_loc6_ > _loc7_ + 1)
         {
            _loc10_ = _loc7_ + (_loc6_ - _loc7_) / 2;
            _loc11_ = getDepth(_loc9_.getChildAt(_loc10_));
            if(_loc11_ > param2)
            {
               _loc6_ = _loc10_;
            }
            else
            {
               if(_loc11_ >= param2)
               {
                  _loc9_.setChildIndex(param1,_loc10_);
                  setDepth(param1,param2);
                  return _loc10_;
               }
               _loc7_ = _loc10_;
            }
         }
         var _loc3_:Number = getDepth(_loc9_.getChildAt(_loc7_));
         var _loc12_:Number = getDepth(_loc9_.getChildAt(_loc6_));
         var _loc13_:int = 0;
         if(param2 >= _loc12_)
         {
            if(_loc8_ <= _loc6_)
            {
               _loc13_ = Math.min(_loc6_,_loc4_ - 1);
            }
            else
            {
               _loc13_ = Math.min(_loc6_ + 1,_loc4_ - 1);
            }
         }
         else if(param2 < _loc3_)
         {
            if(_loc8_ < _loc7_)
            {
               _loc13_ = Math.max(_loc7_ - 1,0);
            }
            else
            {
               _loc13_ = _loc7_;
            }
         }
         else if(_loc8_ <= _loc7_)
         {
            _loc13_ = _loc7_;
         }
         else
         {
            _loc13_ = Math.min(_loc7_ + 1,_loc4_ - 1);
         }
         _loc9_.setChildIndex(param1,_loc13_);
         setDepth(param1,param2);
         return _loc13_;
      }
      
      public function getDepth(param1:DisplayObject) : Number
      {
         if(depths[param1] == null)
         {
            return countDepth(param1,param1.parent.getChildIndex(param1),0);
         }
         return depths[param1];
      }
   }
}

