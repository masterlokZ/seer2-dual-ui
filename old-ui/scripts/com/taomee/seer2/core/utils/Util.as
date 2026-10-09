package com.taomee.seer2.core.utils
{
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.utils.StringUtil;
   
   public class Util
   {
      
      public function Util()
      {
         super();
      }
      
      public static function pad(param1:String, param2:String, param3:int, param4:Boolean = true) : String
      {
         var _loc5_:String = param1;
         while(_loc5_.length < param3)
         {
            if(param4)
            {
               _loc5_ += param2;
            }
            else
            {
               _loc5_ = param2 + _loc5_;
            }
         }
         return _loc5_;
      }
      
      public static function splice(param1:String, param2:int, param3:int, param4:String) : String
      {
         if(param2 < 0 || param2 > param1.length)
         {
            return "";
         }
         if(param3 < 0 || param3 > param1.length - param2)
         {
            return "";
         }
         var _loc6_:String = param1.slice(0,param2);
         var _loc5_:String = param1.slice(param2 + param3);
         return _loc6_ + param4 + _loc5_;
      }
      
      public static function replaceVariables(param1:String, param2:Object) : String
      {
         var _loc5_:String = null;
         var _loc4_:String = null;
         var _loc3_:RegExp = null;
         var _loc6_:String = param1;
         for(_loc5_ in param2)
         {
            _loc4_ = "\\{\\$" + _loc5_ + "\\}";
            _loc3_ = new RegExp(_loc4_,"g");
            _loc6_ = _loc6_.replace(_loc3_,String(param2[_loc5_]));
         }
         return _loc6_;
      }
      
      public static function verifyUserID(param1:String) : Boolean
      {
         var _loc2_:RegExp = /^\d{5,11}$/;
         return _loc2_.test(param1);
      }
      
      public static function parsePositionStr(param1:String) : Point
      {
         if(StringUtil.trim(param1) == "")
         {
            return new Point(0,0);
         }
         var _loc2_:Array = param1.split(",");
         return new Point(int(_loc2_[0]),int(_loc2_[1]));
      }
      
      public static function isDigital(param1:String) : Boolean
      {
         var _loc2_:RegExp = /\D/g;
         return !_loc2_.test(param1);
      }
      
      public static function capitalizeFirstLetter(param1:String) : String
      {
         var _loc2_:String = param1.charAt(0);
         var _loc3_:RegExp = new RegExp("^" + _loc2_);
         return param1.replace(_loc3_,_loc2_.toUpperCase());
      }
      
      public static function getSessionString(param1:ByteArray) : String
      {
         param1.endian = "bigEndian";
         var _loc2_:String = "";
         var _loc4_:int = param1.length / 4;
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ += fillString(param1.readUnsignedInt().toString(16));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function fillString(param1:String) : String
      {
         var _loc2_:int = param1.length;
         while(_loc2_ < 8)
         {
            param1 = "0" + param1;
            _loc2_++;
         }
         return param1;
      }
      
      public static function setEnabled(param1:InteractiveObject, param2:Boolean, param3:Boolean = true) : void
      {
         var _loc12_:Sprite = null;
         var _loc7_:SimpleButton = null;
         var _loc5_:Array = null;
         var _loc10_:int = 0;
         var _loc8_:BitmapFilter = null;
         var _loc4_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc6_:ColorMatrixFilter = null;
         _loc12_ = param1 as Sprite;
         if(_loc12_)
         {
            _loc12_.mouseEnabled = param2;
            _loc12_.mouseChildren = param2;
         }
         _loc7_ = param1 as SimpleButton;
         if(_loc7_)
         {
            _loc7_.enabled = param2;
            _loc7_.mouseEnabled = param2;
         }
         if(param3)
         {
            _loc5_ = param1.filters;
            _loc10_ = _loc5_.length - 1;
            while(_loc10_ >= 0)
            {
               _loc8_ = _loc5_[_loc10_];
               if(_loc8_ is ColorMatrixFilter)
               {
                  _loc5_.splice(_loc10_,1);
               }
               _loc10_--;
            }
            if(param2 == false)
            {
               _loc4_ = 0.299;
               _loc9_ = 0.587;
               _loc11_ = 0.114;
               _loc6_ = new ColorMatrixFilter([_loc4_,_loc9_,_loc11_,0,0,_loc4_,_loc9_,_loc11_,0,0,_loc4_,_loc9_,_loc11_,0,0,0,0,0,1,0]);
               _loc5_.push(_loc6_);
            }
            param1.filters = _loc5_;
         }
         else
         {
            param1.filters = null;
         }
      }
   }
}

