package utils
{
   import animation.ext.ImgPet;
   import animation.ext.S1Pet;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import ui.IconFallback;
   import ui.PetFallback;
   import ui.SkillEffect0;
   import ui.UI_Map0;
   import ui.sound.MapSound0;
   import ui.sound.PetSound0;
   import ui.sound.SkillSound0;
   
   public class CacheUtils extends Sprite
   {
      
      public static const PET_EXT_S1:String = "ext-s1://";
      
      public static const EXT_IMAGE:String = "ext-img://";
      
      public function CacheUtils()
      {
         super();
      }
      
      public static function loadItem(param1:String, param2:Function) : void
      {
         if(mayLoadAsExtImg(param1,param2,IconFallback))
         {
            return;
         }
         CacheUtils0.loadClass(param1,param2,"item",IconFallback);
      }
      
      public static function loadEffect(param1:String, param2:Function) : void
      {
         CacheUtils0.loadClass(param1,param2,"effect",SkillEffect0);
      }
      
      public static function loadPet(param1:String, param2:Function, param3:uint = 3000) : void
      {
         if(mayLoadAsExtImg(param1,param2,PetFallback,ImgPet))
         {
            return;
         }
         if(mayLoadAsExtPet(param1,param2,PetFallback,S1Pet))
         {
            return;
         }
         CacheUtils0.loadClass(param1,param2,"pet",PetFallback,param3);
      }
      
      public static function loadMapContent(param1:String, param2:Function) : void
      {
         if(mayLoadAsExtImg(param1,param2,UI_Map0))
         {
            return;
         }
         CacheUtils0.loadContent(param1,param2,UI_Map0);
      }
      
      public static function loadSkillSound(param1:String, param2:Function) : void
      {
         CacheUtils0.loadSound(param1,param2,SkillSound0);
      }
      
      public static function loadPetSound(param1:String, param2:Function) : void
      {
         CacheUtils0.loadSound(param1,param2,PetSound0);
      }
      
      public static function loadMapSound(param1:String, param2:Function) : void
      {
         CacheUtils0.loadSound(param1,param2,MapSound0);
      }
      
      private static function mayLoadAsExtImg(param1:String, param2:Function, param3:Class, param4:Class = null) : Boolean
      {
         var url:String = param1;
         var cb:Function = param2;
         var fallback:Class = param3;
         var wrapper:Class = param4;
         var EXT:String = "ext-img://";
         if(url.slice(0,EXT.length) === EXT)
         {
            CacheUtils0.loadContent(url.slice(EXT.length),function(param1:*):void
            {
               if(param1 is fallback)
               {
                  cb(param1);
                  return;
               }
               var _loc2_:Bitmap = new Bitmap(param1.bitmapData.clone());
               cb(wrapper ? new wrapper(_loc2_) : _loc2_);
            },fallback);
            return true;
         }
         return false;
      }
      
      private static function mayLoadAsExtPet(param1:String, param2:Function, param3:Class, param4:Class) : Boolean
      {
         var url:String = param1;
         var cb:Function = param2;
         var fallback:Class = param3;
         var wrapper:Class = param4;
         var EXT:String = "ext-s1://";
         if(url.slice(0,EXT.length) === EXT)
         {
            CacheUtils0.loadClass(url.slice(EXT.length),function(param1:MovieClip):void
            {
               if(param1 is fallback)
               {
                  cb(param1);
                  return;
               }
               cb(new wrapper(param1));
            },"pet",fallback);
            return true;
         }
         return false;
      }
   }
}

import data.Config;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.media.Sound;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;
import ui.Resource;

class CacheUtils0
{
   
   private static var loading:int = 0;
   
   private static const S2_DOMAIN:String = "http://seer2.61.com/";
   
   private static const S2_PROXY:String = "https://cdn.jsdelivr.net/gh/arcadia-star/seer2-origin-client@1.0.0/seer2.61.com/";
   
   private static const RES:String = "res/";
   
   private static const waiting:Array = [];
   
   private static const CONTENT_CACHE:LRUCache = new LRUCache(1000);
   
   private static const CLASS_CACHE:LRUCache = new LRUCache(1000);
   
   private static const SOUND_CACHE:LRUCache = new LRUCache(1000);
   
   public function CacheUtils0()
   {
      super();
   }
   
