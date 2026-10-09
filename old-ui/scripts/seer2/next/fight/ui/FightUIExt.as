package seer2.next.fight.ui
{
   import com.taomee.seer2.app.arena.data.ArenaDataInfo;
   import com.taomee.seer2.app.arena.data.FighterInfo;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.item.EmblemItemDefinition;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import flash.display.Sprite;
   import seer2.next.fight.auto.AutoFightPanel;
   import seer2.next.fight.ui.data.ArenaData;
   import seer2.next.fight.ui.data.PetData;
   import seer2.next.fight.ui.data.PetExtData;
   
   public class FightUIExt extends Sprite
   {
      
      public static var isDeposit:Boolean = false;
      
      public static var callbackWhenDepositBtn:Function;
      
      public function FightUIExt()
      {
         super();
      }
      
      public static function onDeposit2() : void
      {
         isDeposit = !isDeposit;
         if(isDeposit)
         {
            if(FightUIExt.callbackWhenDepositBtn)
            {
               FightUIExt.callbackWhenDepositBtn();
            }
         }
      }
      
      public static function fish(_arenaData:ArenaData) : void
      {
         var skillOp:* = function(skillIndex:int):void
         {
            var skillId:int = 0;
            var j:int = 0;
            if(_arenaData.left.master.hp > 0)
            {
               skillId = _arenaData.left.master.skills[skillIndex].id;
               Connection.send(CommandSet.FIGHT_USE_SKILL_1502,skillId);
               return;
            }
            var pid:int = 0;
            var pets:Vector.<PetData> = _arenaData.left.pets;
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
         };
         var runOp:* = function():void
         {
            Connection.send(CommandSet.FIGHT_ESCAPE_1509);
         };
         var cure:* = function():void
         {
            Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,_arenaData.left.master.pid,200019,1);
         };
         var capture:* = function():void
         {
            Connection.send(CommandSet.FIGHT_CATCH_PET_1031,200003);
         };
         var angerSupplement:* = function(param:uint):void
         {
            Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,_arenaData.left.master.pid,200000 + param,1);
         };
         var changeOp:* = function(petIndex:int):void
         {
            var o:PetData = _arenaData.left.pets[petIndex - 11];
            if(o.position != 0)
            {
               skillOp(0);
            }
            else if(o.hp > 0)
            {
               Connection.send(CommandSet.FIGHT_CHANGE_FIGHTER_1032,o.pid);
            }
            else if(o.hp == 0)
            {
               Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,o.pid,200064,1);
            }
         };
         var op:int = AutoFightPanel.instance().getOperation();
         if(op < 6)
         {
            skillOp(op);
         }
         else if(op == 6)
         {
            runOp();
         }
         else if(op == 7)
         {
            cure();
         }
         else if(op == 8)
         {
            capture();
         }
         else if(op > 20 && op < 30)
         {
            angerSupplement(op);
         }
         else if(op > 10 && op < 20)
         {
            changeOp(op);
         }
      }
      
      public static function append(arenaData:ArenaData, _rawArenaData:ArenaDataInfo) : void
      {
         var i:int = 0;
         var pet:PetData = null;
         var rawFighter:FighterInfo = null;
         var petDefinition:PetDefinition = null;
         var petDefinitionInfo:PetDictionaryInfo = null;
         var rawPet:PetInfo = null;
         var petExtData:PetExtData = null;
         var featureId:int = 0;
         var emblemId:int = 0;
         var decorationId:int = 0;
         var pets:Vector.<PetData> = arenaData.left.pets;
         var leftUid:int = _rawArenaData.leftTeam.teamInfo.leaderId;
         for(i = 0; i < pets.length; )
         {
            pet = pets[i];
            rawFighter = _rawArenaData.fighterInfo(leftUid,pet.pid);
            if(rawFighter)
            {
               petDefinition = PetConfig.getPetDefinition(rawFighter.resourceId);
               petDefinitionInfo = PetConfig.getPetDefinitionInfo(rawFighter.resourceId);
               rawPet = PetInfoManager.getPetInfoFromAllBag(pet.pid);
               petExtData = pet.ext;
               petExtData.sex = rawPet ? rawPet.sex : 0;
               featureId = int(rawPet ? rawPet.featureId : 0);
               if(featureId > 0)
               {
                  petExtData.featureTips = rawPet.featureDescription;
               }
               emblemId = int(rawPet ? rawPet.emblemId : 0);
               if(emblemId > 0)
               {
                  petExtData.emblem1 = emblemId;
                  petExtData.emblem1Tips = getEmblemDefinitionTips(emblemId);
               }
               else if(petDefinition && petDefinition.emblemId > 0)
               {
                  petExtData.emblem1Tips = getEmblemDefinitionTips(petDefinition.emblemId);
               }
               decorationId = int(rawPet ? rawPet.decorationId : 0);
               if(decorationId > 0)
               {
                  petExtData.emblem2 = decorationId;
                  petExtData.emblem2Tips = getEmblemDefinitionTips(decorationId);
               }
               else if(petDefinition && petDefinition.emblem2Id > 0)
               {
                  petExtData.emblem2Tips = getEmblemDefinitionTips(petDefinition.emblem2Id);
               }
               petExtData.fetterTips = petDefinitionInfo ? petDefinitionInfo.fetter : null;
               petExtData.morphTips = petDefinitionInfo ? petDefinitionInfo.changeTip : null;
            }
            i++;
         }
      }
      
      private static function getEmblemDefinitionTips(param1:int) : String
      {
         var emblemDefinition:EmblemItemDefinition = ItemConfig.getEmblemDefinition(param1);
         if(emblemDefinition)
         {
            return emblemDefinition.tip;
         }
         return null;
      }
   }
}

