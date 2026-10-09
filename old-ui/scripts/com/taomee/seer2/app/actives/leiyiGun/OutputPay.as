package com.taomee.seer2.app.actives.leiyiGun
{
   import com.taomee.seer2.app.controls.PetAvatarPanel;
   import com.taomee.seer2.app.lobby.LobbyScene;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.map.MapModel;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class OutputPay
   {
      
      private const GUN_NUM:int = 7;
      
      private const MAP_W:int = 920;
      
      private const MAP_H:int = 560;
      
      private const EYE_ITEM:int = 603147;
      
      private var mapModel:MapModel;
      
      private var currentP:Point;
      
      private var buyBtn:SimpleButton;
      
      private var itemBtn:SimpleButton;
      
      private var boxBtn:SimpleButton;
      
      private var isEye:Boolean = false;
      
      private var gunList:Vector.<Sprite>;
      
      public function OutputPay()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.buyBtn.removeEventListener("click",this.toBuyEye);
         this.itemBtn.removeEventListener("click",this.buyItem);
         this.boxBtn.removeEventListener("click",this.showBoxPanel);
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            this.gunList[_loc1_].removeEventListener("click",this.toFight);
            this.gunList[_loc1_] = null;
            _loc1_++;
         }
         this.gunList = null;
      }
      
      public function getGunlist() : Vector.<Sprite>
      {
         return this.gunList;
      }
      
      public function setup() : void
      {
         (SceneManager.active as LobbyScene).hideToolbar();
         PetAvatarPanel.show();
         this.mapModel = SceneManager.active.mapModel;
         this.buyBtn = this.mapModel.front["eyeBtn"];
         this.itemBtn = this.mapModel.front["itemBtn"];
         this.boxBtn = this.mapModel.front["boxBtn"];
         this.currentP = new Point();
         ServerBufferManager.getServerBuffer(57,this.getServer);
      }
      
      private function getServer(param1:ServerBuffer) : void
      {
         var buff:ServerBuffer = param1;
         var isPlay:Boolean = Boolean(buff.readDataAtPostion(21));
         if(!isPlay)
         {
            ServerBufferManager.updateServerBuffer(57,21,1);
            MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("LeiyiGunAppearFull"),function():void
            {
               createGun();
               initEvent();
            });
         }
         else
         {
            this.createGun();
            this.initEvent();
         }
      }
      
      private function initEvent() : void
      {
         this.buyBtn.addEventListener("click",this.toBuyEye);
         this.itemBtn.addEventListener("click",this.buyItem);
         this.boxBtn.addEventListener("click",this.showBoxPanel);
      }
      
      private function showBoxPanel(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("MedicineShopPanel"));
      }
      
      private function buyItem(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("LeiyiGunItemPanel"));
      }
      
      private function toBuyEye(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("LeiyiGunEyePanel"));
      }
      
      private function createGun() : void
      {
         var _loc1_:Sprite = null;
         this.gunList = new Vector.<Sprite>();
         var _loc2_:int = 0;
         while(_loc2_ < 7)
         {
            _loc1_ = UIManager.getSprite("LeiyiGun");
            _loc1_.buttonMode = true;
            _loc1_.mouseChildren = false;
            _loc1_.addEventListener("click",this.toFight);
            this.mapModel.content.addChild(_loc1_);
            this.gunList.push(_loc1_);
            this.setXY(_loc1_);
            _loc2_++;
         }
      }
      
      private function toFight(param1:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("LeiyiGunPayTipsPanel"));
      }
      
      private function setXY(param1:Sprite) : void
      {
         this.getPoint();
         param1.x = this.currentP.x;
         param1.y = this.currentP.y;
         var _loc2_:int = 0;
         while(_loc2_ < this.gunList.length - 1)
         {
            if(param1.hitTestObject(this.gunList[_loc2_]))
            {
               this.setXY(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function getPoint() : void
      {
         this.currentP.x = 130 + Math.random() * (920 - 130);
         this.currentP.y = 220 + Math.random() * (560 - 220);
      }
   }
}

