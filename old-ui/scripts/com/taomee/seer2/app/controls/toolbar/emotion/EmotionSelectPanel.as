package com.taomee.seer2.app.controls.toolbar.emotion
{
   import com.taomee.seer2.app.chat.data.ChatSendMessage;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.ui.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EmotionSelectPanel extends Sprite
   {
      
      public static const EMOTION_NUM:int = 24;
      
      private var _ui:MovieClip;
      
      private var _isShow:Boolean;
      
      protected var _selectedEmotionId:String;
      
      public function EmotionSelectPanel()
      {
         var _loc1_:MovieClip = null;
         super();
         this._ui = UIManager.getMovieClip("UI_EmotionSelectPanelUI");
         var _loc2_:int = 0;
         while(_loc2_ < 24)
         {
            _loc1_ = this._ui["face" + _loc2_];
            _loc1_.buttonMode = true;
            _loc1_.addEventListener("rollOver",this.onEmotionOver);
            _loc1_.addEventListener("rollOut",this.onEmotionOut);
            _loc1_.addEventListener("click",this.onBtnClick);
            _loc2_++;
         }
         addChild(this._ui);
      }
      
      private function onEmotionOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         MotionEffects.execElastic(_loc2_);
      }
      
      private function onEmotionOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         MotionEffects.resetScale(_loc2_);
      }
      
      protected function onBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         this._selectedEmotionId = _loc2_.name.substring(4);
         var _loc4_:String = "[e_" + this._selectedEmotionId + "]";
         var _loc3_:ChatSendMessage = new ChatSendMessage(0,_loc4_);
         Connection.send(CommandSet.CHAT_1102,_loc3_.pack());
         this.hide();
      }
      
      public function toggle() : void
      {
         this._isShow = !this._isShow;
         this.visible = this._isShow;
      }
      
      public function hide() : void
      {
         this._isShow = true;
         this.toggle();
      }
   }
}

