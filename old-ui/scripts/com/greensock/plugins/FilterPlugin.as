package com.greensock.plugins
{
   import com.greensock.core.*;
   import flash.filters.*;
   
   public class FilterPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 2.03;
      
      public static const API:Number = 1;
      
      protected var _remove:Boolean;
      
      protected var _target:Object;
      
      protected var _index:int;
      
      protected var _filter:BitmapFilter;
      
      protected var _type:Class;
      
      public function FilterPlugin()
      {
         super();
      }
      
      public function onCompleteTween() : void
      {
         var _loc2_:Array = null;
         var _loc1_:int = 0;
         if(_remove)
         {
            _loc2_ = _target.filters;
            if(!(_loc2_[_index] is _type))
            {
               _loc1_ = int(_loc2_.length);
               while(_loc1_--)
               {
                  if(_loc2_[_loc1_] is _type)
                  {
                     _loc2_.splice(_loc1_,1);
                     break;
                  }
               }
            }
            else
            {
               _loc2_.splice(_index,1);
            }
            _target.filters = _loc2_;
         }
      }
      
      protected function initFilter(param1:Object, param2:BitmapFilter, param3:Array) : void
      {
         var _loc5_:String = null;
         var _loc4_:int = 0;
         var _loc7_:HexColorsPlugin = null;
         var _loc8_:Array = _target.filters;
         var _loc6_:Object = param1 is BitmapFilter ? {} : param1;
         _index = -1;
         if(_loc6_.index != null)
         {
            _index = _loc6_.index;
         }
         else
         {
            _loc4_ = int(_loc8_.length);
            while(_loc4_--)
            {
               if(_loc8_[_loc4_] is _type)
               {
                  _index = _loc4_;
                  break;
               }
            }
         }
         if(_index == -1 || _loc8_[_index] == null || _loc6_.addFilter == true)
         {
            _index = _loc6_.index != null ? int(_loc6_.index) : int(_loc8_.length);
            _loc8_[_index] = param2;
            _target.filters = _loc8_;
         }
         _filter = _loc8_[_index];
         if(_loc6_.remove == true)
         {
            _remove = true;
            this.onComplete = onCompleteTween;
         }
         _loc4_ = int(param3.length);
         while(_loc4_--)
         {
            _loc5_ = String(param3[_loc4_]);
            if(_loc5_ in param1 && _filter[_loc5_] != param1[_loc5_])
            {
               if(_loc5_ == "color" || _loc5_ == "highlightColor" || _loc5_ == "shadowColor")
               {
                  _loc7_ = new HexColorsPlugin();
                  _loc7_.initColor(_filter,_loc5_,_filter[_loc5_],param1[_loc5_]);
                  _tweens[_tweens.length] = new PropTween(_loc7_,"changeFactor",0,1,_loc5_,false);
               }
               else if(_loc5_ == "quality" || _loc5_ == "inner" || _loc5_ == "knockout" || _loc5_ == "hideObject")
               {
                  _filter[_loc5_] = param1[_loc5_];
               }
               else
               {
                  addTween(_filter,_loc5_,_filter[_loc5_],param1[_loc5_],_loc5_);
               }
            }
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc4_:PropTween = null;
         var _loc2_:int = int(_tweens.length);
         var _loc3_:Array = _target.filters;
         while(_loc2_--)
         {
            _loc4_ = _tweens[_loc2_];
            _loc4_.target[_loc4_.property] = _loc4_.start + _loc4_.change * param1;
         }
         if(!(_loc3_[_index] is _type))
         {
            _loc2_ = _index = _loc3_.length;
            while(_loc2_--)
            {
               if(_loc3_[_loc2_] is _type)
               {
                  _index = _loc2_;
                  break;
               }
            }
         }
         _loc3_[_index] = _filter;
         _target.filters = _loc3_;
      }
   }
}

