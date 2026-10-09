package seer2.next.fight.ui
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.arena.controller.FightController;
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.data.BuffResultInfo;
   import com.taomee.seer2.app.arena.data.BuffResultInfoRoundData;
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.arena.data.FighterBuffInfo;
   import com.taomee.seer2.app.arena.data.FighterInfo;
   import com.taomee.seer2.app.arena.data.FighterTurnResultInfo;
   import com.taomee.seer2.app.arena.data.ItemUseResultInfo;
   import com.taomee.seer2.app.arena.data.RevenueInfo;
   import com.taomee.seer2.app.arena.data.TeamInfo;
   import com.taomee.seer2.app.arena.data.TurnResultInfo;
   import com.taomee.seer2.app.arena.effect.SkillSound;
   import com.taomee.seer2.app.arena.processor.ChangeFighterInfo;
   import com.taomee.seer2.app.arena.processor.Parser_8;
   import com.taomee.seer2.app.arena.processor.Processor_15;
   import com.taomee.seer2.app.arena.processor.Processor_9;
   import com.taomee.seer2.app.arena.ui.toolbar.ItemPanel;
   import com.taomee.seer2.app.arena.util.AngerCorrecter;
   import com.taomee.seer2.app.arena.util.FightWeatherNameMap;
   import com.taomee.seer2.app.config.FitConfig;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.PetPressConfig;
   import com.taomee.seer2.app.config.SkillSideEffectConfig;
   import com.taomee.seer2.app.config.item.PetItemDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.item.PetItem;
   import com.taomee.seer2.app.manager.FightResultPanelWrapper;
   import com.taomee.seer2.app.net.Command;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.ErrorMap;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.UILoader;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.ImageLevelManager;
   import com.taomee.seer2.core.scene.MapLoader;
   import com.taomee.seer2.core.sound.SoundManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.Sprite;
   import flash.utils.IDataInput;
   import seer2.next.entry.DynSwitch;
   import seer2.next.fight.auto.AutoFightPanel;
   import seer2.next.fight.ui.data.*;
   import seer2.next.utils.JsUtils;
   
   public class FightUI extends Sprite
   {
      
      public static var enable:Boolean = false;
      
      public static var disableMoveFrame:Boolean = false;
      
      public static var clazz:Class;
      
      UILoader.load(URLUtil.getUISwf("FramePlayer"),"swf",function(param1:ContentInfo):void
      {
         clazz = param1.domain.getDefinition("FramePlayer") as Class;
      });
      
      private var _arenaScene:ArenaScene;
      
      private var _rawArenaData:ArenaDataInfo;
      
      private var _player:*;
      
      private var _arenaData:ArenaData;
      
      private var _next:Vector.<Object> = new Vector.<Object>();
      
      private var _playing:Boolean = false;
      
      private var _processors:Vector.<Object> = new Vector.<Object>();
      
      private var _countDown:int;
      
      private var _operation:Array;
      
      private var _escapeUid:Array;
      
      private var _changePet:Array;
      
      private var _catchPid:uint;
      
      private var _itemId:uint;
      
      private var _fightRevenue:RevenueInfo;
      
      private var _fightResult:FightResultInfo;
      
      private var _uiStyle:int;
      
      private var _itemId4Pet:int;
      
      private var _mayFit:Function;
      
      public function FightUI()
      {
         super();
      }
      
      private static function fromArena(arenaData:ArenaDataInfo) : ArenaData
      {
         var arena:ArenaData = new ArenaData();
         arena.left = fromTeam(arenaData.leftTeam.teamInfo,1);
         arena.right = fromTeam(arenaData.rightTeam.teamInfo,2);
         arena.left.items = fromItem(2);
         arena.left.capsules = fromItem(1);
         arena.round = 0;
         arena.mapSwf = MapLoader.lastMapUrl;
         var soundSetting:Array = SoundManager.parseSoundSetting(SoundManager.getCurrentMapSoundSetting());
         if(soundSetting.length > 0)
         {
            arena.mapSound = soundSetting[0].url;
         }
         return arena;
      }
      
      private static function fromTeam(team:TeamInfo, side:int) : TeamData
      {
         var i:int = 0;
         var pets:Vector.<PetData> = new Vector.<PetData>();
         var fighters:Vector.<FighterInfo> = team.fightUserInfoVec[0].fighterInfoVec;
         for(i = 0; i < fighters.length; )
         {
            pets.push(fromPet(fighters[i],side));
            i++;
         }
         fighters = team.fightUserInfoVec[0].changeFighterInfoVec;
         for(i = 0; i < fighters.length; )
         {
            pets.push(fromPet(fighters[i],side));
            i++;
         }
         var target:TeamData = new TeamData();
         target.pets = pets;
         target.items = new Vector.<ItemData>(0);
         target.capsules = new Vector.<ItemData>(0);
         target.init();
         return target;
      }
      
      private static function fromPet(obj:FighterInfo, side:int) : PetData
      {
         var j:int = 0;
         var target:PetData = new PetData();
         target.pid = obj.catchTime;
         target.petIcon = URLUtil.getPetIcon(obj.resourceId);
         target.petSwf = URLUtil.getPetFightSwf(FightUIUtil.skinnedMonster(side,obj.resourceId));
         target.petSound = URLUtil.getPetSound(obj.resourceId);
         target.name = obj.name;
         target.level = obj.level;
         target.typeIcon = "internal://UI_PetTypeIcon_" + obj.typeId;
         target.position = obj.position;
         target.alive = 1;
         target.anger = obj.fightAnger;
         target.maxAnger = obj.maxAnger;
         target.hp = obj.hp;
         target.maxHp = obj.maxHp;
         target.rate = 100;
         target.atk = 0;
         target.def = 0;
         target.spa = 0;
         target.spd = 0;
         target.spe = 0;
         target.skills = new Vector.<SkillData>(0);
         for(j = 0; j < obj.skillInfoVec.length; )
         {
            target.skills.push(fromSkill(obj.skillInfoVec[j]));
            j++;
         }
         target.buffs = new Vector.<BuffData>(0);
         target.items = new Vector.<ItemData>(0);
         var extData:PetExtData = new PetExtData();
         extData.monster = obj.resourceId;
         extData.showIcon = 0;
         extData.typeId = obj.typeId;
         target.ext = extData;
         return target;
      }
      
      private static function fromSkill(obj:SkillInfo) : SkillData
      {
         var target:SkillData = new SkillData();
         target.id = obj.id;
         target.name = obj.name;
         target.power = obj.power;
         target.anger = obj.anger;
         target.category = obj.category;
         target.typeIcon = "internal://UI_PetTypeIcon_" + obj.typeId;
         target.tips = obj.description;
         target.enable = false;
         return target;
      }
      
      private static function fromItem(typ:int) : Vector.<ItemData>
      {
         var i:int = 0;
         var obj:PetItem = null;
         var target:ItemData = null;
         var items:Vector.<ItemData> = new Vector.<ItemData>(0);
         var petItems:Vector.<PetItem> = ItemPanel.filterItemsAllFight(typ);
         for(i = 0; i < petItems.length; )
         {
            obj = petItems[i];
            target = new ItemData();
            target.id = obj.referenceId;
            target.name = obj.name;
            target.count = obj.quantity;
            target.icon = ItemConfig.getItemIconUrl(obj.referenceId);
            target.tips = obj.tip;
            items.push(target);
            i++;
         }
         return items;
      }
      
      private static function fromBuff(buffInfoVec:Vector.<FighterBuffInfo>) : Vector.<BuffData>
      {
         var k:int = 0;
         var buff:FighterBuffInfo = null;
         var buffData:BuffData = null;
         var buffs:Vector.<BuffData> = new Vector.<BuffData>(0);
         for(k = 0; k < buffInfoVec.length; )
         {
            buff = buffInfoVec[k];
            if(buff.round > 0)
            {
               buffData = new BuffData();
               buffData.id = buff.buffId;
               buffData.name = buff.buffId + "-" + SkillSideEffectConfig.getName(buff.buffId);
               buffData.icon = URLUtil.getSkillSideEffectIcon(buff.buffId);
               buffData.tips = buff.tip;
               buffData.count = buff.dummy0 || buff.dummy1 || buff.dummy2;
               buffs.push(buffData);
            }
            k++;
         }
         return buffs;
      }
      
      public function init(param1:ArenaScene, param2:ArenaDataInfo) : void
      {
         var fightIndex:int;
         var frame:FrameData;
         var petResUrlVec:Vector.<String>;
         var i:int;
         _arenaScene = param1;
         _rawArenaData = param2;
         _arenaData = fromArena(_rawArenaData);
         FightUIExt.append(_arenaData,_rawArenaData);
         updateWeather(_rawArenaData.fightWeather);
         if(!clazz)
         {
            throw new Error("clazz is not loaded");
         }
         _player = new clazz();
         if(3 === _rawArenaData.fightMode || _arenaData.right.master.hp >= 1000)
         {
            _uiStyle = 1;
         }
         if(is2v2())
         {
            _uiStyle = 2;
         }
         _player.updateUiStyle(_uiStyle);
         _player.updateAutoFightStatus(FightUIExt.isDeposit);
         addChild(_player);
         fightIndex = int(FightManager.currentFightRecord.initData.hasOwnProperty("positionIndex") ? int(FightManager.currentFightRecord.initData.positionIndex) : 0);
         frame = new FrameData();
         frame.start = new StartData();
         petResUrlVec = new Vector.<String>();
         for(i = 0; i < _arenaData.left.pets.length; )
         {
            petResUrlVec.push(_arenaData.left.pets[i].petSwf);
            i = i + 1;
         }
         for(i = 0; i < _arenaData.right.pets.length; )
         {
            petResUrlVec.push(_arenaData.right.pets[i].petSwf);
            i = i + 1;
         }
         frame.start.urls = petResUrlVec;
         frame.logs = new Vector.<String>();
         frame.logs.push("<font color=\'#ffffff\'>index:[" + fightIndex + "] side:[" + _rawArenaData.leftTeam.teamInfo.serverSide + "]</font>");
         pushNextFrame(frame);
         pushNextFunc(function():void
         {
            Connection.send(CommandSet.FIGHT_RES_READY_1501,fightIndex);
            _player.playFightWaiting();
            addChild(new FightUIExt());
         });
         pushProcessor(CommandSet.FIGHT_TURN_START_2,processor2FirstRoundStart);
         pushProcessor(CommandSet.FIGHT_HURT_NOTIFY_3,processor3AttackMove);
         pushProcessor(CommandSet.FIGHT_GET_REVENUE_5,processor5UserRevenue);
         pushProcessor(CommandSet.FIGHT_NEXT_TURN_7,processor7NextRoundStart);
         pushProcessor(CommandSet.FIGHT_CHANGED_NOTIFY_8,processor8ChangePet);
         pushProcessor(CommandSet.FIGHT_BUFF_RESULT_NOTIFY_9,processor9BuffHp);
         pushProcessor(CommandSet.FIGHT_USE_ITEM_NOTIFY_10,processor10UseItem);
         pushProcessor(CommandSet.FIGHT_FEATRUE_RESULT_11,processor11);
         pushProcessor(CommandSet.FIGHT_ESCAPE_NOTIFY_12,processor12UserEscape);
         pushProcessor(CommandSet.FIGHT_NOTIFY_MON_POS_15,processor15PetChange);
         pushProcessor(CommandSet.FIGHT_UPDATE_ANGER_16,processor16AttackBefore);
         pushProcessor(CommandSet.PVP_FIGHT_NOTIFY_MON_POS_17,processor17);
         pushProcessor(CommandSet.FIT_CHANGE_HP_POS_18,processor18PetFit);
         pushProcessor(CommandSet.FIGHT_CHANGE_PET_19,processor19PetMorph);
         pushProcessor(CommandSet.FIGHT_CATCH_PET_1031,processor1031CmdCapsule);
         pushProcessor(CommandSet.FIGHT_CHANGE_FIGHTER_1032,processor1032CmdPet);
         pushProcessor(CommandSet.FIGHT_USE_MEDICINE_1048,processor1048CmdItem);
         pushProcessor(CommandSet.FIGHT_RES_READY_1501,processor1501ResReady);
         pushProcessor(CommandSet.FIGHT_USE_SKILL_1502,processor1502CmdSkill);
         pushProcessor(CommandSet.FIGHT_END_1507,processor1507FightEnd);
         pushProcessor(CommandSet.FIGHT_ESCAPE_1509,processor1509CmdEscape);
         Connection.addErrorHandler(CommandSet.FIGHT_CATCH_PET_1031,processorCmdError);
         Connection.addErrorHandler(CommandSet.FIGHT_CHANGE_FIGHTER_1032,processorCmdError);
         Connection.addErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,processorCmdError);
         Connection.addErrorHandler(CommandSet.FIGHT_USE_SKILL_1502,processorCmdError);
         Connection.addErrorHandler(CommandSet.FIGHT_ESCAPE_1509,processorCmdError);
         _player.addEventListener("operateEnd",onOperate);
         _player.addEventListener("sundries",onSundries);
      }
      
      private function onFightEnd() : void
      {
         var object:Object = null;
         if(FightManager.currentFightRecord != null)
         {
            FightManager.currentFightRecord.endReason = _fightResult.endReason;
            FightManager.currentFightRecord.fightResult = _fightResult.showWinnerSider;
         }
         _player.removeEventListener("operateEnd",onOperate);
         _player.removeEventListener("sundries",onSundries);
         while(_processors.length)
         {
            object = _processors.shift();
            Connection.removeCommandListener(object[0],object[1]);
         }
         Connection.removeErrorHandler(CommandSet.FIGHT_CATCH_PET_1031,processorCmdError);
         Connection.removeErrorHandler(CommandSet.FIGHT_CHANGE_FIGHTER_1032,processorCmdError);
         Connection.removeErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,processorCmdError);
         Connection.removeErrorHandler(CommandSet.FIGHT_USE_SKILL_1502,processorCmdError);
         Connection.removeErrorHandler(CommandSet.FIGHT_ESCAPE_1509,processorCmdError);
         DisplayObjectUtil.removeFromParent(this);
         FightController.exitFight0(_fightResult,_arenaScene);
      }
      
      internal function onSundries(event:Object) : void
      {
         var data:Object = event.data;
         loop0:
         switch(int(data.functional))
         {
            case 1:
               _uiStyle = (_uiStyle + 1) % 5;
               _player.updateUiStyle(_uiStyle);
               switch(functional)
               {
                  case 2:
                  case 3:
                     break;
                  default:
                     break loop0;
               }
            case 2:
               FightUIExt.onDeposit2();
               _player.updateAutoFightStatus(FightUIExt.isDeposit);
               if(functional !== 3)
               {
                  break;
               }
            case 3:
               ImageLevelManager.showImagePanel();
         }
      }
      
      internal function onOperate(event:Object) : void
      {
         var skill:int;
         var master:PetData;
         var skills:Vector.<SkillData>;
         var i:int;
         var item:int;
         var petItemDefinition:PetItemDefinition;
         var pet:int;
         var pet0:PetData;
         var capsule:int;
         var snapshot:int;
         var escape:int;
         var data:Object = event.data;
         if(AutoFightPanel.isRunning)
         {
            AlertManager.showConfirm("【鱼但】帮你战斗中，你要取消吗",function():void
            {
               AutoFightPanel.isRunning = false;
            });
            return;
         }
         if(FightUIExt.isDeposit)
         {
            AlertManager.showAutoCloseAlert("自动战斗中，无法操作",1);
            return;
         }
         skill = int(data.skill);
         if(skill > 0)
         {
            master = _arenaData.left.master;
            if(!is2v2() && master.hp <= 0)
            {
               return;
            }
            skills = _arenaData.left.master.skills;
            for(i = 0; i < skills.length; )
            {
               if(skills[i].id === skill)
               {
                  Connection.send(CommandSet.FIGHT_USE_SKILL_1502,skill);
               }
               i = i + 1;
            }
         }
         item = int(data.item);
         if(item > 0)
         {
            petItemDefinition = ItemConfig.getPetDefinition(item);
            if(petItemDefinition && petItemDefinition.type === 17)
            {
               _itemId4Pet = item;
               _player.showPetPanel();
               return;
            }
            _itemId = item;
            Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,_arenaData.left.master.pid,item,1);
         }
         pet = int(data.pet);
         if(pet != 0)
         {
            if(_itemId4Pet > 0)
            {
               _itemId = _itemId4Pet;
               Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,pet,_itemId,1);
               _itemId4Pet = 0;
               return;
            }
            pet0 = petData(thisUid(),pet);
            if(pet0.hp <= 0 || pet0.position > 0)
            {
               return;
            }
            Connection.send(CommandSet.FIGHT_CHANGE_FIGHTER_1032,pet);
         }
         capsule = int(data.capsule);
         if(capsule > 0)
         {
            if(capsule > 200003)
            {
               snapshot = _countDown;
               AlertManager.showConfirm("FightUI解除了部分限制，无敌不一定能捕获",function():void
               {
                  if(snapshot === _countDown)
                  {
                     _itemId = capsule;
                     Connection.send(CommandSet.FIGHT_CATCH_PET_1031,capsule);
                  }
               });
               return;
            }
            _itemId = capsule;
            Connection.send(CommandSet.FIGHT_CATCH_PET_1031,capsule);
         }
         escape = int(data.escape);
         if(escape > 0)
         {
            Connection.send(CommandSet.FIGHT_ESCAPE_1509);
         }
      }
      
      internal function processor2FirstRoundStart(param1:MessageEvent) : void
      {
         _operation = [];
         _arenaData.round = 1;
         pushNextFrame();
         pushNextFunc(playCountDown);
      }
      
      internal function processor3AttackMove(param1:MessageEvent) : void
      {
         var monster:int = 0;
         var skillId:int = 0;
         var movePet:PetData = null;
         var i:int = 0;
         var turnResult:FighterTurnResultInfo = null;
         var pet:PetData = null;
         var _mayFitTmp:Function = null;
         var obj:TurnResultInfo = new TurnResultInfo(param1.message.getRawData());
         var side:int = 1;
         for(i = 0; i < obj.fighterTurnResultInfoVec.length; )
         {
            turnResult = obj.fighterTurnResultInfoVec[i];
            pet = updatePosition(turnResult.userId,turnResult.catchTime,turnResult.position);
            if(turnResult.isAtker)
            {
               side = teamSide(turnResult.userId);
               monster = int(rawFighterInfo(turnResult.userId,turnResult.catchTime).resourceId);
               skillId = int(turnResult.skillId);
               movePet = pet;
            }
            pet.hp = turnResult.hp;
            pet.maxHp = turnResult.maxHp;
            pet.anger = turnResult.anger;
            pet.atk = turnResult.changedAtk;
            pet.def = turnResult.changedDefence;
            pet.spa = turnResult.changedSpecialAtk;
            pet.spd = turnResult.changedSpecialDefence;
            pet.spe = turnResult.changedSpeed;
            pet.buffs = fromBuff(turnResult.buffInfoVec);
            i++;
         }
         if(skillId <= 0)
         {
            pushNextFrame();
            return;
         }
         var bunchId:uint = PetConfig.getPetDefinition(monster).bunchId;
         var skillInfo:SkillInfo = new SkillInfo(skillId);
         var target:MoveData = new MoveData();
         target.side = side;
         target.skill = skillInfo.name;
         target.category = skillInfo.isIntercourse ? "合体" : skillInfo.category;
         target.damage = obj.changedHp;
         target.critical = obj.isCritical ? 1 : 0;
         target.miss = obj.atkTimes === 0 ? 1 : 0;
         target.rate = obj.skillTypeDelationRate;
         target.soundUrl = new SkillSound(bunchId,skillInfo).getSoundUrl();
         target.effectUrl = URLUtil.getSkillEffectSwf(PetConfig.getPetSkillSettingDefinition(skillId).effectId);
         target.hits = FightUIUtil.hitArray(side,monster,target.category);
         var frame:FrameData = new FrameData();
         if(disableMoveFrame)
         {
            frame.event = new EventData();
            frame.event.type = 2;
            frame.event.side = 3 - target.side;
            frame.event.change = target.damage;
            frame.event.delay = 1000;
         }
         else
         {
            frame.move = target;
            frame.smooth = 1;
         }
         frame.logs = new Vector.<String>();
         frame.logs.push("<font color=\'#ffffff\'>[" + _arenaData.round + "]</font><font color=\'#00ffff\'>" + movePet.name + "</font><font color=\'#ffffff\'>使用</font><font color=\'#ffff00\'>" + target.skill + "</font>");
         pushNextFrame(frame);
         if(Boolean(_mayFit))
         {
            _mayFitTmp = _mayFit;
            _mayFit = null;
            _mayFitTmp(skillId);
         }
      }
      
      internal function processor5UserRevenue(param1:MessageEvent) : void
      {
         _fightRevenue = new RevenueInfo(param1.message.getRawData());
      }
      
      internal function processor7NextRoundStart(param1:MessageEvent) : void
      {
         var frame:FrameData;
         var buffer:IDataInput = param1.message.getRawData();
         var round:uint = buffer.readUnsignedByte();
         var weather:uint = buffer.readUnsignedByte();
         addPetAnger(_arenaData.left.slave,15);
         addPetAnger(_arenaData.right.slave,15);
         AngerCorrecter.angerFix(_arenaData.left.master,_arenaData.right.master,rawFighterInfo(_rawArenaData.leftTeam.teamInfo.leaderId,_arenaData.left.master.pid).resourceId,rawFighterInfo(_rawArenaData.rightTeam.teamInfo.leaderId,_arenaData.right.master.pid).resourceId);
         addPetAnger(_arenaData.left.master,0);
         addPetAnger(_arenaData.right.master,0);
         _operation = [];
         _arenaData.round = round;
         updateWeather(weather);
         frame = new FrameData();
         frame.smooth = 1;
         pushNextFrame(frame);
         pushNextFunc(function():void
         {
            if(!is2v2() && _arenaData.left.master.hp <= 0)
            {
               _player.showPetPanel();
            }
            playCountDown();
         });
      }
      
      internal function processor8ChangePet(param1:MessageEvent) : void
      {
         var buffer:IDataInput = param1.message.getRawData();
         var result:Parser_8 = new Parser_8(buffer);
         var buffInfos:Vector.<FighterBuffInfo> = result.parserFighterBuffInfo(buffer);
         var pet:PetData = updatePosition(result.userId,result.fighterId,1);
         pet.anger = result.angerValue;
         pet.buffs = fromBuff(buffInfos);
         var frame:FrameData = new FrameData();
         frame.change = new ChangeData();
         if(thisTeam(result.userId))
         {
            frame.change.left = 1;
         }
         else
         {
            frame.change.right = 1;
         }
         pushNextFrame(frame);
         if(_changePet && _changePet.length)
         {
            _changePet = null;
            pushNextFunc(playCountDown);
         }
      }
      
      internal function processor9BuffHp(param1:MessageEvent) : void
      {
         var i:int = 0;
         var buffResult:BuffResultInfoRoundData = null;
         var changeHp:int = 0;
         var frame:FrameData = null;
         var resultInfo:BuffResultInfo = Processor_9.parse(param1);
         var side:int = teamSide(resultInfo.userId);
         var pet:PetData = petData(resultInfo.userId,resultInfo.fighterId);
         var buffResults:Vector.<BuffResultInfoRoundData> = resultInfo.buffResultInfoRoundDatas;
         for(i = 0; i < buffResults.length; )
         {
            buffResult = buffResults[i];
            changeHp = buffResult.changeHp;
            frame = new FrameData();
            frame.event = new EventData();
            frame.event.side = side;
            frame.event.delay = 30;
            if(changeHp < 0)
            {
               frame.event.type = 2;
               frame.event.change = -changeHp;
            }
            else
            {
               frame.event.type = 1;
               frame.event.change = changeHp;
            }
            pet.hp += changeHp;
            if(pet.hp < 0)
            {
               pet.hp = 0;
            }
            else if(pet.hp > pet.maxHp)
            {
               pet.hp = pet.maxHp;
            }
            frame.smooth = 1;
            pushNextFrame(frame);
            i++;
         }
      }
      
      internal function processor10UseItem(param1:MessageEvent) : void
      {
         var obj:ItemUseResultInfo = new ItemUseResultInfo(param1.message.getRawData());
         var pet:PetData = petData(obj.userId,obj.fighterId);
         var hpChange:int = obj.hp - pet.hp;
         var angerChange:int = obj.anger - pet.anger;
         pet.hp = obj.hp;
         pet.maxHp = obj._maxHp;
         pet.anger = obj.anger;
         pet.atk = obj._atkLevel - 6;
         pet.def = obj._defenceLevel - 6;
         pet.spa = obj._specialAtkLevel - 6;
         pet.spd = obj._specialDefenceLevel - 6;
         pet.spe = obj._speedLevel - 6;
         pet.buffs = fromBuff(obj._buffInfoVec);
         var frame:FrameData = new FrameData();
         if(pet.position > 0)
         {
            frame.event = new EventData();
            frame.event.type = hpChange > 0 ? 3 : 4;
            frame.event.side = teamSide(obj.userId);
            frame.event.change = hpChange > 0 ? hpChange : angerChange;
            frame.event.delay = 0;
         }
         pushNextFrame(frame);
      }
      
      internal function processor11(param1:MessageEvent) : void
      {
      }
      
      internal function processor12UserEscape(param1:MessageEvent) : void
      {
         _escapeUid = [param1.message.getRawData().readUnsignedInt()];
      }
      
      internal function processor15PetChange(param1:MessageEvent) : void
      {
         var parse:* = function():void
         {
            var i:int = 0;
            var changeFighter:ChangeFighterInfo = null;
            var uid:* = 0;
            var pid:Number = NaN;
            var anger:* = 0;
            var position:* = 0;
            var master:PetData = null;
            var slave:PetData = null;
            var frame:FrameData = null;
            var changeInfos:Vector.<ChangeFighterInfo> = Processor_15.parserTeamData(buffer);
            for(i = 0; i < changeInfos.length; )
            {
               changeFighter = changeInfos[i];
               uid = changeFighter.userId;
               pid = changeFighter.petCatchTime;
               anger = changeFighter.angerValue;
               position = changeFighter.position;
               master = teamData(uid).master;
               slave = teamData(uid).slave;
               updatePosition(uid,pid,position).anger = anger;
               if(slave && slave.position === 1)
               {
                  pushNextFrame();
               }
               else if(!thisTeam(uid) && master !== teamData(uid).master)
               {
                  frame = new FrameData();
                  frame.change = new ChangeData();
                  frame.change.right = 1;
                  pushNextFrame(frame);
               }
               i++;
            }
         };
         var buffer:IDataInput = param1.message.getRawDataCopy();
         parse();
         parse();
         pushNextFrame();
      }
      
      internal function processor16AttackBefore(param1:MessageEvent) : void
      {
         var parse:* = function():void
         {
            var frame:FrameData = null;
            var uid:uint = buffer.readUnsignedInt();
            var pid:uint = buffer.readUnsignedInt();
            var anger:uint = buffer.readUnsignedInt();
            var slave:PetData = teamData(uid).slave;
            updatePosition(uid,pid,1).anger = anger;
            if(slave && slave.position === 1)
            {
               frame = new FrameData();
               frame.event = new EventData();
               frame.event.type = 7;
               frame.event.side = teamSide(uid);
               pushNextFrame(frame);
            }
         };
         var buffer:IDataInput = param1.message.getRawDataCopy();
         parse();
         parse();
         pushNextFrame();
      }
      
      internal function processor17(param1:MessageEvent) : void
      {
      }
      
      internal function processor18PetFit(param1:MessageEvent) : void
      {
         var i:int;
         var uid:int;
         var pid:int;
         var hp:int;
         var fitSkills:Vector.<SkillInfo>;
         var buffer:IDataInput = param1.message.getRawDataCopy();
         var fitPets:Array = [];
         var len:int = int(buffer.readUnsignedInt());
         for(i = 0; i < len; )
         {
            uid = int(buffer.readUnsignedInt());
            pid = int(buffer.readUnsignedInt());
            hp = int(buffer.readUnsignedInt());
            fitPets.push([uid,pid,hp]);
            i = i + 1;
         }
         fitSkills = Vector.<SkillInfo>([]);
         len = int(buffer.readUnsignedInt());
         for(i = 0; i < len; )
         {
            fitSkills.push(new SkillInfo(buffer.readUnsignedInt()));
            i = i + 1;
         }
         _mayFit = function(fitSkill:int):void
         {
            var j:int = 0;
            var data:Object = null;
            var uid:int = 0;
            var pid:int = 0;
            var hp:int = 0;
            var pet:PetData = null;
            var k:int = 0;
            for(j = 0; j < fitPets.length; )
            {
               data = fitPets[j];
               uid = int(data[0]);
               pid = int(data[1]);
               hp = int(data[2]);
               pet = petData(uid,pid);
               pet.hp = hp;
               if(FitConfig.isPetFit(rawFighterInfo(uid,pid).bunchId))
               {
                  pet.anger += FitConfig.formSkillIdGetPetFitDefinition(fitSkill).anger;
                  if(fitSkills.length > 0)
                  {
                     pet.skills = new Vector.<SkillData>(0);
                     for(k = 0; k < fitSkills.length; )
                     {
                        pet.skills.push(fromSkill(fitSkills[k]));
                        k++;
                     }
                  }
               }
               j++;
            }
            pushNextFrame();
         };
      }
      
      internal function processor19PetMorph(param1:MessageEvent) : void
      {
         var idx:int = 0;
         var uid:* = 0;
         var typ:int = 0;
         var pid:int = 0;
         var morphPid:int = 0;
         var pet:PetData = null;
         var morphPet:PetData = null;
         var team:TeamData = null;
         var pos1:int = 0;
         var pos2:int = 0;
         var i:int = 0;
         var frame:FrameData = null;
         var buffer:IDataInput = param1.message.getRawData();
         var len:int = int(buffer.readUnsignedInt());
         for(idx = 0; idx < len; )
         {
            uid = buffer.readUnsignedInt();
            typ = int(buffer.readUnsignedByte());
            pid = int(buffer.readUnsignedInt());
            morphPid = int(buffer.readUnsignedInt());
            pet = petData(uid,pid);
            morphPet = petData(uid,morphPid);
            morphPet.anger = 20;
            if(typ === 0)
            {
               morphPet.hp = morphPet.maxHp;
            }
            else
            {
               morphPet.hp = 0;
            }
            morphPet.position = pet.position;
            pet.hp = 0;
            pet.position = 0;
            team = teamData(uid);
            pos1 = 0;
            pos2 = 0;
            for(i = 0; i < team.pets.length; )
            {
               if(team.pets[i].pid === pid)
               {
                  pos1 = i;
               }
               if(team.pets[i].pid === morphPid)
               {
                  pos2 = i;
               }
               i++;
            }
            team.pets[pos1] = morphPet;
            team.pets[pos2] = pet;
            team.init();
            frame = new FrameData();
            frame.change = new ChangeData();
            if(thisTeam(uid))
            {
               frame.change.left = 2;
            }
            else
            {
               frame.change.right = 2;
            }
            pushNextFrame(frame);
            idx++;
         }
      }
      
      internal function processor1031CmdCapsule(param1:MessageEvent) : void
      {
         if(_itemId > 0)
         {
            ItemManager.reduceItemQuantity(_itemId,1);
            _itemId = 0;
            _arenaData.left.capsules = fromItem(1);
         }
         clearCountDown();
         var _loc3_:IDataInput = param1.message.getRawData();
         var success:uint = _loc3_.readUnsignedInt();
         _catchPid = _loc3_.readUnsignedInt();
         var frame:FrameData = new FrameData();
         frame.event = new EventData();
         frame.event.type = success ? 6 : 5;
         pushNextFrame(frame);
         nextPetOperate();
      }
      
      internal function processor1032CmdPet(param1:MessageEvent) : void
      {
         var buffer:IDataInput = param1.message.getRawData();
         var normal:uint = buffer.readUnsignedByte();
         clearCountDown();
         nextPetOperate();
         if(!normal)
         {
            _changePet = [normal];
         }
      }
      
      internal function processor1048CmdItem(param1:MessageEvent) : void
      {
         if(_itemId > 0)
         {
            ItemManager.reduceItemQuantity(_itemId,1);
            _itemId = 0;
            _arenaData.left.items = fromItem(2);
         }
         clearCountDown();
         nextPetOperate();
      }
      
      internal function processor1501ResReady(param1:MessageEvent) : void
      {
         _player.clearFgLayer();
      }
      
      internal function processor1502CmdSkill(param1:MessageEvent) : void
      {
         clearCountDown();
         var buffer:IDataInput = param1.message.getRawData();
         var uid:int = thisUid();
         var pid:int = int(buffer.readUnsignedInt());
         var skill:int = int(buffer.readUnsignedInt());
         var pet:PetData = petData(uid,pid);
         if(skill !== 0)
         {
            pet.anger = Math.max(pet.anger - new SkillInfo(skill).anger,0);
         }
         pushNextFrame();
         nextPetOperate();
      }
      
      internal function processor1507FightEnd(param1:MessageEvent) : void
      {
         var frame:FrameData;
         _fightResult = new FightResultInfo(param1.message.getRawDataCopy());
         if(_escapeUid && _escapeUid.length)
         {
            pushNextFunc(function():void
            {
               if(thisTeam(_escapeUid[0]))
               {
                  AlertManager.showAutoCloseAlert("逃跑成功",1,onFightEnd);
               }
               else
               {
                  AlertManager.showAutoCloseAlert("对手已逃跑",3,onFightEnd);
               }
            });
         }
         else if(_fightResult.endReason === 5)
         {
            pushNextFunc(function():void
            {
               AlertManager.showAutoCloseAlert("战斗超时结束",3,onFightEnd);
            });
         }
         else if(_fightResult.endReason === 7 && _catchPid > 1)
         {
            pushNextFunc(function():void
            {
               ModuleManager.toggleModule(URLUtil.getAppModule("PetCatchPanel"),"正在打开捕捉成功面板...",{
                  "petId":_catchPid,
                  "closeCallback":onFightEnd
               });
            });
         }
         else if(AutoFightPanel.isRunning)
         {
            pushNextFunc(onFightEnd);
         }
         else
         {
            frame = new FrameData();
            frame.end = new EndData();
            frame.end.winner = _fightResult.showWinnerSider;
            frame.end.alert = _fightRevenue.fighterRevenueInfoVec.length > 0 ? 2 : 0;
            pushNextFrame(frame);
            pushNextFunc(function():void
            {
               if(_fightRevenue.fighterRevenueInfoVec.length > 0)
               {
                  pushNextFunc(function():void
                  {
                     new FightResultPanelWrapper(onFightEnd).show(PetInfoManager.getAllBagPetInfo(),_fightRevenue,_fightResult);
                  });
               }
               else
               {
                  onFightEnd();
               }
            });
         }
      }
      
      internal function processor1509CmdEscape(param1:MessageEvent) : void
      {
         clearCountDown();
      }
      
      internal function processorCmdError(param1:MessageEvent) : void
      {
         ServerMessager.addMessage(ErrorMap.findErrorMessage(param1.message.statusCode));
      }
      
      private function pushNextFrame(frame:FrameData = null) : void
      {
         if(!frame)
         {
            frame = new FrameData();
         }
         updateSkillEnable();
         updatePetAlive();
         frame.data = ArenaData.clone(_arenaData);
         _next.push({"frame":frame});
         playNext();
      }
      
      private function pushNextFunc(func:Function) : void
      {
         _next.push({"func":func});
         playNext();
      }
      
      private function playNext() : void
      {
         var next0:Object;
         if(_playing)
         {
            return;
         }
         if(!_next.length)
         {
            return;
         }
         next0 = _next.shift();
         if(next0.func)
         {
            next0.func();
            return;
         }
         _playing = true;
         playFrame(next0.frame,function():void
         {
            _playing = false;
            playNext();
         });
      }
      
      private function playFrame(frame:FrameData, cb:Function) : void
      {
         var _frame:Object = JSON.parse(JSON.stringify(frame));
         JsUtils.call("FightUI_playFrameJson",_frame);
         _player.playFrameJson(_frame,cb);
      }
      
      private function autoOperateFish() : void
      {
         FightUIExt.fish(_arenaData);
      }
      
      private function autoOperate() : void
      {
         var skill:int = 0;
         var skills:* = undefined;
         var i:int = 0;
         var pid:int = 0;
         var pets:* = undefined;
         var j:int = 0;
         var pet:PetData = _arenaData.left.master;
         if(pet.hp > 0)
         {
            skill = 0;
            skills = pet.skills;
            for(i = 0; i < skills.length; )
            {
               if(skills[i].enable)
               {
                  skill = skills[i].id;
                  break;
               }
               i++;
            }
            if(DynSwitch.autobsMode)
            {
               for(i = 0; i < skills.length; )
               {
                  if(skills[i].enable && skills[i].category === "必杀")
                  {
                     skill = skills[i].id;
                     break;
                  }
                  i++;
               }
            }
            Connection.send(CommandSet.FIGHT_USE_SKILL_1502,skill);
         }
         else
         {
            pid = 0;
            pets = _arenaData.left.pets;
            for(j = 0; j < pets.length; )
            {
               if(pets[j].hp > 0)
               {
                  pid = pets[j].pid;
                  break;
               }
               j++;
            }
            if(pid != 0)
            {
               Connection.send(CommandSet.FIGHT_CHANGE_FIGHTER_1032,pid);
            }
            else
            {
               Connection.send(CommandSet.FIGHT_USE_SKILL_1502,0);
            }
         }
      }
      
      private function playCountDown() : void
      {
         var snapshot:int;
         _countDown++;
         if(AutoFightPanel.isRunning)
         {
            autoOperateFish();
            return;
         }
         if(FightUIExt.isDeposit)
         {
            autoOperate();
            return;
         }
         snapshot = _countDown;
         FightUIExt.callbackWhenDepositBtn = function():void
         {
            FightUIExt.callbackWhenDepositBtn = null;
            if(snapshot === _countDown)
            {
               autoOperate();
            }
         };
         _player.playCountDown(function():void
         {
            if(snapshot === _countDown)
            {
               autoOperate();
            }
         });
      }
      
      private function clearCountDown() : void
      {
         _countDown++;
         _player.clearFgLayer();
         _itemId4Pet = 0;
      }
      
      private function nextPetOperate() : void
      {
         var uid:int = 0;
         _operation.push(1);
         var slave:PetData = _arenaData.left.slave;
         if(_operation.length === 1 && slave)
         {
            uid = thisUid();
            updatePosition(uid,slave.pid,1);
            pushNextFrame();
            playCountDown();
         }
      }
      
      private function updateSkillEnable() : void
      {
         var i:int = 0;
         var pet:PetData = null;
         var j:int = 0;
         var pets:Vector.<PetData> = _arenaData.left.pets;
         for(i = 0; i < pets.length; )
         {
            pet = pets[i];
            for(j = 0; j < pet.skills.length; )
            {
               pet.skills[j].enable = pet.hp > 0 ? pet.anger >= pet.skills[j].anger : false;
               j++;
            }
            i++;
         }
      }
      
      private function updatePetAlive() : void
      {
         var update:* = function(thisTeam:TeamData, oppoTeam:TeamData):void
         {
            var pets:* = undefined;
            var pet:PetData = null;
            var otherMaster:PetData = null;
            var i:int = 0;
            pets = thisTeam.pets;
            otherMaster = oppoTeam.master;
            for(i = 0; i < pets.length; )
            {
               pet = pets[i];
               pet.alive = pet.hp > 0 ? 1 : 0;
               pet.rate = 100 * PetPressConfig.getPressNumber(pet.ext.typeId,otherMaster.ext.typeId);
               if(pet.position > 0 && pet.ext)
               {
                  pet.ext.showIcon = 1;
               }
               i++;
            }
         };
         update(_arenaData.left,_arenaData.right);
         update(_arenaData.right,_arenaData.left);
      }
      
      private function addPetAnger(pet:PetData, anger:int) : void
      {
         if(pet)
         {
            pet.anger += anger;
            if(pet.anger < 0)
            {
               pet.anger = 0;
            }
            if(pet.anger > 100)
            {
               pet.anger = 100;
            }
         }
      }
      
      private function updateWeather(weather:int) : void
      {
         if(weather > 0)
         {
            _arenaData.weatherIcon = "internal://UI_WeatherIcon" + weather;
            _arenaData.weatherTips = FightWeatherNameMap.getWeatherNameByCode(weather);
         }
         else
         {
            _arenaData.weatherIcon = "";
            _arenaData.weatherTips = "";
         }
      }
      
      private function updatePosition(uid:int, pid:int, position:int) : PetData
      {
         var team:TeamData = teamData(uid);
         var pet:PetData = petData(uid,pid);
         if(position === 1)
         {
            team.master.position = pet.position;
         }
         else if(position === 2)
         {
            team.slave.position = pet.position;
         }
         pet.position = position;
         team.init();
         return pet;
      }
      
      private function pushProcessor(command:Command, processor:Function) : void
      {
         Connection.addCommandListener(command,processor);
         Connection.releaseCommand(command);
         _processors.push([command,processor]);
      }
      
      private function is2v2() : Boolean
      {
         return _arenaData.left.slave;
      }
      
      private function thisUid() : int
      {
         return _rawArenaData.leftTeam.teamInfo.leaderId;
      }
      
      private function thisTeam(uid:int) : Boolean
      {
         return thisUid() === uid;
      }
      
      private function teamSide(uid:int) : int
      {
         if(thisTeam(uid))
         {
            return 1;
         }
         return 2;
      }
      
      private function teamData(uid:int) : TeamData
      {
         var team:TeamData = null;
         if(thisTeam(uid))
         {
            team = _arenaData.left;
         }
         else
         {
            team = _arenaData.right;
         }
         return team;
      }
      
      private function petData(uid:int, pid:int) : PetData
      {
         var i:int = 0;
         var team:TeamData = teamData(uid);
         for(i = 0; i < team.pets.length; )
         {
            if(team.pets[i].pid === pid)
            {
               return team.pets[i];
            }
            i++;
         }
         throw new Error("invalid");
      }
      
      private function rawFighterInfo(userId:uint, catchTime:uint) : FighterInfo
      {
         return _rawArenaData.fighterInfo(userId,catchTime);
      }
   }
}

