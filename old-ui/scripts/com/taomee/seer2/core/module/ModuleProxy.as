package com.taomee.seer2.core.module
{
   import com.taomee.seer2.core.debugTools.MapPanelProtocolPanel;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.UILoader;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.utils.getDefinitionByName;
   import org.taomee.utils.Tick;
   
   public class ModuleProxy extends EventDispatcher
   {
      
      public static const HIDE:String = "hide";
      
      public static const SHOW:String = "show";
      
      public static const CLOSE:String = "close";
      
      private var _state:String;
      
      private var _url:String;
      
      private var _title:String;
      
      private var _module:Module;
      
      private var _data:Object;
      
      private var _isLoading:Boolean;
      
      private var _name:String;
      
      private var _subName:String;
      
      private var _curtBytes:Number;
      
      private var _totalBytes:Number;
      
      private var _lastBytes:Number;
      
      private var _repeatTimes:uint = 0;
      
      private const gamePanelList:Vector.<String> = Vector.<String>(["MazeGamePanel"]);
      
      private var swapDefinition:* = getDefinitionByName("com.taomee.seer2.app.swap.SwapManager");
      
      private var specialInfoDefinition:* = getDefinitionByName("com.taomee.seer2.app.swap.special.SpecialInfo");
      
      public function ModuleProxy(param1:String, param2:String, param3:String = "")
      {
         super(this);
         this._url = param1;
         this._title = param2;
         this._state = "hide";
         this._name = URLUtil.getFileName(this._url);
         this._subName = param3;
      }
      
      public function get lifecycleType() : String
      {
         if(this._module)
         {
            return this._module.lifecycleType;
         }
         return "nonce";
      }
      
      public function get module() : Module
      {
         return this._module;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get subName() : String
      {
         return this._subName;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function init(param1:Object = null) : void
      {
         this._data = param1;
         if(this._module)
         {
            this._module.init(this._data);
         }
         this.setup();
      }
      
      public function show() : void
      {
         this._state = "show";
         MapPanelProtocolPanel.instance().addLog(2,"\n打开面板： " + this._name);
         if(this._module)
         {
            if(this._module.parent == null)
            {
               this._module.show();
               ModuleManager.dispatchEvent(this._name + this._subName,"show");
               ModuleManager.dispatchEvent1(this._name + this._subName,"show");
               this.disToolbar();
            }
         }
         this.setup();
         this.gamePanel(1);
      }
      
      private function gamePanel(param1:int) : void
      {
         var _loc2_:* = undefined;
         if(this.gamePanelList.indexOf(this._name) != -1)
         {
            _loc2_ = new this.specialInfoDefinition(1,param1);
            this.swapDefinition.swapItem(3643,1,null,null,_loc2_);
         }
      }
      
      public function get hasParent() : Boolean
      {
         if(this._module)
         {
            return this._module.parent == null ? false : true;
         }
         return false;
      }
      
      public function dispose() : void
      {
         ModuleManager.removeForName(this._name,this._subName);
         UILoader.cancel(this._url,this.onLoadComplete);
         if(this._module)
         {
            this._module.dispose();
         }
         this._data = null;
         ModuleManager.dispatchEvent(this._name + this._subName,"dispose");
         if(Tick.instance.hasRender(this.checkBytes))
         {
            Tick.instance.removeRender(this.checkBytes);
         }
         this.gamePanel(2);
      }
      
      public function hide() : void
      {
         this._state = "hide";
         if(this._module)
         {
            if(this._module.parent)
            {
               this._module.hide();
            }
         }
         this._data = null;
         this.gamePanel(2);
         ModuleManager.dispatchEvent(this._name + this._subName,"hide");
      }
      
      private function setup() : void
      {
         if(this._module)
         {
            return;
         }
         if(this._isLoading)
         {
            return;
         }
         this._isLoading = true;
         Tick.instance.addRender(this.checkBytes,1000);
         this.resetBytes();
         UILoader.load(this._url,"module",this.onLoadComplete,this.onLoadError,"",null,this.onLoadOpen,this.onProgress);
      }
      
      private function resetBytes() : void
      {
         this._curtBytes = 0;
         this._totalBytes = 0;
         this._lastBytes = 0;
         this._repeatTimes = 0;
      }
      
      private function checkBytes(param1:int) : void
      {
         if(this._curtBytes != 0 && this._curtBytes == this._totalBytes)
         {
            return;
         }
         if(this._curtBytes == this._lastBytes)
         {
            ++this._repeatTimes;
         }
         else
         {
            this._lastBytes = this._curtBytes;
            this._repeatTimes = 0;
         }
         if(this._repeatTimes >= 10)
         {
            UILoader.cancel(this._url,this.onLoadComplete);
            this.resetBytes();
            this._isLoading = true;
            UILoader.load(this._url,"module",this.onLoadComplete,this.onLoadError,"",null,this.onLoadOpen,this.onProgress);
         }
      }
      
      private function onLoadError(param1:ContentInfo) : void
      {
         this._isLoading = false;
         this.dispose();
      }
      
      private function onLoadOpen(param1:ContentInfo) : void
      {
         ModuleManager.dispatchEvent(this._name + this._subName,"open");
      }
      
      private function disToolbar() : void
      {
         var _loc2_:Object = getDefinitionByName("com.taomee.seer2.app.controls.ToolbarEventDispatcher");
         var _loc1_:Object = getDefinitionByName("com.taomee.seer2.app.controls.ToolbarEvent");
         _loc2_.dispatchEvent(new _loc1_(_loc1_.TOOLBAR_HIDE));
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         this._curtBytes = param1.bytesLoaded;
         this._totalBytes = param1.bytesTotal;
      }
      
      private function onLoadComplete(param1:ContentInfo) : void
      {
         this._isLoading = false;
         this._module = param1.content as Module;
         this._module.setup();
         this._module.init(this._data);
         if(this._state == "show")
         {
            this._module.show();
            ModuleManager.dispatchEvent(this._name + this._subName,"show");
            this.disToolbar();
         }
         ModuleManager.dispatchEvent(this._name + this._subName,"setup");
         if(Tick.instance.hasRender(this.checkBytes))
         {
            Tick.instance.removeRender(this.checkBytes);
         }
      }
   }
}

