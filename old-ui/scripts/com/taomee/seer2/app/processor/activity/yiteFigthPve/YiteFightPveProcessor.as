package com.taomee.seer2.app.processor.activity.yiteFigthPve
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.controls.ToolbarEvent;
   import com.taomee.seer2.app.controls.ToolbarEventDispatcher;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.gameRule.data.FighterSelectPanelVO;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class YiteFightPveProcessor
   {
      
      private static var _currFightIndex:int;
      
      private static var fightWinBoolean:Array = [[false,false,false],[false,false,false],[false,false,false],[false]];
      
      private const fightList:Array;
      
      private const yiteList:Vector.<uint>;
      
      private const swapList:Array;
      
      private var _yiteList:Vector.<MovieClip>;
      
      private var _mapModel:MapModel;
      
      public function YiteFightPveProcessor()
      {
         var b:Boolean;
         var i:int;
         fightList = [[322,323,324],[325,326,327],[328,329,330],[0,0,0,331]];
         yiteList = Vector.<uint>([39,40,41,42]);
         swapList = [1140,1140,1141,1142];
         b = false;
         i = 0;
         super();
         ToolbarEventDispatcher.dispatchEvent(new ToolbarEvent("retract",false,"actor"));
         if(SceneManager.prevSceneType != 2)
         {
            SwapManager.swapItem(this.swapList[YiteFightPveEntry.mapIndex - 1]);
         }
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1)
         {
            fightWinBoolean[YiteFightPveEntry.mapIndex - 1][_currFightIndex] = true;
            b = true;
            for(i = 0; i < fightWinBoolean[YiteFightPveEntry.mapIndex - 1].length; )
            {
               if(fightWinBoolean[YiteFightPveEntry.mapIndex - 1][i] == false)
               {
                  b = false;
               }
               i++;
            }
            if(b)
            {
               SceneManager.addEventListener("switchComplete",this.onSwitchComplete);
               return;
            }
         }
         this._mapModel = SceneManager.active.mapModel;
         this._yiteList = Vector.<MovieClip>([]);
         ItemManager.requestItemList(function():void
         {
            ItemManager.addEventListener1("requestSpecialItemSuccess",onSuccess);
            ItemManager.requestSpecialItemList();
         });
      }
      
      private function onSwitchComplete(param1:SceneEvent) : void
      {
         var event:SceneEvent = param1;
         SceneManager.removeEventListener("switchComplete",this.onSwitchComplete);
         SceneManager.changeScene(1,1170);
         setTimeout(function():void
         {
            ServerMessager.addMessage("恭喜你，挑战成功");
         },1000);
         this.dispose();
      }
      
      private function onSuccess(param1:ItemEvent) : void
      {
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.onSuccess);
         this.initYite();
      }
      
      private function initYite() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._yiteList.push(this._mapModel.content["yite" + _loc1_]);
            this._yiteList[_loc1_].buttonMode = true;
            this._yiteList[_loc1_].gotoAndStop(YiteFightPveEntry.mapIndex);
            this._yiteList[_loc1_].addEventListener("click",this.onYite);
            _loc1_++;
         }
         this.updateYite();
      }
      
      private function updateYite() : void
      {
         var _loc2_:Array = fightWinBoolean[YiteFightPveEntry.mapIndex - 1];
         if(YiteFightPveEntry.mapIndex == 4)
         {
            this._yiteList[3].visible = !_loc2_[0];
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_.length)
         {
            this._yiteList[_loc1_].visible = !_loc2_[_loc1_];
            _loc1_++;
         }
         if(YiteFightPveEntry.mapIndex == 3)
         {
            if(Boolean(_loc2_[0]) && Boolean(_loc2_[1]))
            {
               this._yiteList[2].visible = true;
            }
            else
            {
               this._yiteList[2].visible = false;
            }
         }
      }
      
      private function onYite(param1:MouseEvent) : void
      {
         var baseArr:Array = null;
         var nextFight:Function = null;
         var event:MouseEvent = param1;
         nextFight = function():void
         {
            var _loc2_:FighterSelectPanelVO = new FighterSelectPanelVO();
            _loc2_.minSelectedPetCount = 1;
            _loc2_.maxSelectedPetCount = 1;
            _loc2_.pets = PetInfoManager.getAllBagPetInfo();
            var _loc1_:Vector.<PetInfo> = PetInfoManager.getRandomFightPetInfo();
            _loc2_.defaultPets = _loc1_;
            _loc2_.onComplete = onSelectedFighter;
            ModuleManager.showModule(URLUtil.getAppModule("FighterSelectPanel"),"正在打开精灵选择面板...",_loc2_);
         };
         var index:int = this._yiteList.indexOf(event.currentTarget as MovieClip);
         var arr:Array = this.fightList[YiteFightPveEntry.mapIndex - 1];
         var b:Boolean = true;
         var winList:Array = fightWinBoolean[YiteFightPveEntry.mapIndex - 1];
         if(YiteFightPveEntry.mapIndex == 3 && index == 2)
         {
            if(winList[0] == true && winList[1] == true)
            {
               _currFightIndex = index;
               FightManager.startFightBinaryWild(arr[index]);
               return;
            }
            AlertManager.showAlert("请先挑战完暗伊特和光伊特再来挑战我们");
            return;
         }
         if(YiteFightPveEntry.mapIndex == 4)
         {
            NpcDialog.show(492,"战伊特",[[0,"准备好了吗？我只接受伊特家族的挑战哟，请选用伊特家族的精灵与我对战。"]],["开始对战","让我准备下"],[nextFight]);
            return;
         }
         _currFightIndex = index;
         FightManager.startFightWithWild(arr[index]);
      }
      
      private function onSelectedFighter(param1:Vector.<uint>) : void
      {
         var _loc4_:LittleEndianByteArray = null;
         var _loc3_:uint = 0;
         var _loc2_:PetInfo = PetInfoManager.getPetInfoFromBag(param1[0]);
         if(_loc2_.bunchId >= 39 && _loc2_.bunchId <= 50)
         {
            _loc4_ = new LittleEndianByteArray();
            _loc4_.writeUnsignedInt(param1.length);
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_.writeUnsignedInt(param1[_loc3_]);
               _loc3_++;
            }
            Connection.send(CommandSet.SELECT_FIGHT_MONS_1192,_loc4_);
            _currFightIndex = 0;
            FightManager.startFightWithWild(331);
         }
         else
         {
            AlertManager.showAlert("请选择伊特来进行战斗");
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < fightWinBoolean.length)
         {
            _loc1_ = 0;
            while(_loc1_ < fightWinBoolean[_loc2_].length)
            {
               fightWinBoolean[_loc2_][_loc1_] = false;
               _loc1_++;
            }
            _loc2_++;
         }
      }
   }
}

