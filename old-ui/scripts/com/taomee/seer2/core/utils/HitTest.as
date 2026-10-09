package com.taomee.seer2.core.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HitTest
   {
      
      public static var tileSize:int = 20;
      
      public function HitTest()
      {
         super();
      }
      
      public static function complexHitTestObject(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         var _loc3_:ColorTransform = null;
         var _loc8_:Number = (param1.width < param2.width ? param1.width : param2.width) / tileSize;
         var _loc7_:Number = (param1.height < param2.height ? param1.height : param2.height) / tileSize;
         _loc8_ = _loc8_ < 1 ? 1 : _loc8_;
         _loc7_ = _loc7_ < 1 ? 1 : _loc7_;
         var _loc4_:Point = new Point();
         _loc3_ = new ColorTransform();
         _loc3_.color = 4278190095;
         var _loc6_:Rectangle = intersectionRectangle(param1,param2);
         var _loc5_:Rectangle = new Rectangle();
         return complexIntersectionRectangle(param1,param2,_loc8_,_loc7_,_loc4_,_loc3_,_loc6_,_loc5_,tileSize,tileSize).width != 0;
      }
      
      public static function intersectionRectangle(param1:DisplayObject, param2:DisplayObject) : Rectangle
      {
         if(!param1.root || !param2.root || !param1.hitTestObject(param2))
         {
            return new Rectangle();
         }
         var _loc4_:Rectangle = param1.getBounds(param1.root);
         var _loc3_:Rectangle = param2.getBounds(param2.root);
         return _loc4_.intersection(_loc3_);
      }
      
      private static function complexIntersectionRectangle(param1:DisplayObject, param2:DisplayObject, param3:Number, param4:Number, param5:Point, param6:ColorTransform, param7:Rectangle, param8:Rectangle, param9:int, param10:int) : Rectangle
      {
         var _loc13_:BitmapData = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if(!param1.hitTestObject(param2))
         {
            return new Rectangle();
         }
         param8.x = param7.x;
         param8.y = param7.y;
         param8.width = param7.width / param3;
         param8.height = param7.height / param4;
         _loc13_ = new BitmapData(param9,param10,true,0);
         _loc13_.draw(param1,getDrawMatrix(param1,param8,param3,param4),param6);
         if(param3 != 1 && param4 != 1)
         {
            _loc13_.threshold(_loc13_,_loc13_.rect,param5,">",0,4278190095);
         }
         _loc13_.draw(param2,getDrawMatrix(param2,param8,param3,param4),param6,"add");
         var _loc11_:int = int(_loc13_.threshold(_loc13_,_loc13_.rect,param5,">",4278190095,4294901760));
         var _loc12_:Rectangle = _loc13_.getColorBoundsRect(4294967295,4294901760);
         _loc13_.dispose();
         if(_loc12_.width != 0 && (param3 > 1 || param4 > 1) && _loc11_ <= (param3 + param4) * 1.5)
         {
            _loc16_ = 0.5;
            _loc17_ = 0.5;
            _loc14_ = int(_loc12_.width != param9 ? tileSize : param9 * 2);
            _loc15_ = int(_loc12_.height != param10 ? tileSize : param10 * 2);
            param7.x += (_loc12_.x - _loc16_) * param3;
            param7.y += (_loc12_.y - _loc17_) * param4;
            param7.width = (_loc12_.width + _loc16_ * 2) * param3;
            param7.height = (_loc12_.height + _loc17_ * 2) * param4;
            param3 = param7.width / _loc14_;
            param4 = param7.height / _loc15_;
            param3 = param3 < 2 ? 1 : param3;
            param4 = param4 < 2 ? 1 : param4;
            _loc12_ = complexIntersectionRectangle(param1,param2,param3,param4,param5,param6,param7,param8,_loc14_,_loc15_);
         }
         return _loc12_;
      }
      
      protected static function getDrawMatrix(param1:DisplayObject, param2:Rectangle, param3:Number, param4:Number) : Matrix
      {
         var _loc6_:Point = null;
         var _loc5_:Matrix = null;
         var _loc7_:Matrix = param1.root.transform.concatenatedMatrix;
         _loc6_ = param1.localToGlobal(new Point());
         _loc5_ = param1.transform.concatenatedMatrix;
         _loc5_.tx = (_loc6_.x - param2.x) / param3;
         _loc5_.ty = (_loc6_.y - param2.y) / param4;
         _loc5_.a = _loc5_.a / _loc7_.a / param3;
         _loc5_.d = _loc5_.d / _loc7_.d / param4;
         return _loc5_;
      }
   }
}

