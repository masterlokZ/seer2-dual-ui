package com.taomee.seer2.app.debugTools
{
   import com.taomee.seer2.core.debugTools.MapPanelProtocolPanel;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import seer2.next.fight.auto.AutoFightPanel;
   
   public class DebugTools extends Sprite
   {
      
      private static var _instance:DebugTools;
      
      public static var uiLoadedFlag:Boolean = false;
      
      private var _mainUI:MovieClip;
      
      private var _functionPanel:MovieClip;
      
      private var _btnPanel:MovieClip;
      
      private var _dragMc:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      private var FuncBtn:Class;
      
      private var _curIndex:int = 0;
      
      private var _spriteVec:Vector.<Sprite> = new Vector.<Sprite>();
      
      private var _funcBtnVec:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      public function DebugTools(param1:InterClass)
      {
         super();
         if(_instance)
         {
            throw new Error("DebugTools重复实例化");
         }
         this._mainUI = UIManager.getMovieClip("DebugToolMainUI");
         this.FuncBtn = UIManager.getClass("FuncBtn");
         this._closeBtn = this._mainUI["closeBtn"];
         this._closeBtn.addEventListener("click",this.onCloseBtn);
         this._dragMc = this._mainUI["dragMc"];
         this._dragMc.addEventListener("mouseOver",this.onDragMcOver);
         this._dragMc.addEventListener("mouseOut",this.onDragMcOut);
         this._dragMc.addEventListener("mouseDown",this.onMouseDown);
         this._dragMc.addEventListener("mouseUp",this.onMouseUp);
         this._functionPanel = this._mainUI["FunctionPanel"];
         this._btnPanel = this._mainUI["ButtonPanel"];
         this.addBtnToPanel(new this.FuncBtn(),"监视","面板、地图、协议");
         this.addSpriteToPanel(MapPanelProtocolPanel.instance());
         this.addBtnToPanel(new this.FuncBtn(),"协议","模拟协议");
         this.addSpriteToPanel(SimulateSendingProtocolPanel.instance());
         this.addBtnToPanel(new this.FuncBtn(),"修改","跳转地图、拖动NPC");
         this.addSpriteToPanel(JumpTestNpcPanel.instance());
         this.addBtnToPanel(new this.FuncBtn(),"战斗","自动刷怪");
         this.addSpriteToPanel(AutoFightPanel.instance());
         addChild(this._mainUI);
      }
      
      public static function setUp(param1:uint) : void
      {
         uiLoadedFlag = true;
      }
      
      public static function getInstance() : DebugTools
      {
         if(_instance == null)
         {
            _instance = new DebugTools(new InterClass());
         }
         return _instance;
      }
      
      private function addSpriteToPanel(param1:Sprite) : void
      {
         if(this._spriteVec.length != 0)
         {
            param1.visible = false;
         }
         this._functionPanel.addChild(param1);
         this._spriteVec.push(param1);
      }
      
      private function addBtnToPanel(param1:InteractiveObject, param2:String, param3:String) : void
      {
         var _loc7_:TextField = param1["nameTxt"] as TextField;
         var _loc5_:int = 20;
         var _loc4_:int = 10;
         var _loc6_:int = 15;
         if(param1 != null)
         {
            if(_loc7_)
            {
               _loc7_.text = param2;
               _loc7_.mouseEnabled = false;
            }
            param1.x = (param1.width + _loc6_) * this._spriteVec.length + _loc5_;
            param1.y = _loc4_;
            this._btnPanel.addChild(param1);
            this._funcBtnVec.push(param1);
            TooltipManager.addCommonTip(param1,param3);
            param1.addEventListener("click",this.onFuncBtn);
         }
      }
      
      private function onCloseBtn(param1:MouseEvent) : void
      {
         DisplayObjectUtil.removeFromParent(DebugTools.getInstance());
      }
      
      private function onDragMcOver(param1:MouseEvent) : void
      {
         Mouse.cursor = "hand";
      }
      
      private function onDragMcOut(param1:MouseEvent) : void
      {
         Mouse.cursor = "auto";
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function onFuncBtn(param1:MouseEvent) : void
      {
         var _loc2_:int = this._funcBtnVec.indexOf(param1.currentTarget as MovieClip);
         if(-1 != _loc2_)
         {
            if(this._curIndex != _loc2_)
            {
               this._spriteVec[this._curIndex].visible = false;
               this._curIndex = _loc2_;
               this._spriteVec[this._curIndex].visible = true;
            }
         }
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
