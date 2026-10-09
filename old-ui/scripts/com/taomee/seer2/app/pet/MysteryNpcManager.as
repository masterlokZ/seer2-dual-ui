package com.taomee.seer2.app.pet
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1140;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.loader.QueueLoader;
   import com.taomee.seer2.core.map.ResourceLibrary;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class MysteryNpcManager
   {
      
      public static var hasShowMovie:int = 0;
      
      public static var isNpcAppear:int = 0;
      
      private static const feiniaoID:int = 555;
      
      private static const mapIdList:Array = [550,490,310,204,213,261,121,141];
      
      private static const posList:Array = [new Point(300,400),new Point(635,375),new Point(365,310),new Point(240,340),new Point(330,465),new Point(580,420),new Point(300,395),new Point(520,405)];
      
      public function MysteryNpcManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         SceneManager.addEventListener("switchComplete",onComplete);
         Connection.addCommandListener(CommandSet.RANDOM_EVENT_1140,onRandom);
      }
      
      private static function onRandom(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.RANDOM_EVENT_1140,onRandom);
         var _loc2_:Parser_1140 = new Parser_1140(param1.message.getRawDataCopy());
         if(_loc2_.index == 42)
         {
            isNpcAppear = 1;
         }
         checkMobile();
      }
      
      private static function onComplete(param1:SceneEvent) : void
      {
         if(SceneManager.prevSceneType != 2)
         {
            return;
         }
         var _loc2_:int = SceneManager.active.mapID;
         var _loc3_:int = mapIdList.indexOf(_loc2_);
         if(_loc3_ < 0)
         {
            return;
         }
         checkMobile();
      }
      
      private static function checkMobile() : void
      {
         var _loc1_:Mobile = MobileManager.getMobile(555,"npc");
         if(_loc1_)
         {
            MobileManager.removeMobile(_loc1_,"npc");
            _loc1_.dispose();
         }
         if(isNpcAppear == 0)
         {
            return;
         }
         if(hasShowMovie == 0)
         {
            QueueLoader.load(URLUtil.getActivityAnimation("MysteryYiTe/feiniao"),"domain",onLoadComplete);
         }
         else
         {
            createNpc();
         }
      }
      
      private static function onLoadComplete(param1:ContentInfo) : void
      {
         var _resLib:ResourceLibrary;
         var index:int;
         var mc:MovieClip = null;
         var position:Point = null;
         var info:ContentInfo = param1;
         if(hasShowMovie == 1)
         {
            return;
         }
         _resLib = new ResourceLibrary(info.content);
         mc = _resLib.getMovieClip("FeiNiao");
         SceneManager.active.mapModel.front.addChild(mc);
         index = mapIdList.indexOf(SceneManager.active.mapID);
         position = posList[index];
         mc.x = position.x;
         mc.y = position.y;
         MovieClipUtil.playMc(mc,1,mc.totalFrames,function():void
         {
            DisplayUtil.removeForParent(mc);
            hasShowMovie = 1;
            mc = null;
            createNpc();
         });
      }
      
      private static function createNpc() : void
      {
         var _loc2_:MysteryNpc = new MysteryNpc();
         MobileManager.addMobile(_loc2_.npc,"npc");
         var _loc1_:int = mapIdList.indexOf(SceneManager.active.mapID);
         var _loc3_:Point = posList[_loc1_];
         _loc2_.npc.x = _loc3_.x;
         _loc2_.npc.y = _loc3_.y;
      }
   }
}

