package com.taomee.seer2.core.module
{
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DomainUtil;
   
   public class BaseModule extends Module
   {
      
      protected var _resUrl:String;
      
      private var _loadInfo:ContentInfo;
      
      protected var _setBackGround:Boolean = true;
      
      protected var _setCoverUI:Boolean = true;
      
      public function BaseModule()
      {
         super();
         this._lifecycleType = "nonce";
      }
      
      override public function setup() : void
      {
         QueueLoader.load(URLUtil.getModuleRes(this._resUrl),"swf",this.onLoadComplete);
      }
      
      protected function onLoadComplete(param1:ContentInfo) : void
      {
         _mainUI = param1.content as MovieClip;
         this._loadInfo = param1;
         this.setMainUI(_mainUI);
         this.show();
         this.refreshPanel();
         _mainUI.addEventListener("click",this.onPanelClick);
      }
      
      protected function refreshPanel() : void
      {
      }
      
      protected function onPanelClick(param1:MouseEvent) : void
      {
      }
      
      override public function show() : void
      {
         if(_mainUI == null)
         {
            return;
         }
         if(this._setBackGround)
         {
            setBackGround();
         }
         LayerManager.moduleLayer.addChild(this);
         if(this._setCoverUI)
         {
            setCoverUI();
         }
      }
      
      override public function dispose() : void
      {
         if(_mainUI != null)
         {
            _mainUI.removeEventListener("click",this.onPanelClick);
         }
         if(this._loadInfo != null)
         {
            this._loadInfo.dispose();
            this._loadInfo = null;
         }
         super.dispose();
      }
      
      public function getClass(param1:String) : *
      {
         return DomainUtil.getClass(param1,this._loadInfo.domain);
      }
   }
}

