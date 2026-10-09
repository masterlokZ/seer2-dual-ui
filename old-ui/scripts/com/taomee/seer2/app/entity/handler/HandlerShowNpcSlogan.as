package com.taomee.seer2.app.entity.handler
{
   import com.taomee.seer2.core.entity.Mobile;
   import com.taomee.seer2.core.entity.definition.EntityDefinition;
   import com.taomee.seer2.core.entity.handler.IEntityEventHandler;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class HandlerShowNpcSlogan implements IEntityEventHandler
   {
      
      private static var _npcSloganMc:MovieClip;
      
      private var _type:String;
      
      private var _entityDefinition:EntityDefinition;
      
      private var _slogan:String;
      
      private var _npcId:uint;
      
      private var _npc:Mobile;
      
      public function HandlerShowNpcSlogan()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         if(_npcSloganMc == null)
         {
            _npcSloganMc = UIManager.getMovieClip("UI_ChatBubble");
            _npcSloganMc.mouseEnabled = _npcSloganMc.mouseChildren = false;
         }
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function setEntityDefinition(param1:EntityDefinition) : void
      {
         this._entityDefinition = param1;
         this._npcId = this._entityDefinition.id;
      }
      
      public function initData(param1:XML) : void
      {
         this._slogan = param1.toString();
      }
      
      public function onEvent(param1:Event) : void
      {
         this._npc = param1.currentTarget as Mobile;
         if(this._npc != null && this._npc.hasOverHeadMark() == false)
         {
            this.showSlogan();
            this.deploySloganPosition();
            SceneManager.active.mapModel.front.addChild(_npcSloganMc);
            this._npc.addEventListener("mouseOut",this.onMouseOut);
            this._npc.addEventListener("removedFromStage",this.onRemoveNpc);
         }
      }
      
      private function onRemoveNpc(param1:Event) : void
      {
         this._npc.removeEventListener("mouseOut",this.onMouseOut);
         this._npc.removeEventListener("removedFromStage",this.onRemoveNpc);
         DisplayObjectUtil.removeFromParent(_npcSloganMc);
      }
      
      private function deploySloganPosition() : void
      {
         _npcSloganMc.x = this._npc.x;
         _npcSloganMc.y = this._npc.y - this._npc.height;
         if(_npcSloganMc.x + _npcSloganMc.width > LayerManager.root.width)
         {
            _npcSloganMc.x = LayerManager.root.width - _npcSloganMc.width;
         }
         if(_npcSloganMc.y - _npcSloganMc.height < 0)
         {
            _npcSloganMc.y = _npcSloganMc.height;
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this._npc.removeEventListener("mouseOut",this.onMouseOut);
         DisplayObjectUtil.removeFromParent(_npcSloganMc);
      }
      
      private function showSlogan() : void
      {
         var _loc2_:TextField = _npcSloganMc["txtMsg"];
         _loc2_.wordWrap = false;
         _loc2_.autoSize = "left";
         var _loc1_:MovieClip = _npcSloganMc["mcBack"];
         _loc2_.text = this._slogan;
         _loc1_.width = _loc2_.width + 15;
      }
   }
}

