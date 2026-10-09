package test
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   internal class RequestPool
   {
      
      public function RequestPool()
      {
         super();
      }
      
      public static function sendSwfRequest(url:String, onSuccess:Function, onError:Function = null) : void
      {
         var timerId:Number;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener("complete",function(event:Event):void
         {
            clearTimeout(timerId);
            onSuccess && onSuccess(loader.contentLoaderInfo.applicationDomain);
         });
         loader.contentLoaderInfo.addEventListener("ioError",function(event:Event):void
         {
            clearTimeout(timerId);
            onError && onError("Request failed: " + event.toString());
         });
         timerId = setTimeout(function():void
         {
            onError && onError("Request timeout");
         },5000);
         loader.load(new URLRequest(url));
      }
      
      public static function sendHttpGetRequest(url:String, onSuccess:Function, onError:Function = null) : void
      {
         var timerId:Number;
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.addEventListener("complete",function(event:Event):void
         {
            clearTimeout(timerId);
            onSuccess && onSuccess(urlLoader.data);
         });
         urlLoader.addEventListener("ioError",function(event:Event):void
         {
            clearTimeout(timerId);
            onError && onError("Request failed: " + event.toString());
         });
         timerId = setTimeout(function():void
         {
            onError && onError("Request timeout");
         },5000);
         urlLoader.load(new URLRequest(url));
      }
   }
}

