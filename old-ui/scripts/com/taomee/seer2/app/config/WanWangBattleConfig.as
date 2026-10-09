package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.WanWangBattleInfo;
   import com.taomee.seer2.app.config.info.WanWangBattleItemInfo;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.geom.Point;
   
   public class WanWangBattleConfig
   {
      
      private static var _instance:WanWangBattleConfig;
      
      private var _isLoaded:Boolean = false;
      
      private var _isLoading:Boolean = false;
      
      private var _allXml:XMLList;
      
      private var _allStep:Vector.<WanWangBattleInfo>;
      
      private var callback:Function;
      
      public function WanWangBattleConfig()
      {
         super();
      }
      
      public static function get Instance() : WanWangBattleConfig
      {
         if(!_instance)
         {
            _instance = new WanWangBattleConfig();
         }
         return _instance;
      }
      
      public function get allStep() : Vector.<WanWangBattleInfo>
      {
         return this._allStep;
      }
      
      public function getLevelBattle(param1:int) : WanWangBattleInfo
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this._allStep.length)
         {
            _loc2_ += this._allStep[_loc4_].needScore;
            if(param1 <= _loc2_)
            {
               _loc3_ = 1;
               this._allStep[_loc4_].curLevel = int((param1 - (_loc2_ - this._allStep[_loc4_].needScore)) / this._allStep[_loc4_].unitScore) + _loc3_;
               if(this._allStep[_loc4_].curLevel > this._allStep[_loc4_].slevel)
               {
                  this._allStep[_loc4_].curLevel = this._allStep[_loc4_].slevel;
               }
               return this._allStep[_loc4_];
            }
            _loc4_++;
         }
         this._allStep[_loc4_ - 1].curLevel = (_loc2_ - (_loc2_ - this._allStep[_loc4_ - 1].needScore)) / this._allStep[_loc4_ - 1].unitScore;
         return this._allStep[_loc4_ - 1];
      }
      
      public function getStatusBattle(param1:int) : Array
      {
         var _loc2_:Array = [];
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._allStep.length)
         {
            _loc4_ += this._allStep[_loc3_].needScore;
            if(param1 < _loc4_)
            {
               _loc2_.push((param1 - (_loc4_ - this._allStep[_loc3_].needScore)) % this._allStep[_loc3_].unitScore);
               _loc2_.push(this._allStep[_loc3_].unitScore);
               _loc2_.push(this._allStep[_loc3_].posArr);
               return _loc2_;
            }
            _loc3_++;
         }
         _loc2_.push(this._allStep[_loc3_ - 1].unitScore);
         _loc2_.push(this._allStep[_loc3_ - 1].unitScore);
         _loc2_.push(this._allStep[_loc3_ - 1].posArr);
         return _loc2_;
      }
      
      public function getWWBInfo(param1:Function) : void
      {
         if(this._isLoaded)
         {
            param1();
         }
         else
         {
            this.callback = param1;
            this.loadConfig();
         }
      }
      
      private function loadConfig() : void
      {
         if(!this._isLoaded && !this._isLoading)
         {
            this._isLoading = true;
            QueueLoader.load(URLUtil.getActivityXML("wanWangBattle"),"text",this.onComplete);
         }
      }
      
      private function onComplete(param1:ContentInfo) : void
      {
         this._allXml = XML(param1.content).descendants("step");
         this.parserXml();
      }
      
      private function parserXml() : void
      {
         var _loc10_:XML = null;
         var _loc9_:WanWangBattleInfo = null;
         var _loc12_:Array = null;
         var _loc11_:Array = null;
         var _loc4_:int = 0;
         var _loc2_:XMLList = null;
         var _loc7_:Vector.<WanWangBattleItemInfo> = null;
         var _loc5_:XML = null;
         var _loc1_:Array = null;
         var _loc6_:WanWangBattleItemInfo = null;
         var _loc8_:Array = null;
         var _loc3_:Point = null;
         this._allStep = new Vector.<WanWangBattleInfo>();
         for each(_loc10_ in this._allXml)
         {
            _loc9_ = new WanWangBattleInfo();
            _loc9_.sid = int(_loc10_.@sid);
            _loc9_.sresid = String(_loc10_.@sresid);
            _loc9_.slevel = int(_loc10_.@slevel);
            _loc9_.unitScore = int(_loc10_.@unitScore);
            _loc9_.sname = String(_loc10_.@sname);
            _loc9_.needScore = _loc9_.slevel * _loc9_.unitScore;
            _loc12_ = [];
            _loc11_ = String(_loc10_.@posArr).split(";");
            _loc4_ = 0;
            while(_loc4_ < _loc11_.length)
            {
               _loc1_ = String(_loc11_[_loc4_]).split(",");
               _loc12_.push(_loc1_);
               _loc4_++;
            }
            _loc9_.posArr = _loc12_;
            _loc2_ = _loc10_.descendants("item");
            _loc7_ = new Vector.<WanWangBattleItemInfo>();
            for each(_loc5_ in _loc2_)
            {
               _loc6_ = new WanWangBattleItemInfo();
               _loc6_.id = uint(_loc5_.@id);
               _loc6_.name = String(_loc5_.@name);
               _loc6_.count = uint(_loc5_.@count);
               _loc8_ = String(_loc5_.@pos).split(",");
               _loc3_ = new Point(_loc8_[0],_loc8_[1]);
               _loc6_.posArr = _loc3_;
               _loc7_.push(_loc6_);
            }
            _loc9_.itemList = _loc7_;
            this._allStep.push(_loc9_);
         }
         this._allStep.sort(this.downSort);
         this._isLoaded = true;
         this._isLoading = false;
         this.callback();
      }
      
      private function downSort(param1:WanWangBattleInfo, param2:WanWangBattleInfo) : Number
      {
         if(param1.sid < param2.sid)
         {
            return -1;
         }
         if(param1.sid > param2.sid)
         {
            return 1;
         }
         return 0;
      }
   }
}

