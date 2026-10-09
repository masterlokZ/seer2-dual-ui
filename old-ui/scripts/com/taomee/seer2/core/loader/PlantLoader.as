package com.taomee.seer2.core.loader
{
   import flash.events.ProgressEvent;
   
   public class PlantLoader
   {
      
      private static var _loader:QueueLoaderImpl = new QueueLoaderImpl();
      
      private static var _waitList:Array = [];
      
      public function PlantLoader()
      {
         super();
      }
      
      public static function load(param1:String, param2:String, param3:Function, param4:Function = null, param5:String = "", param6:* = null, param7:Function = null, param8:Function = null) : void
      {
         var _loc9_:QueueInfo = null;
         if(hasWaitList(param1,param3))
         {
            return;
         }
         _loc9_ = new QueueInfo();
         _loc9_.url = param1;
         _loc9_.type = param2;
         _loc9_.title = param5;
         _loc9_.data = param6;
         _loc9_.completeHandler = param3;
         _loc9_.errorHandler = param4;
         _loc9_.openHandler = param7;
         _loc9_.progressHandler = param8;
         _waitList.push(_loc9_);
         _loader.load(param1,param2,onComplete,onError,null,2,onOpen,onProgress);
      }
      
      public static function cancel(param1:String, param2:Function) : void
      {
         var _loc4_:QueueInfo = null;
         var _loc6_:Boolean = false;
         var _loc5_:int = int(_waitList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = _waitList[_loc3_];
            if(_loc4_.url == param1)
            {
               if(_loc4_.completeHandler == param2)
               {
                  _waitList.splice(_loc3_,1);
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
         for each(_loc4_ in _waitList)
         {
            if(_loc4_.url == param1)
            {
               return;
            }
         }
         _loader.cancel(param1,onComplete);
      }
      
      private static function hasWaitList(param1:String, param2:Function) : Boolean
      {
         var _loc3_:QueueInfo = null;
         for each(_loc3_ in _waitList)
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
      
      private static function onOpen(param1:ContentInfo) : void
      {
         var _loc3_:QueueInfo = null;
         var _loc2_:int = int(_waitList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _waitList[_loc4_];
            if(_loc3_)
            {
               if(_loc3_.url == param1.url)
               {
                  if(_loc3_.openHandler != null)
                  {
                     _loc3_.openHandler(new ContentInfo(_loc3_.url,_loc3_.type,null,null,_loc3_.data));
                  }
                  break;
               }
            }
            _loc4_++;
         }
      }
      
      private static function onComplete(param1:ContentInfo) : void
      {
         var _loc3_:QueueInfo = null;
         var _loc2_:int = int(_waitList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _waitList[_loc4_];
            if(_loc3_)
            {
               if(_loc3_.url == param1.url)
               {
                  _waitList.splice(_loc4_,1);
                  _loc4_--;
                  if(_loc3_.completeHandler != null)
                  {
                     _loc3_.completeHandler(new ContentInfo(_loc3_.url,_loc3_.type,param1.content,param1.domain,_loc3_.data));
                  }
                  _loc3_.dispose();
               }
            }
            _loc4_++;
         }
      }
      
      private static function onError(param1:ContentInfo) : void
      {
         var _loc3_:QueueInfo = null;
         var _loc2_:int = int(_waitList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _waitList[_loc4_];
            if(_loc3_)
            {
               if(_loc3_.url == param1.url)
               {
                  _waitList.splice(_loc4_,1);
                  _loc4_--;
                  if(_loc3_.errorHandler != null)
                  {
                     _loc3_.errorHandler(new ContentInfo(_loc3_.url,_loc3_.type,null,null,_loc3_.data));
                  }
                  _loc3_.dispose();
               }
            }
            _loc4_++;
         }
      }
      
      private static function onProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:QueueInfo = null;
         if(_loader.currentInfo)
         {
            _loc2_ = int(_waitList.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = _waitList[_loc4_];
               if(_loc3_)
               {
                  if(_loc3_.url == _loader.currentInfo.url)
                  {
                     if(_loc3_.progressHandler != null)
                     {
                        _loc3_.progressHandler(param1);
                     }
                     break;
                  }
               }
               _loc4_++;
            }
         }
      }
   }
}

