package com.taomee.seer2.app.processor.map
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.manager.DayLimitListManager;
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
   
   public class MapProcessor_80209 extends MapProcessor
   {
      
      private static const FIGHT_INDEX:int = 1015;
      
      private static const FIGHT_NUM_RULE:int = 3;
      
      private static const DAY_LIST:Array = [1165];
      
      private var _npc:Mobile;
      
      public function MapProcessor_80209(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         this.onActInit();
      }
      
      private function onActInit() : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.currentFightRecord.initData.positionIndex == 1015)
         {
            DayLimitListManager.getDaylimitList(DAY_LIST,function(param1:DayLimitListInfo):void
            {
               var info:DayLimitListInfo = param1;
               var canFightNum:int = 3 - info.getCount(DAY_LIST[0]) >= 0 ? 3 - info.getCount(DAY_LIST[0]) : 0;
               if(canFightNum > 0)
               {
                  if(VipManager.vipInfo.isVip())
                  {
                     initAct();
                  }
                  else
                  {
                     SceneManager.changeScene(1,70);
                  }
               }
               else
               {
                  TweenNano.delayedCall(3,function():void
                  {
                     ServerMessager.addMessage("今日免费挑战次数已用完，可花费星钻继续战斗！");
                     SceneManager.changeScene(1,70);
                  });
               }
            });
         }
         else
         {
            this.initAct();
         }
      }
      
      private function initAct() : void
      {
         this.createNpc();
      }
      
      private function onActDispose() : void
      {
         this.clearNpc();
      }
      
      private function createNpc() : void
      {
         if(!this._npc)
         {
            this._npc = new Mobile();
            this._npc.width = 100;
            this._npc.height = 160;
            this._npc.setPostion(new Point(460,275));
            this._npc.resourceUrl = URLUtil.getNpcSwf(708);
            this._npc.labelPosition = 1;
            this._npc.label = "炎煞";
            this._npc.labelImage.y = -this._npc.height - 10;
            this._npc.buttonMode = true;
            MobileManager.addMobile(this._npc,"npc");
            this._npc.addEventListener("click",this.onNpcClick);
         }
      }
      
      private function onNpcClick(param1:MouseEvent) : void
      {
         FightManager.startFightWithWild(1015);
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
         this.onActDispose();
         super.dispose();
      }
   }
}

