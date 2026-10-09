package com.taomee.seer2.core.loader
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.media.Sound;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   internal class IntegrateLoader extends EventDispatcher
   {
      
      private var _info:QueueInfo;
      
      private var _urlLoader:URLLoader;
      
      private var _loader:Loader;
      
      private var _sound:Sound;
      
      private var _module:AirLoader;
      
      private var _loader2:Loader;
      
      public function IntegrateLoader()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.close();
         if(this._urlLoader)
         {
            this._urlLoader.removeEventListener("open",this.onOpen);
            this._urlLoader.removeEventListener("complete",this.onComplete);
            this._urlLoader.removeEventListener("progress",this.onProgress);
            this._urlLoader.removeEventListener("ioError",this.onError);
            this._urlLoader.removeEventListener("securityError",this.onError);
         }
         if(this._loader)
         {
            this._loader.contentLoaderInfo.removeEventListener("open",this.onOpen);
            this._loader.contentLoaderInfo.removeEventListener("complete",this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener("progress",this.onProgress);
            this._loader.contentLoaderInfo.removeEventListener("ioError",this.onError);
         }
         if(this._module)
         {
            this._module.removeEventListener("open",this.onOpen);
            this._module.removeEventListener("complete",this.onComplete);
            this._module.removeEventListener("progress",this.onProgress);
            this._module.removeEventListener("ioError",this.onError);
            this._module.removeEventListener("securityError",this.onError);
            this._module.dispose();
         }
         if(this._loader2)
         {
            this._loader2.contentLoaderInfo.removeEventListener("complete",this.onLoadComplete);
         }
         this._urlLoader = null;
         this._loader = null;
         this._sound = null;
         this._module = null;
         this._loader2 = null;
      }
      
      public function get info() : QueueInfo
      {
         return this._info;
      }
      
      public function load(param1:QueueInfo) : void
      {
         this._info = param1;
         switch(this._info.type)
         {
            case "binary":
            case "text":
               this.getURLLoader().dataFormat = this._info.type;
               this.getURLLoader().load(new URLRequest(this._info.url));
               break;
            case "dll":
               this.getLoader().load(new URLRequest(this._info.url),new LoaderContext(false,ApplicationDomain.currentDomain));
               break;
            case "swf":
            case "domain":
            case "image":
               this.getLoader().load(new URLRequest(this._info.url));
               break;
            case "sound":
               this.getSound().load(new URLRequest(this._info.url));
               break;
            case "module":
               this.getModule().load(new URLRequest(this._info.url));
               break;
            default:
               return;
         }
      }
      
      public function close() : void
      {
         if(this._info)
         {
            switch(this._info.type)
            {
               case "binary":
               case "text":
                  this.closeURLLoader();
                  break;
               case "dll":
               case "swf":
               case "domain":
               case "image":
                  this.closeLoader();
                  break;
               case "sound":
                  this.closeSound();
                  break;
               case "module":
                  this.closeModule();
            }
         }
         this._info = null;
      }
      
      private function getURLLoader() : URLLoader
      {
         if(this._urlLoader == null)
         {
            this._urlLoader = new URLLoader();
            this._urlLoader.addEventListener("open",this.onOpen);
            this._urlLoader.addEventListener("complete",this.onComplete);
            this._urlLoader.addEventListener("progress",this.onProgress);
            this._urlLoader.addEventListener("ioError",this.onError);
            this._urlLoader.addEventListener("securityError",this.onError);
         }
         return this._urlLoader;
      }
      
      private function getLoader() : Loader
      {
         if(this._loader == null)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener("open",this.onOpen);
            this._loader.contentLoaderInfo.addEventListener("complete",this.onComplete);
            this._loader.contentLoaderInfo.addEventListener("progress",this.onProgress);
            this._loader.contentLoaderInfo.addEventListener("ioError",this.onError);
         }
         return this._loader;
      }
      
      private function getSound() : Sound
      {
         this.closeSound();
         this._sound = new Sound();
         this._sound.addEventListener("open",this.onOpen);
         this._sound.addEventListener("complete",this.onComplete);
         this._sound.addEventListener("progress",this.onProgress);
         this._sound.addEventListener("ioError",this.onError);
         return this._sound;
      }
      
      private function getModule() : AirLoader
      {
         if(this._module == null)
         {
            this._module = new AirLoader();
            this._module.addEventListener("open",this.onOpen);
            this._module.addEventListener("complete",this.onComplete);
            this._module.addEventListener("progress",this.onProgress);
            this._module.addEventListener("ioError",this.onError);
            this._module.addEventListener("securityError",this.onError);
         }
         return this._module;
      }
      
      private function closeURLLoader() : void
      {
         if(this._urlLoader)
         {
            try
            {
               this._urlLoader.close();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function closeLoader() : void
      {
         if(this._loader)
         {
            this._loader.unload();
            try
            {
               this._loader.close();
            }
            catch(e:Error)
            {
            }
         }
         if(this._loader2)
         {
            this._loader2.unload();
            try
            {
               this._loader2.close();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function closeSound() : void
      {
         if(this._sound)
         {
            this._sound.removeEventListener("open",this.onOpen);
            this._sound.removeEventListener("complete",this.onComplete);
            this._sound.removeEventListener("progress",this.onProgress);
            this._sound.removeEventListener("ioError",this.onError);
            try
            {
               this._sound.close();
            }
            catch(e:Error)
            {
            }
            this._sound = null;
         }
      }
      
      private function closeModule() : void
      {
         if(this._module)
         {
            this._module.unload();
            try
            {
               this._module.close();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function onOpen(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc3_:LoaderContext = null;
         var _loc2_:LoaderInfo = null;
         switch(this._info.type)
         {
            case "binary":
            case "text":
               dispatchEvent(new IntegrateLoaderEvent("complete",this._urlLoader.data));
               break;
            case "dll":
            case "swf":
            case "domain":
               _loc2_ = param1.target as LoaderInfo;
               this._loader2 = new Loader();
               this._loader2.contentLoaderInfo.addEventListener("complete",this.onLoadComplete);
               _loc3_ = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
               _loc3_.allowCodeImport = true;
               this._loader2.loadBytes(_loc2_.bytes,_loc3_);
               break;
            case "image":
               dispatchEvent(new IntegrateLoaderEvent("complete",Bitmap(this._loader.content).bitmapData,this._loader.contentLoaderInfo.applicationDomain));
               break;
            case "sound":
               dispatchEvent(new IntegrateLoaderEvent("complete",this._sound));
               break;
            case "module":
               dispatchEvent(new IntegrateLoaderEvent("complete",this._module.content));
         }
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         switch(this._info.type)
         {
            case "dll":
               dispatchEvent(new IntegrateLoaderEvent("complete",null,this._loader2.contentLoaderInfo.applicationDomain));
               break;
            case "swf":
               dispatchEvent(new IntegrateLoaderEvent("complete",this._loader2.content,this._loader2.contentLoaderInfo.applicationDomain));
               break;
            case "domain":
               dispatchEvent(new IntegrateLoaderEvent("complete",this._loader2.contentLoaderInfo.applicationDomain,this._loader2.contentLoaderInfo.applicationDomain));
         }
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onError(param1:ErrorEvent) : void
      {
         dispatchEvent(new ErrorEvent("error"));
      }
   }
}

