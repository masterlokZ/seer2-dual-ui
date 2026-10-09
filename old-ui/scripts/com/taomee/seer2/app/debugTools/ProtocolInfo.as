package com.taomee.seer2.app.debugTools
{
   public class ProtocolInfo
   {
      
      private var _ID:uint;
      
      private var _haveRequest:Boolean;
      
      private var _haveReturn:Boolean;
      
      private var _name:String;
      
      private var _description:String;
      
      private var _requestPack:Vector.<ParameterInfo>;
      
      private var _returnPack:Vector.<ParameterInfo>;
      
      public function ProtocolInfo(param1:uint, param2:String, param3:String, param4:Boolean, param5:Boolean)
      {
         super();
         this._ID = param1;
         this._name = param2;
         this._description = param3;
         this._haveRequest = param4;
         this._haveReturn = param5;
      }
      
      public function get id() : uint
      {
         return this._ID;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get haveReturn() : Boolean
      {
         return this._haveReturn;
      }
      
      public function set requestPack(param1:*) : void
      {
         this._requestPack = param1;
      }
      
      public function get requestPack() : *
      {
         return this._requestPack;
      }
      
      public function set returnPack(param1:*) : void
      {
         this._returnPack = param1;
      }
      
      public function get returnPack() : *
      {
         return this._returnPack;
      }
      
      public function toString() : String
      {
         var _loc7_:* = undefined;
         var _loc1_:String = null;
         var _loc4_:String = null;
         var _loc3_:String = null;
         var _loc6_:String = "协议号：" + this.id.toString() + "\n";
         var _loc5_:String = "说明：\n\t" + this.description + "\n";
         var _loc8_:Vector.<String> = new Vector.<String>();
         _loc8_.push("请求包格式：\n");
         if(this._haveRequest)
         {
            this.printParameters(this._requestPack,_loc8_);
         }
         else
         {
            _loc8_.push("无");
         }
         _loc7_ = new Vector.<String>();
         _loc7_.push("返回包格式：\n");
         if(this._haveReturn)
         {
            this.printParameters(this._returnPack,_loc7_);
         }
         else
         {
            _loc7_.push("无");
         }
         var _loc2_:String = "";
         for each(_loc1_ in _loc8_)
         {
            _loc2_ += _loc1_;
         }
         _loc4_ = "";
         for each(_loc3_ in _loc7_)
         {
            _loc4_ += _loc3_;
         }
         return _loc6_ + _loc5_ + _loc2_ + _loc4_;
      }
      
      private function printParameters(param1:Vector.<ParameterInfo>, param2:Vector.<String>, param3:String = "") : void
      {
         var _loc4_:ParameterInfo = null;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc4_ = param1[_loc6_];
            param2.push(param3 + _loc4_.pid + ": " + _loc4_.type + "  " + _loc4_.length + "  " + _loc4_.name + "\n\t" + _loc4_.description + "\n");
            if(_loc4_.type == "struct")
            {
               this.printParameters(_loc4_.structList,param2,param3 + _loc4_.pid + "-");
            }
            _loc6_++;
         }
      }
   }
}

