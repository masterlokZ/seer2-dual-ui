package com.taomee.seer2.core.loader
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class AirLoader extends EventDispatcher
   {
      
      private var _context:LoaderContext;
      
      private var _byteLoader:URLLoader;
      
      private var _loader:Loader;
      
      public function AirLoader()
      {
         super();
         this._byteLoader = new URLLoader();
         this._byteLoader.dataFormat = "binary";
         this._byteLoader.addEventListener("open",this.onOpen);
         this._byteLoader.addEventListener("complete",this.onURLComplete);
         this._byteLoader.addEventListener("ioError",this.onIOError);
         this._byteLoader.addEventListener("securityError",this.onSecurityError);
         this._byteLoader.addEventListener("progress",this.onProgress);
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener("complete",this.onComplete);
         this._loader.contentLoaderInfo.addEventListener("ioError",this.onIOError);
         this._loader.contentLoaderInfo.addEventListener("securityError",this.onSecurityError);
      }
      
      public function dispose() : void
      {
         this._byteLoader.removeEventListener("open",this.onOpen);
         this._byteLoader.removeEventListener("complete",this.onURLComplete);
         this._byteLoader.removeEventListener("ioError",this.onIOError);
         this._byteLoader.removeEventListener("securityError",this.onSecurityError);
         this._byteLoader.removeEventListener("progress",this.onProgress);
         this._loader.contentLoaderInfo.removeEventListener("complete",this.onComplete);
         this._loader.contentLoaderInfo.removeEventListener("ioError",this.onIOError);
         this._loader.contentLoaderInfo.removeEventListener("securityError",this.onSecurityError);
         this._context = null;
         this._byteLoader = null;
         this._loader = null;
      }
      
      public function get content() : DisplayObject
      {
         return this._loader.content;
      }
      
      public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         this._context = param2;
         this._byteLoader.load(param1);
      }
      
      public function close() : void
      {
         try
         {
            this._byteLoader.close();
            this._loader.close();
         }
         catch(e:Error)
         {
         }
      }
      
      public function unload() : void
      {
         this._loader.unload();
      }
      
      public function unloadAndStop(param1:Boolean = true) : void
      {
         this._loader.unloadAndStop(param1);
      }
      
      private function onURLComplete(param1:Event) : void
      {
         if(this._context == null)
         {
            this._context = new LoaderContext();
         }
         if("allowCodeImport" in this._context)
         {
            this._context["allowCodeImport"] = true;
         }
         this._loader.loadBytes(ByteArray(this._byteLoader.data),this._context);
      }
      
      private function onComplete(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onOpen(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         dispatchEvent(param1);
      }
   }
}

