package utils
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.external.ExternalInterface;
   import flash.media.Sound;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class Utils
   {
      
      public function Utils()
      {
         super();
      }
      
      public static function once(param1:IEventDispatcher, param2:String, param3:Function) : void
      {
         var dispatcher:IEventDispatcher = param1;
         var name:String = param2;
         var cb:Function = param3;
         var handleOnce:* = function(param1:Event):void
         {
            dispatcher.removeEventListener(name,handleOnce);
            cb();
         };
         dispatcher.addEventListener(name,handleOnce);
      }
      
      public static function repeat(param1:IEventDispatcher, param2:String, param3:int, param4:Function) : void
      {
         var count:int;
         var dispatcher:IEventDispatcher = param1;
         var name:String = param2;
         var times:int = param3;
         var cb:Function = param4;
         var handle:* = function(param1:Event):void
         {
            count = count + 1;
            cb();
            if(count >= times)
            {
               dispatcher.removeEventListener(name,handle);
            }
         };
         dispatcher.addEventListener(name,handle);
         count = 0;
      }
      
      public static function load(param1:String, param2:Function, param3:Function = null) : Loader
      {
         var url:String = param1;
         var cb:Function = param2;
         var onError:Function = param3;
         var loader:Loader = new Loader();
         var contentLoaderInfo:LoaderInfo = loader.contentLoaderInfo;
         contentLoaderInfo.addEventListener("complete",(function():*
         {
            var onComplete:Function;
            return onComplete = function(param1:Event):void
            {
               contentLoaderInfo.removeEventListener("complete",onComplete);
               cb(contentLoaderInfo);
            };
         })());
         contentLoaderInfo.addEventListener("ioError",(function():*
         {
            var onIOError:Function;
            return onIOError = function(param1:Event):void
            {
               contentLoaderInfo.removeEventListener("ioError",onIOError);
               onError && onError(param1);
            };
         })());
         contentLoaderInfo.addEventListener("securityError",(function():*
         {
            var onSecurityError:Function;
            return onSecurityError = function(param1:Event):void
            {
               contentLoaderInfo.removeEventListener("securityError",onSecurityError);
               onError && onError(param1);
            };
         })());
         loader.load(new URLRequest(url));
         return loader;
      }
      
      public static function loadText(param1:String, param2:Function, param3:Function = null) : void
      {
         var url:String = param1;
         var cb:Function = param2;
         var onError:Function = param3;
         var loader:URLLoader = new URLLoader();
         loader.dataFormat = "text";
         loader.addEventListener("complete",function(param1:Event):void
         {
            cb(loader.data);
         });
         loader.addEventListener("ioError",function(param1:Event):void
         {
            onError && onError(param1);
         });
         loader.addEventListener("securityError",function(param1:Event):void
         {
            onError && onError(param1);
         });
         loader.load(new URLRequest(url));
      }
      
      public static function loadSound(param1:String, param2:Function, param3:Function = null) : void
      {
         var url:String = param1;
         var cb:Function = param2;
         var onError:Function = param3;
         var sound:Sound = new Sound();
         sound.addEventListener("complete",function(param1:Event):void
         {
            cb(sound);
         });
         sound.addEventListener("ioError",function(param1:Event):void
         {
            onError && onError(param1);
         });
         sound.addEventListener("securityError",function(param1:Event):void
         {
            onError && onError(param1);
         });
         sound.load(new URLRequest(url));
      }
      
      public static function callJs(param1:String, param2:String, param3:Object = null, param4:Object = null) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(param1,{
               "func":param1,
               "type":param2,
               "data":param3,
               "version":param4
            });
         }
      }
      
      public static function addCallbackJs(param1:String, param2:Function) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback(param1,param2);
         }
      }
      
      public static function promiseAll(param1:Array, param2:Function, param3:int = 0) : void
      {
         var i:int;
         var array:Array = param1;
         var cb:Function = param2;
         var timeout:int = param3;
         var mayCb:* = function():void
         {
            if(cnt == 0)
            {
               if(timeoutKey > 0)
               {
                  clearTimeout(timeoutKey);
               }
               cnt -= 1;
               async(cb);
            }
         };
         var timeoutKey:uint = uint(timeout > 0 ? setTimeout(function():void
         {
            if(cnt > 0)
            {
               cnt = -1;
               async(cb);
            }
         },timeout) : 0);
         var cnt:uint = array.length;
         mayCb();
         i = 0;
         while(i < array.length)
         {
            array[i](function():void
            {
               cnt -= 1;
               mayCb();
            });
            i = i + 1;
         }
      }
      
      public static function hasLabel(param1:MovieClip, param2:String) : Boolean
      {
         var mc:MovieClip = param1;
         var label:String = param2;
         return mc.currentLabels.some(function(param1:Object, param2:int, param3:Array):Boolean
         {
            return param1.name == label;
         });
      }
      
      public static function onComplete(param1:MovieClip, param2:Function) : void
      {
         var mc:MovieClip = param1;
         var cb:Function = param2;
         var handleEnterFrame:* = function(param1:Event):void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               mc.removeEventListener("enterFrame",handleEnterFrame);
               cb();
            }
         };
         mc.addEventListener("enterFrame",handleEnterFrame);
      }
      
      public static function jsonParse(param1:String) : *
      {
         return JSON.parse(param1);
      }
      
      public static function jsonStringify(param1:*) : *
      {
         return JSON.stringify(param1);
      }
      
      public static function center(param1:DisplayObject, param2:Stage) : void
      {
         param1.x = param2.stageWidth - param1.width >> 1;
         param1.y = param2.stageHeight - param1.height >> 1;
      }
      
      public static function async(param1:Function) : void
      {
         setTimeout(param1,0);
      }
   }
}

