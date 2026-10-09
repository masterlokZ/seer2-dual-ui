package com.taomee.seer2.app.cmdl
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.common.ResourceLibraryLoader;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.RarePet;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.map.ResourceLibrary;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.MapLoader;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   import org.taomee.bean.BaseBean;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class MapRatePetShowListener extends BaseBean
   {
      
      private static const SEC:uint = 5;
      
      private var vec:Vector.<RatePetInfo> = new Vector.<RatePetInfo>();
      
      private var rareVec:Vector.<RarePet> = new Vector.<RarePet>();
      
      private var _resLoader:ResourceLibraryLoader;
      
      public function MapRatePetShowListener()
      {
         super();
         Connection.addCommandListener(CommandSet.MAP_RATE_PET_INFO_1201,this.onMessage);
         SceneManager.addEventListener("switchComplete",this.onMapSwitchComplete);
         finish();
      }
      
      private function onMessage(param1:MessageEvent) : void
      {
         var _loc4_:RatePetInfo = null;
         var _loc2_:uint = 0;
         var _loc3_:IDataInput = param1.message.getRawData();
         var _loc5_:uint = _loc3_.readUnsignedInt();
         this.vec.length = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = new RatePetInfo();
            _loc4_.pointIndex = _loc3_.readUnsignedInt();
            _loc4_.id = _loc3_.readUnsignedInt();
            _loc4_.lev = _loc3_.readUnsignedShort();
            _loc4_.time = _loc3_.readUnsignedInt();
            _loc4_.type = _loc3_.readByte();
            this.vec.push(_loc4_);
            _loc2_++;
         }
         this.initRatePet();
      }
      
      private function initRatePet() : void
      {
         var _loc2_:int = 0;
         var _loc1_:RarePet = null;
         MobileManager.clearMobileVec("ratePet");
         this.rareVec.length = 0;
         if(Boolean(SceneManager.active) && Boolean(SceneManager.active.mapModel))
         {
            _loc2_ = 0;
            while(_loc2_ < this.vec.length)
            {
               _loc1_ = new RarePet(this.vec[_loc2_].id,this.vec[_loc2_].pointIndex,this.vec[_loc2_].lev,this.vec[_loc2_].time,this.vec[_loc2_].type);
               this.rareVec.push(_loc1_);
               MobileManager.addMobile(_loc1_,"ratePet");
               _loc2_++;
            }
            this.onTick();
         }
      }
      
      private function onMapSwitchComplete(param1:SceneEvent) : void
      {
         MobileManager.clearMobileVec("ratePet");
         this.rareVec.length = 0;
         if(SceneManager.prevSceneType == 2 && FightManager.fightWinnerSide == 1)
         {
            if(FightManager.currentFightRecord && FightManager.currentFightRecord.initData && FightManager.currentFightRecord.initData.positionIndex && FightManager.currentFightRecord.initData.type && FightManager.currentFightRecord.initData.type == "fightMiniBoss" && MapLoader.isDream == false)
            {
               this._resLoader = new ResourceLibraryLoader(URLUtil.getRes("publicRes/miniBoss.swf"));
               this._resLoader.getLib(this.onGetLib);
            }
         }
      }
      
      private function onGetLib(param1:ResourceLibrary) : void
      {
         var tip:MovieClip = null;
         var lib:ResourceLibrary = param1;
         tip = lib.getMovieClip("MiniBossTipUI");
         (tip["btn"] as SimpleButton).addEventListener("click",function(param1:MouseEvent):void
         {
            var shine:MovieClip = null;
            var e:MouseEvent = param1;
            (tip["btn"] as SimpleButton).removeEventListener("click",arguments.callee);
            DisplayObjectUtil.removeFromParent(tip);
            shine = lib.getMovieClip("SunShineUI");
            shine.gotoAndStop(1);
            ActorManager.getActor().addChild(shine);
            MovieClipUtil.playMc(shine,1,shine.totalFrames,function():void
            {
               DisplayObjectUtil.removeFromParent(shine);
            });
         });
         LayerManager.moduleLayer.addChild(tip);
         DisplayUtil.align(tip,4,LayerManager.rootRect);
      }
      
      private function onTick() : void
      {
         Tick.instance.addRender(this.update,5 * 1000);
      }
      
      private function update(param1:int) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.rareVec.length)
         {
            this.rareVec[_loc2_].time -= 5;
            if(this.rareVec[_loc2_].time <= 0 && this.rareVec[_loc2_].type == 0)
            {
               MobileManager.removeMobile(this.rareVec[_loc2_],"ratePet");
               this.rareVec.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
   }
}

class RatePetInfo
{
   
   internal var pointIndex:uint;
   
   internal var id:uint;
   
   internal var lev:uint;
   
   internal var time:int;
   
   internal var type:int;
   
   public function RatePetInfo()
   {
      super();
   }
}
