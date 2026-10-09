package com.taomee.seer2.app.actives
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.dialog.DialogPanel;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.dialog.events.DialogPanelEvent;
   import com.taomee.seer2.app.pet.PetIsHaveManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.DisplayObject;
   import flash.utils.IDataInput;
   
   public class NianshouAct
   {
      
      public static const PET_ID:int = 2589;
      
      public static const FIGHT_ID:int = 1883;
      
      private static var _npc:DisplayObject;
      
      public function NianshouAct()
      {
         super();
      }
      
      public static function init() : void
      {
         DialogPanel.addEventListener("customUnitClick",onCustomUnitClick);
         initForMap40();
      }
      
      public static function initForMap40() : void
      {
         PetIsHaveManager.requestIsHavePet(petIds,function():void
         {
            var _loc2_:IconDisplayer = null;
            var _loc1_:String = null;
            if(PetIsHaveManager.petIsHave(2589))
            {
               return;
            }
            _loc2_ = new IconDisplayer();
            _loc1_ = URLUtil.getRes("activity/icon/nianshou.swf");
            _loc2_.setIconUrl(_loc1_);
            _loc2_.addEventListener("click",onNpcClick);
            _loc2_.x = 727;
            _loc2_.y = 364;
            _npc = _loc2_;
            SceneManager.active.mapModel.content.addChild(_loc2_);
            _loc2_.mouseChildren = false;
            _loc2_.buttonMode = true;
         });
      }
      
      public static function leaveMap40() : void
      {
         if(_npc != null)
         {
            _npc.removeEventListener("click",onNpcClick);
            _npc = null;
         }
      }
      
      private static function onCustomUnitClick(param1:DialogPanelEvent) : void
      {
         if(param1.content.params != "nianshou")
         {
            return;
         }
         onNpcClick();
      }
      
      private static function onNpcClick(param1:* = null) : void
      {
         var e:* = param1;
         PetIsHaveManager.requestIsHavePet(petIds,function():void
         {
            if(PetIsHaveManager.petIsHave(2589))
            {
               AlertManager.showAlert("你已经捕捉到精灵“吞”了！");
               return;
            }
            ServerBufferManager.getServerBuffer(459,function(param1:ServerBuffer):void
            {
               if(param1.readDataAtPostion(1) == 0)
               {
                  ServerBufferManager.updateServerBuffer(459,1,1);
                  NpcDialog.showDialogsByText("activity/dialog/nianshou.json",catchNianshou);
               }
               else
               {
                  catchNianshou();
               }
            });
         });
      }
      
      private static function catchNianshou(param1:Boolean = false) : void
      {
         var isRedo:Boolean = param1;
         var dialogs:Array = [[113,"NONO",[[0,"继续喂他赛尔豆吗？"]],["喂！(8888赛尔豆)","不喂了！！"]]];
         if(isRedo)
         {
            dialogs = [[113,"NONO",[[0,"也许还要再试试…"]],["喂！(8888赛尔豆)","不喂了！！"]]];
         }
         NpcDialog.showDialogs(dialogs,function():void
         {
            useSaierdou(function(param1:Boolean):void
            {
               if(param1)
               {
                  FightManager.addEventListener("FIGHT_OVER",onFightOver);
                  FightManager.startFightWithWild(1883);
               }
               else
               {
                  catchNianshou(true);
               }
            });
         });
      }
      
      private static function onFightOver(param1:* = null) : void
      {
         var e:* = param1;
         if(FightManager.currentFightRecord.initData.positionIndex != 1883)
         {
            return;
         }
         FightManager.removeEventListener("FIGHT_OVER",onFightOver);
         PetIsHaveManager.requestIsHavePet(petIds,function():void
         {
            var sucessDialog:Array = null;
            var dialogs:Array = null;
            if(PetIsHaveManager.petIsHave(2589))
            {
               sucessDialog = [[5,"乔修尔",[[0,"呀，小赛尔，你可真是有财力呀——给你拜个小年，给个红包怎么样。"]],["拒绝！"]]];
               NpcDialog.showDialogs(sucessDialog,function():void
               {
               });
            }
            else
            {
               dialogs = [[113,"NONO",[[0,"吧唧吧唧…"]],["可恶…我的赛尔豆…"]]];
               NpcDialog.showDialogs(dialogs,catchNianshou);
            }
         });
      }
      
      private static function useSaierdou(param1:Function) : void
      {
         var callBack:Function = param1;
         SwapManager.swapItem(4653,1,(function():*
         {
            var success:Function;
            return success = function(param1:IDataInput):void
            {
               new SwapInfo(param1);
               if(Math.random() * 100 < 40)
               {
                  callBack(true);
               }
               else
               {
                  callBack(false);
               }
            };
         })(),(function():*
         {
            var failed:Function;
            return failed = function(param1:uint):void
            {
               AlertManager.showAlert("没有足够的赛尔豆！");
            };
         })());
      }
      
      private static function get petIds() : Vector.<uint>
      {
         return Vector.<uint>([2589,2590]);
      }
   }
}

