package com.taomee.seer2.app.popup.alert
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.common.ResourceLibraryLoader;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.gameRule.behavior.InvitePetSelectBehavior;
   import com.taomee.seer2.app.gameRule.behavior.SOMultiBehavior;
   import com.taomee.seer2.app.gameRule.data.FighterSelectPanelVO;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.helper.UserInfoParseHelper;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.map.ResourceLibrary;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.filter.ColorFilter;
   
   public class InviteFightAlert extends Sprite implements IAlert
   {
      
      private var _ui:MovieClip;
      
      private var _closeButton:SimpleButton;
      
      private var _fightButtons:Vector.<ButtonInfo>;
      
      private var _inviteUserId:uint;
      
      private var _inviteUser:UserInfo;
      
      private var _requestFlag:Boolean = false;
      
      private var _alertInfo:AlertInfo;
      
      private var _resLoader:ResourceLibraryLoader;
      
      public function InviteFightAlert()
      {
         super();
         ModelLocator.getInstance().addEventListener("godFirePkSelect",this.onSelectEvent);
         ModelLocator.getInstance().addEventListener("bestCatchPkSelect",this.onSelectEvent1);
         this._resLoader = new ResourceLibraryLoader(URLUtil.getRes("publicRes/inviteFight.swf"));
         this._resLoader.getLib(this.onGetLib);
      }
      
      private function onGetLib(param1:ResourceLibrary) : void
      {
         var _loc6_:SimpleButton = null;
         var _loc3_:int = 0;
         var _loc2_:SimpleButton = null;
         var _loc4_:int = 0;
         this._ui = param1.getMovieClip("UI_InviteSkin");
         addChild(this._ui);
         this._ui.x -= this._ui.width / 2;
         this._ui.y -= this._ui.height / 2;
         this._closeButton = this._ui["closeBtn"];
         this._closeButton.addEventListener("click",this.onCloseHandler);
         this._fightButtons = new Vector.<ButtonInfo>();
         this._fightButtons.push(new ButtonInfo(this._ui["fBtn_0"],105,1));
         this._fightButtons.push(new ButtonInfo(this._ui["fBtn_1"],106,1));
         this._fightButtons.push(new ButtonInfo(this._ui["fBtn_2"],107,2));
         if(SceneManager.active.mapID == 1111)
         {
            _loc3_ = 1;
            while(_loc3_ < 3)
            {
               _loc6_ = this._fightButtons[_loc3_].button;
               if(_loc6_)
               {
                  ColorFilter.setGrayscale(_loc6_);
                  _loc6_.mouseEnabled = false;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc2_ = this._fightButtons[_loc4_].button;
               if(_loc2_)
               {
                  _loc2_.filters = [];
                  _loc2_.mouseEnabled = true;
               }
               _loc4_++;
            }
         }
         var _loc5_:uint = this._fightButtons.length;
         if(SceneManager.active.mapID == 15001)
         {
            this._requestFlag = true;
            this.requestFightInvite(1,106);
            return;
         }
         var _loc7_:uint = 0;
         while(_loc7_ < _loc5_)
         {
            this._fightButtons[_loc7_].button.addEventListener("click",this.onInviteHandler);
            _loc7_++;
         }
      }
      
      private function onSelectEvent(param1:LogicEvent) : void
      {
         var evt:LogicEvent = param1;
         ModelLocator.getInstance().removeEventListener("godFirePkSelect",this.onSelectEvent);
         this.visible = false;
         if(this._fightButtons == null)
         {
            TweenNano.delayedCall(2,function():void
            {
               requestFightInvite(_fightButtons[int(evt.obj)].fightType,_fightButtons[int(evt.obj)].fightMode);
            });
         }
         else
         {
            this.requestFightInvite(this._fightButtons[int(evt.obj)].fightType,this._fightButtons[int(evt.obj)].fightMode);
         }
      }
      
      private function onSelectEvent1(param1:LogicEvent) : void
      {
         var evt:LogicEvent = param1;
         ModelLocator.getInstance().removeEventListener("bestCatchPkSelect",this.onSelectEvent1);
         this.visible = false;
         if(this._fightButtons == null)
         {
            TweenNano.delayedCall(2,function():void
            {
               if(Boolean(_fightButtons) && Boolean(_fightButtons[int(evt.obj)]))
               {
                  requestFightInvite(_fightButtons[int(evt.obj)].fightType,_fightButtons[int(evt.obj)].fightMode);
               }
            });
         }
         else
         {
            this.requestFightInvite(this._fightButtons[int(evt.obj)].fightType,this._fightButtons[int(evt.obj)].fightMode);
         }
      }
      
      private function onInviteHandler(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         if(this._requestFlag == false)
         {
            this._requestFlag = true;
            _loc2_ = param1.currentTarget as SimpleButton;
            _loc4_ = this._fightButtons.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(this._fightButtons[_loc3_].button == _loc2_)
               {
                  this.requestFightInvite(this._fightButtons[_loc3_].fightType,this._fightButtons[_loc3_].fightMode);
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      private function requestFightInvite(param1:uint, param2:uint) : void
      {
         var _loc3_:FighterSelectPanelVO = null;
         var _loc4_:uint = this._inviteUser.id;
         _loc3_ = new FighterSelectPanelVO();
         _loc3_.defaultPets = this.getDefaultPets(param2,PetInfoManager.getAllBagPetInfo());
         _loc3_.pets = PetInfoManager.getAllBagPetInfo();
         if(param2 == 105)
         {
            _loc3_.minSelectedPetCount = 1;
            _loc3_.maxSelectedPetCount = 1;
         }
         else if(param2 == 106)
         {
            _loc3_.minSelectedPetCount = 1;
            _loc3_.maxSelectedPetCount = 6;
            _loc3_.selectable = false;
         }
         else if(param2 == 107)
         {
            _loc3_.minSelectedPetCount = 2;
            _loc3_.maxSelectedPetCount = 2;
            if(_loc3_.pets.length < 2)
            {
               AlertManager.showAlert("您背包中的精灵少于2只！");
               return;
            }
         }
         _loc3_.actorName = ActorManager.actorInfo.nick;
         _loc3_.callBackBehavior = new InvitePetSelectBehavior(this._inviteUser,param2,param1);
         ModuleManager.showModule(URLUtil.getAppModule("FighterSelectPanel"),"正在打开选择对战精灵面板...",_loc3_);
         this.dispose();
      }
      
      private function getDefaultPets(param1:uint, param2:Vector.<PetInfo>) : Vector.<PetInfo>
      {
         var _loc4_:uint = 0;
         var _loc8_:Array = null;
         var _loc6_:uint = 0;
         var _loc3_:uint = 0;
         var _loc7_:uint = 0;
         var _loc10_:Vector.<PetInfo> = new Vector.<PetInfo>();
         var _loc9_:String = SOMultiBehavior.getKey(param1);
         var _loc5_:Array = SOMultiBehavior.readDefaultPets(_loc9_);
         if(param1 == 106)
         {
            _loc10_ = PetInfoManager.getAllBagPetInfo();
         }
         else
         {
            if(_loc5_ != null)
            {
               _loc3_ = param2.length;
               while(_loc7_ < _loc3_)
               {
                  if(_loc5_.indexOf(param2[_loc7_].catchTime) != -1)
                  {
                     _loc10_.push(param2[_loc7_]);
                  }
                  _loc7_++;
               }
            }
            if(_loc10_.length == 0)
            {
               if(param1 == 105)
               {
                  _loc10_ = Vector.<PetInfo>([PetInfoManager.getFirstPetInfo()]);
               }
               else if(param1 == 107)
               {
                  _loc10_ = PetInfoManager.getRandomFightPetInfo(2);
               }
            }
            _loc4_ = _loc10_.length;
            _loc8_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc8_.push(_loc10_[_loc6_].catchTime);
               _loc6_++;
            }
            SOMultiBehavior.writeDefaultPets(_loc9_,_loc8_);
         }
         return _loc10_;
      }
      
      private function onCloseHandler(param1:MouseEvent) : void
      {
         this.dispose();
         param1.stopImmediatePropagation();
      }
      
      public function show(param1:AlertInfo) : void
      {
         this._alertInfo = param1;
         this._inviteUserId = param1.initInfo.userId;
         this.requestUserInfo(this._inviteUserId);
      }
      
      private function requestUserInfo(param1:uint) : void
      {
         Connection.addCommandListener(CommandSet.USER_GET_DETAIL_INFO_1010,this.onGetDetailInfo);
         Connection.send(CommandSet.USER_GET_DETAIL_INFO_1010,param1);
      }
      
      private function onGetDetailInfo(param1:MessageEvent) : void
      {
         var _loc2_:IDataInput = param1.message.getRawData();
         var _loc3_:uint = _loc2_.readUnsignedInt();
         if(_loc3_ == this._inviteUserId)
         {
            Connection.removeCommandListener(CommandSet.USER_GET_DETAIL_INFO_1010,this.onGetDetailInfo);
            ByteArray(_loc2_).position = 0;
            this._inviteUser = new UserInfo();
            UserInfoParseHelper.parseUserDetailInfo(this._inviteUser,_loc2_);
            AlertManager.addPopUp(this._alertInfo,this);
         }
      }
      
      public function dispose() : void
      {
         this._resLoader.dispose();
         this._inviteUser = null;
         this._closeButton.removeEventListener("click",this.onCloseHandler);
         this._closeButton = null;
         var _loc2_:uint = this._fightButtons.length;
         var _loc1_:uint = 0;
         while(_loc1_ < _loc2_)
         {
            this._fightButtons[_loc1_].button.removeEventListener("click",this.onInviteHandler);
            _loc1_++;
         }
         this._fightButtons = null;
         this._ui = null;
         AlertManager.removePopUp(this);
         LayerManager.resetOperation();
         this.dispatchEvent(new Event("close"));
      }
   }
}

import flash.display.SimpleButton;

class ButtonInfo
{
   
   public var button:SimpleButton;
   
   public var fightMode:uint;
   
   public var fightType:uint;
   
   public function ButtonInfo(param1:SimpleButton, param2:uint, param3:uint)
   {
      this.button = param1;
      this.fightMode = param2;
      this.fightType = param3;
      super();
   }
}
