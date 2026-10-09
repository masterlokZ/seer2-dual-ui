package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.component.MouseClickHintSprite;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcessor_80063 extends MapProcessor
   {
      
      private const fightIDList:Vector.<uint> = Vector.<uint>([683,677,678,679,680,681,682]);
      
      private var _fengMC:SimpleButton;
      
      private var _mainBtn:SimpleButton;
      
      private var _petList:Vector.<MovieClip>;
      
      private var _currArr:Array = [];
      
      private var _currPetArr:Array = [];
      
      private var _mouseHint:MouseClickHintSprite;
      
      public function MapProcessor_80063(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         ServerBufferManager.getServerBuffer(215,this.onServerBuff);
         StatisticsManager.sendNovice("0x10034200");
      }
      
      private function onServerBuff(param1:ServerBuffer) : void
      {
         var ser:ServerBuffer = param1;
         if(ser.readDataAtPostion(0) != 1)
         {
            ServerBufferManager.updateServerBuffer(215,0,1);
            MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("DanceFengPlay"),function():void
            {
               initRes();
            },true,false,2);
         }
         else
         {
            this.initRes();
         }
      }
      
      private function initRes() : void
      {
         this.clearAll();
         ActiveCountManager.requestActiveCount(203958,function(param1:uint, param2:int):void
         {
            _currArr = [];
            _currArr[0] = (param2 & 1) == 1;
            _currArr[1] = (param2 & 2) == 2;
            _currArr[2] = (param2 & 4) == 4;
            _currArr[3] = (param2 & 8) == 8;
            _currArr[4] = (param2 & 0x10) == 16;
            _currArr[5] = (param2 & 0x20) == 32;
            _currArr[6] = (param2 & 0x40) == 64;
            _currPetArr = [];
            var _loc4_:Boolean = false;
            var _loc3_:int = 0;
            while(_loc3_ < _currArr.length)
            {
               if(_currArr[_loc3_])
               {
                  _currPetArr.push(_loc3_);
                  _loc4_ = true;
               }
               _loc3_++;
            }
            updateBtn(_loc4_);
         });
      }
      
      private function updateBtn(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         this._fengMC = _map.content["fengMC"];
         this._mainBtn = _map.content["mainBtn"];
         this._mainBtn.addEventListener("click",this.onMain);
         this._petList = Vector.<MovieClip>([]);
         var _loc2_:int = 0;
         while(_loc2_ < 7)
         {
            this._petList.push(_map.content["pet" + _loc2_]);
            this._petList[_loc2_].gotoAndStop(1);
            _loc2_++;
         }
         if(param1 == false)
         {
            this._mouseHint = new MouseClickHintSprite();
            this._mouseHint.x = this._fengMC.x + 76;
            this._mouseHint.y = this._fengMC.y - 5;
            _map.content.addChild(this._mouseHint);
            this._fengMC.addEventListener("click",this.onFeng);
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this._currPetArr.length)
            {
               this._petList[_loc3_].gotoAndStop(this._currPetArr[_loc3_] + 2);
               this._petList[_loc3_].buttonMode = true;
               this._petList[_loc3_].addEventListener("click",this.onPetList);
               _loc3_++;
            }
         }
      }
      
      private function clearAll() : void
      {
         var _loc1_:MovieClip = null;
         if(this._mainBtn)
         {
            this._mainBtn.removeEventListener("click",this.onMain);
         }
         ModuleManager.removeEventListener("DanceFengPanel","hide",this.onModuleHide);
         DisplayUtil.removeForParent(this._mouseHint);
         if(this._fengMC)
         {
            this._fengMC.removeEventListener("click",this.onFeng);
         }
         for each(_loc1_ in this._petList)
         {
            _loc1_.buttonMode = false;
            _loc1_.removeEventListener("click",this.onPetList);
         }
      }
      
      private function onFeng(param1:MouseEvent) : void
      {
         ModuleManager.addEventListener("DanceFengPanel","hide",this.onModuleHide);
         ModuleManager.toggleModule(URLUtil.getAppModule("DanceFengPanel"),"正在打开");
      }
      
      private function onModuleHide(param1:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("DanceFengPanel","hide",this.onModuleHide);
         this.initRes();
      }
      
      private function onPetList(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         FightManager.startFightWithWild(this.fightIDList[_loc2_.currentFrame - 2]);
      }
      
      private function onMain(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("DanceShowPanel"),"正在打开");
      }
      
      override public function dispose() : void
      {
         this.clearAll();
         super.dispose();
      }
   }
}

