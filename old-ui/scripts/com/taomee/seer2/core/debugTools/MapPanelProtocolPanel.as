package com.taomee.seer2.core.debugTools
{
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.TextField;
   
   public class MapPanelProtocolPanel extends Sprite
   {
      
      private static var _instance:MapPanelProtocolPanel;
      
      public static const MAX_LINES:uint = 12;
      
      public static const ADD_DIRECTLY:uint = 0;
      
      public static const MAP_ID:uint = 1;
      
      public static const PANEL_NAME:uint = 2;
      
      public static const ACTIVE_COUNT:uint = 3;
      
      public static const DAY_LIMIT:uint = 4;
      
      public static const SWAP_ID:uint = 5;
      
      public static const MIBUY_ID:uint = 6;
      
      public static const FIGHT_ID:uint = 7;
      
      private var _mainUI:MovieClip;
      
      private var _debugInfo:TextField;
      
      private var _clearBtn:SimpleButton;
      
      private var _saveBtn:SimpleButton;
      
      private var _checkBoxList:Vector.<SimpleButton>;
      
      private var _crossSymbleList:Vector.<MovieClip>;
      
      private var _foreverLimitArr:Array;
      
      private var _buyID:uint;
      
      private var _fightID:uint;
      
      private var _swapID:uint;
      
      private var _addInfoFlag:Array = [false,false,false,false,false,false,false];
      
      private var _configUrl:String = "http://10.1.1.159/cgi-bin/HelloWorld.exe";
      
      private var _configLoader:URLLoader;
      
      private var _userId:String;
      
      public function MapPanelProtocolPanel(param1:InterClass)
      {
         super();
         if(_instance)
         {
            throw new Error("(地图、面板、协议)重复实例化");
         }
         this._mainUI = UIManager.getMovieClip("MapPanelProtocolUI");
         if(this._mainUI == null)
         {
            return;
         }
         this.initset();
         this.initEvent();
         addChild(this._mainUI);
      }
      
      public static function instance() : MapPanelProtocolPanel
      {
         var _loc1_:MapPanelProtocolPanel = null;
         if(_instance == null)
         {
            _loc1_ = new MapPanelProtocolPanel(new InterClass());
            if(_loc1_.mainUI == null)
            {
               _instance = null;
               _loc1_ = null;
            }
            else
            {
               _instance = _loc1_;
            }
         }
         return _instance;
      }
      
      private function initset() : void
      {
         this._checkBoxList = new Vector.<SimpleButton>();
         this._crossSymbleList = new Vector.<MovieClip>();
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            this._checkBoxList.push(this._mainUI["selectBtn" + _loc1_]);
            this._crossSymbleList.push(this._mainUI["crossSymble" + _loc1_]);
            this._crossSymbleList[_loc1_].visible = this._crossSymbleList[_loc1_].mouseChildren = this._crossSymbleList[_loc1_].mouseEnabled = false;
            _loc1_++;
         }
         this._clearBtn = this._mainUI["clearBtn"];
         this._saveBtn = this._mainUI["saveBtn"];
         this._debugInfo = this._mainUI["contentText"];
         this._debugInfo.text = "";
      }
      
      private function initEvent() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._checkBoxList.length)
         {
            this._checkBoxList[_loc1_].addEventListener("click",this.onCheckBtn);
            _loc1_++;
         }
         this._clearBtn.addEventListener("click",this.onClearBtn);
         this._saveBtn.addEventListener("click",this.onSaveBtn);
      }
      
      public function getConfigData(param1:uint) : void
      {
         var userId:uint = param1;
         var request:URLRequest = new URLRequest(this._configUrl);
         var variables:URLVariables = new URLVariables();
         this._userId = userId.toString();
         variables.p0 = 2;
         variables.p1 = this._userId;
         request.data = variables;
         request.method = "POST";
         if(this._configLoader == null)
         {
            this._configLoader = new URLLoader();
         }
         this._configLoader.dataFormat = "variables";
         this._configLoader.addEventListener("complete",this.onUrlLoaderComplete);
         this._configLoader.addEventListener("ioError",this.onIoError);
         this._configLoader.addEventListener("httpStatus",this.onHttpStatus);
         this._configLoader.addEventListener("securityError",this.onSecureError);
         try
         {
            this._configLoader.load(request);
         }
         catch(error:*)
         {
            removeListener();
         }
      }
      
      private function setConfigData(param1:URLVariables) : void
      {
         var variables:URLVariables = param1;
         var request:URLRequest = new URLRequest(this._configUrl);
         request.data = variables;
         request.method = "POST";
         if(this._configLoader == null)
         {
            this._configLoader = new URLLoader();
         }
         this._configLoader.dataFormat = "variables";
         this._configLoader.addEventListener("complete",(function():*
         {
            var saveComplete:Function;
            return saveComplete = function(param1:Event):void
            {
               _configLoader.removeEventListener("complete",saveComplete);
            };
         })());
         this._configLoader.addEventListener("ioError",this.onIoError);
         this._configLoader.addEventListener("httpStatus",this.onHttpStatus);
         try
         {
            this._configLoader.load(request);
         }
         catch(error:Error)
         {
            removeListener();
         }
      }
      
      private function removeListener() : void
      {
         this._configLoader.removeEventListener("complete",this.onUrlLoaderComplete);
         this._configLoader.removeEventListener("ioError",this.onIoError);
         this._configLoader.removeEventListener("httpStatus",this.onHttpStatus);
         this._configLoader.removeEventListener("securityError",this.onSecureError);
      }
      
      private function onUrlLoaderComplete(param1:Event) : void
      {
         var _loc4_:String = null;
         this.removeListener();
         var _loc2_:Object = URLLoader(param1.currentTarget).data;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            if(_loc2_.hasOwnProperty("p" + (_loc3_ + 1)))
            {
               _loc4_ = String(_loc2_["p" + (_loc3_ + 1)]);
               if(_loc4_ == "" || _loc4_ == "0")
               {
                  this._addInfoFlag[_loc3_] = this._crossSymbleList[_loc3_].visible = false;
               }
               else
               {
                  this._addInfoFlag[_loc3_] = this._crossSymbleList[_loc3_].visible = true;
               }
            }
            _loc3_++;
         }
      }
      
      private function onIoError(param1:IOErrorEvent) : void
      {
         this.removeListener();
      }
      
      private function onSecureError(param1:SecurityErrorEvent) : void
      {
         this.removeListener();
      }
      
      private function onHttpStatus(param1:HTTPStatusEvent) : void
      {
         this._configLoader.removeEventListener("httpStatus",this.onHttpStatus);
         if(param1.status == 404)
         {
            throw new Error("CGI应用程序 " + this._configUrl + "不存在。该应用用于内部调试工具的配置缓存，屏蔽相关接口即可。MapPanelProtocolPanel.getConfigData() | MapPanelProtocolPanel.setConfigData()");
         }
      }
      
      private function onCheckBtn(param1:MouseEvent) : void
      {
         var _loc2_:int = this._checkBoxList.indexOf(param1.currentTarget as SimpleButton);
         if(-1 != _loc2_)
         {
            if(this._crossSymbleList[_loc2_].visible)
            {
               this._crossSymbleList[_loc2_].visible = false;
               this._addInfoFlag[_loc2_] = false;
            }
            else
            {
               this._crossSymbleList[_loc2_].visible = true;
               this._addInfoFlag[_loc2_] = true;
            }
         }
      }
      
      private function onClearBtn(param1:MouseEvent) : void
      {
         this._debugInfo.text = "";
         this._debugInfo.scrollV = 1;
      }
      
      private function onSaveBtn(param1:MouseEvent) : void
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.p0 = 1;
         _loc2_.p1 = this._userId;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this._addInfoFlag.length)
         {
            if(this._addInfoFlag[_loc3_] == true)
            {
               _loc2_["p" + (_loc3_ + 2)] = 1;
            }
            else
            {
               _loc2_["p" + (_loc3_ + 2)] = 0;
            }
            _loc3_++;
         }
      }
      
      public function addLog(param1:uint, param2:String) : void
      {
         if(this._debugInfo.scrollV >= 200)
         {
            this.onClearBtn(null);
         }
         if(Boolean(this._debugInfo) && this.checkAddCondition(param1))
         {
            this._debugInfo.appendText(param2);
            if(this._debugInfo.numLines > 12)
            {
               this._debugInfo.scrollV = this._debugInfo.numLines - 12 + 1;
            }
            else
            {
               this._debugInfo.scrollV = 1;
            }
         }
      }
      
      public function set foreverLimitArr(param1:Array) : void
      {
         this._foreverLimitArr = param1;
      }
      
      public function get foreverLimitArr() : Array
      {
         return this._foreverLimitArr;
      }
      
      public function set buyID(param1:uint) : void
      {
         this._buyID = param1;
      }
      
      public function get buyID() : uint
      {
         return this._buyID;
      }
      
      public function set fightID(param1:uint) : void
      {
         this._fightID = param1;
      }
      
      public function get fightID() : uint
      {
         return this._fightID;
      }
      
      public function set swapID(param1:uint) : void
      {
         this._swapID = param1;
      }
      
      public function get swapID() : uint
      {
         return this._swapID;
      }
      
      public function checkAddCondition(param1:uint) : Boolean
      {
         if(param1 == 0 || Boolean(this._addInfoFlag[param1 - 1]))
         {
            return true;
         }
         return false;
      }
      
      public function get mainUI() : MovieClip
      {
         return this._mainUI;
      }
   }
}

class InterClass
{
   
   public function InterClass()
   {
      super();
   }
}
