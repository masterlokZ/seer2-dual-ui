package com.taomee.seer2.app.shoot
{
   import com.taomee.seer2.core.cache.ShootCache;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class ShootGridPanel extends Sprite
   {
      
      private static const ITEM_HEIGHT:Number = 37;
      
      private static const ITEM_WIDTH:Number = 41;
      
      public static var isShow:Boolean;
      
      private static var _instance:ShootGridPanel;
      
      private var _obj:DisplayObject;
      
      private var _bg:Sprite;
      
      private var _itemVec:Vector.<ShootGridItem>;
      
      public function ShootGridPanel()
      {
         var _loc1_:ShootGridItem = null;
         super();
         mouseEnabled = false;
         this._bg = UIManager.getSprite("UI_ShootPanel_Background");
         this._bg.mouseChildren = false;
         this._bg.mouseEnabled = false;
         addChild(this._bg);
         this._itemVec = new Vector.<ShootGridItem>();
         var _loc3_:Vector.<int> = ShootXMLInfo.getIDs();
         var _loc2_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc3_[_loc4_] != 0)
            {
               _loc1_ = new ShootGridItem();
               _loc1_.x = 6 + (_loc1_.width + 4) * _loc5_;
               _loc1_.y = 6;
               _loc1_.id = _loc3_[_loc4_];
               addChild(_loc1_);
               _loc1_.addEventListener("mouseDown",this.onItemClick);
               ShootCache.load(_loc1_.id);
               this._itemVec.push(_loc1_);
               _loc5_++;
            }
            _loc4_++;
         }
         this._bg.width = _loc5_ * 41 + 6;
         this._bg.height = 12 + 37;
      }
      
      public static function get instance() : ShootGridPanel
      {
         if(_instance == null)
         {
            _instance = new ShootGridPanel();
         }
         return _instance;
      }
      
      public function show(param1:DisplayObject) : void
      {
         isShow = true;
         this._obj = param1;
         this.x = 385;
         this.y = 522;
         LayerManager.topLayer.addChild(this);
         SceneManager.addEventListener("switchStart",this.onMapChange);
      }
      
      public function hide() : void
      {
         isShow = false;
         DisplayUtil.removeForParent(this,false);
      }
      
      private function onItemClick(param1:MouseEvent) : void
      {
         var _loc2_:ShootGridItem = param1.currentTarget as ShootGridItem;
         if(_loc2_.id > 0)
         {
            if(_loc2_.canShoot)
            {
               ShootController.start(_loc2_.id);
            }
         }
      }
      
      private function onMapChange(param1:SceneEvent) : void
      {
         SceneManager.removeEventListener("switchStart",this.onMapChange);
         this.hide();
      }
      
      private function onStageDown(param1:MouseEvent) : void
      {
         if(this._obj.hitTestPoint(param1.stageX,param1.stageY) == false)
         {
            this.hide();
         }
      }
   }
}

