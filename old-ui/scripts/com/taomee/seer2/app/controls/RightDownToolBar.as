package com.taomee.seer2.app.controls
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Expo;
   import com.taomee.seer2.app.controls.widget.SupermarketWidgetClick;
   import com.taomee.seer2.app.controls.widget.ToolBarWidget;
   import com.taomee.seer2.app.controls.widget.VipNewsWidgetClick;
   import com.taomee.seer2.app.controls.widget.core.IToolBarWidgetClick;
   import com.taomee.seer2.core.cookie.SharedObjectManager;
   import com.taomee.seer2.core.effects.SoundEffects;
   import com.taomee.seer2.core.manager.VersionManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import org.taomee.ds.HashMap;
   
   public class RightDownToolBar extends Sprite
   {
      
      private static var _instance:RightDownToolBar;
      
      private static const _showXPos:int = 805;
      
      private static const _hideXPos:int = 945;
      
      private var _mainPanel:MovieClip;
      
      private var _retractBtn:MovieClip;
      
      private var _isRetract:Boolean = false;
      
      private var _widgetMap:HashMap;
      
      public function RightDownToolBar()
      {
         super();
         y = 437;
         x = 805;
         this._mainPanel = UIManager.getMovieClip("UI_Toolbar_RightDown");
         addChild(this._mainPanel);
         this._retractBtn = this._mainPanel["btnRetract"];
         this._retractBtn.gotoAndStop(2);
         SoundEffects.setArrow(this._retractBtn);
         this._widgetMap = new HashMap();
         this.addToolBarWidget("vipNews",this._mainPanel["vipNewsBtn"],null,"充值活动",new VipNewsWidgetClick());
         this.addToolBarWidget("supermarket",this._mainPanel["supermarketBtn"],null,"米币商城",new SupermarketWidgetClick());
         this._retractBtn.addEventListener("click",this.onRetractPanel);
      }
      
      public static function show() : void
      {
         if(_instance == null)
         {
            _instance = new RightDownToolBar();
         }
         _instance.show();
      }
      
      public static function hide() : void
      {
         _instance.hide();
      }
      
      public static function extendBar() : void
      {
         _instance.extend();
      }
      
      public static function backBar() : void
      {
         _instance.back();
      }
      
      public function show() : void
      {
         LayerManager.uiLayer.addChild(this);
      }
      
      public function hide() : void
      {
         DisplayObjectUtil.removeFromParent(this);
      }
      
      public function extend() : void
      {
         this._retractBtn.gotoAndStop(2);
         this._isRetract = false;
         this.x = 805;
      }
      
      public function back() : void
      {
         this._retractBtn.gotoAndStop(1);
         this._isRetract = true;
         this.x = 945;
      }
      
      private function addToolBarWidget(param1:String, param2:SimpleButton, param3:MovieClip, param4:String, param5:IToolBarWidgetClick) : void
      {
         var _loc6_:ToolBarWidget = new ToolBarWidget(param2,param3,param4,param5);
         param5.widget = _loc6_;
         this._mainPanel.addChild(_loc6_);
         this._widgetMap.add(param1,_loc6_);
      }
      
      private function onRetractPanel(param1:MouseEvent) : void
      {
         if(this._isRetract)
         {
            this._retractBtn.gotoAndStop(2);
            this._isRetract = false;
            TweenLite.to(this,0.6,{
               "x":805,
               "ease":Expo.easeOut
            });
         }
         else
         {
            this._retractBtn.gotoAndStop(1);
            this._isRetract = true;
            TweenLite.to(this,0.6,{
               "x":945,
               "ease":Expo.easeOut
            });
         }
         param1.stopImmediatePropagation();
      }
      
      private function isReandNews() : Boolean
      {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject("seerNewsVipBtn");
         var _loc1_:String = String(_loc2_.data["newVipBtn"]);
         if(_loc1_ == VersionManager.version)
         {
            return true;
         }
         return false;
      }
   }
}

