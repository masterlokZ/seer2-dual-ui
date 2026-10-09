package com.taomee.seer2.app.processor.map
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcessor_80096 extends MapProcessor
   {
      
      private static const FIGHT_INDEX:int = 752;
      
      private static const FIGHT_NUM_DAY:int = 902;
      
      private static const FIGHT_NUM_MI_BUY_FOR:int = 203535;
      
      private static const FIGHT_NUM_RULE:Vector.<int> = Vector.<int>([1,1]);
      
      private var _npc:Mobile;
      
      public function MapProcessor_80096(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.findMoInSnowActInit();
      }
      
      private function findMoInSnowActInit() : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.currentFightRecord.initData.positionIndex == 752)
         {
            DayLimitManager.getDoCount(902,function(param1:int):void
            {
               var val:int = param1;
               ActiveCountManager.requestActiveCount(203535,function(param1:uint, param2:uint):void
               {
                  var canFightNum:int = 0;
                  var type:uint = param1;
                  var count:uint = param2;
                  if(type == 203535)
                  {
                     if(VipManager.vipInfo.isVip())
                     {
                        if(val > FIGHT_NUM_RULE[1])
                        {
                           canFightNum = int(count);
                        }
                        else
                        {
                           canFightNum = FIGHT_NUM_RULE[1] - val + count;
                        }
                     }
                     else if(val > FIGHT_NUM_RULE[0])
                     {
                        canFightNum = int(count);
                     }
                     else
                     {
                        canFightNum = FIGHT_NUM_RULE[0] - val + count;
                     }
                     if(canFightNum > 0)
                     {
                        createNpc();
                     }
                     else
                     {
                        TweenNano.delayedCall(3,function():void
                        {
                           ServerMessager.addMessage("今日免费挑战次数已用完，可花费星钻继续战斗！");
                           SceneManager.changeScene(1,70);
                        });
                     }
                  }
               });
            });
         }
         else
         {
            this.createNpc();
         }
      }
      
      private function findMoInSnowActDispose() : void
      {
         this.clearNpc();
      }
      
      private function createNpc() : void
      {
         if(!this._npc)
         {
            this._npc = new Mobile();
            this._npc.width = 100;
            this._npc.height = 140;
            this._npc.setPostion(new Point(645,320));
            this._npc.resourceUrl = URLUtil.getNpcSwf(647);
            this._npc.labelPosition = 1;
            this._npc.label = "路奇";
            this._npc.labelImage.y = -this._npc.height - 10;
            this._npc.buttonMode = true;
            MobileManager.addMobile(this._npc,"npc");
            this._npc.addEventListener("click",this.onNpcClick);
         }
      }
      
      private function onNpcClick(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         NpcDialog.show(647,"路奇",[[0,"我这里倒是有一点你想要的东西！不如先比一下？"]],["挑战吧！","准备一下"],[function():void
         {
            FightManager.startFightWithWild(752);
         }]);
      }
      
      private function clearNpc() : void
      {
         if(this._npc)
         {
            this._npc.removeEventListener("click",this.onNpcClick);
            DisplayUtil.removeForParent(this._npc);
            this._npc = null;
         }
      }
      
      override public function dispose() : void
      {
         this.findMoInSnowActDispose();
         super.dispose();
      }
   }
}

