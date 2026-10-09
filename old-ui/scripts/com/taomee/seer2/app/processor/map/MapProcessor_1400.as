package com.taomee.seer2.app.processor.map
{
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.net.parser.Parser_1065;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.map.MapProcessor;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcessor_1400 extends MapProcessor
   {
      
      private const PET_NUM:uint = 5;
      
      private const LIMIT_IDs:Array = [671,672,673,674,675];
      
      private const NPC_IDs:Array = [567,568,569,570,572];
      
      private const FIGHT_IDs:Array = [419,420,421,422,423];
      
      private const MAX_COUNT:Array = [1,1,1,1,3];
      
      private const POSITIONs:Array = [new Point(142,383),new Point(318,491),new Point(639,455),new Point(742,354),new Point(426,269)];
      
      private var mobiles:Vector.<Mobile>;
      
      private var dayLimit:Array = [0,0,0,0,0];
      
      public function MapProcessor_1400(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this.mobiles = new Vector.<Mobile>();
         var _loc2_:LittleEndianByteArray = new LittleEndianByteArray();
         _loc2_.writeUnsignedInt(5);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_.writeUnsignedInt(this.LIMIT_IDs[_loc1_]);
            this.mobiles.push(new Mobile());
            _loc1_++;
         }
         DayLimitListManager.getDoCount(_loc2_,this.getDayLimitList);
      }
      
      private function getDayLimitList(param1:DayLimitListInfo) : void
      {
         var _loc2_:Parser_1065 = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            _loc2_ = param1.dayLimitList[_loc4_];
            _loc3_ = this.LIMIT_IDs.indexOf(_loc2_.id);
            this.dayLimit[_loc3_] = _loc2_.count;
            _loc4_++;
         }
         this.checkMobile();
      }
      
      private function checkMobile() : void
      {
         var _loc2_:Boolean = true;
         var _loc1_:int = 0;
         while(_loc1_ < 5 - 1)
         {
            if(this.dayLimit[_loc1_] < this.MAX_COUNT[_loc1_])
            {
               this.mobiles[_loc1_].resourceUrl = URLUtil.getNpcSwf(this.NPC_IDs[_loc1_]);
               this.mobiles[_loc1_].buttonMode = true;
               this.mobiles[_loc1_].addEventListener("click",this.toFight);
               this.mobiles[_loc1_].setPostion(this.POSITIONs[_loc1_]);
               this.mobiles[_loc1_].height = 100;
               if(_loc1_ > 1)
               {
                  this.mobiles[_loc1_].direction = 2;
               }
               MobileManager.addMobile(this.mobiles[_loc1_],"npc");
               _loc2_ = false;
            }
            _loc1_++;
         }
         if(!_loc2_)
         {
            this.NPC_IDs[4] = 573;
         }
         else if(SceneManager.prevSceneType == 2 && this.FIGHT_IDs.indexOf(FightManager.currentFightRecord.initData.positionIndex) != -1)
         {
            if(FightManager.currentFightRecord.initData.positionIndex != 423)
            {
               MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("ShowQinPet"));
            }
         }
         this.mobiles[4].resourceUrl = URLUtil.getNpcSwf(this.NPC_IDs[4]);
         this.mobiles[4].buttonMode = true;
         this.mobiles[4].addEventListener("click",this.toFight);
         this.mobiles[4].setPostion(this.POSITIONs[4]);
         MobileManager.addMobile(this.mobiles[4],"npc");
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         var index:int = 0;
         var event:MouseEvent = param1;
         index = this.mobiles.indexOf(event.target as Mobile);
         if(index != 4)
         {
            FightManager.startFightWithWild(this.FIGHT_IDs[index]);
         }
         else if(this.NPC_IDs[4] == 573)
         {
            NpcDialog.show(571,"沁灵兽",[[0,"只有将我身边的4只精灵击败时，你才是一个拥有激情与荣耀的勇士，我便承诺与你相见。你每天可以与我战斗3次。"]],[" 好吧"]);
         }
         else if(this.dayLimit[4] < this.MAX_COUNT[4])
         {
            NpcDialog.show(571,"沁灵兽",[[0,"只有勇气、信念兼并的勇士才有资格挑战我，你通过了我的考验，已经是一个名符其实的勇士了。你每天可以与我战斗3次。"]],["  挑战沁灵兽","我准备下"],[function():void
            {
               FightManager.startFightWithWild(FIGHT_IDs[index]);
            }]);
         }
         else
         {
            NpcDialog.show(571,"沁灵兽",[[0,"勇士还差一点点，就差一点点了，今天就到这里吧，请明天再来和我挑战。"]],["好吧"]);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.mobiles[_loc1_].removeEventListener("click",this.toFight);
            _loc1_++;
         }
         super.dispose();
      }
   }
}

