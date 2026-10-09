package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.component.MouseClickHintSprite;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.manager.WebJumpManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import org.taomee.manager.EventManager;
   
   public class MapProcessor_80383 extends MapProcessor
   {
      
      private var _mouseHint:MouseClickHintSprite;
      
      private var _mcStone:SimpleButton;
      
      private var _mcIsVip:MovieClip;
      
      private var _txtLeftCount:TextField;
      
      private var _npc:Mobile;
      
      private var _mcShoot:MovieClip;
      
      private const FOR_GAME_FINISH:int = 205398;
      
      private const FOR_COUNT:int = 205404;
      
      private const DAY_COUNT:int = 1551;
      
      private const BBS_ID:int = 118;
      
      private const FIGHT_ID:uint = 1443;
      
      private const MI_COUNT:uint = 605343;
      
      private var _leftCount:int;
      
      private var _isGameFinish:int;
      
      public function MapProcessor_80383(param1:MapModel)
      {
         super(param1);
      }
      
      private function get leftCount() : int
      {
         return this._leftCount;
      }
      
      private function set leftCount(param1:int) : void
      {
         this._txtLeftCount.text = "还可挑战 " + param1.toString() + " 次";
         this._leftCount = param1;
      }
      
      override public function init() : void
      {
         _map.front.visible = false;
         this._txtLeftCount = _map.front["leftCount"];
         this.updateCount();
         this.setVIPPanel();
         this._mcStone = _map.content["stone"];
         this._mcShoot = _map.content["shootMc"];
         this._mcShoot.visible = false;
         ActiveCountManager.requestActiveCount(205398,function(param1:uint, param2:uint):void
         {
            _isGameFinish = param2 + 1;
            if(param2 == 0)
            {
               EventManager.addEventListener("SAMGameOver",onGameOver);
               ServerBufferManager.getServerBuffer(314,onGetBuffer);
            }
            else if(param2 == 1)
            {
               _map.front.visible = true;
               showSomething();
            }
         });
      }
      
      private function onGameOver(param1:Event) : void
      {
         this._isGameFinish = 2;
         QueueLoader.load(URLUtil.getActivityAnimation("SealAncientMonster" + this._isGameFinish),"swf",this.onLoadComplete);
      }
      
      private function updateCount() : void
      {
         ActiveCountManager.requestActiveCount(205404,function(param1:uint, param2:uint):void
         {
            var t:uint = param1;
            var c:uint = param2;
            DayLimitManager.getDoCount(1551,function(param1:uint):void
            {
               leftCount = ActsHelperUtil.getCanNum(param1,c,VipManager.vipInfo.isVip() ? 10 : 5);
            });
         });
      }
      
      protected function onStone(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("SAMStartGamePanel");
      }
      
      override public function dispose() : void
      {
         this._npc = null;
         this._mcStone.removeEventListener("click",this.onStone);
         _map.front["goBBS"].removeEventListener("click",this.onBBS);
         if(this._mcIsVip["isVIP"] != null)
         {
            this._mcIsVip["isVIP"].removeEventListener("click",this.onGetVip);
         }
         _map.front["itemShop"].removeEventListener("click",this.onItemShop);
         super.dispose();
      }
      
      private function setVIPPanel() : void
      {
         _map.front["goBBS"].addEventListener("click",this.onBBS);
         this._mcIsVip = _map.front["isVIP"];
         if(ActorManager.actorInfo.vipInfo.isVip())
         {
            this._mcIsVip.gotoAndStop(1);
         }
         else
         {
            this._mcIsVip.gotoAndStop(2);
            this._mcIsVip["getVIP"].addEventListener("click",this.onGetVip);
         }
         _map.front["itemShop"].addEventListener("click",this.onItemShop);
      }
      
      private function onGetVip(param1:MouseEvent) : void
      {
         VipManager.navigateToPayPage();
      }
      
      private function onItemShop(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("MedicineShopPanel");
      }
      
      private function onBBS(param1:MouseEvent) : void
      {
         WebJumpManager.toBBSForId(118);
      }
      
      private function onGetBuffer(param1:ServerBuffer) : void
      {
         if(param1.readDataAtPostion(this._isGameFinish) != 1)
         {
            QueueLoader.load(URLUtil.getActivityAnimation("SealAncientMonster" + this._isGameFinish),"swf",this.onLoadComplete);
         }
         else
         {
            this.showSomething();
         }
      }
      
      private function onLoadComplete(param1:ContentInfo) : void
      {
         var anime1:MovieClip = null;
         var info:ContentInfo = param1;
         anime1 = (info.content as MovieClip)["movie"];
         var movie:MovieClip = anime1["movie"];
         LayerManager.topLayer.addChild(anime1);
         MovieClipUtil.playMc(movie,1,movie.totalFrames,function():void
         {
            DisplayObjectUtil.removeFromParent(anime1);
            ServerBufferManager.updateServerBuffer(314,_isGameFinish,1);
            showSomething();
         });
      }
      
      private function showSomething() : void
      {
         if(this._isGameFinish == 2)
         {
            this._mcShoot.visible = false;
            this._mcStone.mouseEnabled = false;
            DisplayObjectUtil.removeFromParent(this._mouseHint);
            this.initNPC();
         }
         else if(this._isGameFinish == 1)
         {
            this._mcShoot.visible = true;
            this._mcStone.mouseEnabled = true;
            this._mcStone.addEventListener("click",this.onStone);
            this.addMouseHint();
         }
      }
      
      private function initNPC() : void
      {
         if(this._npc == null)
         {
            this._npc = new Mobile();
            this._npc.setPostion(new Point(278,495));
            this._npc.resourceUrl = URLUtil.getNpcSwf(844);
            this._npc.buttonMode = true;
            MobileManager.addMobile(this._npc,"npc");
            this._npc.addEventListener("click",this.fightDialog);
         }
      }
      
      private function fightDialog(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         NpcDialog.show(844,"远古地魔",[[0,"是该出来活动活动了！看来你就是要解开这该死封印的家伙吧！"]],["开始吧！","我好纠结"],[function():void
         {
            if(leftCount <= 0)
            {
               NpcDialog.show(844,"远古地魔",[[0,"今天到此为止吧！明天再来！"]],["我要花费星钻再战一次","好吧"],[function():void
               {
                  ShopManager.buyItemForId(605343,function():void
                  {
                     FightManager.startFightWithBoss(1443);
                  });
               },null]);
            }
            else
            {
               NpcDialog.show(844,"远古地魔",[[0,"你想打就打吗？先看看能不能遭遇到我的真身吧？"]],["来吧！我不怕你！（战胜任何敌人都可获得魔灵，VIP翻倍）"],[function():void
               {
                  FightManager.startFightWithBoss(1443);
               }]);
            }
         },null]);
      }
      
      private function addMouseHint() : void
      {
         DisplayObjectUtil.removeFromParent(this._mouseHint);
         this._mouseHint = new MouseClickHintSprite();
         this._mouseHint.x = 135;
         this._mouseHint.y = 315;
         _map.content.addChild(this._mouseHint);
      }
   }
}

