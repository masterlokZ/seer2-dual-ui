package com.taomee.seer2.core.animation.frame
{
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   
   public class FrameSequence
   {
      
      public var referredCount:uint;
      
      public var isFromPool:Boolean = true;
      
      private var _sheet:FrameSheet;
      
      private var _frameWidth:uint;
      
      private var _frameHeight:uint;
      
      private var _totalFrameNum:uint;
      
      private var _anchor:Point;
      
      private var _labelMap:HashMap;
      
      public function FrameSequence()
      {
         super();
      }
      
      public function setData(param1:ByteArray) : void
      {
         param1.position = 0;
         this.parseHead(param1);
         this._sheet = new FrameSheet(param1);
      }
      
      private function parseHead(param1:ByteArray) : void
      {
         var _loc5_:Object = null;
         var _loc4_:ByteArray = new ByteArray();
         var _loc6_:uint = uint(param1.readShort());
         param1.readBytes(_loc4_,0,_loc6_);
         _loc4_.position = 0;
         this._frameWidth = _loc4_.readShort();
         this._frameHeight = _loc4_.readShort();
         this._totalFrameNum = _loc4_.readShort();
         this._anchor = new Point(_loc4_.readShort(),_loc4_.readShort());
         _loc5_ = _loc4_.readObject();
         var _loc3_:String = _loc5_.l as String;
         var _loc2_:String = _loc5_.i as String;
         this.parseLabel(_loc3_,_loc2_);
      }
      
      private function parseLabel(param1:String, param2:String) : void
      {
         var _loc5_:FrameLabelInfo = null;
         var _loc7_:Array = param1.split(",");
         var _loc6_:Array = param2.split(",");
         this._labelMap = new HashMap();
         var _loc4_:int = int(_loc7_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new FrameLabelInfo(_loc7_[_loc3_],_loc6_[_loc3_ * 2],_loc6_[_loc3_ * 2 + 1]);
            this._labelMap.add(_loc7_[_loc3_],_loc5_);
            _loc3_++;
         }
      }
      
      public function getTotalFrameNum() : uint
      {
         return this._totalFrameNum;
      }
      
      public function getLabelInfo(param1:String) : FrameLabelInfo
      {
         return this._labelMap.getValue(param1);
      }
      
      public function getLabelMap() : HashMap
      {
         return this._labelMap;
      }
      
      public function getFrameInfoByIndex(param1:uint) : FrameInfo
      {
         if(this.isReady == true)
         {
            return this._sheet.getFrameInfo(param1);
         }
         return null;
      }
      
      public function get isReady() : Boolean
      {
         return Boolean(this._sheet) && this._sheet.isReady;
      }
      
      public function get anchor() : Point
      {
         return this._anchor;
      }
      
      public function get frameWidth() : uint
      {
         return this._frameWidth;
      }
      
      public function get frameHeight() : uint
      {
         return this._frameHeight;
      }
      
      public function dispose() : void
      {
         if(this._sheet != null)
         {
            this._sheet.dispose();
            this._sheet = null;
         }
      }
   }
}

