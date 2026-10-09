package com.taomee.seer2.app.processor.quest.handler.branch.quest10140
{
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class Game10140
   {
      
      private var _mainMC:MovieClip;
      
      private var _smc:MovieClip;
      
      private var _panMC:MovieClip;
      
      private var _lianMC:MovieClip;
      
      private var _ballMC:Vector.<MovieClip>;
      
      private var _count:int;
      
      private var _function:Function;
      
      public function Game10140(param1:MovieClip, param2:Function)
      {
         var _loc4_:MovieClip = null;
         super();
         this._function = param2;
         this._mainMC = param1;
         LayerManager.topLayer.addChild(this._mainMC);
         this._smc = this._mainMC["s"];
         this._panMC = this._mainMC["pan"];
         this._lianMC = this._mainMC["lian"];
         this._lianMC.gotoAndStop(1);
         this._lianMC.visible = false;
         this._panMC.buttonMode = true;
         this._panMC.addEventListener("click",this.onClickPanHandler);
         this._smc.gotoAndStop(1);
         this._panMC.gotoAndStop(1);
         this._ballMC = new Vector.<MovieClip>();
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            _loc4_ = this._mainMC["ball" + _loc3_];
            _loc4_.gotoAndStop(1);
            this._ballMC.push(_loc4_);
            _loc3_++;
         }
         this._ballMC[0].gotoAndStop(2);
         this._ballMC[0].buttonMode = true;
         this._ballMC[0].addEventListener("click",this.onClickBall0Handler);
      }
      
      private function onClickPanHandler(param1:MouseEvent) : void
      {
         AlertManager.showAlert("点击魔法光球，开启魔法阵！");
      }
      
      private function onClickBall0Handler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._panMC.buttonMode = false;
         this._panMC.removeEventListener("click",this.onClickPanHandler);
         this._ballMC[0].gotoAndStop(3);
         setTimeout(function():void
         {
            _ballMC[0].visible = false;
            _ballMC[1].gotoAndStop(2);
            _ballMC[1].buttonMode = true;
            _ballMC[1].addEventListener("click",onClickBall1Handler);
         },600);
      }
      
      private function onClickBall1Handler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._ballMC[1].gotoAndStop(3);
         setTimeout(function():void
         {
            _ballMC[1].visible = false;
            _ballMC[2].gotoAndStop(2);
            _ballMC[2].buttonMode = true;
            _ballMC[2].addEventListener("click",onClickBall2Handler);
         },600);
      }
      
      private function onClickBall2Handler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._ballMC[2].gotoAndStop(3);
         setTimeout(function():void
         {
            _ballMC[2].visible = false;
            _ballMC[3].gotoAndStop(2);
            _ballMC[3].buttonMode = true;
            _ballMC[3].addEventListener("click",onClickBall3Handler);
         },600);
      }
      
      private function onClickBall3Handler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._ballMC[3].gotoAndStop(3);
         setTimeout(function():void
         {
            _ballMC[3].visible = false;
            _ballMC[4].gotoAndStop(2);
            _ballMC[4].buttonMode = true;
            _ballMC[4].addEventListener("click",onClickBall4Handler);
         },600);
      }
      
      private function onClickBall4Handler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._ballMC[4].gotoAndStop(3);
         setTimeout(function():void
         {
            _ballMC[4].visible = false;
            _ballMC[5].gotoAndStop(2);
            _ballMC[5].buttonMode = true;
            _ballMC[5].addEventListener("click",onClickBall5Handler);
         },600);
      }
      
      private function onClickBall5Handler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._ballMC[5].gotoAndStop(3);
         setTimeout(function():void
         {
            _ballMC[5].visible = false;
            _panMC.gotoAndStop(2);
            _smc.gotoAndStop(2);
            _smc.buttonMode = true;
            _smc.addEventListener("click",onClickSHandler);
         },600);
      }
      
      private function onClickSHandler(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         this._smc.removeEventListener("click",this.onClickSHandler);
         this._smc.gotoAndStop(1);
         this._lianMC.visible = true;
         this._lianMC.gotoAndPlay(2);
         setTimeout(function():void
         {
            _lianMC.visible = false;
            _lianMC.gotoAndStop(1);
            _panMC.gotoAndStop(3);
            setTimeout(function():void
            {
               dispose();
               if(_function != null)
               {
                  _function();
                  _function = null;
               }
            },500);
         },5000);
      }
      
      public function dispose() : void
      {
         DisplayUtil.removeForParent(this._mainMC);
      }
   }
}

