package com.taomee.seer2.app.config
{
   import com.taomee.seer2.app.config.info.shareToInfo;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class ShareToConfig
   {
      
      private static var _instance:ShareToConfig;
      
      private var _isLoaded:Boolean = false;
      
      private var _isLoading:Boolean = false;
      
      private var _allXml:XMLList;
      
      private var _allShare:Vector.<shareToInfo>;
      
      private var callback:Function;
      
      public function ShareToConfig()
      {
         super();
      }
      
      public static function get Instance() : ShareToConfig
      {
         if(!_instance)
         {
            _instance = new ShareToConfig();
         }
         return _instance;
      }
      
      public function getShareToInfo(param1:Function) : void
      {
         if(this._isLoaded)
         {
            param1();
         }
         else
         {
            this.callback = param1;
            this.loadConfig();
         }
      }
      
      private function loadConfig() : void
      {
         if(!this._isLoaded && !this._isLoading)
         {
            this._isLoading = true;
            QueueLoader.load(URLUtil.getActivityXML("shareTo"),"text",this.onComplete);
         }
      }
      
      private function onComplete(param1:ContentInfo) : void
      {
         this._allXml = XML(param1.content).descendants("share");
         this.parserXml();
      }
      
      private function parserXml() : void
      {
         var _loc2_:XML = null;
         var _loc1_:shareToInfo = null;
         this._allShare = new Vector.<shareToInfo>();
         for each(_loc2_ in this._allXml)
         {
            _loc1_ = new shareToInfo();
            _loc1_.id = uint(_loc2_.@id);
            _loc1_.url = String(_loc2_.@url);
            _loc1_.desc = String(_loc2_.@desc);
            _loc1_.title = String(_loc2_.@title);
            _loc1_.summary = String(_loc2_.@summary);
            _loc1_.site = String(_loc2_.@site);
            _loc1_.pics = String(_loc2_.@pics);
            _loc1_.style = int(_loc2_.@style);
            _loc1_.height = uint(_loc2_.@height);
            _loc1_.width = uint(_loc2_.@width);
            _loc1_.flash = String(_loc2_.@flash);
            this._allShare.push(_loc1_);
         }
         this._isLoaded = true;
         this._isLoading = false;
         this.callback();
      }
      
      public function getallShare(param1:int) : shareToInfo
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._allShare.length)
         {
            if(param1 == this._allShare[_loc2_].id)
            {
               return this._allShare[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

