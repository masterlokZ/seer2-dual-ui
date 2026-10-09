package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.SpawnedPet;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   import org.taomee.utils.Tick;
   
   public class MapProcessor_80011 extends CopyMapProcessor
   {
      
      private var serverBuffer:ServerBuffer;
      
      private var preTime:uint;
      
      private var currentTime:uint;
      
      private var petIDs:Array = [170,1062,1063];
      
      private var fightState:Array = [false,false,false];
      
      private var fightIds:Array = [357,358,359];
      
      private var petLevls:Array = [50,70,100];
      
      private var petVec:Vector.<SpawnedPet>;
      
      private var mobileNpc:Mobile;
      
      private var stoneId:int = 400077;
      
      private var stoneNum:int;
      
      private var sceneInteractiveVec:Vector.<MovieClip>;
      
      public function MapProcessor_80011(param1:MapModel)
      {
         super(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Tick.instance.removeTimeout(this.timeCheck);
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            this.sceneInteractiveVec[_loc1_].removeEventListener("click",this.playMc);
            _loc1_++;
         }
      }
      
      override public function init() : void
      {
         super.init();
         StatisticsManager.sendNovice("0x10033764");
         this.petVec = new Vector.<SpawnedPet>();
         this.sceneInteractiveVec = new Vector.<MovieClip>();
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            this.sceneInteractiveVec.push(_map.ground["interactive" + _loc1_]);
            this.sceneInteractiveVec[_loc1_].gotoAndStop(1);
            this.sceneInteractiveVec[_loc1_].buttonMode = true;
            this.sceneInteractiveVec[_loc1_].mouseChildren = false;
            this.sceneInteractiveVec[_loc1_].addEventListener("click",this.playMc);
            _loc1_++;
         }
         ItemManager.requestItemList(this.getItemNum);
         this.requestSeverBuffer();
      }
      
      private function playMc(param1:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var event:MouseEvent = param1;
         mc = event.target as MovieClip;
         MovieClipUtil.playMc(mc,1,mc.totalFrames,function():void
         {
            mc.gotoAndStop(1);
            if(Math.random() * 100 < 10)
            {
               NpcDialog.show(509,"小恶魔",[[0,"嘻嘻嘻~！！欢迎来到无尽的深渊！进得来，你还想出去？"]],["与小恶魔对战 "," 懒得理你,放弃对战!"],[function():void
               {
                  FightManager.startFightWithWild(364);
               }]);
            }
         });
      }
      
      private function getItemNum() : void
      {
         this.stoneNum = ItemManager.getItemQuantityByReferenceId(this.stoneId) + ItemManager.getItemQuantityByReferenceId(400080);
         this.mobileNpc = new Mobile();
         this.mobileNpc.setPostion(new Point(595,200));
         this.mobileNpc.resourceUrl = URLUtil.getNpcSwf(130);
         this.mobileNpc.buttonMode = true;
         MobileManager.addMobile(this.mobileNpc,"npc");
         this.mobileNpc.addEventListener("click",this.showDia);
      }
      
      private function showDia(param1:MouseEvent) : void
      {
         ItemManager.requestItemList(this.getItemNumNew);
      }
      
      private function getItemNumNew() : void
      {
         this.stoneNum = ItemManager.getItemQuantityByReferenceId(this.stoneId) + ItemManager.getItemQuantityByReferenceId(400080);
         NpcDialog.show(130,"审判官",[[0,"此门是我管！给我<font color=\'#ff3300\'>10个</font>暗月石就给你开门！ 我知道你现在已经有<font color=\'#ff3300\'>" + this.stoneNum + "</font>个石头了（阴险的笑）"]],["打开第二重门","购买暗月石","一重门规则","离开"],[function():void
         {
            NpcDialog.show(130,"审判官",[[0,"小赛尔，你确定准备好了吗？第二重门即将打开，迎接你的将是更加艰巨的挑战！"]],["确定","我先准备一下"],[function():void
            {
               if(stoneNum < 10)
               {
                  NpcDialog.show(130,"审判官",[[0,"别想蒙我！我最拿手的就是算账！你的石头——不够！ 要不要买点啊？"]],["购买暗月石 ","知道了"],[function():void
                  {
                     ModuleManager.toggleModule(URLUtil.getAppModule("BuyPropPanel"),"",{
                        "itemId":400078,
                        "canBatch":true,
                        "isLimitNum":false,
                        "buyType":"mi",
                        "itemType":"hideShop"
                     });
                  }]);
               }
               else
               {
                  SwapManager.swapItem(1168,1,swapSuccess);
               }
            }]);
         },function():void
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("BuyPropPanel"),"",{
               "itemId":400078,
               "canBatch":true,
               "isLimitNum":false,
               "buyType":"mi",
               "itemType":"hideShop"
            });
         },function():void
         {
            ModuleManager.toggleModule(URLUtil.getAppModule("DarkDeathRule0Panel"));
         }]);
      }
      
      private function swapSuccess(param1:IDataInput) : void
      {
         var data:IDataInput = param1;
         new SwapInfo(data);
         MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("OpenDarkDeathDoor"),function():void
         {
            SceneManager.changeScene(9,80012);
         },true,true);
      }
      
      private function requestSeverBuffer() : void
      {
         this.clearPet();
         Connection.addCommandListener(CommandSet.CLIENT_GET_BUFFER_INFO_1062,this.getServerBufferData);
         Connection.send(CommandSet.CLIENT_GET_BUFFER_INFO_1062,100013);
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
      
      public function getServerBufferData(param1:MessageEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:LittleEndianByteArray = param1.message.getRawData().clone();
         var _loc5_:int = int(_loc3_.readUnsignedInt());
         if(_loc5_ == 100013)
         {
            Connection.removeCommandListener(CommandSet.CLIENT_GET_BUFFER_INFO_1062,this.getServerBufferData);
            this.serverBuffer = new ServerBuffer(_loc3_,100013);
            _loc4_ = this.serverBuffer.readDataAtPostion(0);
            this.preTime = this.serverBuffer.readDataAtPostionGetInt(1);
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               this.fightState[_loc2_] = Boolean(this.serverBuffer.readDataAtPostion(5 + _loc2_));
               _loc2_++;
            }
            this.checkMonster();
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
         var _loc4_:SpawnedPet = new SpawnedPet(param1,param2,param3);
         this.petVec.push(_loc4_);
         MobileManager.addMobile(_loc4_,"spawnedPet");
      }
   }
}

