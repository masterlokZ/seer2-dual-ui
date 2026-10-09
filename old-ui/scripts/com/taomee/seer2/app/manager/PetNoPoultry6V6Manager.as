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
   import com.taomee.seer2.app.pet.data.SkillInfo;
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
   
   public class PetNoPoultry6V6Manager
   {
      
      private static var _pvpInfo:PVPInfo;
      
      private static var _mc:MovieClip;
      
      private static var _remoteInfo:UserInfo;
      
      private static var _thisPetList:Vector.<PetInfo>;
      
      private static var _remotePetList:Vector.<PetInfo>;
      
      private static var _thisPreview:ActorPreview;
      
      private static var _remotePreview:ActorPreview;
      
      private static var _thisIconList:Vector.<IconDisplayer>;
      
      private static var _remoteIconList:Vector.<IconDisplayer>;
      
      public function PetNoPoultry6V6Manager()
      {
         super();
      }
      
      public static function startNoPoultry6V6Fight(param1:Vector.<uint>, param2:uint = 19, param3:uint = 214, param4:uint = 19) : void
      {
         var bagInfo:* = undefined;
         _pvpInfo = new PVPInfo();
         _pvpInfo.minPetNum = 6;
         _pvpInfo.maxPetNum = 6;
         _pvpInfo.gate = param2;
         _pvpInfo.mode = param3;
         _pvpInfo.type = param4;
         _pvpInfo.isStartFight = false;
         _pvpInfo.isShowTag = false;
         if(param2 == 21 || param2 == 22)
         {
            bagInfo = PetInfoManager.getAllBagPetInfo();
            for each(var info in bagInfo)
            {
               if(info.emblemId == 300137 || info.resourceId == 106 && info.emblemId != 0 || info.resourceId == 292 || info.resourceId == 435)
               {
                  _pvpInfo.mode = 215;
                  break;
               }
               if(info.resourceId == 108)
               {
                  for each(var skill in info.skillInfo.skillInfoVec)
                  {
                     if(skill.id == 14579)
                     {
                        _pvpInfo.mode = 215;
                        break;
                     }
                  }
               }
               else if(info.resourceId == 325)
               {
                  for each(var skill2 in info.skillInfo.skillInfoVec)
                  {
                     if(skill.id == 12278)
                     {
                        _pvpInfo.mode = 215;
                        break;
                     }
                  }
               }
            }
         }
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
         var _loc15_:uint = 0;
         var _loc20_:uint = 0;
         var _loc9_:uint = 0;
         var _loc25_:uint = 0;
         var _loc14_:int = 0;
         var _loc24_:PetInfo = null;
         var _loc12_:EquipItem = null;
         var _loc19_:uint = 0;
         var _loc7_:int = 0;
         var _loc2_:uint = 0;
         var _loc10_:uint = 0;
         var _loc23_:uint = 0;
         var _loc8_:uint = 0;
         var _loc21_:int = 0;
         var _loc13_:uint = 0;
         var _loc26_:int = 0;
         Connection.removeCommandListener(CommandSet.DOOR_FIGHT_MATCH_END_1082,matchSuccess);
         var _loc17_:IDataInput = param1.message.getRawData();
         var _loc6_:uint = _loc17_.readUnsignedInt();
         var _loc18_:Vector.<PetInfo> = Vector.<PetInfo>([]);
         var _loc4_:Vector.<PetInfo> = Vector.<PetInfo>([]);
         var _loc5_:UserInfo = new UserInfo();
         var _loc16_:UserInfo = new UserInfo();
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc20_ = _loc17_.readUnsignedInt();
            _loc9_ = _loc17_.readUnsignedInt();
            _loc25_ = _loc17_.readUnsignedInt();
            if(_loc20_ != ActorManager.actorInfo.id)
            {
               _loc15_ = _loc20_;
            }
            _loc14_ = 0;
            while(_loc14_ < _loc25_)
            {
               _loc2_ = _loc17_.readUnsignedInt();
               _loc10_ = _loc17_.readUnsignedInt();
               _loc23_ = _loc17_.readUnsignedInt();
               _loc14_++;
            }
            if(_loc20_ == ActorManager.actorInfo.id)
            {
               _loc5_.id = _loc17_.readUnsignedInt();
               _loc5_.sex = _loc17_.readUnsignedByte();
               _loc5_.nick = _loc17_.readUTFBytes(16);
               _loc5_.color = _loc17_.readUnsignedInt();
               _loc5_.trainerScore = _loc17_.readUnsignedInt();
               _loc5_.equipVec = new Vector.<EquipItem>();
               _loc8_ = _loc17_.readUnsignedInt();
               _loc21_ = 0;
               while(_loc21_ < _loc8_)
               {
                  _loc12_ = new EquipItem(_loc17_.readUnsignedInt());
                  _loc5_.equipVec.push(_loc12_);
                  _loc21_++;
               }
            }
            else
            {
               _loc16_.id = _loc17_.readUnsignedInt();
               _loc16_.sex = _loc17_.readUnsignedByte();
               _loc16_.nick = _loc17_.readUTFBytes(16);
               _loc16_.color = _loc17_.readUnsignedInt();
               _loc16_.trainerScore = _loc17_.readUnsignedInt();
               _loc16_.equipVec = new Vector.<EquipItem>();
               _loc13_ = _loc17_.readUnsignedInt();
               _loc26_ = 0;
               while(_loc26_ < _loc13_)
               {
                  _loc12_ = new EquipItem(_loc17_.readUnsignedInt());
                  _loc16_.equipVec.push(_loc12_);
                  _loc26_++;
               }
               ActorEquipAssembler.mergeDefaultEquip(_loc16_.color,_loc16_.equipVec);
            }
            _loc19_ = _loc17_.readUnsignedInt();
            _loc7_ = 0;
            while(_loc7_ < _loc19_)
            {
               _loc24_ = new PetInfo();
               _loc24_.resourceId = _loc17_.readUnsignedInt();
               if(_loc20_ == ActorManager.actorInfo.id)
               {
                  _loc18_.push(_loc24_);
               }
               else
               {
                  _loc4_.push(_loc24_);
               }
               _loc7_++;
            }
            _loc3_++;
         }
         _remoteInfo = _loc16_;
         _thisPetList = _loc18_;
         _remotePetList = _loc4_;
         FightManager.addEventListener("FIGHT_LOADING_START",onFightLoadStart);
         startFight();
         var _loc22_:Array = [19,21,20,22];
         var _loc11_:Array = ["演习阶段开发模式进入战斗","演习阶段传统模式进入战斗","宣战阶段开发模式进入战斗","宣战阶段传统模式进入战斗"];
         StatisticsManager.newSendNovice("无禽战系统","无禽战",_loc11_[_loc22_.indexOf(_pvpInfo.gate)]);
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
         _thisIconList = Vector.<IconDisplayer>([]);
         _remoteIconList = Vector.<IconDisplayer>([]);
         for each(petInfo in _thisPetList)
         {
            iconDisplayer = new IconDisplayer();
            iconDisplayer.setIconUrl(URLUtil.getPetIcon(petInfo.resourceId));
            iconDisplayer.scaleY = 1;
            iconDisplayer.scaleX = 1;
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
         _mc.addChild(_thisPreview);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            _thisIconList[_loc2_].y = 0;
            _thisIconList[_loc2_].x = 0;
            _loc1_ = _mc["myIconList" + _loc2_]["iconMc"]["icon"];
            DisplayObjectUtil.removeAllChildren(_loc1_);
            _loc1_.addChild(_thisIconList[_loc2_]);
            MovieClip(_mc["enIconList" + _loc2_]).gotoAndStop(2);
            _loc2_++;
         }
      }
      
      private static function onShowEnemyTeam() : void
      {
         var _loc1_:MovieClip = null;
         _remotePreview.x = 950;
         _remotePreview.y = 440;
         _mc.addChild(_remotePreview);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            MovieClip(_mc["enIconList" + _loc2_]).gotoAndStop(1);
            _remoteIconList[_loc2_].y = 0;
            _remoteIconList[_loc2_].x = 0;
            _loc1_ = _mc["enIconList" + _loc2_]["iconMc"]["icon"];
            DisplayObjectUtil.removeAllChildren(_loc1_);
            _loc1_.addChild(_remoteIconList[_loc2_]);
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
            ModuleManager.showAppModule("NoPoultryBattleFieldMainPanel");
         }
      }
   }
}

