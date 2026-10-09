package com.taomee.seer2.app.manager
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.preview.ActorPreview;
   import com.taomee.seer2.app.actor.util.ActorEquipAssembler;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.events.FightStartEvent;
   import com.taomee.seer2.app.arena.resource.ArenaResourceLoader;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.info.PVPInfo;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.ErrorMap;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.sound.SoundManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.IDataInput;
   import org.taomee.utils.DisplayUtil;
   
   public class JuedouchangPVPManager
   {
      
      private static var _pvpInfo:PVPInfo;
      
      private static var _enterFightFun:Function;
      
      private static var _endFightFun:Function;
      
      private static var _mc:MovieClip;
      
      private static var _remoteInfo:UserInfo;
      
      private static var _thisPetList:Vector.<PetInfo>;
      
      private static var _remotePetList:Vector.<PetInfo>;
      
      private static var _thisPreview:ActorPreview;
      
      private static var _remotePreview:ActorPreview;
      
      private static var _thisIconList:Vector.<IconDisplayer>;
      
      private static var _remoteIconList:Vector.<IconDisplayer>;
      
      public function JuedouchangPVPManager()
      {
         super();
      }
      
      public static function startPVPFight(param1:Vector.<uint>, param2:uint, param3:uint, param4:uint, param5:Function = null, param6:Function = null, param7:int = 6, param8:int = 6) : void
      {
         _enterFightFun = param5;
         _endFightFun = param6;
         _pvpInfo = new PVPInfo();
         _pvpInfo.minPetNum = param7;
         _pvpInfo.maxPetNum = param8;
         _pvpInfo.gate = param2;
         _pvpInfo.mode = param3;
         _pvpInfo.type = param4;
         _pvpInfo.isStartFight = false;
         _pvpInfo.isShowTag = false;
         if(PetInfoManager.getAllBagPetInfo().length < _pvpInfo.minPetNum)
         {
            AlertManager.showAlert("出战精灵数量不足");
            return;
         }
         _pvpInfo.petList = param1;
         applyMatch();
      }
      
      private static function applyMatch() : void
      {
         Connection.addCommandListener(CommandSet.DOOR_FIGHT_MATCH_END_1082,matchSuccess);
         Connection.addErrorHandler(CommandSet.DOOR_FIGHT_MATCH_END_1082,onPvpError);
         Connection.addErrorHandler(CommandSet.DOOR_FIGHT_MATCH_1079,onPvpError);
         Connection.send(CommandSet.DOOR_FIGHT_MATCH_1079,_pvpInfo.gate,_pvpInfo.mode);
         ModuleManager.toggleModule(URLUtil.getAppModule("PetNoPoultryWaitMatePanel"),"打开面板中...",_pvpInfo);
      }
      
      private static function onPvpError(param1:MessageEvent) : void
      {
         ErrorMap.parseStatusCode(param1.message.statusCode);
      }
      
      private static function matchSuccess(param1:MessageEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc17_:uint = 0;
         var _loc19_:uint = 0;
         var _loc13_:uint = 0;
         var _loc15_:int = 0;
         var _loc23_:PetInfo = null;
         var _loc24_:EquipItem = null;
         var _loc21_:uint = 0;
         var _loc22_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc2_:uint = 0;
         var _loc18_:uint = 0;
         var _loc20_:int = 0;
         var _loc14_:uint = 0;
         var _loc16_:int = 0;
         Connection.removeCommandListener(CommandSet.DOOR_FIGHT_MATCH_END_1082,matchSuccess);
         var _loc8_:IDataInput = param1.message.getRawData();
         var _loc10_:uint = _loc8_.readUnsignedInt();
         var _loc9_:Vector.<PetInfo> = Vector.<PetInfo>([]);
         var _loc5_:Vector.<PetInfo> = Vector.<PetInfo>([]);
         var _loc7_:UserInfo = new UserInfo();
         var _loc6_:UserInfo = new UserInfo();
         var _loc3_:int = 0;
         while(_loc3_ < _loc10_)
         {
            _loc17_ = _loc8_.readUnsignedInt();
            _loc19_ = _loc8_.readUnsignedInt();
            _loc13_ = _loc8_.readUnsignedInt();
            if(_loc17_ != ActorManager.actorInfo.id)
            {
               _loc4_ = _loc17_;
            }
            _loc15_ = 0;
            while(_loc15_ < _loc13_)
            {
               _loc11_ = _loc8_.readUnsignedInt();
               _loc12_ = _loc8_.readUnsignedInt();
               _loc2_ = _loc8_.readUnsignedInt();
               _loc23_ = new PetInfo();
               _loc23_.resourceId = _loc11_;
               if(_loc17_ == ActorManager.actorInfo.id)
               {
                  _loc9_.push(_loc23_);
               }
               else
               {
                  _loc5_.push(_loc23_);
               }
               _loc15_++;
            }
            if(_loc17_ == ActorManager.actorInfo.id)
            {
               _loc7_.id = _loc8_.readUnsignedInt();
               _loc7_.sex = _loc8_.readUnsignedByte();
               _loc7_.nick = _loc8_.readUTFBytes(16);
               _loc7_.color = _loc8_.readUnsignedInt();
               _loc7_.trainerScore = _loc8_.readUnsignedInt();
               _loc7_.equipVec = new Vector.<EquipItem>();
               _loc18_ = _loc8_.readUnsignedInt();
               _loc20_ = 0;
               while(_loc20_ < _loc18_)
               {
                  _loc24_ = new EquipItem(_loc8_.readUnsignedInt());
                  _loc7_.equipVec.push(_loc24_);
                  _loc20_++;
               }
            }
            else
            {
               _loc6_.id = _loc8_.readUnsignedInt();
               _loc6_.sex = _loc8_.readUnsignedByte();
               _loc6_.nick = _loc8_.readUTFBytes(16);
               _loc6_.color = _loc8_.readUnsignedInt();
               _loc6_.trainerScore = _loc8_.readUnsignedInt();
               _loc6_.equipVec = new Vector.<EquipItem>();
               _loc14_ = _loc8_.readUnsignedInt();
               _loc16_ = 0;
               while(_loc16_ < _loc14_)
               {
                  _loc24_ = new EquipItem(_loc8_.readUnsignedInt());
                  _loc6_.equipVec.push(_loc24_);
                  _loc16_++;
               }
               ActorEquipAssembler.mergeDefaultEquip(_loc6_.color,_loc6_.equipVec);
            }
            _loc21_ = _loc8_.readUnsignedInt();
            _loc22_ = 0;
            while(_loc22_ < _loc21_)
            {
               _loc8_.readUnsignedInt();
               _loc22_++;
            }
            _loc3_++;
         }
         _remoteInfo = _loc6_;
         _thisPetList = _loc9_;
         _remotePetList = _loc5_;
         FightManager.addEventListener("FIGHT_LOADING_START",onFightLoadStart);
         startFight();
      }
      
      private static function onFightLoadStart(param1:FightStartEvent) : void
      {
         FightManager.removeEventListener("FIGHT_LOADING_START",onFightLoadStart);
         ArenaResourceLoader.hideLoadingBar();
         entryFight();
      }
      
      private static function entryFight() : void
      {
         var iconDisplayer:IconDisplayer = null;
         var petInfo:PetInfo = null;
         if(_enterFightFun != null)
         {
            _enterFightFun();
         }
         _thisIconList = Vector.<IconDisplayer>([]);
         _remoteIconList = Vector.<IconDisplayer>([]);
         for each(petInfo in _thisPetList)
         {
            iconDisplayer = new IconDisplayer();
            iconDisplayer.setIconUrl(URLUtil.getPetIcon(petInfo.resourceId));
            iconDisplayer.scaleX = iconDisplayer.scaleY = 1;
            _thisIconList.push(iconDisplayer);
         }
         for each(petInfo in _remotePetList)
         {
            iconDisplayer = new IconDisplayer();
            iconDisplayer.setIconUrl(URLUtil.getPetIcon(petInfo.resourceId));
            iconDisplayer.scaleX = 1;
            iconDisplayer.scaleY = 1;
            _remoteIconList.push(iconDisplayer);
         }
         LayerManager.focusOnTopLayer();
         MovieClipUtil.getSwfContent(URLUtil.getActivityFullScreen("PetNoPoultry"),function(param1:MovieClip):void
         {
            SoundManager.enabled = false;
            _mc = param1["mcc"];
            _mc["vs"].visible = false;
            LayerManager.topLayer.addChild(_mc);
            _thisPreview = new ActorPreview();
            _thisPreview.scaleX = -1;
            _remotePreview = new ActorPreview();
            _thisPreview.setData(ActorManager.actorInfo);
            _remotePreview.setData(_remoteInfo);
            Connection.addCommandListener(CommandSet.FIGHT_GET_REVENUE_5,onFightGetRevenue);
            Connection.addCommandListener(CommandSet.FIGHT_TURN_START_2,onFightLoadEnd);
            _mc["loading"].gotoAndPlay(2);
            _mc["loading"].addEventListener("enterFrame",onFullScreenEnter);
            onShowMyTeam();
         });
      }
      
      private static function onShowMyTeam() : void
      {
         var _loc1_:MovieClip = null;
         LayerManager.hideMap();
         _thisPreview.x = 260;
         _thisPreview.y = 440;
         LayerManager.topLayer.addChild(_thisPreview);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            _thisIconList[_loc2_].x = _thisIconList[_loc2_].y = 0;
            _loc1_ = _mc["myIconList" + _loc2_]["iconMc"]["icon"];
            DisplayObjectUtil.removeAllChildren(_loc1_);
            if(_thisIconList[_loc2_])
            {
               _loc1_.addChild(_thisIconList[_loc2_]);
            }
            MovieClip(_mc["enIconList" + _loc2_]).gotoAndStop(2);
            _loc2_++;
         }
      }
      
      private static function onShowEnemyTeam() : void
      {
         var _loc1_:MovieClip = null;
         _remotePreview.x = 950;
         _remotePreview.y = 440;
         LayerManager.topLayer.addChild(_remotePreview);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            MovieClip(_mc["enIconList" + _loc2_]).gotoAndStop(1);
            _remoteIconList[_loc2_].x = _remoteIconList[_loc2_].y = 0;
            _loc1_ = _mc["enIconList" + _loc2_]["iconMc"]["icon"];
            DisplayObjectUtil.removeAllChildren(_loc1_);
            if(_remoteIconList[_loc2_])
            {
               _loc1_.addChild(_remoteIconList[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      private static function onFightGetRevenue(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.FIGHT_GET_REVENUE_5,onFightGetRevenue);
         Connection.removeCommandListener(CommandSet.FIGHT_TURN_START_2,onFightLoadEnd);
         clearMC();
      }
      
      private static function onFightLoadEnd(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.FIGHT_GET_REVENUE_5,onFightGetRevenue);
         Connection.removeCommandListener(CommandSet.FIGHT_TURN_START_2,onFightLoadEnd);
         clearMC();
      }
      
      private static function clearMC() : void
      {
         var _loc1_:IconDisplayer = null;
         if(_mc)
         {
            _mc["loading"].stop();
            _mc["loading"].removeEventListener("enterFrame",onFullScreenEnter);
            DisplayUtil.removeForParent(_thisPreview);
            DisplayUtil.removeForParent(_remotePreview);
            for each(_loc1_ in _thisIconList)
            {
               DisplayUtil.removeForParent(_loc1_);
            }
            for each(_loc1_ in _remoteIconList)
            {
               DisplayUtil.removeForParent(_loc1_);
            }
            DisplayUtil.removeForParent(_mc);
            LayerManager.resetOperation();
            LayerManager.showMap();
            SoundManager.enabled = true;
         }
      }
      
      private static function onFullScreenEnter(param1:Event) : void
      {
         var event:Event = param1;
         if(_mc["loading"].currentFrame == 45)
         {
            onShowEnemyTeam();
         }
         if(_mc["loading"].currentFrame >= _mc["loading"].totalFrames)
         {
            _mc["loading"].stop();
            _mc["loading"].removeEventListener("enterFrame",onFullScreenEnter);
            MovieClip(_mc["vs"]).gotoAndStop(1);
            _mc["loading"].visible = false;
            _mc["vs"].visible = true;
            MovieClipUtil.playMc(MovieClip(_mc["vs"]),2,MovieClip(_mc["vs"]).totalFrames,function():void
            {
               MovieClip(_mc["vs"]).gotoAndStop(MovieClip(_mc["vs"]).totalFrames);
            });
         }
      }
      
      private static function startFight() : void
      {
         var _loc2_:LittleEndianByteArray = new LittleEndianByteArray();
         _loc2_.writeUnsignedInt(_pvpInfo.gate);
         var _loc1_:Array = [];
         var _loc4_:uint = _pvpInfo.petList.length;
         _loc2_.writeUnsignedInt(_loc4_);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_.push(_pvpInfo.petList[_loc3_]);
            _loc2_.writeUnsignedInt(_pvpInfo.petList[_loc3_]);
            _loc3_++;
         }
         SceneManager.addEventListener("switchComplete",onSwitchComplete);
         FightManager.startFightPVP(_loc2_);
      }
      
      private static function onSwitchComplete(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType == 2)
         {
            SceneManager.removeEventListener("switchComplete",onSwitchComplete);
            if(_endFightFun != null)
            {
               _endFightFun();
            }
         }
      }
   }
}

