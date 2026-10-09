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
   
   public class MapProcessor_292 extends MapProcessor
   {
      
      private const PET_NUM:int = 5;
      
      private const dayLimitIDs:Array = [636,637,638,639,640];
      
      private const maxNums:Array = [1,1,1,1,3];
      
      private var mobile_arr:Vector.<Mobile>;
      
      private var dayLimitValues:Array = [0,0,0,0,0];
      
      private var npcIDs:Array = [557,558,559,560,561];
      
      private var fights:Array = [352,353,354,355,356];
      
      private var mobilePostions:Array = [new Point(285,285),new Point(370,370),new Point(620,370),new Point(800,235),new Point(500,320)];
      
      public function MapProcessor_292(param1:MapModel)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this.mobile_arr = new Vector.<Mobile>();
         var _loc2_:LittleEndianByteArray = new LittleEndianByteArray();
         _loc2_.writeUnsignedInt(5);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_.writeUnsignedInt(this.dayLimitIDs[_loc1_]);
            this.mobile_arr.push(new Mobile());
            _loc1_++;
         }
         DayLimitListManager.getDoCount(_loc2_,this.getDaylimit);
      }
      
      private function getDaylimit(param1:DayLimitListInfo) : void
      {
         var _loc2_:Parser_1065 = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            _loc2_ = param1.dayLimitList[_loc4_];
            _loc3_ = this.dayLimitIDs.indexOf(_loc2_.id);
            this.dayLimitValues[_loc3_] = _loc2_.count;
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
            if(this.dayLimitValues[_loc1_] < this.maxNums[_loc1_])
            {
               this.mobile_arr[_loc1_].resourceUrl = URLUtil.getNpcSwf(this.npcIDs[_loc1_]);
               this.mobile_arr[_loc1_].buttonMode = true;
               this.mobile_arr[_loc1_].addEventListener("click",this.toFight);
               this.mobile_arr[_loc1_].setPostion(this.mobilePostions[_loc1_]);
               this.mobile_arr[_loc1_].height = 100;
               if(_loc1_ > 1)
               {
                  this.mobile_arr[_loc1_].direction = 2;
               }
               MobileManager.addMobile(this.mobile_arr[_loc1_],"npc");
               _loc2_ = false;
            }
            _loc1_++;
         }
         if(!_loc2_)
         {
            this.npcIDs[4] = 562;
         }
         else if(SceneManager.prevSceneType == 2 && this.fights.indexOf(FightManager.currentFightRecord.initData.positionIndex) != -1)
         {
            if(FightManager.currentFightRecord.initData.positionIndex != 356)
            {
               MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("ShowHuanPet"));
            }
         }
         this.mobile_arr[4].resourceUrl = URLUtil.getNpcSwf(this.npcIDs[4]);
         this.mobile_arr[4].buttonMode = true;
         this.mobile_arr[4].addEventListener("click",this.toFight);
         this.mobile_arr[4].setPostion(this.mobilePostions[4]);
         MobileManager.addMobile(this.mobile_arr[4],"npc");
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         var index:int = 0;
         var event:MouseEvent = param1;
         index = this.mobile_arr.indexOf(event.target as Mobile);
         if(index != 4)
         {
            FightManager.startFightWithWild(this.fights[index]);
         }
         else if(this.npcIDs[4] == 562)
         {
            NpcDialog.show(561,"幻灵兽",[[0,"只有将我身边的4只精灵击败时，你才是一个拥有激情与荣耀的勇士，我便承诺与你相见。你每天可以与我战斗3次。"]],[" 好吧"]);
         }
         else if(this.dayLimitValues[4] < this.maxNums[4])
         {
            NpcDialog.show(561,"幻灵兽",[[0,"深藏壶中多年，我应该重新拾回属于我的那份激情与荣耀了。是你，勇士，你让我重新找回自己。你每天可以与我战斗3次。"]],["  挑战幻灵兽","我准备下"],[function():void
            {
               FightManager.startFightWithWild(fights[index]);
            }]);
         }
         else
         {
            NpcDialog.show(561,"幻灵兽",[[0,"我想今日我已经完成了我的荣耀之战，请明天再来和我挑战吧。"]],[" 好吧"]);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this.mobile_arr[_loc1_].removeEventListener("click",this.toFight);
            _loc1_++;
         }
         super.dispose();
      }
   }
}

