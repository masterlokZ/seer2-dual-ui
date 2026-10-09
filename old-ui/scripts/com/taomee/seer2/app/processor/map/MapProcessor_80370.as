package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.component.MouseClickHintSprite;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   import org.taomee.utils.BitUtil;
   import org.taomee.utils.Tick;
   
   public class MapProcessor_80370 extends CopyMapProcessor
   {
      
      private var serverBuffer:ServerBuffer;
      
      private var preTime:uint;
      
      private var currentTime:uint;
      
      private var petIDs:Array = [10001,10002,10003];
      
      private const DAY_LIST:Array = [1516,1517];
      
      private var fightState:Array = [false,false,false];
      
      private var fightIds:Array = [1417,1418,1419];
      
      private var petLevls:Array = [50,70,100];
      
      private var petVec:Vector.<SpawnedPet>;
      
      private var mobileNpc:Mobile;
      
      private var stoneId:uint = 401091;
      
      private var stoneNum:int;
      
      private var sceneInteractiveVec:Vector.<MovieClip>;
      
      public function MapProcessor_80370(param1:MapModel)
      {
         super(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Tick.instance.removeTimeout(this.timeCheck);
      }
      
      override public function init() : void
      {
         super.init();
         this.petVec = new Vector.<SpawnedPet>();
         ItemManager.requestItemList(this.getItemNum);
         this.requestSeverBuffer();
      }
      
      private function getItemNum() : void
      {
         this.stoneNum = ItemManager.getItemQuantityByReferenceId(this.stoneId);
         this.mobileNpc = new Mobile();
         this.mobileNpc.setPostion(new Point(595,430));
         this.mobileNpc.resourceUrl = URLUtil.getNpcSwf(835);
         this.mobileNpc.buttonMode = true;
         MobileManager.addMobile(this.mobileNpc,"npc");
         this.showMouseHintAtMonster(this.mobileNpc);
         this.mobileNpc.addEventListener("click",this.showDia);
      }
      
      private function showDia(param1:MouseEvent) : void
      {
         ItemManager.requestItemList(this.getItemNumNew);
      }
      
      private function getItemNumNew() : void
      {
         this.stoneNum = ItemManager.getItemQuantityByReferenceId(this.stoneId);
         NpcDialog.show(835,"小地兽",[[0,"这里是地壳！挑战我身边的家伙能拿电池哦。 给我<font color=\'#ff3300\'>10</font>块电池就能让你去地幔里玩玩， 我知道你现在已经有<font color=\'#ff3300\'>" + this.stoneNum + "</font>块电池了。"]],["进入地幔层","购买电池","地壳层规则","离开"],[function():void
         {
            NpcDialog.show(835,"小地兽",[[0,"小赛尔，你确定准备好了吗？你就进入地幔层了，迎接你的将是更加艰巨的挑战！"]],["确定","我先准备一下"],[function():void
            {
               if(stoneNum < 10)
               {
                  NpcDialog.show(835,"小地兽",[[0,"1、2、3、6、5、9、8……虽然我的数学课是体育老师教的，但是也算的出你给的电池不够啊！ 要不要买点啊？"]],["购买电池 ","知道了"],[function():void
                  {
                     ModuleManager.showAppModule("EarthItemBuyPanel");
                  }]);
               }
               else
               {
                  SwapManager.swapItem(3540,1,swapSuccess,null,new SpecialInfo(1,0));
               }
            }]);
         },function():void
         {
            ModuleManager.showAppModule("EarthItemBuyPanel");
         },function():void
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("EarthActIntroduceOnePanel"));
         }]);
      }
      
      private function showMouseHintAtMonster(param1:Mobile) : void
      {
         var _loc2_:MouseClickHintSprite = new MouseClickHintSprite();
         _loc2_.y = -_loc2_.height - 50;
         _loc2_.x = (param1.width - param1.width) / 2;
         param1.addChild(_loc2_);
      }
      
      private function swapSuccess(param1:IDataInput) : void
      {
         var data:IDataInput = param1;
         new SwapInfo(data);
         MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("earthSearchAct/EarthSearchAct1"),function():void
         {
            SceneManager.changeScene(9,80371);
         },true,true);
      }
      
      private function requestSeverBuffer() : void
      {
         this.clearPet();
         DayLimitListManager.getDaylimitList(this.DAY_LIST,function(param1:DayLimitListInfo):void
         {
            preTime = param1.getCount(DAY_LIST[0]) - 60;
            var _loc2_:int = 0;
            while(_loc2_ < 3)
            {
               fightState[_loc2_] = BitUtil.getBit(param1.getCount(DAY_LIST[1]),_loc2_);
               _loc2_++;
            }
            checkMonster();
         });
      }
      
      private function clearPet() : void
      {
         var _loc1_:SpawnedPet = null;
         while(this.petVec.length > 0)
         {
            _loc1_ = this.petVec.pop();
            MobileManager.removeMobile(_loc1_,"spawnedPet");
            _loc1_.dispose();
         }
      }
      
      private function checkMonster() : void
      {
         this.currentTime = TimeManager.getPrecisionServerTime();
         var _loc2_:int = this.currentTime - this.preTime;
         var _loc1_:int = 60 - _loc2_;
         if(_loc1_ > 60)
         {
            _loc1_ = 60;
         }
         this.createAll();
         if(_loc1_ > 0)
         {
            Tick.instance.addTimeout(_loc1_ * 1000,this.timeCheck);
         }
         else
         {
            this.timeCheck();
         }
      }
      
      private function timeCheck() : void
      {
         Tick.instance.removeTimeout(this.timeCheck);
         this.clearPet();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.fightState[_loc1_] = false;
            _loc1_++;
         }
         this.createAll();
      }
      
      private function createAll(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            if(!this.fightState[_loc2_])
            {
               this.createMonster(this.petIDs[_loc2_],this.fightIds[_loc2_],this.petLevls[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      private function createMonster(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SpawnedPet = null;
         _loc4_ = new SpawnedPet(param1,param2,param3);
         _loc4_.setDefinedLabel("瓦力");
         this.petVec.push(_loc4_);
         MobileManager.addMobile(_loc4_,"spawnedPet");
      }
   }
}

