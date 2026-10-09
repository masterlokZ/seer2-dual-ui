package com.taomee.seer2.app.arena.parser
{
   import com.taomee.seer2.app.arena.ArenaScene;
   import com.taomee.seer2.app.arena.Fighter;
   import com.taomee.seer2.app.arena.animation.ArenaAnimationManager;
   import com.taomee.seer2.app.arena.controller.IArenaUIController;
   import com.taomee.seer2.app.arena.controller.IFightController;
   import com.taomee.seer2.app.arena.data.BuffResultInfo;
   import com.taomee.seer2.app.arena.data.FighterTeam;
   import com.taomee.seer2.app.arena.data.FighterTurnResultInfo;
   import com.taomee.seer2.app.arena.data.TurnResultInfo;
   import com.taomee.seer2.app.arena.events.FighterEvent;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.app.popup.ServerMessager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   
   public class FightTurnResultParser extends EventDispatcher
   {
      
      public static const PARSE_END:String = "parseEnd";
      
      private var _scene:ArenaScene;
      
      private var _turnResultInfoVec:Vector.<TurnResultInfo>;
      
      private var _buffResultInfoVec:Vector.<BuffResultInfo>;
      
      private var atker:Fighter;
      
      private var atkee:Fighter;
      
      public var parsingTurnResultInfo:TurnResultInfo;
      
      public function FightTurnResultParser(param1:ArenaScene)
      {
         super(this);
         this._scene = param1;
      }
      
      public function dispose() : void
      {
         this._scene = null;
         this._turnResultInfoVec = null;
         this._buffResultInfoVec = null;
      }
      
      public function parseTurnResult(param1:Vector.<TurnResultInfo>, param2:Vector.<BuffResultInfo>) : void
      {
         this._turnResultInfoVec = param1;
         this._buffResultInfoVec = param2;
         if(this._turnResultInfoVec.length > 0)
         {
            this.parseTurnResultInfo(this._turnResultInfoVec.pop());
         }
         else
         {
            this.parseBuffResult(false,0);
            this._scene.arenaData.effectHpPackage11();
            this.dispatchParseEvent("parseEnd");
         }
      }
      
      private function parseTurnResultInfo(param1:TurnResultInfo) : void
      {
         var turnResultVec:Vector.<FighterTurnResultInfo>;
         var arenaUIController:IArenaUIController = null;
         var _turnActionCount:int = 0;
         var recordCount:uint = 0;
         var fighterTurnInfo:FighterTurnResultInfo = null;
         var adjustPositionComplete:Function = null;
         var onAtkerHit:Function = null;
         var onFighterActionEnd:Function = null;
         var fighter:Fighter = null;
         var resultInfo:TurnResultInfo = param1;
         adjustPositionComplete = function():void
         {
            _scene.sortAllFighters();
            _scene.mapModel.content.addChild(atker);
            atker.takeAction();
            var _loc1_:FighterTurnResultInfo = atker.fighterTurnResultInfo;
            showAtkerSkillInfo(_loc1_.skillId);
         };
         var showAtkerSkillInfo:Function = function(param1:uint):void
         {
            var _loc2_:SkillInfo = atker.fighterInfo.getSkillInfo(param1);
            if(_loc2_ != null)
            {
               arenaUIController.showSkillBubble(atker,_loc2_.name);
               arenaUIController.entryValue("<font color=\'#00ffff\'>" + atker.fighterInfo.name + ":" + "</font>" + "<font color=\'#ffffff\'>" + "使用技能" + "</font>" + "<font color=\'#ffff00\'>" + _loc2_.name + "</font>");
            }
            else
            {
               arenaUIController.showSkillBubble(atker,"技能不详");
            }
         };
         onAtkerHit = function(param1:FighterEvent):void
         {
            var atkerTurnResultInfo:FighterTurnResultInfo = null;
            var skillInfo:SkillInfo = null;
            var skillHitCount:int = 0;
            var timeout:uint = 0;
            var burstArr:Array = null;
            var skillHitTimeOut:Function = null;
            var evt:FighterEvent = param1;
            atker.removeEventListener("sexHit",onAtkerHit);
            atkerTurnResultInfo = atker.fighterTurnResultInfo;
            skillInfo = atker.fighterInfo.getSkillInfo(atkerTurnResultInfo.skillId);
            if(skillInfo != null && skillInfo.categoryId != 4)
            {
               if(parsingTurnResultInfo.atkTimes > 1)
               {
                  ServerMessager.addMessage("连击次数为: " + parsingTurnResultInfo.atkTimes + "次");
               }
               atkee.takeAction();
               ArenaAnimationManager.showAtkeeHpReduceSplash(atkee,parsingTurnResultInfo);
               if(skillInfo.category == "必杀")
               {
                  ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.PowSkillHitAnimation");
               }
            }
            if(parsingTurnResultInfo.isCritical)
            {
               ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.BaoJiHitAnimation");
            }
            ArenaAnimationManager.environmentFeedback(atker,_scene.mapModel,_scene.arenaData.isDoubleMode);
            atkee.updateInfo();
            atker.updateInfo();
            arenaUIController.updateStatusPanel();
            ArenaAnimationManager.showBuffDisabledAnimation(atkee.fighterInfo.fightBuffInfoVec,atkee.fighterSide);
         };
         var getBurstList:Function = function(param1:uint):Array
         {
            var _loc2_:Array = [];
            ServerMessager.addMessage("连击次数为: " + param1 + "次");
            switch(param1)
            {
               case 2:
                  _loc2_ = [1];
                  break;
               case 3:
                  _loc2_ = [1];
                  break;
               case 4:
                  _loc2_ = [1];
                  break;
               case 5:
                  _loc2_ = [1];
                  break;
               case 6:
                  _loc2_ = [0,0,0,0,0,1];
                  break;
               case 7:
                  _loc2_ = [0,0,0,0,0,0,1];
                  break;
               case 8:
                  _loc2_ = [0,0,0,0,0,0,0,1];
                  break;
               case 9:
                  _loc2_ = [0,0,0,0,0,0,0,0,1];
                  break;
               case 10:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,1];
                  break;
               case 11:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 12:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 13:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 14:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 15:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 16:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 17:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 18:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 19:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 20:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 21:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 22:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 23:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 24:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 25:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 26:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 27:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 28:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 29:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               case 30:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
                  break;
               default:
                  _loc2_ = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
            }
            return _loc2_;
         };
         onFighterActionEnd = function(param1:FighterEvent):void
         {
            var _loc3_:SkillInfo = null;
            var _loc2_:Fighter = param1.target as Fighter;
            _loc2_.removeEventListener("actionEnd",onFighterActionEnd);
            var _loc4_:FighterTurnResultInfo = atker.fighterTurnResultInfo;
            _loc3_ = atker.fighterInfo.getSkillInfo(_loc4_.skillId);
            if(Boolean(_loc3_) && _loc3_.categoryId == 4)
            {
               atkee.fakeAct();
            }
            recordPlayedAction();
         };
         var recordPlayedAction:Function = function():void
         {
            ++_turnActionCount;
            if(atkee == atker || _turnActionCount == recordCount)
            {
               _turnActionCount = 0;
               setTimeout(function():void
               {
                  if(_scene == null)
                  {
                     return;
                  }
                  if(_turnResultInfoVec.length > 0)
                  {
                     parseTurnResultInfo(_turnResultInfoVec.pop());
                  }
                  else
                  {
                     if(parsingTurnResultInfo)
                     {
                        parseBuffResult(false,0);
                     }
                     arenaUIController.updateStatusPanel();
                     dispatchParseEvent("parseEnd");
                  }
               },0);
            }
         };
         arenaUIController = this._scene.arenaUIController;
         this.parsingTurnResultInfo = resultInfo;
         turnResultVec = resultInfo.fighterTurnResultInfoVec;
         _turnActionCount = 0;
         recordCount = turnResultVec.length;
         for each(fighterTurnInfo in turnResultVec)
         {
            fighter = this._scene.arenaData.getFighter(fighterTurnInfo.userId,fighterTurnInfo.catchTime);
            fighter.turnResultInfo = resultInfo;
            fighter.addEventListener("actionEnd",onFighterActionEnd);
            if(fighterTurnInfo.isAtker)
            {
               this.atker = fighter;
               this.atker.addEventListener("sexHit",onAtkerHit);
            }
            else
            {
               this.atkee = fighter;
            }
         }
         this.updateMainPosition(Vector.<Fighter>([this.atker,this.atkee]),adjustPositionComplete);
      }
      
      private function updateMainPosition(param1:Vector.<Fighter>, param2:Function) : void
      {
         var leftContain:Boolean = false;
         var controller:IFightController = null;
         var arenaController:IArenaUIController = null;
         var onChangeComplete:Function = null;
         var fighters:Vector.<Fighter> = param1;
         var onComplete:Function = param2;
         var updateFighterPosition:Function = function(param1:Fighter):void
         {
            var _loc2_:FighterTeam = null;
            var _loc3_:Boolean = false;
            leftContain = controller.leftTeam.hasFighter(param1);
            if(leftContain)
            {
               _loc2_ = controller.leftTeam;
            }
            else
            {
               _loc3_ = controller.rightTeam.hasFighter(param1);
               if(_loc3_)
               {
                  _loc2_ = controller.rightTeam;
               }
            }
            if(_loc2_ != null)
            {
               if(_loc2_.mainFighter != param1)
               {
                  _loc2_.changeMainSubPosition(onChangeComplete);
               }
               else
               {
                  onChangeComplete();
               }
               return;
            }
            throw new Error("该精灵[" + param1.name + "]不属于任何队伍!!");
         };
         onChangeComplete = function():void
         {
            arenaController.updateStatusPanelInfo();
            updateMainPosition(fighters,onComplete);
         };
         leftContain = false;
         controller = this._scene.fightController;
         arenaController = this._scene.arenaUIController;
         if(fighters.length > 0)
         {
            updateFighterPosition(fighters.pop());
         }
         else
         {
            onComplete();
         }
      }
      
      private function parseBuffResult(param1:Boolean, param2:uint) : void
      {
         var _loc5_:BuffResultInfo = null;
         var _loc4_:uint = 0;
         var _loc7_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc3_:Fighter = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc9_:int = int(this._buffResultInfoVec.length);
         var _loc8_:uint = 0;
         while(this._buffResultInfoVec.length > 0)
         {
            _loc5_ = this._buffResultInfoVec.pop();
            _loc4_ = _loc5_.userId;
            _loc7_ = _loc5_.fighterId;
            _loc6_ = _loc5_.isDying;
            _loc3_ = this._scene.arenaData.getFighter(_loc4_,_loc7_);
            _loc3_.fighterBuffResultInfo = _loc5_;
            if(_loc6_)
            {
               _loc3_.dyingHp();
            }
            else
            {
               _loc12_ = int(_loc5_.buffNum);
               _loc13_ = 0;
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc11_ = _loc5_.getChangeHp(_loc10_);
                  _loc3_.fighterInfo.changeHp(_loc11_);
                  _loc13_ += _loc11_;
                  _loc10_++;
               }
               if(_loc13_ > 0)
               {
                  ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.HPIncreaseAnimation",{
                     "fightSide":_loc3_.fighterSide,
                     "fighter":_loc3_,
                     "changedHp":_loc13_,
                     "startInterval":_loc8_
                  });
               }
               else if(_loc11_ < 0)
               {
                  ArenaAnimationManager.createAnimation("com.taomee.seer2.app.arena.animation.HpDecreaseAnimation",{
                     "reducedHp":Math.abs(_loc13_),
                     "fighter":_loc3_,
                     "fightSide":_loc3_.fighterSide,
                     "isBaoJi":param1,
                     "skillTypeRelation":param2
                  });
               }
               _loc8_ += 30;
            }
         }
      }
      
      private function dispatchParseEvent(param1:String) : void
      {
         if(hasEventListener(param1))
         {
            dispatchEvent(new Event(param1));
         }
      }
   }
}

