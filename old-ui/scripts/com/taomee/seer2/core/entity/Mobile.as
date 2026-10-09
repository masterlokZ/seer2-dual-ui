package com.taomee.seer2.core.entity
{
   import com.taomee.seer2.core.entity.constant.MoveStyle;
   import com.taomee.seer2.core.entity.label.LabelStyle;
   import com.taomee.seer2.core.utils.LabelRenderer;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class Mobile extends AnimateElement
   {
      
      private var _overHeadMark:DisplayObject;
      
      private var _carrierMobile:Mobile;
      
      private var _carriedMobileVec:Vector.<Mobile>;
      
      private var _followDistance:int;
      
      private var _label:String;
      
      private var _labelImg:Bitmap;
      
      private var _labelStyle:LabelStyle;
      
      private var _labelPosition:int;
      
      private var _direction:uint = 0;
      
      private var _moveStyle:String = "stand";
      
      public function Mobile()
      {
         super();
      }
      
      public function setLabelStyle(param1:uint, param2:uint) : void
      {
         this._labelStyle = new LabelStyle(param1,param2);
      }
      
      public function set labelPosition(param1:int) : void
      {
         this._labelPosition = param1;
      }
      
      public function get labelPosition() : int
      {
         return this._labelPosition;
      }
      
      public function set label(param1:String) : void
      {
         this._label = param1;
         if(this._labelImg)
         {
            this._labelImg.bitmapData.dispose();
            removeChild(this._labelImg);
         }
         if(this._labelStyle != null)
         {
            this._labelImg = LabelRenderer.getLabelImage(this._label,this._labelStyle.frontColor,this._labelStyle.backColor);
         }
         else
         {
            this._labelImg = LabelRenderer.getLabelImage(this._label);
         }
         this.layoutLabel();
         addChild(this._labelImg);
      }
      
      public function get labelImage() : Bitmap
      {
         return this._labelImg;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      private function layoutLabel() : void
      {
         switch(this._labelPosition)
         {
            case 0:
               this._labelImg.x = -1 * (this._labelImg.width >> 1);
               break;
            case 1:
               this._labelImg.x = -1 * (this._labelImg.width >> 1);
               this._labelImg.y = -this.height;
         }
      }
      
      public function set direction(param1:int) : void
      {
         this._direction = param1;
         var _loc2_:uint = uint(1 & this._direction);
         (this.animation as DisplayObject).scaleX = _loc2_ * 2 - 1;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function set moveStyle(param1:String) : void
      {
         this._moveStyle = param1;
         var _loc2_:String = MoveStyle.getStyleByDirection(this._moveStyle,this.direction);
         this.action = _loc2_;
      }
      
      public function get moveStyle() : String
      {
         return this._moveStyle;
      }
      
      override public function update() : void
      {
         super.update();
         this.updateCarriedMobile();
      }
      
      protected function updateCarriedMobile() : void
      {
         var _loc2_:Mobile = null;
         var _loc1_:int = 0;
         var _loc4_:Point = null;
         var _loc3_:Number = NaN;
         for each(_loc2_ in this._carriedMobileVec)
         {
            _loc1_ = Point.distance(new Point(this.x,this.y),new Point(_loc2_.x,_loc2_.y));
            if(_loc1_ > _loc2_.followDistance)
            {
               _loc4_ = new Point(_loc2_.x - this.x,_loc2_.y - this.y);
               _loc3_ = Math.atan2(_loc4_.y,_loc4_.x);
               _loc2_.x = this.x + _loc2_.followDistance * Math.cos(_loc3_);
               _loc2_.y = this.y + _loc2_.followDistance * Math.sin(_loc3_);
               _loc2_.direction = this.direction;
               _loc2_.moveStyle = "walk";
            }
            else
            {
               _loc2_.moveStyle = "stand";
            }
            _loc2_.update();
         }
      }
      
      public function set followDistance(param1:int) : void
      {
         this._followDistance = param1;
      }
      
      public function get followDistance() : int
      {
         return this._followDistance;
      }
      
      public function setCarrierMobile(param1:Mobile, param2:int) : void
      {
         this._carrierMobile = param1;
         this._carrierMobile.addCarriedMobile(this,param2);
      }
      
      public function getCarrierMobile() : Mobile
      {
         return this._carrierMobile;
      }
      
      public function addCarriedMobile(param1:Mobile, param2:int = 0) : void
      {
         if(this._carriedMobileVec == null)
         {
            this._carriedMobileVec = new Vector.<Mobile>();
         }
         param1._carrierMobile = this;
         param1.followDistance = param2;
         this._carriedMobileVec.push(param1);
      }
      
      public function removeCarriedMobile(param1:Mobile) : void
      {
         if(this._carriedMobileVec == null)
         {
            return;
         }
         var _loc2_:int = this.findCarriedMobileIndex(param1);
         if(_loc2_ >= 0)
         {
            param1._carrierMobile = null;
            this._carriedMobileVec.splice(_loc2_,1);
         }
      }
      
      private function findCarriedMobileIndex(param1:Mobile) : int
      {
         var _loc2_:int = int(this._carriedMobileVec.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this._carriedMobileVec[_loc3_])
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function getCarriedMobileVec() : Vector.<Mobile>
      {
         return this._carriedMobileVec;
      }
      
      public function isCarried() : Boolean
      {
         return this._carrierMobile != null;
      }
      
      public function isCarrier() : Boolean
      {
         return this._carriedMobileVec.length != 0;
      }
      
      public function addOverHeadMark(param1:DisplayObject) : void
      {
         this._overHeadMark = param1;
         this._overHeadMark.y = -this.height;
         addChild(this._overHeadMark);
      }
      
      public function removeOverHeadMark() : void
      {
         if(Boolean(this._overHeadMark) && contains(this._overHeadMark))
         {
            removeChild(this._overHeadMark);
            this._overHeadMark = null;
         }
      }
      
      public function hasOverHeadMark() : Boolean
      {
         return this._overHeadMark != null;
      }
      
      override public function dispose() : void
      {
         this.removeOverHeadMark();
         this._overHeadMark = null;
         super.dispose();
      }
   }
}

