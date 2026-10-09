package com.taomee.seer2.app.popup
{
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.gameRule.door.core.ServerReward;
   import com.taomee.seer2.app.inventory.ItemDescription;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.popup.alert.Alert;
   import com.taomee.seer2.app.popup.alert.AutoCloseAlert;
   import com.taomee.seer2.app.popup.alert.CoinsGainedAlert;
   import com.taomee.seer2.app.popup.alert.Confirm;
   import com.taomee.seer2.app.popup.alert.DoorResultAlert;
   import com.taomee.seer2.app.popup.alert.DoorRewardAlert;
   import com.taomee.seer2.app.popup.alert.DreamAlert;
   import com.taomee.seer2.app.popup.alert.FakeDogzAlert;
   import com.taomee.seer2.app.popup.alert.FishingAlert;
   import com.taomee.seer2.app.popup.alert.FishingStartAlert;
   import com.taomee.seer2.app.popup.alert.GetPetInBagAlert;
   import com.taomee.seer2.app.popup.alert.GetPetInStorageAlert;
   import com.taomee.seer2.app.popup.alert.GetPetSpiritAlert;
   import com.taomee.seer2.app.popup.alert.HonorAlert;
   import com.taomee.seer2.app.popup.alert.IAlert;
   import com.taomee.seer2.app.popup.alert.IndulgeAlert;
   import com.taomee.seer2.app.popup.alert.InviteFightAlert;
   import com.taomee.seer2.app.popup.alert.InvitedFightAlert;
   import com.taomee.seer2.app.popup.alert.ItemGainedAlert;
   import com.taomee.seer2.app.popup.alert.ItemGroupView;
   import com.taomee.seer2.app.popup.alert.ItemMaxAlert;
   import com.taomee.seer2.app.popup.alert.ItemSpeialGainedAlert;
   import com.taomee.seer2.app.popup.alert.MedalGainedAlert;
   import com.taomee.seer2.app.popup.alert.MoneyAlert;
   import com.taomee.seer2.app.popup.alert.PetBagSelectPetAlert;
   import com.taomee.seer2.app.popup.alert.PiggyBankAlert;
   import com.taomee.seer2.app.popup.alert.SelectAllPetAlert;
   import com.taomee.seer2.app.popup.alert.SelectPetAlert;
   import com.taomee.seer2.app.popup.alert.team.TeamApplyAlert;
   import com.taomee.seer2.app.popup.alert.team.TeamCommonAlert;
   import com.taomee.seer2.app.popup.alert.team.TeamCreComAlert;
   import com.taomee.seer2.app.popup.alert.team.TeamEntryAlert;
   import com.taomee.seer2.app.team.data.TeamMainInfo;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import seer2.next.fight.auto.AutoFightPanel;
   
   public class AlertManager
   {
      
      private static var _popFlag:Boolean = true;
      
      private static var _currAlert:IAlert;
      
      private static var _popList:Vector.<AlertInfo> = new Vector.<AlertInfo>();
      
      public function AlertManager()
      {
         super();
      }
      
      public static function blockPop() : void
      {
         _popFlag = false;
      }
      
      public static function releasePop() : void
      {
         _popFlag = true;
         nextShow();
      }
      
      public static function showPopUp(param1:uint, param2:AlertInitInfo = null, param3:Boolean = true, param4:Boolean = true) : void
      {
         var _loc5_:AlertInfo = null;
         _loc5_ = new AlertInfo();
         _loc5_.alertType = param1;
         _loc5_.initInfo = param2;
         _loc5_.centralize = param3;
         _loc5_.isFocus = param4;
         _popList.push(_loc5_);
         if(_popFlag)
         {
            nextShow();
         }
      }
      
      public static function addPopUp(param1:AlertInfo, param2:IAlert) : void
      {
         if(param1.centralize == true)
         {
            proxy(param2);
         }
         LayerManager.topLayer.addChild(param2 as DisplayObject);
         if(param1.isFocus == true)
         {
            LayerManager.focusOnTopLayer();
         }
      }
      
      private static function proxy(param1:IAlert) : void
      {
         var _loc2_:int = LayerManager.root.stage.stageWidth - param1.width >> 1;
         var _loc3_:int = LayerManager.root.stage.stageHeight - param1.height >> 1;
         param1.x = _loc2_;
         param1.y = _loc3_;
      }
      
      public static function closeAllPopUp() : void
      {
         if(_currAlert != null)
         {
            _currAlert.removeEventListener("close",onAlertClose);
            _currAlert.dispose();
            _currAlert = null;
            _popList.length = 0;
         }
      }
      
      public static function removePopUp(param1:DisplayObject, param2:Boolean = true) : void
      {
         DisplayObjectUtil.removeFromParent(param1 as DisplayObject);
         if(param2 == true)
         {
            LayerManager.resetOperation();
         }
      }
      
      private static function nextShow() : void
      {
         if(_popList.length == 0)
         {
            return;
         }
         var _loc1_:AlertInfo = _popList.shift() as AlertInfo;
         switch(_loc1_.alertType)
         {
            case 0:
               _currAlert = new Alert();
               break;
            case 2:
               _currAlert = new Confirm();
               break;
            case 1:
               _currAlert = new AutoCloseAlert();
               break;
            case 3:
               _currAlert = new ItemGainedAlert();
               _loc1_.isFocus = false;
               break;
            case 21:
               _currAlert = new ItemSpeialGainedAlert();
               _loc1_.isFocus = false;
               break;
            case 4:
               _currAlert = new HonorAlert();
               _loc1_.isFocus = false;
               break;
            case 5:
               _currAlert = new TeamCommonAlert();
               _loc1_.isFocus = false;
               break;
            case 14:
               _currAlert = new TeamApplyAlert();
               _loc1_.isFocus = false;
               break;
            case 6:
               _currAlert = new FakeDogzAlert();
               break;
            case 7:
               _currAlert = new CoinsGainedAlert();
               _loc1_.isFocus = false;
               break;
            case 8:
               _currAlert = new MedalGainedAlert();
               _loc1_.isFocus = false;
               break;
            case 10:
               _currAlert = new PiggyBankAlert();
               break;
            case 11:
               _currAlert = new ItemGroupView();
               break;
            case 12:
               _currAlert = new FishingAlert();
               break;
            case 13:
               _currAlert = new FishingStartAlert();
               break;
            case 15:
               _currAlert = new DoorRewardAlert();
               break;
            case 9:
               _currAlert = new DoorResultAlert();
               _loc1_.isFocus = false;
               break;
            case 16:
               _currAlert = new InviteFightAlert();
               break;
            case 17:
               _currAlert = new InvitedFightAlert();
               break;
            case 18:
               _currAlert = new ItemMaxAlert();
               _loc1_.isFocus = false;
               break;
            case 19:
               _currAlert = new IndulgeAlert();
               break;
            case 20:
               _currAlert = new MoneyAlert();
               break;
            case 22:
               _currAlert = new SelectPetAlert();
               break;
            case 30:
               _currAlert = new SelectAllPetAlert();
               break;
            case 23:
               _currAlert = new PetBagSelectPetAlert();
               break;
            case 24:
               _currAlert = new GetPetInBagAlert();
               break;
            case 25:
               _currAlert = new GetPetInStorageAlert();
               break;
            case 26:
               _currAlert = new GetPetSpiritAlert();
               break;
            case 27:
               _currAlert = new TeamEntryAlert();
               break;
            case 28:
               _currAlert = new TeamCreComAlert();
               break;
            case 29:
               _currAlert = new DreamAlert();
               break;
            default:
               return;
         }
         _currAlert.addEventListener("close",onAlertClose);
         _currAlert.show(_loc1_);
      }
      
      private static function onAlertClose(param1:Event) : void
      {
         if(_currAlert)
         {
            _currAlert.removeEventListener("close",onAlertClose);
            _currAlert = null;
         }
         if(_popFlag)
         {
            nextShow();
         }
      }
      
      public static function get currAlert() : IAlert
      {
         return _currAlert;
      }
      
      public static function showInvitedFightAlert(param1:uint, param2:uint) : void
      {
         var _loc3_:AlertInitInfo = new AlertInitInfo("");
         _loc3_.userId = param1;
         _loc3_.mode = param2;
         showPopUp(17,_loc3_);
      }
      
      public static function showInviteFightAlert(param1:uint) : void
      {
         var _loc2_:AlertInitInfo = new AlertInitInfo("");
         _loc2_.userId = param1;
         showPopUp(16,_loc2_);
      }
      
      public static function showAlert(param1:String, param2:Function = null) : void
      {
         showPopUp(0,new AlertInitInfo(param1,param2));
      }
      
      public static function showIndulgeAlert(param1:String) : void
      {
         closeAllPopUp();
         if(AutoFightPanel.isRunning)
         {
            return;
         }
         showPopUp(19,new AlertInitInfo(param1,null),true,false);
      }
      
      public static function showAutoCloseAlert(param1:String, param2:uint = 3, param3:Function = null) : void
      {
         showPopUp(1,new AlertInitInfo(param1,param3,null,null,param2));
      }
      
      public static function showConfirm(param1:String, param2:Function = null, param3:Function = null) : void
      {
         showPopUp(2,new AlertInitInfo(param1,null,param2,param3));
      }
      
      public static function showFishingStartAlert(param1:Function = null, param2:Function = null) : void
      {
         showPopUp(13,new AlertInitInfo("",null,param1,param2));
      }
      
      public static function showFishingAlert(param1:uint, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:AlertInitInfo = null;
         _loc4_ = new AlertInitInfo("",null,param2,param3);
         _loc4_.referenceId = param1;
         showPopUp(12,_loc4_);
      }
      
      public static function showItemGainedAlert(param1:uint, param2:uint = 1, param3:Function = null, param4:String = "") : void
      {
         var _loc5_:AlertInitInfo = null;
         if(AutoFightPanel.isRunning)
         {
            return;
         }
         _loc5_ = new AlertInitInfo(param4,param3);
         _loc5_.referenceId = param1;
         _loc5_.quantity = param2;
         showPopUp(3,_loc5_);
      }
      
      public static function showGetPetInBagAlert(param1:uint, param2:uint = 1, param3:Function = null, param4:String = "") : void
      {
         var _loc5_:AlertInitInfo = null;
         _loc5_ = new AlertInitInfo(param4,param3);
         _loc5_.referenceId = param1;
         _loc5_.quantity = param2;
         showPopUp(24,_loc5_);
      }
      
      public static function showGetPetInStorageAlert(param1:uint, param2:uint = 1, param3:Function = null, param4:String = "") : void
      {
         var _loc5_:AlertInitInfo = null;
         _loc5_ = new AlertInitInfo(param4,param3);
         _loc5_.referenceId = param1;
         _loc5_.quantity = param2;
         showPopUp(25,_loc5_);
      }
      
      public static function showGetPetSpiritAlert(param1:uint, param2:uint = 1, param3:Function = null, param4:String = "") : void
      {
         var _loc5_:AlertInitInfo = null;
         _loc5_ = new AlertInitInfo(param4,param3);
         _loc5_.referenceId = param1;
         _loc5_.quantity = param2;
         showPopUp(26,_loc5_);
      }
      
      public static function showSpiecalItemGainedAlert(param1:uint, param2:uint = 1, param3:Function = null, param4:String = "") : void
      {
         var _loc5_:AlertInitInfo = null;
         _loc5_ = new AlertInitInfo(param4,param3);
         _loc5_.referenceId = param1;
         _loc5_.quantity = param2;
         showPopUp(21,_loc5_);
      }
      
      public static function showItemMaxAlert(param1:uint, param2:uint = 1, param3:Function = null, param4:String = "") : void
      {
         var _loc5_:AlertInitInfo = null;
         _loc5_ = new AlertInitInfo(param4,param3);
         _loc5_.referenceId = param1;
         _loc5_.quantity = param2;
         showPopUp(18,_loc5_);
      }
      
      public static function showHonorAlert(param1:uint, param2:uint, param3:Function = null) : void
      {
         var _loc4_:AlertInitInfo = null;
         _loc4_ = new AlertInitInfo("",param3);
         _loc4_.referenceId = param1;
         _loc4_.quantity = param2;
         showPopUp(4,_loc4_);
      }
      
      public static function showMedalGainedAlert(param1:uint, param2:Function = null) : void
      {
         var _loc3_:AlertInitInfo = new AlertInitInfo("",param2);
         _loc3_.referenceId = param1;
         showPopUp(8,_loc3_);
      }
      
      public static function showCoinsGainedAlert(param1:uint, param2:Function = null) : void
      {
         var _loc3_:AlertInitInfo = new AlertInitInfo("",param2);
         _loc3_.quantity = param1;
         showPopUp(7,_loc3_);
      }
      
      public static function showPiggyBankAlert(param1:int, param2:Function = null) : void
      {
         var _loc3_:AlertInitInfo = new AlertInitInfo("",param2);
         _loc3_.quantity = param1;
         showPopUp(10,_loc3_);
      }
      
      public static function showTeamCommonAlert(param1:String, param2:TeamMainInfo, param3:Function = null, param4:Function = null) : void
      {
         var _loc5_:AlertInitInfo = null;
         _loc5_ = new AlertInitInfo(param1,null,param3,param4);
         _loc5_.teamInfo = param2;
         showPopUp(5,_loc5_);
      }
      
      public static function showTeamApplyAlert(param1:String, param2:TeamMainInfo, param3:Function = null, param4:Function = null) : void
      {
         var _loc5_:AlertInitInfo = null;
         _loc5_ = new AlertInitInfo(param1,null,param3,param4);
         _loc5_.teamInfo = param2;
         showPopUp(14,_loc5_);
      }
      
      public static function showEntryTeamAlert(param1:Function = null, param2:Function = null) : void
      {
         var _loc3_:AlertInitInfo = new AlertInitInfo("",null,param1,param2);
         showPopUp(27,_loc3_);
      }
      
      public static function showTeamCreComAlert(param1:String, param2:Function = null) : void
      {
         showPopUp(28,new AlertInitInfo(param1,null,param2));
      }
      
      public static function showDoorResult(param1:Boolean, param2:uint, param3:uint, param4:PetInfo = null, param5:uint = 0, param6:Function = null) : void
      {
         var _loc7_:AlertInitInfo = null;
         _loc7_ = new AlertInitInfo("",param6);
         _loc7_.result = param1;
         _loc7_.doorType = param2;
         _loc7_.doorRule = param3;
         _loc7_.petInfo = param4;
         _loc7_.equipId = param5;
         showPopUp(9,_loc7_);
      }
      
      public static function showDoorReward(param1:Boolean, param2:uint, param3:uint, param4:uint, param5:Vector.<ServerReward>, param6:Function = null) : void
      {
         var _loc7_:AlertInitInfo = null;
         _loc7_ = new AlertInitInfo("",param6);
         _loc7_.result = param1;
         _loc7_.doorType = param2;
         _loc7_.doorRule = param3;
         _loc7_.rewardId = param4;
         _loc7_.rewardList = param5;
         showPopUp(15,_loc7_);
      }
      
      public static function showFakeDogzAlert(param1:Function = null) : void
      {
         showPopUp(6,new AlertInitInfo("",param1));
      }
      
      public static function showItemListGaindeAlert(param1:Vector.<ItemDescription>, param2:Function = null) : void
      {
         var _loc4_:ItemDescription = null;
         var _loc3_:AlertInitInfo = null;
         var _loc5_:Vector.<ItemDescription> = param1.slice();
         while(_loc5_.length > 0)
         {
            _loc4_ = _loc5_.shift();
            _loc3_ = new AlertInitInfo("");
            _loc3_.referenceId = _loc4_.referenceId;
            _loc3_.quantity = _loc4_.quantity;
            if(_loc5_.length == 0)
            {
               _loc3_.closeHandler = param2;
            }
            if(_loc3_.referenceId > 603000 && _loc3_.referenceId <= 605055 || _loc3_.referenceId >= 400266 && _loc3_.referenceId <= 400268 || _loc3_.referenceId == 401067)
            {
               ServerMessager.addMessage("恭喜你获得了" + _loc3_.quantity + "个[" + ItemConfig.getItemName(_loc3_.referenceId) + "]");
            }
            else if(ItemConfig.getItemCategory(_loc3_.referenceId) == 8)
            {
               AlertManager.showGetPetSpiritAlert(_loc3_.referenceId,_loc3_.quantity);
            }
            else
            {
               showPopUp(3,_loc3_);
            }
         }
      }
      
      public static function showMoney(param1:Function = null, param2:Function = null) : void
      {
         showPopUp(20,new AlertInitInfo("",null,param1,param2));
      }
      
      public static function showMoneyOnly(param1:Function = null, param2:Function = null) : void
      {
         showPopUp(20,new AlertInitInfo("",null,param1,param2));
      }
      
      public static function showSelectAlert(param1:String, param2:Function, param3:Function = null) : void
      {
         showPopUp(22,new AlertInitInfo(param1,null,param2,param3));
      }
      
      public static function showSelectAllAlert(param1:String, param2:Function, param3:Function = null) : void
      {
         showPopUp(30,new AlertInitInfo(param1,null,param2,param3));
      }
      
      public static function showPetBagSelectAlert(param1:String, param2:Function, param3:Function = null) : void
      {
         showPopUp(23,new AlertInitInfo(param1,null,param2,param3));
      }
      
      public static function showDreamMiniAlert(param1:uint, param2:Function, param3:Function = null) : void
      {
         showPopUp(29,new AlertInitInfo(param1.toString(),null,param2,param3));
      }
   }
}

