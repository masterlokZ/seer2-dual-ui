package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.info.BuyPropInfo;
   import com.taomee.seer2.app.net.parser.Parser_1224;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.DomainUtil;
   
   public class SpriteBaseGame
   {
      
      private static const NPC_ID:uint = 645;
      
      private static const FIGHT_INDEX:uint = 689;
      
      private static const NpcName:String = "木忍";
      
      private static const NpcTalk:String = "使用战斗药剂可以增强精灵的战斗力！再接再励！";
      
      private static const BUFFER_TYPE:int = 160;
      
      private static const LOSE_MOVIE:String = "MuRenLoseMovie";
      
      private static const ENTER_MOVIE:String = "MuRenEnterMovie";
      
      private static const EMBED_ID:int = 203221;
      
      private static const PAPER_ID:int = 200374;
      
      private static const SOURCE:String = "SpriteMuRenMc";
      
      private var _map:MapModel;
      
      private var _npc:Mobile;
      
      private var _buyPanelBtn:SimpleButton;
      
      private var _progressPanelBtn:SimpleButton;
      
      private var _buyEmbedBtn:SimpleButton;
      
      private var _buyPaperBtn:SimpleButton;
      
      private var _resLibs:ApplicationDomain;
      
      private var mc:MovieClip;
      
      protected var info:BuyPropInfo;
      
      public function SpriteBaseGame(param1:MapModel)
      {
         super();
         this._map = param1;
         this.initMap();
         this.checkFromFight();
         this.show();
      }
      
      protected function initMap() : void
      {
         this._npc = MobileManager.getMobile(645,"npc");
         this._buyEmbedBtn = this._map.content["buyEmbedBtn"];
         this._buyPanelBtn = this._map.content["buyPanelBtn"];
         this._buyPaperBtn = this._map.content["buyPaperBtn"];
         this._progressPanelBtn = this._map.content["progressPanelBtn"];
      }
      
      protected function checkFromFight() : void
      {
         var a:Boolean = SceneManager.prevSceneType == 2;
         var b:Boolean = FightManager.currentFightRecord.initData.positionIndex == 689;
         var c:Boolean = FightManager.fightWinnerSide == 1;
         if(a && b)
         {
            if(c)
            {
               if(this._npc)
               {
                  this._npc.visible = false;
               }
               QueueLoader.load(URLUtil.getActivityAnimation("SpriteMuRenMc"),"swf",function(param1:ContentInfo):void
               {
                  var info:ContentInfo = param1;
                  _resLibs = info.domain;
                  mc = DomainUtil.getDisplayObject("movie",_resLibs) as MovieClip;
                  mc.stop();
                  _map.front.addChild(mc);
                  MovieClipUtil.playMc(mc,1,mc.totalFrames,function():void
                  {
                     DisplayObjectUtil.removeFromParent(mc);
                     if(_npc)
                     {
                        _npc.visible = true;
                     }
                     mc.stop();
                     mc = null;
                  });
               });
            }
            else
            {
               MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("MuRenLoseMovie"),function():void
               {
                  NpcDialog.show(645,"木忍",[[0,"使用战斗药剂可以增强精灵的战斗力！再接再励！"]],["继续挑战"," 准备一下","购买战斗辅助"],[function():void
                  {
                     FightManager.startFightWithWild(689);
                  },null,function():void
                  {
                     onPanel();
                  }]);
               });
            }
         }
         if(!a)
         {
            this.checkPlayMovie();
         }
      }
      
      protected function checkPlayMovie() : void
      {
         ServerBufferManager.getServerBuffer(160,function(param1:ServerBuffer):void
         {
            var buffer:ServerBuffer = param1;
            var value:int = buffer.readDataAtPostion(0);
            if(value == 0)
            {
               MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("MuRenEnterMovie"),function():void
               {
                  ServerBufferManager.updateServerBuffer(160,0,1);
               });
            }
         });
      }
      
      private function show() : void
      {
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._npc.addEventListener("click",this.onNpc);
         this._buyEmbedBtn.addEventListener("click",this.onEmbed);
         this._buyPanelBtn.addEventListener("click",this.onPanel);
         this._buyPaperBtn.addEventListener("click",this.onPaper);
         this._progressPanelBtn.addEventListener("click",this.onProgress);
      }
      
      private function removeEvent() : void
      {
         this._npc.removeEventListener("click",this.onNpc);
         this._buyEmbedBtn.removeEventListener("click",this.onEmbed);
         this._buyPanelBtn.removeEventListener("click",this.onPanel);
         this._buyPaperBtn.removeEventListener("click",this.onPaper);
         this._progressPanelBtn.removeEventListener("click",this.onProgress);
      }
      
      protected function onNpc(param1:MouseEvent) : void
      {
         ModuleManager.showModule(URLUtil.getAppModule("MuRenProgressPanel"),"");
      }
      
      private function onPanel(param1:MouseEvent = null) : void
      {
         ModuleManager.showModule(URLUtil.getAppModule("BuyItemPanel"),"");
      }
      
      protected function onEmbed(param1:MouseEvent) : void
      {
         this.info = new BuyPropInfo();
         this.info.itemId = 203221;
         this.info.buyComplete = this.complete;
         ShopManager.buyBagItem(this.info);
      }
      
      protected function onPaper(param1:MouseEvent) : void
      {
         this.info = new BuyPropInfo();
         this.info.itemId = 200374;
         this.info.buyComplete = this.complete;
         ShopManager.buyBagItem(this.info);
      }
      
      protected function onProgress(param1:MouseEvent) : void
      {
         ModuleManager.showModule(URLUtil.getAppModule("SpriteQuickChangePanel"),"");
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._resLibs = null;
         if(this.mc)
         {
            DisplayObjectUtil.removeFromParent(this.mc);
            this.mc = null;
         }
      }
      
      private function complete(param1:Parser_1224) : void
      {
      }
   }
}

