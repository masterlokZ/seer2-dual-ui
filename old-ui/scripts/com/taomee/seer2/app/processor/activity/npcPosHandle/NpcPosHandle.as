package com.taomee.seer2.app.processor.activity.npcPosHandle
{
   import com.taomee.seer2.core.config.ClientConfig;
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.MobileManager;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.events.SceneEvent;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class NpcPosHandle
   {
      
      private static var _isDown:Boolean = false;
      
      public static var isMove:Boolean = false;
      
      private static var _curDrag:Mobile;
      
      private static var _movableFlag:Boolean = false;
      
      private static var _switchCompleteFlag:Boolean = false;
      
      public function NpcPosHandle()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(ClientConfig.isLocal)
         {
            SceneManager.addEventListener("switchComplete",onComplete);
         }
      }
      
      private static function onComplete(param1:SceneEvent) : void
      {
         SceneManager.removeEventListener("switchComplete",onComplete);
         _switchCompleteFlag = true;
         if(_movableFlag == false)
         {
            return;
         }
         LayerManager.stage.addEventListener("mouseDown",onStageDown);
         LayerManager.stage.addEventListener("mouseUp",onStageUp);
         LayerManager.stage.addEventListener("mouseOver",onStageOver);
         LayerManager.stage.addEventListener("mouseOut",onStageOut);
      }
      
      private static function onStageDown(param1:MouseEvent) : void
      {
         if(!(param1.target is Mobile))
         {
            return;
         }
         if(MobileManager.getMobileVec("npc") == null)
         {
            return;
         }
         _curDrag = param1.target as Mobile;
         if(MobileManager.getMobileVec("npc").indexOf(_curDrag) != -1)
         {
            _curDrag.startDrag();
            _curDrag.addEventListener("mouseMove",onNpcMove);
            _isDown = true;
         }
      }
      
      private static function onNpcMove(param1:MouseEvent) : void
      {
         isMove = true;
      }
      
      private static function onStageUp(param1:MouseEvent) : void
      {
         if(!(param1.target is Mobile))
         {
            return;
         }
         var _loc2_:Mobile = param1.target as Mobile;
         _loc2_.stopDrag();
         if(_curDrag)
         {
            _curDrag.removeEventListener("mouseMove",onNpcMove);
         }
         _isDown = false;
      }
      
      private static function onStageOver(param1:MouseEvent) : void
      {
         var _loc2_:Mobile = getCurNpc(param1.target as DisplayObject);
         if(!_loc2_)
         {
            return;
         }
         if(_isDown)
         {
            return;
         }
         TooltipManager.addCommonTip(_loc2_,"id:" + _loc2_.id + "  坐标:x=" + int(_loc2_.x) + "  y=" + int(_loc2_.y));
      }
      
      private static function getCurNpc(param1:DisplayObject) : Mobile
      {
         var _loc3_:Mobile = null;
         var _loc2_:Mobile = null;
         for each(_loc3_ in MobileManager.getMobileVec("npc"))
         {
            if(_loc3_ == param1 || _loc3_.contains(param1))
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      private static function onStageOut(param1:MouseEvent) : void
      {
         var _loc2_:Mobile = getCurNpc(param1.target as DisplayObject);
         if(_loc2_)
         {
            TooltipManager.addCommonTip(_loc2_,"id:" + _loc2_.id + "  坐标:x=" + int(_loc2_.x) + "  y=" + int(_loc2_.y));
         }
      }
      
      public static function setMovableState(param1:Boolean) : void
      {
         _movableFlag = param1;
         if(_switchCompleteFlag == false)
         {
            return;
         }
         if(param1)
         {
            LayerManager.stage.addEventListener("mouseDown",onStageDown);
            LayerManager.stage.addEventListener("mouseUp",onStageUp);
            LayerManager.stage.addEventListener("mouseOver",onStageOver);
            LayerManager.stage.addEventListener("mouseOut",onStageOut);
         }
         else
         {
            SceneManager.removeEventListener("switchComplete",onComplete);
            LayerManager.stage.removeEventListener("mouseDown",onStageDown);
            LayerManager.stage.removeEventListener("mouseUp",onStageUp);
            LayerManager.stage.removeEventListener("mouseOver",onStageOver);
            LayerManager.stage.removeEventListener("mouseOut",onStageOut);
         }
      }
   }
}

