package com.taomee.seer2.app.shoot
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.cache.ShootCache;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.Direction;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.ds.HashSet;
   import org.taomee.manager.CursorManager;
   import org.taomee.utils.DomainUtil;
   
   public class ShootController
   {
      
      public static var shootId:uint = 0;
      
      private static const SHOOT_PATH:String = "com.taomee.seer2.app.processor.shoot.Shoot_";
      
      private static const TYPE_PATH:String = "com.taomee.seer2.app.processor.shoot.Type_";
      
      private static var _isAllow:Boolean = true;
      
      private static var _id:uint;
      
      private static var _isFree:Boolean = false;
      
      public static var isAim:Boolean = false;
      
      private static var _list:HashSet = new HashSet();
      
      private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
      
      setup();
      
      public function ShootController()
      {
         super();
      }
      
      public static function set isAllow(param1:Boolean) : void
      {
         _isAllow = param1;
      }
      
      public static function get id() : uint
      {
         return _id;
      }
      
      public static function setup() : void
      {
         SceneManager.addEventListener("switchStart",onMapStart);
      }
      
      private static function onMapStart(param1:SceneEvent) : void
      {
         close();
         dispose();
      }
      
      public static function addShoot(param1:BaseShoot) : void
      {
         _list.add(param1);
      }
      
      public static function removeShoot(param1:BaseShoot) : void
      {
         _list.remove(param1);
      }
      
      public static function dispose() : void
      {
         _list.forEach(function(param1:BaseShoot):void
         {
            param1.dispose();
            param1 = null;
         });
         _list.clear();
      }
      
      public static function hideShootEffect(param1:uint) : void
      {
         var id:uint = param1;
         _list.forEach(function(param1:BaseShoot):void
         {
            if(param1.id == id)
            {
               param1.hideEffect();
            }
         });
      }
      
      public static function start(param1:uint, param2:Boolean = false) : void
      {
         _isFree = param2;
         _id = param1;
         isAim = true;
         CursorManager.setCursor(UIManager.getSprite("UI_Cursor_ShootSkin"));
         LayerManager.mapLayer.mouseEnabled = true;
         LayerManager.mapLayer.mouseChildren = false;
         LayerManager.stage.addEventListener("mouseMove",onMove);
         LayerManager.mapLayer.addEventListener("click",onClick);
      }
      
      public static function close() : void
      {
         isAim = false;
         CursorManager.removeCursor();
         LayerManager.mapLayer.mouseChildren = true;
         LayerManager.mapLayer.mouseEnabled = false;
         LayerManager.mapLayer.removeEventListener("click",onClick);
         LayerManager.stage.removeEventListener("mouseMove",onMove);
      }
      
      public static function execute(param1:uint, param2:uint, param3:Mobile, param4:Point, param5:Point = null) : void
      {
         var _loc8_:Class = null;
         var _loc7_:BaseShoot = null;
         if(ShootCache.contains(param1) == false)
         {
            ShootCache.load(param1);
            return;
         }
         var _loc6_:ShootInfo = ShootXMLInfo.getShootInfo(param1);
         _loc8_ = DomainUtil.getCurrentDomainClass("com.taomee.seer2.app.processor.shoot.Type_" + _loc6_.type);
         if(_loc8_)
         {
            if(param5 == null)
            {
               param5 = param3.pos.clone();
               param5.y = param5.y - 40;
            }
            if(LayerManager.mapLayer.scrollRect)
            {
               param4.x += LayerManager.mapLayer.scrollRect.x;
               param4.y += LayerManager.mapLayer.scrollRect.y;
            }
            param3.direction = Direction.pointToDirection(param5,param4);
            _loc7_ = new _loc8_();
            _loc6_.userID = param2;
            _loc6_.startPos = param5;
            _loc6_.endPos = param4;
            _loc7_.execute(_loc6_);
            if(_loc6_.soundId != -1)
            {
               ShootSoundManager.getInstance().playSound(_loc6_.soundId);
            }
         }
      }
      
      private static function onMove(param1:MouseEvent) : void
      {
         ActorManager.getActor().direction = Direction.pointToDirection(ActorManager.getActor().pos,new Point(LayerManager.stage.mouseX,LayerManager.stage.mouseY));
      }
      
      private static function onClick(param1:MouseEvent) : void
      {
         if(_isFree == false)
         {
            close();
         }
         var _loc2_:ShootInfo = new ShootInfo();
         _loc2_.endPos = new Point(LayerManager.mapLayer.mouseX,LayerManager.mapLayer.mouseY);
         dispatchEvent("serverLeftPlayStart",_loc2_);
         Connection.send(CommandSet.SHOOT_1075,shootId,_id,LayerManager.mapLayer.mouseX,LayerManager.mapLayer.mouseY);
         if(_id == 6)
         {
            Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,onGetReward);
         }
      }
      
      private static function onGetReward(param1:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,onGetReward);
         var _loc2_:SwapInfo = new SwapInfo(param1.message.getRawData());
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public static function dispatchEvent(param1:String, param2:ShootInfo) : void
      {
         _eventDispatcher.dispatchEvent(new ShootEvent(param1,param2));
      }
      
      public static function hasEventListener(param1:String) : Boolean
      {
         return _eventDispatcher.hasEventListener(param1);
      }
   }
}

