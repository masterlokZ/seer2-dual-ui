package com.taomee.seer2.app.common.dataList
{
   import com.taomee.seer2.app.net.Command;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class DataList extends EventDispatcher
   {
      
      public static const LIST_READY:String = "listReady";
      
      public static const UNIT_READY:String = "unitReady";
      
      public static const UNIT_ADD:String = "unitAdd";
      
      public static const UNIT_REMOVE:String = "unitRemove";
      
      private var _cmd:Command;
      
      private var _dataUnitCls:Class;
      
      private var _dataUnitVec:Vector.<DataUnit>;
      
      private var _loadIdVec:Vector.<int>;
      
      public function DataList(param1:Class, param2:Command)
      {
         super();
         this._cmd = param2;
         this._dataUnitCls = param1;
         this._dataUnitVec = new Vector.<DataUnit>();
      }
      
      public function add(param1:int) : void
      {
         var _loc2_:Vector.<int> = this.getDataUnitIdVec();
         _loc2_.push(param1);
         this.updateVec(_loc2_);
         dispatchEvent(new Event("unitAdd"));
      }
      
      public function remove(param1:int) : void
      {
         var _loc2_:Vector.<int> = this.getDataUnitIdVec();
         var _loc3_:int = _loc2_.length - 1;
         while(_loc3_ >= 0)
         {
            if(_loc2_[_loc3_] == param1)
            {
               _loc2_.splice(_loc3_,1);
               this.updateVec(_loc2_);
               dispatchEvent(new Event("unitRemove"));
            }
            _loc3_--;
         }
      }
      
      public function update(param1:Vector.<int>) : void
      {
         this.updateVec(param1);
         this.sortVec(param1);
      }
      
      private function updateVec(param1:Vector.<int>) : void
      {
         var _loc2_:Vector.<int> = this.getDataUnitIdVec();
         var _loc4_:int = int(this._dataUnitVec.length);
         var _loc3_:int = _loc4_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1.indexOf(this._dataUnitVec[_loc3_].id) == -1)
            {
               this._dataUnitVec.splice(_loc3_,1);
            }
            _loc3_--;
         }
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc2_.indexOf(param1[_loc3_]) == -1)
            {
               this._dataUnitVec.push(new this._dataUnitCls(param1[_loc3_],this._cmd));
            }
            _loc3_++;
         }
      }
      
      private function getDataUnitIdVec() : Vector.<int>
      {
         var _loc2_:Vector.<int> = new Vector.<int>();
         var _loc1_:int = int(this._dataUnitVec.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_.push(this._dataUnitVec[_loc3_].id);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function sortVec(param1:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc2_:DataUnit = null;
         var _loc3_:int = int(this._dataUnitVec.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1.indexOf(this._dataUnitVec[_loc5_].id);
            if(_loc4_ != _loc5_)
            {
               _loc2_ = this._dataUnitVec[_loc4_];
               this._dataUnitVec[_loc4_] = this._dataUnitVec[_loc5_];
               this._dataUnitVec[_loc5_] = _loc2_;
            }
            _loc5_++;
         }
      }
      
      public function load(param1:int, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:DataUnit = null;
         this.cancel();
         this._loadIdVec = new Vector.<int>();
         var _loc6_:int = param1 + param2;
         var _loc5_:int = param1;
         while(_loc5_ < _loc6_)
         {
            if(_loc5_ <= this._dataUnitVec.length - 1)
            {
               _loc4_ = this._dataUnitVec[_loc5_];
               if(param3 || _loc4_ && _loc4_.status == "empty")
               {
                  _loc4_.status = "empty";
                  this._loadIdVec.push(_loc4_.id);
               }
            }
            _loc5_++;
         }
         this.next();
      }
      
      private function next() : void
      {
         var _loc1_:DataUnit = null;
         var _loc2_:int = int(this._loadIdVec.length);
         if(_loc2_ > 0)
         {
            _loc1_ = this.getDataUnit(this._loadIdVec.shift());
            _loc1_.addEventListener("unitReady",this.onDataUnitReady);
            _loc1_.start();
         }
         else
         {
            dispatchEvent(new Event("listReady"));
         }
      }
      
      private function onDataUnitReady(param1:Event) : void
      {
         var _loc2_:DataUnit = param1.currentTarget as DataUnit;
         _loc2_.removeEventListener("unitReady",this.onDataUnitReady);
         this.next();
      }
      
      public function cancel() : void
      {
         var _loc2_:int = int(this._dataUnitVec.length);
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            if(this._dataUnitVec[_loc1_].status == "busy")
            {
               this._dataUnitVec[_loc1_].cancel();
               this._dataUnitVec[_loc1_].removeEventListener("unitReady",this.onDataUnitReady);
               break;
            }
            _loc1_++;
         }
      }
      
      public function clear() : void
      {
         this._dataUnitVec = new Vector.<DataUnit>();
      }
      
      public function getDataUnit(param1:int) : DataUnit
      {
         var _loc2_:DataUnit = null;
         for each(_loc2_ in this._dataUnitVec)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getDataUnitVec() : Vector.<DataUnit>
      {
         return this._dataUnitVec;
      }
      
      public function getDataOnlineUnitVec() : Vector.<DataUnit>
      {
         var _loc1_:DataUnit = null;
         var _loc2_:Vector.<DataUnit> = Vector.<DataUnit>([]);
         for each(_loc1_ in this._dataUnitVec)
         {
            if(_loc1_.data.svrId > 0)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
   }
}

