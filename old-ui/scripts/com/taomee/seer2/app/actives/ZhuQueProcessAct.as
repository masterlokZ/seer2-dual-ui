package com.taomee.seer2.app.actives
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.controls.PetAvatarPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.gameRule.fish.FishEventDispatcher;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.ResourceLibrary;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ZhuQueProcessAct
   {
      
      public static const ZHUQUE_BUY_BOMB_COMPLETE:String = "zhuQue_buy_bomb_complete";
      
      public static const ZHUQUE_BUY_WIN_BOSS:String = "zhuQue_buy_win_boss";
      
      public static const ZHUQUE_WIN_LEAVE:String = "zhuQue_win_leave";
      
      public static const ZHUQUE_FAIL_LEAVE:String = "zhuQue_fail_leave";
      
      private static const MAX_NUM:uint = 12;
      
      private static const GUARD_ID:uint = 667;
      
      private static const BOSS_ID:uint = 810;
      
      private static var _selectGuardIndex:int;
      
      private static const DAY_LIST:Array = [1297];
      
      private static const FIGHT_NUM:Vector.<int> = Vector.<int>([4,6]);
      
      private static const FIGHT_INDEX_LIST:Vector.<int> = Vector.<int>([1175,1176]);
      
      private static const BOSS_SEAT:Point = new Point(442,425);
      
      private static const GUARD_SEAT:Array = [new Point(250,235),new Point(460,260),new Point(570,280),new Point(760,260),new Point(830,330),new Point(830,400),new Point(430,515),new Point(540,510),new Point(340,330),new Point(350,420),new Point(540,390),new Point(630,365)];
      
      private static const MODULE_LIST:Vector.<String> = Vector.<String>(["ZhuQueKillMonsterPanel","ZhuQueFightFailPanel","ZhuQueFightWinPanel"]);
      
      private static var _guardKilledList:Vector.<int> = Vector.<int>([]);
      
      private var _resLib:ResourceLibrary;
      
      private var map:MapModel;
      
      private var boxBtn:SimpleButton;
      
      private var bombBtn:SimpleButton;
      
      private var mapBombBtn:SimpleButton;
      
      private var eftList:Vector.<MovieClip>;
      
      private var fight_state:uint;
      
      private var guard_list:Vector.<Mobile>;
      
      private var boss_npc:Mobile;
      
      private var eft_mobile_list:Array;
      
      public function ZhuQueProcessAct()
      {
         super();
      }
      
      public function setup() : void
      {
         (SceneManager.active as LobbyScene).hideToolbar();
         PetAvatarPanel.show();
         this.map = SceneManager.active.mapModel;
         this.boxBtn = this.map.front["boxBtn"];
         this.bombBtn = this.map.front["bombBtn"];
         FishEventDispatcher.getInstance().addEventListener("zhuQue_buy_bomb_complete",this.buyBombComplete);
         FishEventDispatcher.getInstance().addEventListener("zhuQue_buy_win_boss",this.buyWinBoss);
         FishEventDispatcher.getInstance().addEventListener("zhuQue_win_leave",this.winLeave);
         FishEventDispatcher.getInstance().addEventListener("zhuQue_fail_leave",this.failLeave);
         this.updateData();
      }
      
      private function updateData() : void
      {
         DayLimitListManager.getDaylimitList(DAY_LIST,function(param1:DayLimitListInfo):void
         {
            fight_state = param1.getCount(DAY_LIST[0]);
            boxBtn.addEventListener("click",showBox);
            bombBtn.addEventListener("click",showBombPane);
            if(fight_state >= 12)
            {
               bombBtn.visible = false;
               _guardKilledList = Vector.<int>([]);
               if(SceneManager.prevSceneType == 2)
               {
                  if(FightManager.currentFightRecord.initData.positionIndex == FIGHT_INDEX_LIST[0])
                  {
                     createBoss();
                  }
                  if(FightManager.currentFightRecord.initData.positionIndex == FIGHT_INDEX_LIST[1])
                  {
                     if(FightManager.fightWinnerSide == 1)
                     {
                        ModuleManager.showAppModule(MODULE_LIST[2]);
                     }
                     else
                     {
                        createBoss();
                        ModuleManager.showAppModule(MODULE_LIST[1]);
                     }
                  }
               }
               else
               {
                  createBoss();
               }
            }
            else if(SceneManager.prevSceneType == 2)
            {
               if(FightManager.currentFightRecord.initData.positionIndex == FIGHT_INDEX_LIST[0])
               {
                  if(FightManager.fightWinnerSide == 1)
                  {
                     _guardKilledList.push(_selectGuardIndex);
                  }
                  createGuard();
                  createBoss();
               }
               if(FightManager.currentFightRecord.initData.positionIndex == FIGHT_INDEX_LIST[1])
               {
                  if(FightManager.fightWinnerSide == 1)
                  {
                     _guardKilledList = Vector.<int>([]);
                     ModuleManager.showAppModule(MODULE_LIST[2]);
                  }
                  else
                  {
                     createBoss();
                     ModuleManager.showAppModule(MODULE_LIST[1]);
                  }
               }
            }
            else
            {
               createGuard();
               createBoss();
            }
         });
      }
      
      private function createBoss() : void
      {
         if(this.boss_npc)
         {
            return;
         }
         this.boss_npc = new Mobile();
         this.boss_npc.x = BOSS_SEAT.x;
         this.boss_npc.y = BOSS_SEAT.y;
         this.boss_npc.buttonMode = true;
         this.boss_npc.mouseChildren = false;
         this.boss_npc.resourceUrl = URLUtil.getNpcSwf(810);
         this.boss_npc.addEventListener("click",this.clickBoss);
         MobileManager.addMobile(this.boss_npc,"npc");
      }
      
      private function clearBoss() : void
      {
         if(this.boss_npc)
         {
            this.boss_npc.removeEventListener("click",this.clickBoss);
            DisplayObjectUtil.removeFromParent(this.boss_npc);
            this.boss_npc = null;
         }
      }
      
      private function createGuard() : void
      {
         this.guard_list = new Vector.<Mobile>();
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            this.guard_list.push(null);
            if(_loc2_ < 12 - this.fight_state && _guardKilledList.indexOf(_loc1_) == -1)
            {
               this.guard_list[_loc1_] = new Mobile();
               this.guard_list[_loc1_].x = GUARD_SEAT[_loc1_].x;
               this.guard_list[_loc1_].y = GUARD_SEAT[_loc1_].y;
               this.guard_list[_loc1_].buttonMode = true;
               this.guard_list[_loc1_].mouseChildren = false;
               this.guard_list[_loc1_].resourceUrl = URLUtil.getNpcSwf(667);
               this.guard_list[_loc1_].addEventListener("click",this.onGuardClick);
               MobileManager.addMobile(this.guard_list[_loc1_],"npc");
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function clearGuard() : void
      {
         var _loc1_:Mobile = null;
         for each(_loc1_ in this.guard_list)
         {
            if(_loc1_)
            {
               _loc1_.removeEventListener("click",this.onGuardClick);
            }
            DisplayObjectUtil.removeFromParent(_loc1_);
         }
         this.guard_list = null;
      }
      
      private function onGuardClick(param1:MouseEvent) : void
      {
         _selectGuardIndex = this.guard_list.indexOf(param1.currentTarget as Mobile);
         FightManager.startFightWithWild(FIGHT_INDEX_LIST[0]);
      }
      
      private function showBombPane(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule(MODULE_LIST[0]);
      }
      
      private function showBox(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("MedicineShopPanel"));
      }
      
      private function clickBoss(param1:MouseEvent) : void
      {
         if(this.fight_state != 12)
         {
            NpcDialog.show(810,"神兽•朱雀",[[0,"吾乃神兽•朱雀，想挑战我，请先击败我的12只守护精灵吧！"]],["谁怕谁！这就去！"]);
         }
         else
         {
            FightManager.startFightWithWild(FIGHT_INDEX_LIST[1]);
         }
      }
      
      private function buyBombComplete(param1:Event) : void
      {
         QueueLoader.load(URLUtil.getActivityAnimation("ZhuQueEft"),"domain",this.onLoadComplete);
      }
      
      private function winLeave(param1:Event) : void
      {
         var evt:Event = param1;
         this.clearBoss();
         SceneManager.changeScene(1,70);
         TweenNano.delayedCall(2,function():void
         {
            ModuleManager.showAppModule("ZhuQueProcessActPanel");
         });
      }
      
      private function failLeave(param1:Event) : void
      {
         var evt:Event = param1;
         this.clearBoss();
         SceneManager.changeScene(1,70);
         TweenNano.delayedCall(2,function():void
         {
            ModuleManager.showAppModule("ZhuQueProcessActPanel");
         });
      }
      
      private function buyWinBoss(param1:Event) : void
      {
         var evt:Event = param1;
         this.clearBoss();
         ServerMessager.addMessage("恭喜完成挑战哦!");
         SceneManager.changeScene(1,70);
         TweenNano.delayedCall(2,function():void
         {
            ModuleManager.showAppModule("ZhuQueProcessActPanel");
         });
      }
      
      private function onLoadComplete(param1:ContentInfo) : void
      {
         var _loc3_:MovieClip = null;
         this._resLib = new ResourceLibrary(param1.content);
         this.eftList = new Vector.<MovieClip>();
         this.eft_mobile_list = [];
         var _loc2_:int = 0;
         while(_loc2_ < 12)
         {
            if(this.guard_list[_loc2_])
            {
               _loc3_ = this._resLib.getMovieClip("ZhuQueEft");
               _loc3_.x = GUARD_SEAT[_loc2_].x;
               _loc3_.y = GUARD_SEAT[_loc2_].y;
               this.map.content.addChild(_loc3_);
               this.eftList.push(_loc3_);
               this.eft_mobile_list.push(this.guard_list[_loc2_]);
            }
            _loc2_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.eftList.length)
         {
            MovieClipUtil.playMc(this.eftList[_loc4_],1,this.eftList[_loc4_].totalFrames,this.playComplete);
            _loc4_++;
         }
      }
      
      private function playComplete() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.eftList.length)
         {
            if(Boolean(this.eftList[_loc1_].parent) && this.eftList[_loc1_].currentFrame == this.eftList[_loc1_].totalFrames)
            {
               DisplayObjectUtil.removeFromParent(this.eftList[_loc1_]);
               MobileManager.removeMobile(this.eft_mobile_list[_loc1_],"npc");
               break;
            }
            _loc1_++;
         }
         this.fight_state = 12;
         _guardKilledList = Vector.<int>([]);
         this.createBoss();
      }
      
      public function dispose() : void
      {
         FishEventDispatcher.getInstance().removeEventListener("zhuQue_buy_bomb_complete",this.buyBombComplete);
         FishEventDispatcher.getInstance().removeEventListener("zhuQue_buy_win_boss",this.buyWinBoss);
         FishEventDispatcher.getInstance().removeEventListener("zhuQue_win_leave",this.winLeave);
         FishEventDispatcher.getInstance().removeEventListener("zhuQue_fail_leave",this.failLeave);
         this.clearGuard();
         this.clearBoss();
         if(this.boxBtn)
         {
            this.boxBtn.removeEventListener("click",this.showBox);
            this.boxBtn = null;
         }
         if(this.bombBtn)
         {
            this.bombBtn.removeEventListener("click",this.showBombPane);
            this.bombBtn = null;
         }
      }
   }
}

