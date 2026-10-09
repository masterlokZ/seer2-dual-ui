package com.taomee.seer2.app.processor.map
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.scene.SceneManager;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcessor_80080 extends MapProcessor
   {
      
      private static const FIGHT_INDEX:int = 715;
      
      private var _npc:Mobile;
      
      public function MapProcessor_80080(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         if(SceneManager.prevSceneType == 2 && FightManager.currentFightRecord.initData.positionIndex == 715)
         {
            TweenNano.delayedCall(3,function():void
            {
               SceneManager.changeScene(1,70);
            });
            return;
         }
         this._npc = MobileManager.getMobile(660,"npc");
         this._npc.buttonMode = true;
         this._npc.addEventListener("click",this.onNpcClick);
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
      
      private function onNpcClick(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         NpcDialog.show(660,"巨石托尔",[[0,"你是我的过去，我是你的未来。你一定会成为我，来，战一场！"]],["接受挑战","准备一下"],[function():void
         {
            FightManager.startFightWithWild(715);
         }]);
      }
      
      override public function dispose() : void
      {
         this.clearNpc();
         super.dispose();
      }
   }
}

