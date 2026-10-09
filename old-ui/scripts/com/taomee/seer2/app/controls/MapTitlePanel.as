package com.taomee.seer2.app.controls
{
   import com.taomee.seer2.app.controls.mapTitleInfo.ExpStartEndTime;
   import com.taomee.seer2.app.controls.mapTitleInfo.MapTitleInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.config.ClientConfig;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   
   public class MapTitlePanel extends Sprite
   {
      
      private static var _instance:MapTitlePanel;
      
      private var _titleSprite:MovieClip;
      
      private var _title:MovieClip;
      
      private var _titleTxt:TextField;
      
      private var _expEvMC:MovieClip;
      
      private var _expMC:MovieClip;
      
      private var _evMC:MovieClip;
      
      private var _weatherIcon:Sprite;
      
      private var _mapId:int;
      
      private var _mapSceneType:int;
      
      private var _mapName:String;
      
      private var _mapWeather:int;
      
      private var _mapCategoryId:int;
      
      private var _mapTitleInfoVec:Vector.<MapTitleInfo>;
      
      public function MapTitlePanel()
      {
         super();
         mouseEnabled = false;
         this.createChildren();
         this.addNavgateBtnEventListener();
         this.getExpEvInfo();
      }
      
      public static function show() : void
      {
         if(_instance == null)
         {
            _instance = new MapTitlePanel();
         }
         layOut();
         LayerManager.uiLayer.addChild(_instance);
         LayerManager.stage.addEventListener("resize",onResize);
      }
      
      public static function hide() : void
      {
         DisplayObjectUtil.removeFromParent(_instance);
         LayerManager.stage.removeEventListener("resize",onResize);
      }
      
      public static function update(param1:MapModel) : void
      {
         if(_instance != null)
         {
            _instance.update(param1);
         }
      }
      
      private static function onResize(param1:Event) : void
      {
         layOut();
      }
      
      public static function layOut() : void
      {
         _instance.x = LayerManager.stage.stageWidth / 2 - 41 * (LayerManager.stage.stageWidth / 1200);
         _instance.y = LayerManager.stage.stageHeight - _instance.height + 76;
      }
      
      private function getExpEvInfo() : void
      {
         Connection.addCommandListener(CommandSet.GET_DAY_EXP_TIME_1213,this.onGetDayExp);
         Connection.send(CommandSet.GET_DAY_EXP_TIME_1213);
      }
      
      private function onGetDayExp(param1:MessageEvent) : void
      {
         var _loc7_:MapTitleInfo = null;
         var _loc3_:uint = 0;
         var _loc2_:ExpStartEndTime = null;
         var _loc4_:int = 0;
         Connection.removeCommandListener(CommandSet.GET_DAY_EXP_TIME_1213,this.onGetDayExp);
         this._mapTitleInfoVec = Vector.<MapTitleInfo>([]);
         var _loc5_:IDataInput = param1.message.getRawData();
         var _loc6_:int = 0;
         while(_loc6_ < 7)
         {
            _loc7_ = new MapTitleInfo();
            _loc7_.day = _loc6_;
            _loc7_.bitTime = _loc5_.readUnsignedInt();
            _loc7_.expIngTime = _loc5_.readUnsignedInt();
            _loc7_.expRate = _loc5_.readUnsignedInt();
            _loc7_.evRate = _loc5_.readUnsignedInt();
            _loc3_ = _loc5_.readUnsignedInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = new ExpStartEndTime();
               _loc2_.startTime = _loc5_.readUnsignedInt();
               _loc2_.endTime = _loc5_.readUnsignedInt();
               _loc7_.expStartEndTimeVec.push(_loc2_);
               _loc4_++;
            }
            this._mapTitleInfoVec.push(_loc7_);
            _loc6_++;
         }
         this.updateExpEv();
      }
      
      private function createChildren() : void
      {
         this._titleSprite = UIManager.getMovieClip("UI_MapTitle");
         this._title = this._titleSprite["title"];
         this._titleTxt = this._title["mapTitleTxt"];
         this._titleTxt.mouseEnabled = false;
         this._titleSprite.buttonMode = true;
         addChild(this._titleSprite);
      }
      
      private function updateExpEv() : void
      {
         var _loc4_:MapTitleInfo = null;
         var _loc3_:MapTitleInfo = null;
         var _loc5_:uint = 0;
         var _loc7_:String = null;
      }
      
      private function addNavgateBtnEventListener() : void
      {
         this._titleSprite.addEventListener("click",this.onNavgateClick);
      }
      
      private function removeNavgateBtnEventListener() : void
      {
         this._titleSprite.removeEventListener("click",this.onNavgateClick);
      }
      
      private function onNavgateClick(param1:MouseEvent) : void
      {
         if(this._mapSceneType == 3)
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("UserPanel"),"正在打开个人信息面板...",this._mapId);
         }
      }
      
      private function update(param1:MapModel) : void
      {
         this._mapId = param1.id;
         this._mapName = param1.name;
         this._mapWeather = param1.weather;
         this._mapCategoryId = param1.categoryId;
         this._mapSceneType = param1.sceneType;
         if(ClientConfig.isDebug)
         {
            this._titleTxt.text = this._mapName + "(" + this._mapId + ")";
         }
         else
         {
            this._titleTxt.text = this._mapName;
         }
         DisplayObjectUtil.removeFromParent(this._weatherIcon);
         if(this._mapWeather > 0)
         {
            this._weatherIcon = UIManager.getSprite("UI_WeatherIcon" + this._mapWeather);
            this._titleSprite.addChild(this._weatherIcon);
         }
         this.updateNavigateBtn();
         this.updateLayout();
         this.updateExpEv();
      }
      
      private function updateNavigateBtn() : void
      {
         if(this._mapSceneType == 3)
         {
            this._titleSprite.buttonMode = true;
            this.addNavgateBtnEventListener();
         }
         else
         {
            this._titleSprite.buttonMode = false;
            this.removeNavgateBtnEventListener();
         }
      }
      
      private function updateLayout() : void
      {
         var _loc2_:int = 125;
         var _loc1_:int = this._titleTxt.textWidth;
         if(Boolean(this._weatherIcon) && Boolean(this._weatherIcon.parent))
         {
            _loc1_ += this._weatherIcon.width;
         }
         var _loc3_:int = 15 + (_loc2_ - _loc1_) >> 1;
         if(Boolean(this._weatherIcon) && Boolean(this._weatherIcon.parent))
         {
            this._weatherIcon.x = 37;
            this._weatherIcon.y = -46;
         }
      }
   }
}

