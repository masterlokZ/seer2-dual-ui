package com.taomee.seer2.core.cache
{
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   
   internal class CacheImpl
   {
      
      public var maxCount:uint;
      
      public var name:String = "item";
      
      protected var _cacheList:Array = [];
      
      protected var _waitList:Array = [];
      
      public function CacheImpl()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.clear();
         this._waitList = null;
         this._cacheList = null;
      }
      
      public function clear() : void
      {
         var _loc2_:QueueInfo = null;
         var _loc1_:CacheInfo = null;
         for each(_loc2_ in this._waitList)
         {
            _loc2_.dispose();
         }
         for each(_loc1_ in this._cacheList)
         {
            _loc1_.dispose();
         }
      }
      
      public function getContent(param1:String, param2:String, param3:Function, param4:Function = null, param5:* = null, param6:int = 2, param7:Function = null, param8:Function = null) : void
      {
         var _loc10_:QueueInfo = null;
         var _loc9_:CacheInfo = null;
         for each(_loc9_ in this._cacheList)
         {
            if(_loc9_.url == param1)
            {
               this.parseOutput(param1,param2,param3,_loc9_,param5);
               return;
            }
         }
         if(this.hasWaitList(param1,param3))
         {
            return;
         }
         _loc10_ = new QueueInfo();
         _loc10_.url = param1;
         _loc10_.type = param2;
         _loc10_.data = param5;
         _loc10_.completeHandler = param3;
         _loc10_.errorHandler = param4;
         this._waitList.push(_loc10_);
         QueueLoader.load(param1,param2,this.onComplete,this.onError,param5,param6,param7,param8);
      }
      
      public function cancel(param1:String, param2:Function) : void
      {
         var _loc4_:QueueInfo = null;
         var _loc6_:Boolean = false;
         var _loc5_:int = int(this._waitList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this._waitList[_loc3_];
            if(_loc4_.url == param1)
            {
               if(_loc4_.completeHandler == param2)
               {
                  this._waitList.splice(_loc3_,1);
                  _loc4_.dispose();
                  _loc6_ = true;
                  break;
               }
            }
            _loc3_++;
         }
         if(_loc6_ == false)
         {
            return;
         }
         for each(_loc4_ in this._waitList)
         {
            if(_loc4_.url == param1)
            {
               return;
            }
         }
         QueueLoader.cancel(param1,this.onComplete);
      }
      
      private function hasWaitList(param1:String, param2:Function) : Boolean
      {
         var _loc3_:QueueInfo = null;
         for each(_loc3_ in this._waitList)
         {
            if(_loc3_.url == param1)
            {
               if(_loc3_.completeHandler == param2)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function addCache(param1:CacheInfo) : void
      {
         var _loc2_:int = int(this._cacheList.length);
         if(_loc2_ > this.maxCount)
         {
            this.parseCache(this._cacheList);
         }
         this._cacheList.push(param1);
      }
      
      private function onError(param1:ContentInfo) : void
      {
         var _loc3_:QueueInfo = null;
         var _loc2_:int = int(this._waitList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._waitList[_loc4_];
            if(_loc3_)
            {
               if(_loc3_.url == param1.url)
               {
                  this._waitList.splice(_loc4_,1);
                  _loc4_--;
                  if(_loc3_.errorHandler != null)
                  {
                     _loc3_.errorHandler(new ContentInfo(_loc3_.url,param1.type,null,null,_loc3_.data));
                  }
                  _loc3_.dispose();
               }
            }
            _loc4_++;
         }
      }
      
      protected function onComplete(param1:ContentInfo) : void
      {
         var _loc5_:QueueInfo = null;
         var _loc3_:CacheInfo = null;
         var _loc2_:CacheInfo = null;
         var _loc4_:int = int(this._waitList.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._waitList[_loc6_];
            if(_loc5_)
            {
               if(_loc5_.url == param1.url)
               {
                  this._waitList.splice(_loc6_,1);
                  _loc6_--;
                  for each(_loc2_ in this._cacheList)
                  {
                     if(_loc2_.url == _loc5_.url)
                     {
                        _loc3_ = _loc2_;
                        break;
                     }
                  }
                  if(_loc3_ == null)
                  {
                     _loc3_ = new CacheInfo();
                     _loc3_.url = _loc5_.url;
                     this.parseContent(_loc3_,param1);
                     this.addCache(_loc3_);
                  }
                  if(_loc5_.completeHandler != null)
                  {
                     this.parseOutput(_loc5_.url,param1.type,_loc5_.completeHandler,_loc3_,_loc5_.data);
                  }
                  _loc5_.dispose();
               }
            }
            _loc6_++;
         }
      }
      
      protected function parseOutput(param1:String, param2:String, param3:Function, param4:CacheInfo, param5:* = null) : void
      {
         param3(new ContentInfo(param1,param2,param4.content,param4.domain,param5));
      }
      
      protected function parseCache(param1:Array) : void
      {
         var _loc2_:CacheInfo = param1.shift();
         _loc2_.dispose();
      }
      
      protected function parseContent(param1:CacheInfo, param2:ContentInfo) : void
      {
         param1.content = param2.content;
         param1.domain = param2.domain;
      }
   }
}