   private static function loadResourceNext() : void
   {
      var _loc1_:* = waiting.shift();
      if(_loc1_)
      {
         loadResource(_loc1_.url,_loc1_.cb,_loc1_.onError);
      }
   }
   
   public static function loadResource(param1:String, param2:Function, param3:Function = null, param4:int = 100, param5:uint = 3000) : void
   {
      var flag:Boolean;
      var loader:Loader;
      var timeout:uint;
      var url:String = param1;
      var cb:Function = param2;
      var onError:Function = param3;
      var max:int = param4;
      var maxTimeout:uint = param5;
      var next:* = function():void
      {
         if(flag)
         {
            return;
         }
         flag = true;
         loading = Number(loading) - 1;
         Utils.async(loadResourceNext);
         clearTimeout(timeout);
      };
      if(loading > max)
      {
         waiting.push({
            "url":url,
            "cb":cb,
            "onError":onError
         });
         return;
      }
      loading = Number(loading) + 1;
      flag = false;
      loader = Utils.load(proxyHttp2Https(url),function(param1:LoaderInfo):void
      {
         if(flag)
         {
            return;
         }
         next();
         cb(param1);
      },function(param1:Event):void
      {
         if(flag)
         {
            return;
         }
         next();
         onError(param1);
      });
      timeout = setTimeout(function():void
      {
         if(flag)
         {
            return;
         }
         if(!loader.contentLoaderInfo.bytesLoaded)
         {
            next();
            onError(new Event("timeout"));
         }
      },maxTimeout);
   }
   
   public static function loadContent(param1:String, param2:Function, param3:Class) : void
   {
      var exist:*;
      var url:String = param1;
      var cb:Function = param2;
      var fallback:Class = param3;
      if(!url)
      {
         cb(new fallback());
         return;
      }
      exist = CONTENT_CACHE.get(url);
      if(exist)
      {
         cb(exist);
         return;
      }
      loadResource(url,function(param1:LoaderInfo):void
      {
         CONTENT_CACHE.put(url,param1.content);
         cb(param1.content);
      },function():void
      {
         cb(new fallback());
      });
   }
   
   public static function loadClass(param1:String, param2:Function, param3:String, param4:Class, param5:uint = 3000) : void
   {
      var clazz:Class;
      var exist:Class;
      var url:String = param1;
      var cb:Function = param2;
      var name:String = param3;
      var fallback:Class = param4;
      var maxTimeout:uint = param5;
      if(!url)
      {
         cb(new fallback());
         return;
      }
      if(url.slice(0,"internal://".length) === "internal://")
      {
         clazz = Resource.clazz[url.slice("internal://".length)];
         if(clazz)
         {
            cb(new clazz());
            return;
         }
      }
      exist = CLASS_CACHE.get(url);
      if(exist)
      {
         cb(new exist());
         return;
      }
      loadResource(url,function(param1:LoaderInfo):void
      {
         var _loc2_:Class = null;
         try
         {
            _loc2_ = param1.applicationDomain.getDefinition(name) as Class;
            CLASS_CACHE.put(url,_loc2_);
            cb(new _loc2_());
         }
         catch(e:Object)
         {
            cb(new fallback());
         }
      },function():void
      {
         cb(new fallback());
      },100,maxTimeout);
   }
   
   public static function loadSound(param1:String, param2:Function, param3:Class) : void
   {
      var exist:Sound;
      var url:String = param1;
      var cb:Function = param2;
      var fallback:Class = param3;
      if(!url)
      {
         cb(new fallback());
         return;
      }
      exist = SOUND_CACHE.get(url);
      if(exist)
      {
         cb(exist);
         return;
      }
      Utils.loadSound(proxyHttp2Https(url),function(param1:Sound):void
      {
         SOUND_CACHE.put(url,param1);
         cb(param1);
      },function():void
      {
         cb(new fallback());
      });
   }
   
   private static function proxyHttp2Https(param1:String) : String
   {
      if(Config.redirectRes && param1.slice(0,"res/".length) === "res/")
      {
         param1 = "http://seer2.61.com/" + param1;
      }
      if(Config.isHttps && param1.slice(0,"http://seer2.61.com/".length) === "http://seer2.61.com/")
      {
         return "https://cdn.jsdelivr.net/gh/arcadia-star/seer2-origin-client@1.0.0/seer2.61.com/" + param1.slice("http://seer2.61.com/".length);
      }
      return param1;
   }
}
