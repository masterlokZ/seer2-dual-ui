package com.taomee.seer2.app.processor.map
{
   import com.greensock.TweenLite;
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.arena.data.RevenueInfo;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.manager.FightResultPanelWrapper;
   import com.taomee.seer2.app.manager.PetExperenceHelper;
   import com.taomee.seer2.app.manager.SeatTipsManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.scene.LobbyPanel;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   import org.taomee.utils.Tick;
   
   public class MapProcessor_80329 extends MapProcessor
   {
      
      private var arrowTips:MovieClip;
      
      private var leftTime:int;
      
      private var foreverlimit:Array = [204954];
      
      private var dayLimit:Array = [1408,1411,1412,1418,1419];
      
      private var count:int = 0;
      
      private var maxValues:int;
      
      private var curExp:int;
      
      private var curBeiShu:int;
      
      private var tm:Timer;
      
      private var clickGapTm:Timer = new Timer(1000);
      
      private var counter:int = 0;
      
      private var buyWhich:int;
      
      private var tmpSp:Sprite = new Sprite();
      
      private var FireAniList:MovieClip;
      
      private var expList:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var expPos:Array = [];
      
      private var expSprite:Sprite = new Sprite();
      
      private var curidx:int = 0;
      
      private var waitCount:int = 0;
      
      private var curPETidx:int = 0;
      
      private var petList:Vector.<PetInfo>;
      
      private var curPos:Point = new Point();
      
      private var changePET:Array = [9001,9002,9003];
      
      private var flagClick:Boolean = false;
      
      private var flagFire:Boolean = true;
      
      private var yPosArr:Array = [-10,-20,-30,-30,-20,-10];
      
      public function MapProcessor_80329(param1:MapModel)
      {
         super(param1);
      }
      
      override public function dispose() : void
      {
         LobbyPanel.instance.show();
         ActorManager.getActor().stopTransform();
         _map.content.removeEventListener("enterFrame",this.onEnter);
         ActorManager.getActor().getFollowingPet().visible = true;
         this.count = 0;
         Tick.instance.removeRender(this.updateTime);
      }
      
      override public function init() : void
      {
         this.FireAniList = _map.content["ani"];
         this.FireAniList.visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this.expList.push(_map.content["exp" + _loc1_]);
            this.expList[_loc1_].addEventListener("mouseOver",this.onExp);
            this.expPos.push([this.expList[_loc1_].x,this.expList[_loc1_].y]);
            this.expList[_loc1_].visible = false;
            _loc1_++;
         }
         LobbyPanel.instance.hide();
         ActorManager.getActor().blockFollowingPet = true;
         this.initMC();
         Tick.instance.addRender(this.updateTime,1000);
         this.clickGapTm.addEventListener("timer",this.WaitTime);
         this.checkStates();
         this.isAllBtnClick();
      }
      
      private function onExp(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            this.expList[_loc2_].removeEventListener("mouseOver",this.onExp);
            _loc2_++;
         }
         var _loc3_:int = this.expList.indexOf(param1.currentTarget as MovieClip);
         this.curidx = _loc3_;
         TweenLite.to(this.expList[_loc3_],0.5,{
            "x":306,
            "y":268,
            "onComplete":this.toComplete
         });
      }
      
      private function toComplete() : void
      {
         _map.content["valueTxt"].text = (int(_map.content["valueTxt"].text) + 150).toString();
         this.expList[this.curidx].visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this.expList[_loc1_].addEventListener("mouseOver",this.onExp);
            _loc1_++;
         }
      }
      
      private function WaitTime(param1:Event) : void
      {
         ++this.waitCount;
         if(this.waitCount == 5)
         {
            this.waitCount = 0;
            this.clickGapTm.stop();
            this.flagFire = true;
         }
      }
      
      private function isAllBtnClick() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _map.front["giftContent"]["ok" + _loc1_].addEventListener("click",this.onOK);
            _map.front["giftContent"]["max" + _loc1_].addEventListener("click",this.onMax);
            _loc1_++;
         }
      }
      
      private function isOneBtnClick(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            _map.front["giftContent"]["ok" + _loc2_].removeEventListener("click",this.onOK);
            _map.front["giftContent"]["max" + _loc2_].removeEventListener("click",this.onMax);
            _loc2_++;
         }
         _map.front["giftContent"]["ok" + param1].addEventListener("click",this.onOK);
         _map.front["giftContent"]["max" + param1].addEventListener("click",this.onMax);
      }
      
      private function onOK(param1:MouseEvent) : void
      {
         var num:int = 0;
         var e:MouseEvent = param1;
         var index:int = int(e.currentTarget.name.substr(2));
         this.curPETidx = index;
         if(PetInfoManager.getAllBagPetInfo()[index].level >= 100)
         {
            ServerMessager.addMessage("这只精灵已经满级，请换一只未满级精灵~");
         }
         else
         {
            num = int(_map.front["giftContent"]["numTxt" + index].text);
            if(num == 0)
            {
               ServerMessager.addMessage("请在文本框内填写需要分配给精灵的经验值~");
               return;
            }
            if(num > this.maxValues)
            {
               AlertManager.showAlert("输入经验值超出可分配的经验上限哦~请重新分配");
            }
            else
            {
               this.isOneBtnClick(index);
               PetInfoManager.addEventListener("petExperenceChange",this.onPetExperenceChange);
               PetExperenceHelper.startListen();
               SwapManager.swapItem(3312,1,function(param1:IDataInput):void
               {
                  PetExperenceHelper.stopListen();
                  new SwapInfo(param1);
                  checkStates();
               },null,new SpecialInfo(2,this.petList[index].catchTime,num));
            }
         }
      }
      
      private function onPetExperenceChange(param1:PetInfoEvent) : void
      {
         var _loc3_:RevenueInfo = null;
         var _loc5_:FightResultInfo = null;
         var _loc4_:PetInfo = null;
         _loc3_ = param1.content.revenueInfo;
         _loc5_ = param1.content.resultInfo;
         var _loc2_:int = 0;
         while(_loc2_ < PetInfoManager.getAllBagPetInfo().length)
         {
            if(PetInfoManager.getAllBagPetInfo()[_loc2_].catchTime == this.petList[this.curPETidx].catchTime)
            {
               _loc4_ = PetInfoManager.getAllBagPetInfo()[_loc2_];
               break;
            }
            _loc2_++;
         }
         PetInfoManager.removeEventListener("petExperenceChange",this.onPetExperenceChange);
         new FightResultPanelWrapper().show(Vector.<PetInfo>([_loc4_]),_loc3_,_loc5_);
      }
      
      private function onMax(param1:MouseEvent) : void
      {
         var _loc2_:int = int(param1.currentTarget.name.substr(3));
         _map.front["giftContent"]["numTxt" + _loc2_].text = _map.front["giftContent"]["totalTxt"].text;
      }
      
      private function onCloseGiftContentTip(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(int(_map.front["giftContent"]["totalTxt"].text) <= 0)
         {
            SceneManager.changeScene(1,70);
            ModuleManager.showAppModule("DeliverExperiencePanel");
         }
         else
         {
            AlertManager.showConfirm("还有可以分配的经验，现在就离开吗？",function():void
            {
               SceneManager.changeScene(1,70);
               ModuleManager.showAppModule("DeliverExperiencePanel");
            });
         }
      }
      
      private function onCloseGiftTip(param1:MouseEvent) : void
      {
         this.tm.stop();
         this.tm.removeEventListener("timer",this.onTimer);
         this.tm = null;
         _map.front["giftTip"].visible = false;
      }
      
      private function initMC() : void
      {
         _map.front["giftContent"].addChild(this.tmpSp);
         _map.content.addEventListener("enterFrame",this.onEnter);
         _map.front["giftContent"].visible = false;
         _map.front["giftTip"].visible = false;
         _map.front["giftTip"]["closeBtn"].addEventListener("click",this.onCloseGiftTip);
         _map.front["giftContent"]["closeBtn"].addEventListener("click",this.onCloseGiftContentTip);
         this.setPetIcon();
      }
      
      private function setPetIcon() : void
      {
         var _loc1_:Sprite = null;
         while(this.tmpSp.numChildren > 0)
         {
            this.tmpSp.removeChildAt(0);
         }
         this.petList = PetInfoManager.getAllBagPetInfo();
         var _loc2_:int = 0;
         while(_loc2_ < this.petList.length)
         {
            _loc1_ = new Sprite();
            _loc1_ = this.getIcon(this.petList[_loc2_]);
            _loc1_.x = _loc2_ % 3 * 160 - 80;
            _loc1_.y = 115 + int(_loc2_ / 3) * 180;
            _loc1_.scaleX = _loc1_.scaleY = 1.5;
            this.tmpSp.addChild(_loc1_);
            _loc2_++;
         }
      }
      
      private function onEnter(param1:Event) : void
      {
         if(SeatTipsManager.hasSeat(80329,this.curPos))
         {
            SeatTipsManager.removeSeat(this.curPos,80329);
         }
         this.curPos.x = ActorManager.getActor().x + 5;
         this.curPos.y = ActorManager.getActor().y - 40;
         SeatTipsManager.registerSeat(this.curPos,80329);
      }
      
      private function checkStates(param1:Function = null) : void
      {
         var _callBack:Function = param1;
         ActiveCountManager.requestActiveCountList(this.foreverlimit,function(param1:Parser_1142):void
         {
            var par:Parser_1142 = param1;
            maxValues = par.infoVec[0];
            DayLimitListManager.getDaylimitList(dayLimit,function(param1:DayLimitListInfo):void
            {
               buyWhich = param1.getCount(dayLimit[0]);
               curExp = param1.getCount(dayLimit[3]);
               curBeiShu = param1.getCount(dayLimit[4]);
               ActorManager.getActor().startTransform(changePET[buyWhich - 1]);
               if(flagClick == false)
               {
                  flagClick = true;
                  ActorManager.getActor().transformMobile.addEventListener("click",clickSelf,false,1);
                  ActorManager.getActor().transformMobile.buttonMode = true;
               }
               _map.content["valueTxt"].text = curExp.toString();
               _map.front["giftTip"]["numTxt"].text = _map.content["valueTxt"].text;
               _map.front["giftContent"]["totalTxt"].text = maxValues.toString();
               if(_callBack != null)
               {
                  _callBack();
               }
            });
         });
      }
      
      private function clickSelf(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         e.stopImmediatePropagation();
         if(this.flagFire)
         {
            this.flagFire = false;
            SwapManager.swapItem(3310,1,function(param1:IDataInput):void
            {
               var data:IDataInput = param1;
               new SwapInfo(data);
               clickGapTm.start();
               FireAniList.visible = true;
               FireAniList.x = ActorManager.getActor().x;
               FireAniList.y = ActorManager.getActor().y - 50;
               MovieClipUtil.playMc(FireAniList,2,FireAniList.totalFrames,function():void
               {
                  FireAniList.visible = false;
                  var _loc1_:int = 0;
                  while(_loc1_ < expList.length)
                  {
                     expList[_loc1_].visible = true;
                     _loc1_++;
                  }
                  setExpPos(expList);
               });
            });
         }
         else
         {
            ServerMessager.addMessage("连续放烟花对环境不好哦～稍等一下吧～");
         }
      }
      
      private function setExpPos(param1:Vector.<MovieClip>) : void
      {
         var _loc3_:int = ActorManager.getActor().x;
         var _loc5_:int = ActorManager.getActor().y;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = _loc2_ % 3;
            param1[_loc2_].x = _loc3_ - 90 * (3 - _loc2_);
            param1[_loc2_].y = _loc5_ - 350 + this.yPosArr[_loc2_];
            _loc2_++;
         }
      }
      
      private function updateTime(param1:int) : void
      {
         var i:int = 0;
         var u:int = param1;
         ++this.count;
         this.leftTime = 60 - this.count;
         if(this.leftTime < 0)
         {
            Tick.instance.removeRender(this.updateTime);
            if(SeatTipsManager.hasSeat(80329,this.curPos))
            {
               SeatTipsManager.removeSeat(this.curPos,80329);
            }
            _map.content.removeEventListener("enterFrame",this.onEnter);
            for(i = 0; i < this.expList.length; )
            {
               this.expList[i].visible = false;
               i++;
            }
            SwapManager.swapItem(3311,1,function(param1:IDataInput):void
            {
               var data:IDataInput = param1;
               new SwapInfo(data);
               checkStates(function():void
               {
                  _map.front["giftTip"].visible = true;
                  tm = new Timer(20);
                  tm.addEventListener("timer",onTimer);
                  tm.start();
               });
            });
         }
         else
         {
            _map.content["timeTxt"].text = this.leftTime.toString();
         }
      }
      
      private function getIcon(param1:PetInfo) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:IconDisplayer = new IconDisplayer();
         _loc3_.x = 5;
         _loc3_.y = 5;
         _loc2_.addChild(_loc3_);
         _loc3_.setIconUrl(URLUtil.getPetIcon(param1.resourceId));
         return _loc2_;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         ++this.counter;
         if(this.counter > 100)
         {
            this.counter = 0;
            this.tm.stop();
            _map.front["giftTip"]["mc0"].gotoAndStop(this.curBeiShu + 1);
            TweenNano.delayedCall(1,function():void
            {
               _map.front["giftTip"].visible = false;
               _map.front["giftContent"].visible = true;
            });
         }
         else
         {
            _map.front["giftTip"]["mc0"].gotoAndStop(this.counter % 10 + 1);
         }
      }
   }
}

