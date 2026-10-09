package animation.layer
{
   import animation.loading.ArenaLoadingBar;
   import animation.loading.FighterRevenuePanel;
   import data.pet.FrameData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import ui.end.UI_ScreenCover;
   import utils.CacheUtils;
   import utils.Utils;
   import utils.an.DisplayObjectUtil;
   
   public class FaceLayer extends Sprite
   {
      
      private var _loadingBar:ArenaLoadingBar;
      
      private var _version:int;
      
      public function FaceLayer()
      {
         super();
      }
      
      public function playStart(param1:FrameData, param2:Function) : void
      {
         var loadUrls:Vector.<String>;
         var loadTasks:Array;
         var url:String;
         var loadedCount:int;
         var ready:Boolean;
         var readyProgress:int;
         var frame:FrameData = param1;
         var cb:Function = param2;
         var createLoadTask:* = function(param1:String):Function
         {
            var url:String = param1;
            return function(param1:Function):void
            {
               var cb:Function = param1;
               var ready:* = function():void
               {
                  loadedCount = loadedCount + 1;
                  updateProgress(Math.min(100 * loadedCount / loadUrls.length,99));
                  cb();
               };
               if(url.indexOf("res/pet/fight/") != -1)
               {
                  CacheUtils.loadPet(url,function(param1:*):void
                  {
                     ready();
                  });
               }
               else
               {
                  ready();
               }
            };
         };
         var updateProgress:* = function(param1:int):void
         {
            readyProgress = Math.max(param1,readyProgress);
            if(ready && _loadingBar)
            {
               _loadingBar.updateProgress(param1);
            }
         };
         _version = _version + 1;
         var version:int = _version;
         removeLoadingBar();
         _loadingBar = new ArenaLoadingBar();
         _loadingBar.initData(frame.data.left,frame.data.right,frame.start.tips);
         addChild(_loadingBar);
         Utils.once(_loadingBar,"close",function():void
         {
            if(!checkVersion(version))
            {
               return;
            }
            removeLoadingBar();
            cb();
         });
         loadUrls = frame.start.urls;
         loadTasks = [];
         for each(url in loadUrls)
         {
            loadTasks.push(createLoadTask(url));
         }
         loadedCount = 0;
         Utils.promiseAll(loadTasks,function():void
         {
            updateProgress(100);
         },20000);
         ready = false;
         readyProgress = 0;
         setTimeout(function():void
         {
            ready = true;
            updateProgress(readyProgress);
         },2500);
      }
      
      public function playEnd(param1:int, param2:Function) : void
      {
         var shadow:Shape;
         var fighterRevenuePanel:FighterRevenuePanel;
         var side:int = param1;
         var cb:Function = param2;
         var sprite:Sprite = new Sprite();
         var coverUI:UI_ScreenCover = new UI_ScreenCover();
         coverUI.cacheAsBitmap = true;
         sprite.addChild(coverUI);
         shadow = new Shape();
         shadow.graphics.beginFill(0,0.8);
         shadow.graphics.drawRect(0,0,1200,660);
         shadow.graphics.endFill();
         sprite.addChild(shadow);
         fighterRevenuePanel = new FighterRevenuePanel();
         fighterRevenuePanel.initData(side);
         sprite.addChild(fighterRevenuePanel);
         addChild(sprite);
         Utils.once(fighterRevenuePanel,"close",function():void
         {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
         });
      }
      
      private function checkVersion(param1:int) : Boolean
      {
         return this._version === param1;
      }
      
      private function removeLoadingBar() : void
      {
         if(_loadingBar)
         {
            _loadingBar.dispose();
            _loadingBar = null;
         }
      }
   }
}

