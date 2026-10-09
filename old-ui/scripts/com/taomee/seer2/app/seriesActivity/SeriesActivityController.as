package com.taomee.seer2.app.seriesActivity
{
   public class SeriesActivityController
   {
      
      protected var _configs:Array = [];
      
      protected var _configClass:*;
      
      public function SeriesActivityController()
      {
         super();
      }
      
      protected function initConfigs() : void
      {
         var _loc1_:* = undefined;
         var _loc3_:SeriesActivityConfig = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._configs.length)
         {
            _loc1_ = this._configs[_loc2_];
            _loc3_ = new this._configClass(_loc1_);
            this._configs[_loc2_] = _loc3_;
            _loc2_++;
         }
      }
      
      public function getConfigByIndex(param1:int) : SeriesActivityConfig
      {
         return this._configs[param1];
      }
   }
}

