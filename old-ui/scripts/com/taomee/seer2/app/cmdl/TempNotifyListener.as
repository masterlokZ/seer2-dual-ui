package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.cmdl.tempHandler.IHandler;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1548;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.log.Logger;
   import com.taomee.seer2.core.map.grids.HashMap;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   import org.taomee.bean.BaseBean;
   
   public class TempNotifyListener extends BaseBean
   {
      
      private static var _logger:Logger;
      
      private static const ROOT_URL:String = "com.taomee.seer2.app.cmdl.tempHandler.";
      
      private var loader:URLLoader;
      
      private var xml:XML;
      
      private var _infos:HashMap;
      
      public function TempNotifyListener()
      {
         super();
         this._infos = new HashMap();
         this.loadXml();
         _logger = Logger.getLogger("TempNotifyListener");
         finish();
      }
      
      private function onArrive(param1:MessageEvent) : void
      {
         var _loc5_:String = null;
         var _loc3_:Class = null;
         var _loc2_:IHandler = null;
         var _loc4_:LittleEndianByteArray = param1.message.getRawData();
         var _loc6_:Parser_1548 = new Parser_1548(_loc4_);
         if(this._infos.containsKey(_loc6_.eventType))
         {
            _loc5_ = this._infos.getValue(_loc6_.eventType) as String;
         }
         if(_loc5_)
         {
            _loc3_ = getDefinitionByName("com.taomee.seer2.app.cmdl.tempHandler." + _loc5_) as Class;
         }
         if(_loc3_)
         {
            _loc2_ = new _loc3_() as IHandler;
            _loc2_.handle(_loc6_);
         }
         this.showSpecailItem(_loc6_);
      }
      
      private function showSpecailItem(param1:Parser_1548) : void
      {
         if(param1.eventType == 4)
         {
            ServerMessager.addMessage("获得活力值" + param1.eventDataVec[0]);
         }
         if(param1.eventType == 7)
         {
            ModuleManager.showModule(URLUtil.getAppModule("BuLiBuQiBeZhaoPanel"),"打开保护的挑战面板...");
         }
         if(param1.eventType == 9)
         {
            ModuleManager.showModule(URLUtil.getAppModule("CrazyZhanBallSPanel"),"打开保护的挑战面板...");
         }
         if(param1.eventType == 11)
         {
            ModuleManager.showModule(URLUtil.getAppModule("CelebrityPanel"),"打开名人堂...");
         }
      }
      
      private function loadXml() : void
      {
         this.loader = new URLLoader();
         this.loader.addEventListener("complete",this.onComplete);
         this.loader.addEventListener("ioError",this.onError);
         this.loader.addEventListener("securityError",this.onSecurity);
         this.loader.load(new URLRequest(URLUtil.getTempListenerConfig()));
      }
      
      protected function onComplete(param1:Event) : void
      {
         this.loader.removeEventListener("complete",this.onComplete);
         this.loader.removeEventListener("ioError",this.onError);
         this.loader.removeEventListener("securityError",this.onSecurity);
         this.xml = new XML(param1.target.data);
         this.figureOutXML();
      }
      
      private function figureOutXML() : void
      {
         var _loc4_:XML = null;
         var _loc2_:XMLList = this.xml.child("handler");
         var _loc1_:int = _loc2_.length();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = _loc2_[_loc3_];
            this._infos.put(int(_loc4_.@type),String(_loc4_.@cclass));
            _loc3_++;
         }
         Connection.addCommandListener(CommandSet.TEMP_NOTIFY_1548,this.onArrive);
         Connection.releaseCommand(CommandSet.TEMP_NOTIFY_1548);
      }
      
      protected function onError(param1:IOErrorEvent) : void
      {
         this.loader.removeEventListener("complete",this.onComplete);
         this.loader.removeEventListener("ioError",this.onError);
         this.loader.removeEventListener("securityError",this.onSecurity);
      }
      
      protected function onSecurity(param1:SecurityErrorEvent) : void
      {
         this.loader.removeEventListener("complete",this.onComplete);
         this.loader.removeEventListener("ioError",this.onError);
         this.loader.removeEventListener("securityError",this.onSecurity);
      }
   }
}

